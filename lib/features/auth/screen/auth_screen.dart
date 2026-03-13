import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:skills_app/features/dashboard/screen/dashboard_screen.dart';
import '../controller/auth_controller.dart';

class AuthScreen extends StatelessWidget {

  AuthScreen({super.key});

  final phoneController = TextEditingController();
  final AuthController controller = Get.put(AuthController());

  final List<TextEditingController> otpControllers =
  List.generate(6, (index) => TextEditingController());

  final List<FocusNode> focusNodes =
  List.generate(6, (index) => FocusNode());

  String getOtp(){
    return otpControllers.map((e) => e.text).join();
  }

  Widget buildOtpBox(int index) {
    return SizedBox(
      width: 52,
      child: TextField(
        controller: otpControllers[index],
        focusNode: focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            focusNodes[index + 1].requestFocus();
          }
          if (value.isEmpty && index > 0) {
            focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Expanded(
              child: Lottie.asset('assets/intro/Welcome.json'),
            ),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                  Obx(() {

                    return LinearProgressIndicator(
                      value: controller.isOtpSent.value ? 1 : .5,
                      backgroundColor: Colors.grey.shade200,
                      color: Colors.blueAccent,
                    );

                  }),

                  Obx(() {

                    return Column(
                      children: [

                        Text(
                          controller.isOtpSent.value
                              ? 'Enter verification code'
                              : 'Verify your phone',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20),
                        ),

                        Text(
                          controller.isOtpSent.value
                              ? 'Code sent to +91 ${phoneController.text}'
                              : 'We’ll send a 6-digit code to confirm your number.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),

                      ],
                    );

                  }),

                  Obx(() {

                    if(controller.isOtpSent.value){

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(6, (i) => buildOtpBox(i)),
                      );

                    }else{

                      return Row(
                        spacing: 10,
                        children: [

                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text('+91'),
                          ),

                          Expanded(
                            child: TextField(
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                // counterText: "",
                                hintText: 'Enter phone number',
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),

                        ],
                      );

                    }

                  }),

                  Obx(() {

                    if(!controller.isOtpSent.value) return const SizedBox();

                    return Text(
                      "Resend in 00:${controller.resendSeconds.value}",
                      style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13),
                    );

                  }),

                  SizedBox(
                    width: double.infinity,
                    height: 50,

                    child: ElevatedButton(
                      onPressed: () async {

                        if(controller.isOtpSent.value){

                          bool success = await controller.verifyOtp(
                              "+91${phoneController.text}",
                              getOtp()
                          );

                          if(success){
                            Get.offAll(() => const DashboardScreen());
                          }

                        }else{

                          controller.sendOtp("+91${phoneController.text}");

                        }

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Obx(() {

                        return controller.loading.value
                            ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                            : Text(
                          controller.isOtpSent.value
                              ? "Verify OTP"
                              : "Continue",
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        );

                      }),

                    ),
                  ),

                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12),
                      children: [
                        const TextSpan(
                          text: "By continuing, you agree to our ",
                        ),
                        TextSpan(
                          text: "Terms & Privacy Policy",
                          style: const TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w600),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {},
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10)

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}