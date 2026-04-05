import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skills_app/core/widget/app_button.dart';
import 'package:skills_app/core/widget/app_card.dart';
import 'package:skills_app/core/widget/flutter_toast.dart';
import 'package:skills_app/core/widget/my_appbar.dart';

import '../../../core/constant/app_size.dart';
import '../../category/controller/category_controller.dart';
import '../../location/controller/location_controller.dart';
import '../../subcategory/controller/subategory_controller.dart';
import '../../subcategory/repository/subcategory_repository.dart';
import '../controller/add_service_by_user_controller.dart';
import '../repository/add_service_by_user_repository.dart';
import 'package:skills_app/core/constant/app_color.dart';

class CreateAddScreen extends StatefulWidget {
  const CreateAddScreen({super.key});

  @override
  State<CreateAddScreen> createState() => _CreateAddScreenState();
}

class _CreateAddScreenState extends State<CreateAddScreen>
    with SingleTickerProviderStateMixin {

  final LocationController locationController = Get.find<LocationController>();
  final CategoryController categoryController = Get.put(CategoryController());
  final SubCategoryController subController = Get.put(
    SubCategoryController(repository: SubCategoryRepository()),
  );
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

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
    categoryController.categoryList();
  }

  @override
  void dispose() {
    _animController.dispose();
    titleController.dispose();
    descController.dispose();
    priceController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      setState(() => selectedImage = File(result.files.single.path!));
    }
  }

  Future<void> postService() async {
    if (selectedCategoryId == null) {
      FlutterToast.error("Select category");
      return;
    }
    if (selectedSubcategoryId == null) {
      FlutterToast.error("Select subcategory");
      return;
    }
    if (selectedImage == null) {
      FlutterToast.error("Select service image");
      return;
    }
    if (titleController.text.trim().isEmpty) {
      FlutterToast.error("Enter service title");
      return;
    }
    if (descController.text.trim().isEmpty) {
      FlutterToast.error("Enter description");
      return;
    }
    if (isPaid && priceController.text.trim().isEmpty) {
      FlutterToast.error("Enter price");
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

  // ── Field label ─────────────────────────────────────────────────────────
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

  // ── Input field ─────────────────────────────────────────────────────────
  Widget _inputField(
      BuildContext context, {
        TextEditingController? controller,
        String? initialValue,
        required String hint,
        required IconData icon,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: myAppBar(
          title: 'Add Service',
          showBackButton: true,
          backgroundColor: AppColor.primary,
          buttonColor: Colors.white,
          titleColor: Colors.white
      ),
      body: Column(
        children: [
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildImagePicker(context),
                      SizedBox(height: context.sHeight*0.04),
                      _buildTypeToggle(),
                      SizedBox(height: context.sHeight*0.01),
                      _fieldLabel(context, "Category"),
                      Row(
                        children: [
                          Expanded(child: _categoryDropdown()),
                          const SizedBox(width: 10),
                          Expanded(child: _subcategoryDropdown()),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _fieldLabel(context, "Service Title"),
                      const SizedBox(height: 8),
                      _inputField(context,
                          controller: titleController,
                          hint: "Enter service title",
                          icon: Icons.title_rounded),
                      const SizedBox(height: 16),
                      _fieldLabel(context, "Description"),
                      const SizedBox(height: 8),
                      _inputField(context,
                          controller: descController,
                          hint: "Describe your service…",
                          icon: Icons.notes_rounded,
                          maxLines: 4),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeInOut,
                        child: isPaid
                            ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            _fieldLabel(context, "Price"),
                            const SizedBox(height: 8),
                            _inputField(context,
                                controller: priceController,
                                hint: "0",
                                icon: Icons.currency_rupee_rounded,
                                keyboardType: TextInputType.number),
                          ],
                        )
                            : const SizedBox(),
                      ),
                      const SizedBox(height: 32),
                      Obx(() {
                        final loading = serviceController.isLoading.value;
                        return AppButton(
                          text: 'Post Service',
                          isLoading: loading,
                          onPressed: postService,
                        );
                      })
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePicker(BuildContext context) {
    return AppCard(
      height: context.sHeight*0.25,
      width: double.infinity,
      color: AppColor.surface,
      margin: EdgeInsets.zero,
      padding:selectedImage != null ? EdgeInsets.zero:EdgeInsets.all(16),
      onTap: pickImage,
      child: selectedImage != null
          ? Stack(
        alignment: Alignment.center,
        children: [
          Image.file(selectedImage!, fit: BoxFit.fill),
          Positioned(
              bottom: 0,right: 0,
              child: AppCard(
                  color: AppColor.surface,
                  margin: EdgeInsets.zero,
                  child: Row(
                    children: [
                      Icon(Icons.edit,size: 18,color: AppColor.primary),
                      const SizedBox(width: 4),
                      Text("Change", style: TextStyle(color: AppColor.primary)),
                    ],
                  ))),
        ],
      )
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_a_photo_outlined, color: AppColor.primary, size: context.sHeight*0.04),
          const SizedBox(height: 20),
          Text("Upload Service Image",
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: AppColor.subtitle, fontSize: context.text14)),
          const SizedBox(height: 4),
          Text("Tap to choose from gallery",
              style: TextStyle(fontSize: context.text12, color: AppColor.subtitle)),
        ],
      ),
    );
  }

  Widget _buildTypeToggle() {
    return Row(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Service Type',style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: context.text12,
          color: AppColor.title,
        )),
        Row(
          spacing: 0,
          children: ["Unpaid", "Paid"].map((label) {
            final bool selected = (label == "Paid" && isPaid) || (label == "Unpaid" && !isPaid);
            return AppCard(
              color: selected ? AppColor.primary : AppColor.surface,
              onTap: () => setState(() => isPaid = label == "Paid"),
              borderRadius:8 ,
              padding: EdgeInsets.symmetric(horizontal: context.sHeight*0.02,vertical: context.sHeight*0.01),
              margin: EdgeInsets.zero,
              child: Row(
                children: [
                  Icon(
                    label == "Paid" ? Icons.currency_rupee : Icons.currency_rupee,
                    size: context.text18,
                    color: selected ? AppColor.white : AppColor.title,
                  ),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: context.text12,
                      fontWeight: FontWeight.w500,
                      color: selected ? AppColor.white : AppColor.title,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  ({List<T> items, String? safeValue}) _dedup<T>(
      List<T> raw,
      String Function(T) key,
      String? currentValue,
      ) {
    final seen = <String>{};
    final items = raw.where((e) => seen.add(key(e))).toList();
    final ids = items.map(key).toSet();
    final safeValue = (currentValue != null && ids.contains(currentValue)) ? currentValue : null;
    return (items: items, safeValue: safeValue);
  }

  Widget _categoryDropdown() {
    final r = _dedup(
      categoryController.categoryList.toList(),
          (cat) => cat.id.toString(),
      selectedCategoryId,
    );

    if (r.safeValue != selectedCategoryId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => selectedCategoryId = r.safeValue);
      });
    }

    return DropdownButtonFormField<String>(
      value: r.safeValue,
      isExpanded: true,
      hint: const Text("Category", style: TextStyle(fontSize: 13.5, color: AppColor.title)),
      style: const TextStyle(fontSize: 13.5, color: AppColor.title),
      decoration: _dec("Category"),
      items: r.items.map((cat) {
        return DropdownMenuItem(
          value: cat.id.toString(),
          child: Text(cat.categoryName ?? "", style: const TextStyle(fontSize: 13.5)),
        );
      }).toList(),
      onChanged: (value) async {
        setState(() {
          selectedCategoryId = value;
          selectedSubcategoryId = null;
        });

        if (value != null) {
          await subController.fetchSubCategories(int.parse(value));

          if (subController.subCategories.isEmpty) {
            FlutterToast.error("No subcategory available");
          }
        }
      },
    );
  }

  Widget _subcategoryDropdown() {
    return Obx(() {
      final r = _dedup(
        subController.subCategories.toList(),
            (sub) => sub.id.toString(),
        selectedSubcategoryId,
      );

      if (r.safeValue != selectedSubcategoryId) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() => selectedSubcategoryId = r.safeValue);
        });
      }

      return DropdownButtonFormField<String>(
        value: r.safeValue,
        isExpanded: true,
        hint: const Text("Subcategory", style: TextStyle(fontSize: 13.5, color: AppColor.title)),
        style: const TextStyle(fontSize: 13.5, color: AppColor.title),
        decoration: _dec("Subcategory"),
        items: r.items.map((sub) {
          return DropdownMenuItem(
            value: sub.id.toString(),
            child: Text(sub.subcategoryName, style: const TextStyle(fontSize: 13.5)),
          );
        }).toList(),
        onChanged: (value) => setState(() => selectedSubcategoryId = value),
      );
    });
  }
}

InputDecoration _dec(String hint) {
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: AppColor.primary.withOpacity(.1), width: 1.2),
  );
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(fontSize: 13.5, color: AppColor.title),
    filled: true,
    fillColor: AppColor.surface,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    border: border,
    enabledBorder: border,
    focusedBorder: border,
  );
}