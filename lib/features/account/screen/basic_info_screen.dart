import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/helper/auth_preferences.dart';
import '../controller/user_profile_controller.dart';
import '../model/user_profile_model.dart';

class _C {
  static const primary     = Color(0xFF0D6E6E);
  static const primaryDark = Color(0xFF094F4F);
  static const accent      = Color(0xFFFFB347);
  static const surface     = Color(0xFFF4F7F7);
  static const card        = Color(0xFFFFFFFF);
  static const textDark    = Color(0xFF0D1F1F);
  static const textMid     = Color(0xFF4A6565);
  static const textLight   = Color(0xFF8AABAB);
  static const chipBg      = Color(0xFFE6F2F2);
}

class BasicInfoScreen extends StatefulWidget {
  const BasicInfoScreen({super.key});

  @override
  State<BasicInfoScreen> createState() => _BasicInfoScreenState();
}

class _BasicInfoScreenState extends State<BasicInfoScreen> {
  final UserProfileController controller = Get.put(UserProfileController());

  final _formKey      = GlobalKey<FormState>();
  final nameController  = TextEditingController();
  final emailController = TextEditingController();
  final bioController   = TextEditingController();

  File?   selectedImage;
  String? networkImage;
  String? selectedGender;
  int?    userId;

  final List<String> genderList = ["Male", "Female", "Other"];

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  void loadProfile() async {
    userId = await AuthPreferences.getUserId();
    if (userId == null) return;

    await controller.fetchUserProfile(userId!);
    final profile = controller.userProfile.value;

    if (profile != null) {
      nameController.text  = profile.userName  ?? "";
      emailController.text = profile.userEmail ?? "";
      bioController.text   = profile.userBio   ?? "";
      selectedGender = normalizeGender(profile.userGender);
      networkImage   = profile.userImage;
      setState(() {});
    }
  }

  String? normalizeGender(String? gender) {
    if (gender == null) return null;
    final g = gender.toLowerCase().trim();
    if (g == "male"   || g == "m") return "Male";
    if (g == "female" || g == "f") return "Female";
    if (g == "other")               return "Other";
    return null;
  }

  void saveProfile() {
    if (!_formKey.currentState!.validate()) return;
    if (userId == null) return;
    if (selectedGender == null) {
      Get.snackbar("Error", "Please select gender",
          backgroundColor: Colors.red.shade50,
          colorText: Colors.red.shade700);
      return;
    }

    controller.updateProfile(
      userId!,
      UserProfileModel(
        userPhone:  "",
        userName:   nameController.text.trim(),
        userEmail:  emailController.text.trim(),
        userGender: selectedGender!,
        userBio:    bioController.text.trim(),
        user:       userId!,
      ),
      imageFile: selectedImage,
    );
  }

  void pickImage() async {
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
      backgroundColor: _C.surface,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: _C.primary),
          );
        }

        return Column(
          children: [
            // ── Gradient Header ──────────────────────────────────────────────
            _buildHeader(context),

            // ── Form ─────────────────────────────────────────────────────────
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _fieldLabel("Full Name"),
                      _inputField(
                        controller: nameController,
                        hint: "Enter your full name",
                        icon: Icons.person_outline_rounded,
                        validator: (v) =>
                        (v == null || v.trim().isEmpty) ? "Enter name" : null,
                      ),

                      const SizedBox(height: 18),
                      _fieldLabel("Email Address"),
                      _inputField(
                        controller: emailController,
                        hint: "Enter your email",
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return "Enter email";
                          if (!v.contains("@")) return "Enter valid email";
                          return null;
                        },
                      ),

                      const SizedBox(height: 18),
                      _fieldLabel("Phone Number"),
                      _inputField(
                        initialValue:
                        controller.userProfile.value?.userPhone ?? "",
                        hint: "Phone number",
                        icon: Icons.phone_outlined,
                        readOnly: true,
                        suffix: const Icon(Icons.lock_outline_rounded,
                            size: 16, color: _C.textLight),
                      ),

                      const SizedBox(height: 18),
                      _fieldLabel("Gender"),
                      _genderSelector(),

                      const SizedBox(height: 18),
                      _fieldLabel("Short Bio"),
                      _inputField(
                        controller: bioController,
                        hint: "Write something about yourself…",
                        icon: Icons.edit_note_rounded,
                        maxLines: 3,
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),

            // ── Save Button ──────────────────────────────────────────────────
            _buildSaveButton(),
          ],
        );
      }),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_C.primaryDark, _C.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white, size: 20),
                  ),
                  const Expanded(
                    child: Text(
                      "Edit Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Avatar picker
            GestureDetector(
              onTap: pickImage,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: _C.primaryDark.withOpacity(0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        )
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 46,
                      backgroundColor: _C.chipBg,
                      backgroundImage: selectedImage != null
                          ? FileImage(selectedImage!) as ImageProvider
                          : (networkImage != null && networkImage!.isNotEmpty)
                          ? NetworkImage(networkImage!)
                          : null,
                      child: (selectedImage == null &&
                          (networkImage == null || networkImage!.isEmpty))
                          ? const Icon(Icons.person_outline_rounded,
                          size: 44, color: _C.primary)
                          : null,
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: _C.accent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt_rounded,
                        color: Colors.white, size: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            const Text(
              "Tap to change photo",
              style: TextStyle(color: Colors.white60, fontSize: 12),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ── Gender Selector ─────────────────────────────────────────────────────────
  Widget _genderSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _C.chipBg, width: 1.2),
      ),
      child: Row(
        children: genderList.map((gender) {
          final bool selected = selectedGender == gender;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedGender = gender),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selected ? _C.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  gender,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : _C.textMid,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Save Button ─────────────────────────────────────────────────────────────
  Widget _buildSaveButton() {
    return Container(
      color: _C.surface,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: controller.isLoading.value ? null : saveProfile,
          style: ElevatedButton.styleFrom(
            backgroundColor: _C.primary,
            disabledBackgroundColor: _C.textLight,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: controller.isLoading.value
              ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
                color: Colors.white, strokeWidth: 2.5),
          )
              : const Text(
            "Save & Continue",
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }

  // ── Field Label ─────────────────────────────────────────────────────────────
  Widget _fieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 13,
          color: _C.textDark,
        ),
      ),
    );
  }

  // ── Input Field ─────────────────────────────────────────────────────────────
  Widget _inputField({
    TextEditingController? controller,
    String? initialValue,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    int maxLines = 1,
    Widget? suffix,
    String? Function(String?)? validator,
  }) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: _C.chipBg, width: 1.2),
    );

    final decoration = InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: _C.textLight, fontSize: 13.5),
      filled: true,
      fillColor: readOnly ? const Color(0xFFF9FBFB) : _C.card,
      prefixIcon: Icon(icon, color: _C.textLight, size: 20),
      suffixIcon: suffix,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: border,
      enabledBorder: border,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _C.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );

    if (controller != null) {
      return TextFormField(
        controller: controller,
        decoration: decoration,
        keyboardType: keyboardType,
        readOnly: readOnly,
        maxLines: maxLines,
        style: const TextStyle(color: _C.textDark, fontSize: 14),
        validator: validator,
      );
    }

    return TextFormField(
      initialValue: initialValue,
      decoration: decoration,
      keyboardType: keyboardType,
      readOnly: readOnly,
      maxLines: maxLines,
      style: const TextStyle(color: _C.textDark, fontSize: 14),
      validator: validator,
    );
  }
}