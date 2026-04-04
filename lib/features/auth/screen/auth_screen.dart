import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:skills_app/core/constant/app_color.dart';
import 'package:skills_app/core/constant/app_size.dart';
import 'package:skills_app/core/widget/app_button.dart';
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

  Widget buildOtpBox(BuildContext context,int index) {
    return SizedBox(
      width: context.width*0.14,
      child: TextField(
        controller: otpControllers[index],
        focusNode: focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor:AppColor.surface,
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
        padding:  EdgeInsets.symmetric(horizontal:context.sWidth*0.04),

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
                      color: Color(0xFF0D6E6E),
                    );

                  }),

                  Obx(() {

                    return Column(
                      spacing: 5,
                      children: [

                        Text(
                          controller.isOtpSent.value
                              ? 'Enter verification code'
                              : 'Verify your phone',
                          style:  TextStyle(
                              color: AppColor.title,
                              fontWeight: FontWeight.w700,
                              fontSize: context.text18),
                        ),

                        Text(
                          controller.isOtpSent.value
                              ? 'Code sent to +91 ${phoneController.text}'
                              : 'We’ll send a 6-digit code to confirm your number.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColor.subtitle, fontSize: context.text14),
                        ),

                      ],
                    );

                  }),

                  Obx(() {

                    if(controller.isOtpSent.value){

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(6, (i) => buildOtpBox(context,i)),
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
                          fontSize: context.text14),
                    );

                  }),

                  Obx(() {
                     return AppButton(
                       isLoading: controller.loading.value,
                       text: controller.isOtpSent.value ? "Verify OTP" : "Continue",
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
                     );
                  }),


                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: context.text12),
                      children: [
                         TextSpan(
                          text: "By continuing, you agree to our ",
                           style:  TextStyle(
                               color: AppColor.title,
                               fontWeight: FontWeight.w600),
                        ),
                        TextSpan(
                          text: "Terms & Privacy Policy",
                          style:  TextStyle(
                              color: AppColor.primary,
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