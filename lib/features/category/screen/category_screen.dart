import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skills_app/core/constant/app_color.dart';
import 'package:skills_app/core/widget/app_card.dart';
import '../../../core/constant/app_size.dart';
import '../../../core/widget/my_appbar.dart';
import '../../subcategory/controller/subategory_controller.dart';
import '../../subcategory/model/subcategory_model.dart';
import '../controller/category_controller.dart';

class CategoryScreen extends StatefulWidget {
  final String categoryId;
  final String category;

  const CategoryScreen({
    super.key,
    required this.categoryId,
    required this.category,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final categoryController = Get.find<CategoryController>();
  final subController = Get.find<SubCategoryController>();

  String? selectedCategoryId;
  String? selectedCategory;
  final ScrollController _categoryScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    selectedCategoryId = widget.categoryId;
    selectedCategory = widget.category;

    subController.fetchSubCategories(int.parse(selectedCategoryId!));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      syncCategoryScroll();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToSelectedCategory();
    });
  }

  void animateToCategory(int index) {
    if (!_categoryScrollController.hasClients) return;

    const itemHeight = 90.0;
    final offset = index * itemHeight;

    _categoryScrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void onCategoryTap(String categoryId, String category) {
    setState(() {
      selectedCategoryId = categoryId;
      selectedCategory = category;
    });

    subController.fetchSubCategories(int.parse(categoryId));

    final index = categoryController.categoryList
        .indexWhere((c) => c.id.toString() == categoryId);

    if (index != -1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        animateToCategory(index);
      });
    }
  }

  void scrollToSelectedCategory() {
    if (selectedCategoryId == null) return;
    if (!_categoryScrollController.hasClients) return;
    if (categoryController.categoryList.isEmpty) return;

    final index = categoryController.categoryList
        .indexWhere((c) => c.id.toString() == selectedCategoryId);

    if (index == -1) return;

    const itemHeight = 90.0;
    final offset = index * itemHeight;

    final max = _categoryScrollController.position.maxScrollExtent;
    final min = _categoryScrollController.position.minScrollExtent;

    _categoryScrollController.animateTo(
      offset.clamp(min, max),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void syncCategoryScroll() {
    if (categoryController.categoryList.isEmpty) return;

    final index = categoryController.categoryList
        .indexWhere((c) => c.id.toString() == selectedCategoryId);

    if (index == -1) return;

    animateToCategory(index);
  }

  @override
  void dispose() {
    _categoryScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: myAppBar(
        title: 'Categories',
        showBackButton: true,
        backgroundColor: AppColor.primary,
        titleColor: AppColor.white,
        buttonColor: AppColor.white,
      ),
      body: Row(
        children: [
          /// LEFT CATEGORY LIST
          Container(
            width: context.sWidth * 0.24,
            color: AppColor.white,
            child: Obx(() {
              if (categoryController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                controller: _categoryScrollController,
                itemCount: categoryController.categoryList.length,
                itemBuilder: (context, index) {
                  final category = categoryController.categoryList[index];

                  final selectedIndex = categoryController.categoryList
                      .indexWhere((c) => c.id.toString() == selectedCategoryId);

                  final isSelected = index == selectedIndex;
                  final isPrev = index == selectedIndex - 1;
                  final isNext = index == selectedIndex + 1;

                  return GestureDetector(
                    onTap: () => onCategoryTap(
                      category.id.toString(),
                      category.categoryName.toString(),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ?AppColor.white:AppColor.primary,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(
                            (isSelected || isNext) ? 16 : 0,
                          ),
                          bottomRight: Radius.circular(
                            (isSelected || isPrev) ? 16 : 0,
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: context.sHeight * 0.06,
                            child: category.categoryImage != null
                                ? Image.network(
                              color:isSelected ? AppColor.primary: AppColor.white,
                              category.categoryImage!,
                              height: context.sHeight * 0.04,
                              width: context.sHeight * 0.04,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.image_not_supported_outlined,
                                  color: Colors.grey,
                                );
                              },
                            )
                                : const Icon(
                              Icons.image_not_supported_outlined,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            category.categoryName ?? "",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                              fontSize: context.text12,
                              color: isSelected
                                  ? AppColor.primary
                                  : AppColor.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),

          /// RIGHT CONTENT Subcategory
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [

                     AppCard(
                       // height: context.sHeight*0.1,
                       hasBorder: true,
                       width: double.infinity,
                       margin: EdgeInsets.zero,
                       child: Text(
                         selectedCategory ?? "",
                         style:  TextStyle(
                           fontSize:context.text14,
                           fontWeight: FontWeight.w600,
                           color: AppColor.primary
                         ),
                       ),
                     ),
                      // Divider(thickness: 1),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                /// SUBCATEGORY GRID
                Expanded(
                  child: Obx(() {
                    if (subController.isLoading.value) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 10.0, left: 20),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Please Wait...",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      );
                    }

                    final List<SubCategory> subcategories =
                        subController.subCategories;

                    if (subcategories.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 10.0, left: 20),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "No Subcategory Available",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: subcategories.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 18,
                        crossAxisSpacing: 18,
                        childAspectRatio: 0.7,
                      ),
                      itemBuilder: (_, index) {
                        final sub = subcategories[index];

                        return InkWell(
                          onTap: () {
                            Get.toNamed('/service', parameters: {
                              'id': sub.id.toString(),
                            });
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppCard(
                                height:context.sHeight*0.08,
                                width: context.sHeight*0.08,
                                margin: EdgeInsets.zero,
                                padding:  EdgeInsets.all(context.sWidth*0.04),
                                hasBorder: true,
                                child: (sub.subcategoryImage != null &&
                                    sub.subcategoryImage!.isNotEmpty)
                                    ? Image.network(
                                      sub.subcategoryImage!,
                                      fit: BoxFit.fill,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(
                                          Icons
                                              .image_not_supported_outlined,
                                          color: Colors.grey,
                                        );
                                      },
                                    )
                                    : const Icon(
                                  Icons.image_not_supported_outlined,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                sub.subcategoryName,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}