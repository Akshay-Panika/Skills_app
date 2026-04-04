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

// ─── Design Tokens ─────────────────────────────────────────────────────────────
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

class CreateAddScreen extends StatefulWidget {
  const CreateAddScreen({super.key});

  @override
  State<CreateAddScreen> createState() => _CreateAddScreenState();
}

class _CreateAddScreenState extends State<CreateAddScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final LocationController locationController =
  Get.find<LocationController>();
  final CategoryController categoryController =
  Get.put(CategoryController());
  final SubCategoryController subController = Get.put(
    SubCategoryController(repository: SubCategoryRepository()),
  );
  final AddServiceByUserController serviceController = Get.put(
    AddServiceByUserController(repository: AddServiceByUserRepository()),
  );

  File?   selectedImage;
  String? selectedCategoryId;
  String? selectedSubcategoryId;

  final titleController = TextEditingController();
  final descController  = TextEditingController();
  final priceController = TextEditingController();

  bool isPaid = false;

  late AnimationController _animController;
  late Animation<double>  _fadeAnim;
  late Animation<Offset>  _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim  = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
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
    if (!_formKey.currentState!.validate()) return;
    if (selectedCategoryId == null || selectedSubcategoryId == null) return;
    if (selectedImage == null) return;

    await serviceController.createService(
      categoryId:    int.parse(selectedCategoryId!),
      subcategoryId: int.parse(selectedSubcategoryId!),
      name:          titleController.text.trim(),
      description:   descController.text.trim(),
      amount:        isPaid ? priceController.text.trim() : "0",
      status:        isPaid,
      imagePath:     selectedImage!.path,
      latitude:      locationController.latitude.value,
      longitude:     locationController.longitude.value,
    );
  }

  // ── Input decoration ────────────────────────────────────────────────────────
  InputDecoration _dec(String hint, {Widget? prefix, String? prefixText}) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: _C.chipBg, width: 1.2),
    );
    return InputDecoration(
      hintText:        hint,
      hintStyle:       const TextStyle(color: _C.textLight, fontSize: 13.5),
      filled:          true,
      fillColor:       _C.card,
      prefixIcon:      prefix,
      prefixText:      prefixText,
      prefixStyle:     const TextStyle(
          fontWeight: FontWeight.w700, color: _C.primary, fontSize: 15),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border:        border,
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.surface,
      body: Column(
        children: [
          // ── Gradient Header ────────────────────────────────────────────────
          _buildHeader(context),

          // ── Form ──────────────────────────────────────────────────────────
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Image picker ──────────────────────────────────
                        _buildImagePicker(),

                        const SizedBox(height: 20),

                        // ── Service type ──────────────────────────────────
                        _sectionLabel("Service Type"),
                        const SizedBox(height: 8),
                        _buildTypeToggle(),

                        const SizedBox(height: 20),

                        // ── Category row ──────────────────────────────────
                        _sectionLabel("Category"),
                        const SizedBox(height: 8),
                        Obx(() => Row(
                          children: [
                            Expanded(child: _categoryDropdown()),
                            const SizedBox(width: 10),
                            Expanded(child: _subcategoryDropdown()),
                          ],
                        )),

                        const SizedBox(height: 16),

                        // ── Title ────────────────────────────────────────
                        _sectionLabel("Service Title"),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: titleController,
                          style: const TextStyle(
                              fontSize: 14, color: _C.textDark),
                          decoration: _dec("Enter service title",
                              prefix: const Icon(
                                  Icons.title_rounded,
                                  color: _C.textLight,
                                  size: 20)),
                          validator: (v) =>
                          (v == null || v.isEmpty) ? "Enter title" : null,
                        ),

                        const SizedBox(height: 16),

                        // ── Description ───────────────────────────────────
                        _sectionLabel("Description"),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: descController,
                          minLines: 3,
                          maxLines: null,
                          style: const TextStyle(
                              fontSize: 14, color: _C.textDark),
                          decoration: _dec("Describe your service…",
                              prefix: const Padding(
                                padding: EdgeInsets.only(bottom: 40),
                                child: Icon(Icons.notes_rounded,
                                    color: _C.textLight, size: 20),
                              )),
                        ),

                        // ── Price (animated) ──────────────────────────────
                        AnimatedSize(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeInOut,
                          child: isPaid
                              ? Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16),
                              _sectionLabel("Price"),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: priceController,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                    fontSize: 14, color: _C.textDark),
                                decoration:
                                _dec("0", prefixText: "₹  "),
                                validator: (v) {
                                  if (isPaid &&
                                      (v == null || v.isEmpty)) {
                                    return "Enter price";
                                  }
                                  return null;
                                },
                              ),
                            ],
                          )
                              : const SizedBox(),
                        ),

                        const SizedBox(height: 32),

                        // ── Post button ───────────────────────────────────
                        _buildPostButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────────
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 16, 16),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white, size: 20),
              ),
              const Expanded(
                child: Text(
                  "Add Service",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Image Picker ────────────────────────────────────────────────────────────
  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: pickImage,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 170,
        decoration: BoxDecoration(
          color: _C.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selectedImage != null ? _C.primary : _C.chipBg,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _C.primary.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: selectedImage != null
            ? Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.file(selectedImage!, fit: BoxFit.cover),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _C.primaryDark.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.edit_outlined,
                        color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text("Change",
                        style: TextStyle(
                            color: Colors.white, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ],
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 52,
              decoration: const BoxDecoration(
                  color: _C.chipBg, shape: BoxShape.circle),
              child: const Icon(Icons.add_a_photo_outlined,
                  color: _C.primary, size: 26),
            ),
            const SizedBox(height: 10),
            const Text("Upload Service Image",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: _C.textMid,
                    fontSize: 14)),
            const SizedBox(height: 4),
            const Text("Tap to choose from gallery",
                style: TextStyle(
                    fontSize: 12, color: _C.textLight)),
          ],
        ),
      ),
    );
  }

  // ── Service Type Toggle ─────────────────────────────────────────────────────
  Widget _buildTypeToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _C.chipBg, width: 1.2),
      ),
      child: Row(
        children: ["Unpaid", "Paid"].map((label) {
          final bool selected =
              (label == "Paid" && isPaid) || (label == "Unpaid" && !isPaid);
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(
                      () => isPaid = label == "Paid"),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selected ? _C.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      label == "Paid"
                          ? Icons.currency_rupee_rounded
                          : Icons.money_off_rounded,
                      size: 16,
                      color: selected ? Colors.white : _C.textLight,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: selected ? Colors.white : _C.textMid,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Deduplicate helper ──────────────────────────────────────────────────────
  /// Returns unique items by [key]. If the currently selected [value] appears
  /// more than once in the raw list, we still keep exactly one copy so Flutter
  /// won't assert. Returns the safe (possibly-nulled) value alongside items.
  ({List<T> items, String? safeValue}) _dedup<T>(
      List<T> raw,
      String Function(T) key,
      String? currentValue,
      ) {
    final seen  = <String>{};
    final items = raw.where((e) => seen.add(key(e))).toList();
    final ids   = items.map(key).toSet();
    final safeValue = (currentValue != null && ids.contains(currentValue))
        ? currentValue
        : null;
    return (items: items, safeValue: safeValue);
  }

  // ── Category Dropdown ───────────────────────────────────────────────────────
  Widget _categoryDropdown() {
    final r = _dedup(
      categoryController.categoryList.toList(),
          (cat) => cat.id.toString(),
      selectedCategoryId,
    );

    // Sync state without calling setState inside build
    if (r.safeValue != selectedCategoryId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => selectedCategoryId = r.safeValue);
      });
    }

    return DropdownButtonFormField<String>(
      value: r.safeValue,
      isExpanded: true,
      hint: const Text("Category",
          style: TextStyle(fontSize: 13.5, color: _C.textLight)),
      style: const TextStyle(fontSize: 13.5, color: _C.textDark),
      decoration: _dec("Category"),
      items: r.items.map((cat) {
        return DropdownMenuItem(
          value: cat.id.toString(),
          child: Text(cat.categoryName ?? "",
              style: const TextStyle(fontSize: 13.5)),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedCategoryId    = value;
          selectedSubcategoryId = null;
        });
        if (value != null) {
          subController.fetchSubCategories(int.parse(value));
        }
      },
    );
  }

  // ── Subcategory Dropdown ────────────────────────────────────────────────────
  Widget _subcategoryDropdown() {
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
      hint: const Text("Subcategory",
          style: TextStyle(fontSize: 13.5, color: _C.textLight)),
      style: const TextStyle(fontSize: 13.5, color: _C.textDark),
      decoration: _dec("Subcategory"),
      items: r.items.map((sub) {
        return DropdownMenuItem(
          value: sub.id.toString(),
          child: Text(sub.subcategoryName,
              style: const TextStyle(fontSize: 13.5)),
        );
      }).toList(),
      onChanged: (value) =>
          setState(() => selectedSubcategoryId = value),
    );
  }

  // ── Post Button ─────────────────────────────────────────────────────────────
  Widget _buildPostButton() {
    return Obx(() {
      final loading = serviceController.isLoading.value;
      return SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: loading ? null : postService,
          style: ElevatedButton.styleFrom(
            backgroundColor: _C.primary,
            disabledBackgroundColor: _C.textLight,
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
          ),
          child: loading
              ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
                color: Colors.white, strokeWidth: 2.5),
          )
              : const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.rocket_launch_rounded,
                  color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text(
                "Post Service",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // ── Section Label ───────────────────────────────────────────────────────────
  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 13,
        color: _C.textDark,
      ),
    );
  }
}