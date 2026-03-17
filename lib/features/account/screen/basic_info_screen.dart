import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../auth/helper/auth_preferences.dart';
import '../controller/user_profile_controller.dart';
import '../model/user_profile_model.dart';

class BasicInfoScreen extends StatefulWidget {
  const BasicInfoScreen({super.key});

  @override
  State<BasicInfoScreen> createState() => _BasicInfoScreenState();
}

class _BasicInfoScreenState extends State<BasicInfoScreen> {

  final UserProfileController controller = Get.put(UserProfileController());

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final bioController = TextEditingController();

  String? selectedGender;
  int? userId;

  final List<String> genderList = ["Male", "Female", "Other"];

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  /// LOAD PROFILE
  void loadProfile() async {
    userId = await AuthPreferences.getUserId();

    if (userId == null) return;

    await controller.fetchUserProfile(userId!);

    final profile = controller.userProfile.value;

    if (profile != null) {
      nameController.text = profile.userName ?? "";
      emailController.text = profile.userEmail ?? "";
      bioController.text = profile.userBio ?? "";

      selectedGender = normalizeGender(profile.userGender);

      setState(() {});
    }
  }

  /// NORMALIZE GENDER
  String? normalizeGender(String? gender) {
    if (gender == null) return null;

    String g = gender.toLowerCase().trim();

    if (g == "male" || g == "m") return "Male";
    if (g == "female" || g == "f") return "Female";
    if (g == "other") return "Other";

    return null;
  }

  /// SAVE PROFILE
  void saveProfile() {

    if (!_formKey.currentState!.validate()) return;

    if (userId == null) return;

    if (selectedGender == null) {
      Get.snackbar("Error", "Please select gender");
      return;
    }

    UserProfileModel model = UserProfileModel(
      userPhone: "",
      userName: nameController.text.trim(),
      userEmail: emailController.text.trim(),
      userGender: selectedGender!,
      userBio: bioController.text.trim(),
      user: userId!,
    );

    controller.updateProfile(userId!, model);
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
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text("Create Profile"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),

      body: Obx(() {

        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Center(
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.blueAccent.withOpacity(0.16),
                            child: FaIcon(FontAwesomeIcons.solidImage,color: Colors.white,size: 30,),
                          ),
                        ),

                        const SizedBox(height: 16),

                        Text(
                          "Tell us about you",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          "This information helps create your profile.",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),

                        const SizedBox(height: 20),

                        /// NAME
                        fieldLabel("Full Name"),
                        TextFormField(
                          controller: nameController,
                          decoration: inputDecoration("Enter your full name"),
                          validator: (v) =>
                          v == null || v.trim().isEmpty
                              ? "Enter name"
                              : null,
                        ),

                        const SizedBox(height: 20),

                        /// EMAIL
                        fieldLabel("Email"),
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: inputDecoration("Enter your email"),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return "Enter email";
                            }
                            if (!v.contains("@")) {
                              return "Enter valid email";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        /// GENDER
                        fieldLabel("Gender"),
                        DropdownButtonFormField<String>(
                          value: genderList.contains(selectedGender)
                              ? selectedGender
                              : null,
                          decoration: inputDecoration("Select gender"),
                          items: genderList.map((g) {
                            return DropdownMenuItem(
                              value: g,
                              child: Text(g),
                            );
                          }).toList(),
                          onChanged: (v) {
                            setState(() => selectedGender = v);
                          },
                          validator: (v) =>
                          v == null ? "Please select gender" : null,
                        ),

                        const SizedBox(height: 20),

                        /// BIO
                        fieldLabel("Short Bio"),
                        TextFormField(
                          controller: bioController,
                          maxLines: 3,
                          decoration:
                          inputDecoration("Write something about yourself"),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),

                /// BUTTON
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : const Text(
                        "Save & Continue",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  /// LABEL
  Widget fieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  /// 🔥 LIGHT BORDER INPUT DECORATION
  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,

      contentPadding:
      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
          width: 0.8,
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
          width: 0.8,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.blueAccent,
          width: 1.2,
        ),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1,
        ),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.2,
        ),
      ),
    );
  }
}