import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../category/controller/category_controller.dart';
import '../../location/controller/location_controller.dart';
import '../../subcategory/controller/subategory_controller.dart';
import '../../subcategory/repository/subcategory_repository.dart';
import '../controller/add_service_by_user_controller.dart';
import '../repository/add_service_by_user_repository.dart';

class CreateAddScreen extends StatefulWidget {
  const CreateAddScreen({super.key});

  @override
  State<CreateAddScreen> createState() => _CreateAddScreenState();
}

class _CreateAddScreenState extends State<CreateAddScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final LocationController locationController = Get.find<LocationController>();

  final CategoryController categoryController = Get.put(CategoryController());
  final SubCategoryController subController = Get.put(
    SubCategoryController(repository: SubCategoryRepository()),
  );

  // Add your AddServiceByUserController
  final AddServiceByUserController serviceController = Get.put(
    AddServiceByUserController(repository: AddServiceByUserRepository()),
  );

  File? selectedImage;
  String? selectedCategoryId;
  String? selectedSubcategoryId;

  final titleController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();

  bool isPaid = false;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    categoryController.categoryList();
  }

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedImage = File(result.files.single.path!);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    titleController.dispose();
    descController.dispose();
    priceController.dispose();
    super.dispose();
  }

  InputDecoration chatDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontSize: 14),
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

  Future<void> postService() async {
    if (_formKey.currentState!.validate()) {
      if (selectedCategoryId == null || selectedSubcategoryId == null) {
        debugPrint("Error Please select category and subcategory");
        return;
      }

      if (selectedImage == null) {
        debugPrint("Error Please upload a service image");
        return;
      }

      await serviceController.createService(
        categoryId: int.parse(selectedCategoryId!),
        subcategoryId: int.parse(selectedSubcategoryId!),
        name: titleController.text.trim(),
        description: descController.text.trim(),
        amount: isPaid ? priceController.text.trim() : "0",
        status: isPaid,
        imagePath: selectedImage!.path,
        latitude: locationController.latitude.value,
        longitude: locationController.longitude.value,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Add Service"),
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black,
          fontSize: 18,
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  /// IMAGE PICKER
                  GestureDetector(
                    onTap: pickImage,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOut,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Container(
                        height: 160,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.file(
                                  selectedImage!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              )
                            : const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_a_photo_outlined, size: 36),
                                    SizedBox(height: 6),
                                    Text("Upload Service Image"),
                                  ],
                                ),
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// SERVICE TYPE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Service Type",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Row(
                        children: [
                          ChoiceChip(
                            label: const Text("Unpaid"),
                            selected: !isPaid,
                            onSelected: (val) => setState(() => isPaid = false),
                            backgroundColor: Colors.white,
                            checkmarkColor: Colors.blueAccent,
                            selectedColor: Colors.lightBlueAccent.withOpacity(
                              0.16,
                            ),
                          ),
                          const SizedBox(width: 10),
                          ChoiceChip(
                            label: const Text("Paid"),
                            selected: isPaid,
                            onSelected: (val) => setState(() => isPaid = true),
                            backgroundColor: Colors.white,
                            checkmarkColor: Colors.blueAccent,
                            selectedColor: Colors.lightBlueAccent.withOpacity(
                              0.16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// FORM
                  Column(
                    children: [
                      Obx(() {
                        return Row(
                          children: [
                            /// CATEGORY DROPDOWN
                            Expanded(
                              child: DropdownButtonFormField(
                                value: selectedCategoryId,
                                hint: const Text("Category",style: TextStyle(fontSize: 14),),
                                items: categoryController.categoryList.map((
                                  cat,
                                ) {
                                  return DropdownMenuItem(
                                    value: cat.id.toString(),
                                    child: Text(cat.categoryName ?? "",style: TextStyle(fontSize: 14),),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedCategoryId = value.toString();
                                    selectedSubcategoryId = null;
                                  });

                                  subController.fetchSubCategories(
                                    int.parse(value.toString()),
                                  );
                                },
                                decoration: chatDecoration("Category"),
                              ),
                            ),

                            const SizedBox(width: 10),

                            /// SUBCATEGORY DROPDOWN
                            Expanded(
                              child: DropdownButtonFormField(
                                value: selectedSubcategoryId,
                                hint: const Text("Subcategory",style: TextStyle(fontSize: 14),),
                                items: subController.subCategories.map((sub) {
                                  return DropdownMenuItem(
                                    value: sub.id.toString(),
                                    child: Text(sub.subcategoryName, style: TextStyle(fontSize: 14),),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedSubcategoryId = value.toString();
                                  });
                                },
                                decoration: chatDecoration("Subcategory"),
                              ),
                            ),
                          ],
                        );
                      }),

                      const SizedBox(height: 14),

                      TextFormField(
                        controller: titleController,
                        style: TextStyle(fontSize: 14),
                        decoration: chatDecoration("Service title"),
                        validator: (v) =>
                            v!.isEmpty ? "Please enter title" : null,
                      ),

                      const SizedBox(height: 14),

                      TextFormField(
                        controller: descController,
                        minLines: 3,
                        maxLines: null,
                        style: TextStyle(fontSize: 14),
                        decoration: chatDecoration("Describe your service"),
                      ),

                      /// PRICE FIELD ANIMATION
                      AnimatedSize(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeInOut,
                        child: isPaid
                            ? Column(
                                children: [
                                  const SizedBox(height: 14),
                                  TextFormField(
                                    controller: priceController,
                                    keyboardType: TextInputType.number,
                                    decoration: chatDecoration("Price")
                                        .copyWith(
                                          prefixText: "₹ ",
                                          prefixStyle: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                    validator: (v) {
                                      if (isPaid && (v == null || v.isEmpty)) {
                                        return "Enter price";
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              )
                            : const SizedBox(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),

                  /// POST BUTTON
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Obx(() {
                        return InkWell(
                          onTap: serviceController.isLoading.value
                              ? null
                              : postService,
                          child: Container(
                            width: 150,height: 45,
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: serviceController.isLoading.value
                                ? Center(
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : Center(
                                  child: Text(
                                      "Post Service",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                ),
                          ),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
