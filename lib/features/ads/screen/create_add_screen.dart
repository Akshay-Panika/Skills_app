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
  final bool isEdit;
  final dynamic serviceData;

  const CreateAddScreen({
    super.key,
    this.isEdit = false,
    this.serviceData,
  });

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
  String? networkImage;
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

    if (widget.isEdit && widget.serviceData != null) {
      final s = widget.serviceData;

      titleController.text = s.serviceName;
      descController.text = s.serviceDescription;
      priceController.text = s.serviceAmount ?? "";

      selectedCategoryId = s.category.toString();
      selectedSubcategoryId = s.subcategory.toString();

      isPaid = s.serviceStatus;

      if (widget.isEdit && widget.serviceData != null) {
        final s = widget.serviceData;

        titleController.text = s.serviceName;
        descController.text = s.serviceDescription;
        priceController.text = s.serviceAmount ?? "";

        selectedCategoryId = s.category.toString();
        selectedSubcategoryId = s.subcategory.toString();

        isPaid = s.serviceStatus;

        // ✅ IMPORTANT
        networkImage = s.serviceImage;
      }    }
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

    if (!widget.isEdit && selectedImage == null) {
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

    // ✅ EDIT MODE
    if (widget.isEdit) {
      await serviceController.updateService(
        serviceId: widget.serviceData.id,
        categoryId: int.parse(selectedCategoryId!),
        subcategoryId: int.parse(selectedSubcategoryId!),
        name: titleController.text.trim(),
        description: descController.text.trim(),
        amount: isPaid ? priceController.text.trim() : "0",
        status: isPaid,
        swipeStatus: false,
        // swipeStatus: widget.serviceData.swipeStatus,
        imagePath: selectedImage?.path ?? "",
        latitude: locationController.latitude.value,
        longitude: locationController.longitude.value,
      );
    }
    // ✅ CREATE MODE
    else {
      await serviceController.createService(
        categoryId: int.parse(selectedCategoryId!),
        subcategoryId: int.parse(selectedSubcategoryId!),
        name: titleController.text.trim(),
        description: descController.text.trim(),
        amount: isPaid ? priceController.text.trim() : "0",
        status: isPaid,
        swipeStatus: false,
        imagePath: selectedImage!.path,
        latitude: locationController.latitude.value,
        longitude: locationController.longitude.value,
      );
    }
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
      body: FadeTransition(
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

                _dropdownCard(),

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
    );
  }

  Widget _dropdownCard() {
    // Observables for dropdown visibility
    final showCategoryList = false.obs;
    final showSubcategoryList = false.obs;

    return Obx(() {
      final categoryItems = categoryController.categoryList;
      final subcategoryItems = subController.subCategories;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category & Subcategory Buttons
          Row(
            children: [
              Expanded(
                child: AppCard(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.all(14),
                  color: AppColor.surface,
                  hasBorder: true,
                  child: Text(
                    (selectedCategoryId != null && categoryItems.isNotEmpty)
                        ? categoryItems
                        .firstWhere(
                          (cat) => cat.id.toString() == selectedCategoryId!,
                      orElse: () => categoryItems.first,
                    )
                        .categoryName ?? "Category"
                        : "Category",
                    style: TextStyle(
                      color: selectedCategoryId != null ? AppColor.title : AppColor.subtitle,
                      fontWeight: FontWeight.w400,
                      fontSize: context.text14,
                    ),
                  ),
                  onTap: () {
                    showCategoryList.value = !showCategoryList.value;
                    showSubcategoryList.value = false;
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppCard(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.all(14),
                  color: AppColor.surface,
                  hasBorder: true,
                  onTap: (selectedCategoryId == null)//|| subcategoryItems.isEmpty
                      ? (){
                    FlutterToast.error("Please Select Category");
                  }
                      : () {
                    showSubcategoryList.value =
                    !showSubcategoryList.value;
                    showCategoryList.value = false;
                  },
                  child: Text(
                    (selectedSubcategoryId != null && subcategoryItems.isNotEmpty)
                        ? subcategoryItems
                        .firstWhere(
                          (sub) => sub.id.toString() == selectedSubcategoryId!,
                      orElse: () => subcategoryItems.first,
                    )
                        .subcategoryName ?? "Subcategory"
                        : "Subcategory",
                    style: TextStyle(
                      color: selectedSubcategoryId != null ? AppColor.title : AppColor.subtitle,
                      fontWeight: FontWeight.w400,
                      fontSize: context.text14,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Category List with RadioButton
          if (showCategoryList.value && categoryItems.isNotEmpty)
            AppCard(
              color: AppColor.surface,
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.only(top: 10),
              child: Column(
                children: categoryItems.map((cat) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      cat.categoryName ?? '',
                      style: TextStyle(
                        fontSize: context.text14,
                        fontWeight: selectedCategoryId  == cat.id.toString()?FontWeight.w600:FontWeight.w500,
                        color: selectedCategoryId  == cat.id.toString()
                            ? AppColor.title
                            : AppColor.subtitle,
                      ),
                    ),                    trailing: Radio<String>(
                      value: cat.id.toString(),
                      groupValue: selectedCategoryId,
                      onChanged: (value) async {
                        selectedCategoryId = value;
                        selectedSubcategoryId = null;
                        await subController.fetchSubCategories(int.parse(value!));
                        showCategoryList.value = false;
                      },
                    ),
                    onTap: () async {
                      selectedCategoryId = cat.id.toString();
                      selectedSubcategoryId = null;
                      await subController.fetchSubCategories(cat.id!);
                      showCategoryList.value = false;
                    },
                  );
                }).toList(),
              ),
            ),

          if (showSubcategoryList.value)
            AppCard(
              color: AppColor.surface,
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.only(top: 10),
              child: subcategoryItems.isEmpty
                  ? Center(
                    child: Text(
                      "No subcategories available",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColor.subtitle,
                      ),
                    ),
                  )
                  : Column(
                children: subcategoryItems.map((sub) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      sub.subcategoryName ?? '',
                      style: TextStyle(
                        fontSize: context.text14,
                        color: selectedSubcategoryId == sub.id.toString()
                            ? AppColor.title
                            : AppColor.subtitle,
                        fontWeight: selectedSubcategoryId == sub.id.toString()?FontWeight.w600:FontWeight.w500
                      ),
                    ),
                    trailing: Radio<String>(
                      value: sub.id.toString(),
                      groupValue: selectedSubcategoryId,
                      onChanged: (value) {
                        selectedSubcategoryId = value;
                        showSubcategoryList.value = false;
                      },
                    ),
                    onTap: () {
                      selectedSubcategoryId = sub.id.toString();
                      showSubcategoryList.value = false;
                    },
                  );
                }).toList(),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildImagePicker(BuildContext context) {
    return AppCard(
      height: context.sHeight*0.25,
      width: double.infinity,
      color: AppColor.surface,
      margin: EdgeInsets.zero,
      hasBorder: true,
      padding:selectedImage != null ? EdgeInsets.zero:EdgeInsets.all(16),
      onTap: pickImage,
      child: selectedImage != null
          ? Stack(
        alignment: Alignment.center,
        children: [
          Image.file(selectedImage!, fit: BoxFit.fill),
          Positioned(
            bottom: 0,
            right: 0,
            child: AppCard(
              color: AppColor.surface,
              margin: EdgeInsets.zero,
              child: Row(
                children: [
                  Icon(Icons.edit, size: 18, color: AppColor.primary),
                  const SizedBox(width: 4),
                  Text("Change", style: TextStyle(color: AppColor.primary)),
                ],
              ),
            ),
          ),
        ],
      )
          : (networkImage != null && networkImage!.isNotEmpty)
          ? Stack(
        alignment: Alignment.center,
        children: [
          Image.network(networkImage!, fit: BoxFit.fill),
          Positioned(
            bottom: 0,
            right: 0,
            child: AppCard(
              color: AppColor.surface,
              margin: EdgeInsets.zero,
              child: Row(
                children: [
                  Icon(Icons.edit, size: 18, color: AppColor.primary),
                  const SizedBox(width: 4),
                  Text("Change", style: TextStyle(color: AppColor.primary)),
                ],
              ),
            ),
          ),
        ],
      )
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_a_photo_outlined,
              color: AppColor.primary,
              size: context.sHeight * 0.04),
          const SizedBox(height: 20),
          Text("Upload Service Image",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColor.subtitle,
                  fontSize: context.text14)),
          const SizedBox(height: 4),
          Text("Tap to choose from gallery",
              style: TextStyle(
                  fontSize: context.text12,
                  color: AppColor.subtitle)),
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
}