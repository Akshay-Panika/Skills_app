import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:skills_app/features/dashboard/screen/dashboard_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isOtpSent = false;
  int resendSeconds = 30;

  final phoneController = TextEditingController();

  final List<TextEditingController> otpControllers =
  List.generate(6, (index) => TextEditingController());

  final List<FocusNode> focusNodes =
  List.generate(6, (index) => FocusNode());

  String get otpCode => otpControllers.map((e) => e.text).join();

  void verifyPhone() {
    if (phoneController.text.length >= 10) {
      setState(() => isOtpSent = true);
    }
  }

  void verifyOtp() {
    if (otpCode.length == 6) {
      debugPrint("OTP = $otpCode");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen(),));
    }
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

  Widget buildAnimatedInput() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, .15),
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: isOtpSent
          ? Row(
        key: const ValueKey("otp"),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(6, (index) => buildOtpBox(index)),
      )
          : Row(
        key: const ValueKey("phone"),
        children: [
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
              decoration: InputDecoration(
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
      ),
    );
  }

  Widget buildAnimatedProgress() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: isOtpSent ? 1 : .5),
      duration: const Duration(milliseconds: 400),
      builder: (context, value, child) {
        return LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.grey.shade200,
          color: Colors.blueAccent,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.grey.withOpacity(0.16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Center(
                child: Icon(
                  Icons.verified_user_outlined,
                  size: 80,
                  color: Colors.blueAccent.withOpacity(.7),
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(22),
                  topRight: Radius.circular(22),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  buildAnimatedProgress(),
                  const SizedBox(height: 30),

                  Text(
                    isOtpSent
                        ? 'Enter verification code'
                        : 'Verify your phone',
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 20),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    isOtpSent
                        ? 'Code sent to +91 ${phoneController.text}'
                        : 'We’ll send a 6-digit code to confirm your number.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),

                  const SizedBox(height: 24),
                  buildAnimatedInput(),

                  if (isOtpSent) ...[
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Didn’t receive code? Resend in 00:$resendSeconds",
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 13),
                        ),
                        TextButton(
                          onPressed: () =>
                              setState(() => isOtpSent = false),
                          child: const Text("Change number"),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isOtpSent ? verifyOtp : verifyPhone,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        isOtpSent ? 'Verify OTP' : 'Continue',
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style:
                      TextStyle(color: Colors.grey.shade600, fontSize: 12),
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

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}