import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skills_app/core/constant/app_color.dart';
import 'package:skills_app/core/constant/app_size.dart';
import 'package:skills_app/core/widget/app_button.dart';
import 'package:skills_app/core/widget/flutter_toast.dart';
import 'package:skills_app/core/widget/my_appbar.dart';
import '../../auth/helper/auth_preferences.dart';
import '../controller/user_profile_controller.dart';
import '../model/user_profile_model.dart';
import '../widget/basic_info_shimmer.dart';

class BasicInfoScreen extends StatefulWidget {
  const BasicInfoScreen({super.key});

  @override
  State<BasicInfoScreen> createState() => _BasicInfoScreenState();
}

class _BasicInfoScreenState extends State<BasicInfoScreen> {
  final UserProfileController controller = Get.put(UserProfileController());

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final bioController = TextEditingController();

  File? selectedImage;
  String? networkImage;
  String? selectedGender;
  int? userId;

  final List<String> genderList = ["Male", "Female", "Other"];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    userId = await AuthPreferences.getUserId();
    if (userId == null) return;

    await controller.fetchUserProfile(userId!);
    final profile = controller.userProfile.value;

    if (profile != null) {
      nameController.text = profile.userName ?? "";
      emailController.text = profile.userEmail ?? "";
      bioController.text = profile.userBio ?? "";
      selectedGender = _normalizeGender(profile.userGender);
      networkImage = profile.userImage;
      setState(() {});
    }
  }

  String? _normalizeGender(String? gender) {
    if (gender == null) return null;
    final g = gender.toLowerCase().trim();
    if (g == "male" || g == "m") return "Male";
    if (g == "female" || g == "f") return "Female";
    if (g == "other") return "Other";
    return null;
  }

  void _saveProfile() async {
    if (userId == null) return;

    if (nameController.text.trim().isEmpty) {
      FlutterToast.error("Please enter your full name");
      return;
    }

    final email = emailController.text.trim();
    if (email.isEmpty) {
      FlutterToast.error("Please enter your email address");
      return;
    } else if (!GetUtils.isEmail(email)) {
      FlutterToast.error("Please enter a valid email address");
      return;
    }

    if (bioController.text.trim().isEmpty) {
      FlutterToast.error("Please write your bio");
      return;
    }

    if (selectedGender == null || selectedGender!.isEmpty) {
      FlutterToast.error("Please select your gender");
      return;
    }

    final updatedProfile = UserProfileModel(
      user: userId!,
      userName: nameController.text.trim(),
      userEmail: email,
      userGender: selectedGender!,
      userBio: bioController.text.trim(),
      userPhone: controller.userProfile.value?.userPhone ?? "",
    );

    await controller.updateProfile(
      userId!,
      updatedProfile,
      imageFile: selectedImage,
    );

    FlutterToast.success("Profile updated successfully");
  }
  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      setState(() => selectedImage = File(result.files.single.path!));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: myAppBar(
        title: 'Profile',
        backgroundColor: AppColor.primary,
        titleColor: Colors.white,
        showBackButton: true,
        buttonColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return BasicInfoShimmer();
        }
        // return BasicInfoShimmer();
        return Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel(context, "Full Name"),
                    _inputField(
                      context,
                      controller: nameController,
                      hint: "Enter your full name",
                      icon: Icons.person_outline_rounded,
                    ),
                    const SizedBox(height: 18),
                    _fieldLabel(context, "Email Address"),
                    _inputField(
                      context,
                      controller: emailController,
                      hint: "Enter your email",
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 18),
                    _fieldLabel(context, "Phone Number"),
                    _inputField(
                      context,
                      initialValue: controller.userProfile.value?.userPhone ?? "",
                      hint: "Phone number",
                      icon: Icons.phone_outlined,
                      readOnly: true,
                      suffix: const Icon(
                        Icons.lock_outline_rounded,
                        size: 16,
                        color: AppColor.title,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _fieldLabel(context, "Gender"),
                    _genderSelector(context),
                    const SizedBox(height: 18),
                    _fieldLabel(context, "Short Bio"),
                    // _inputField(
                    //   context,
                    //   controller: bioController,
                    //   hint: "Write something about yourself…",
                    //   // icon: Icons.note_alt_outlined,
                    //
                    // ),
                    _mxgBox(controller: bioController),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: context.sHeight * 0.04,
              ),
              child: AppButton(
                text: "Save & Continue",
                isLoading: controller.isLoading.value,
                onPressed: _saveProfile,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: AppColor.primary,
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(height: context.sHeight * 0.02),
          GestureDetector(
            onTap: _pickImage,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.secondary.withOpacity(0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: context.sHeight * 0.048,
                    backgroundColor: AppColor.surface,
                    backgroundImage: selectedImage != null
                        ? FileImage(selectedImage!) as ImageProvider
                        : (networkImage != null && networkImage!.isNotEmpty)
                        ? NetworkImage(networkImage!)
                        : null,
                    child: (selectedImage == null &&
                        (networkImage == null || networkImage!.isEmpty))
                        ? const Icon(
                      Icons.person_outline_rounded,
                      size: 44,
                      color: AppColor.primary,
                    )
                        : null,
                  ),
                ),
                Container(
                  width: context.sHeight * 0.03,
                  height: context.sHeight * 0.03,
                  decoration: const BoxDecoration(
                    color: AppColor.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    color: AppColor.primary,
                    size: context.sHeight * 0.016,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: context.sHeight * 0.02),
          Text(
            "Tap to change photo",
            style: TextStyle(color: Colors.white60, fontSize: context.text14),
          ),
          SizedBox(height: context.sHeight * 0.02),
        ],
      ),
    );
  }

  Widget _fieldLabel(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: context.text12,
          color: AppColor.title,
        ),
      ),
    );
  }

  Widget _inputField(
      BuildContext context, {
        TextEditingController? controller,
        String? initialValue,
        required String hint,
        IconData? icon,
        TextInputType keyboardType = TextInputType.text,
        bool readOnly = false,
        int maxLines = 1,
        Widget? suffix,
      }) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColor.primary.withOpacity(.1), width: 1.2),
    );

    final decoration = InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: AppColor.subtitle, fontSize: context.text14),
      filled: true,
      fillColor: AppColor.surface,
      prefixIcon: Icon(icon, color: AppColor.title, size: context.sHeight * 0.02),
      suffixIcon: suffix,
      contentPadding: EdgeInsets.symmetric(
        horizontal: context.sHeight * 0.014,
        vertical: context.sHeight * 0.014,
      ),
      border: border,
      enabledBorder: border,
      focusedBorder: border,
      errorBorder: border,
      focusedErrorBorder: border,
    );

    return TextFormField(
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      decoration: decoration,
      keyboardType: keyboardType,
      readOnly: readOnly,
      maxLines: maxLines,
      style: TextStyle(color: AppColor.title, fontSize: context.text14),
    );
  }

  Widget _mxgBox({
    TextEditingController? controller,
}){
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColor.primary.withOpacity(.1), width: 1.2),
    );
    return TextField(
      maxLines: 4,
      minLines: 3,
      keyboardType: TextInputType.multiline,
      controller: bioController,
      style: TextStyle(color: AppColor.title, fontSize: context.text14),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColor.surface,
        hintText: "Enter description...",
        alignLabelWithHint: true,
        contentPadding: const EdgeInsets.all(12),
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        hintStyle: TextStyle(color: AppColor.subtitle, fontSize: context.text14),
      ),
    );
  }
  Widget _genderSelector(BuildContext context) {
    return Row(
      children: genderList.map((gender) {
        final bool selected = selectedGender == gender;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => selectedGender = gender),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.all(4),
              padding: EdgeInsets.symmetric(vertical: context.sHeight * 0.01),
              decoration: BoxDecoration(
                color: selected ? AppColor.primary : AppColor.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                gender,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: context.text14,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: selected ? AppColor.white : AppColor.primary,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}