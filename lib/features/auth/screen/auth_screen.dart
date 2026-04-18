import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:skills_app/core/constant/app_color.dart';
import 'package:skills_app/core/constant/app_size.dart';
import 'package:skills_app/core/widget/app_button.dart';
import '../../location/controller/location_controller.dart';
import '../controller/auth_controller.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  final phoneController = TextEditingController();
  final AuthController controller = Get.find<AuthController>();

  final List<TextEditingController> otpControllers = List.generate(6, (_) => TextEditingController());

  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();

    SmsAutoFill().code.listen((code) {
      if (code != null && code.length == 6) {
        fillOtp(code);
        // verifyOtpAuto();
      }
    });
  }

  void startListeningOtp() async {
    await SmsAutoFill().listenForCode();
  }

  void fillOtp(String code) {
    if (code.length != 6) return;

    for (int i = 0; i < 6; i++) {
      otpControllers[i].text = code[i];
    }
    // FocusScope.of(context).unfocus();

    setState(() {});
  }

  Future<void> checkClipboardPaste() async {
    ClipboardData? data = await Clipboard.getData('text/plain');

    if (data != null && data.text != null) {
      String text = data.text!.replaceAll(RegExp(r'[^0-9]'), '');

      if (text.length == 6) {
        fillOtp(text);
        verifyOtpAuto();
      }
    }
  }

  String getOtp() {
    return otpControllers.map((e) => e.text).join();
  }
  void verifyOtpAuto() async {
    final locationController = Get.find<LocationController>();

    String otp = getOtp();

    if (otp.length == 6) {
      bool success = await controller.verifyOtp(
        "+91${phoneController.text}",
        otp,
      );

      if (success) {
        if (locationController.hasLocation &&
            locationController.city.value.isNotEmpty &&
            locationController.state.value.isNotEmpty) {
          Get.offAllNamed('/dashboard');
        } else {
          Get.offAllNamed('/location');
        }
      }
    }
  }

  Widget buildOtpBox(BuildContext context,int index) {
    return Expanded(
      child: TextField(
        controller: otpControllers[index],
        focusNode: focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        onTap: () {
          checkClipboardPaste();
          FocusScope.of(context).requestFocus(focusNodes[index]);
        },
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

          // if (getOtp().length == 6) {
          //   // FocusScope.of(context).unfocus();
          //   verifyOtpAuto();
          // }
        },
      ),
    );
  }


  @override
  void dispose() {
    phoneController.dispose();
    for (var c in otpControllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    SmsAutoFill().unregisterListener();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColor.primary,

      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          /// ICON
          Expanded(
            child: Container(
              color: AppColor.primary,
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.chalkboardTeacher,
                  size: context.sWidth * 0.4,
                  color: AppColor.white,
                ),
              ),
            ),
          ),

          /// CONTENT
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: context.sWidth * 0.06),
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  /// TITLE
                  Obx(() {
                    return Column(
                      spacing: 5,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        Text(
                          controller.isOtpSent.value
                              ? 'Verify OTP'
                              : 'Enter Your Phone',
                          style: TextStyle(
                            color: AppColor.title,
                            fontWeight: FontWeight.w700,
                            fontSize: context.text20,
                          ),
                        ),

                        Text(
                          controller.isOtpSent.value
                              ? 'We have send a 5 digit OTP to +91 ${phoneController.text}'
                              : 'We’ll send you a verification code',
                          // textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColor.subtitle,
                            fontSize: context.text16,
                          ),
                        ),
                      ],
                    );
                  }),

                  /// INPUT AREA
                  Obx(() {
                    if (controller.isOtpSent.value) {
                      return Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Enter OTP',style: TextStyle(color: AppColor.subtitle),),
                          Row(
                            spacing: 10,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(6, (i) => buildOtpBox(context,i)),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Phone Number',style: TextStyle(color: AppColor.subtitle),),
                          Row(
                            children: [

                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text('+91'),
                              ),

                              const SizedBox(width: 10),

                              Expanded(
                                child: TextField(
                                  controller: phoneController,
                                  keyboardType: TextInputType.phone,
                                  maxLength: 10,
                                  decoration: InputDecoration(
                                    hintText: 'Enter phone number',
                                    filled: true,
                                    counterText: "",
                                    fillColor: Colors.grey.shade100,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    if (value.length == 10) {
                                      FocusScope.of(context).unfocus(); // 🔹 keyboard closes automatically
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                  }),

                  /// TIMER
                  Obx(() {
                    if (!controller.isOtpSent.value) return const SizedBox();

                    return Text(
                      "Please Wait... 00:${controller.resendSeconds.value}",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: context.text14,
                      ),
                    );
                  }),

                  /// BUTTON
                  Obx(() {
                    return AppButton(
                      isLoading: controller.loading.value,
                      text: controller.isOtpSent.value ? "Verify OTP" : "Continue",
                      onPressed: () async {
                        if (controller.isOtpSent.value) {
                          verifyOtpAuto();
                        } else {
                          controller.sendOtp("+91${phoneController.text}");
                          startListeningOtp();
                        }

                      },
                    );
                  }),

                  // const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}