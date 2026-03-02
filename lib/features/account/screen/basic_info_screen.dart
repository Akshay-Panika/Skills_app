import 'package:flutter/material.dart';

class BasicInfoScreen extends StatefulWidget {
  const BasicInfoScreen({super.key});

  @override
  State<BasicInfoScreen> createState() => _BasicInfoScreenState();
}

class _BasicInfoScreenState extends State<BasicInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final bioController = TextEditingController();

  String? selectedGender;
  String? profileImage;

  void pickProfile() {
    setState(() => profileImage = "selected");
  }

  void saveProfile() {
    if (_formKey.currentState!.validate()) {
      debugPrint("Name: ${nameController.text}");
      debugPrint("Email: ${emailController.text}");
      debugPrint("Gender: $selectedGender");
      debugPrint("Bio: ${bioController.text}");
      debugPrint("Profile: $profileImage");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Create Profile"),
        titleTextStyle: TextStyle(fontSize: 18,color: Colors.blueAccent,fontWeight: FontWeight.w700),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // const SizedBox(height: 10),

                      /// Header text
                      Text(
                        "Tell us about you",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "This information helps create your profile and personalize your experience.",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),

                      const SizedBox(height: 10),

                      /// Profile picker
                      Center(
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: pickProfile,
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 46,
                                  backgroundColor: Colors.grey.shade200,
                                  child: profileImage == null
                                      ? Icon(Icons.person,
                                      size: 40,
                                      color: Colors.grey.shade500)
                                      : const Icon(Icons.check,
                                      color: Colors.green,
                                      size: 32),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.edit,
                                    size: 16, color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// Name
                      _fieldLabel("Full Name"),
                      TextFormField(
                        controller: nameController,
                        decoration: inputDecoration("Enter your full name"),
                        validator: (v) =>
                        v == null || v.isEmpty ? "Please enter name" : null,
                      ),

                      const SizedBox(height: 20),

                      /// Email
                      _fieldLabel("Email"),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: inputDecoration("Enter your email"),
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Enter email";
                          if (!v.contains("@")) return "Enter valid email";
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      /// Gender
                      _fieldLabel("Gender"),
                      DropdownButtonFormField<String>(
                        value: selectedGender,
                        decoration: inputDecoration("Select gender"),
                        items: const [
                          DropdownMenuItem(value: "Male", child: Text("Male")),
                          DropdownMenuItem(value: "Female", child: Text("Female")),
                          DropdownMenuItem(value: "Other", child: Text("Other")),
                        ],
                        onChanged: (v) => setState(() => selectedGender = v),
                        validator: (v) =>
                        v == null ? "Please select gender" : null,
                      ),

                      const SizedBox(height: 20),

                      /// Bio
                      _fieldLabel("Short Bio"),
                      TextFormField(
                        controller: bioController,
                        maxLines: 3,
                        decoration: inputDecoration("Write something about yourself"),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),

              /// Bottom Button (sticky)
              Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black.withOpacity(.05),
                    )
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
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
      ),
    );
  }

  Widget _fieldLabel(String text) {
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

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
    );
  }
}