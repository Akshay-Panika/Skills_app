import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skills_app/core/constant/app_color.dart';
import '../../../core/constant/app_size.dart';
import '../../service/screen/service_screen.dart';
import '../../subcategory/controller/subategory_controller.dart';
import '../../subcategory/model/subcategory_model.dart';
import '../../subcategory/repository/subcategory_repository.dart';
import '../controller/category_controller.dart';

class CategoryScreen extends StatefulWidget {
  final String categoryId;
  final String category;
  const CategoryScreen({super.key, required this.categoryId, required this.category});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final CategoryController categoryController = Get.put(CategoryController());
  final SubCategoryController subController = Get.put(SubCategoryController(repository: SubCategoryRepository()));

  String? selectedCategoryId;
  String? selectedCategory;
  final ScrollController _categoryScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    selectedCategoryId = widget.categoryId;
    selectedCategory = widget.category;

    // Fetch subcategories for initial category
    subController.fetchSubCategories(int.parse(selectedCategoryId!));

    // Scroll to selected category after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToSelectedCategory();
    });
  }

  void onCategoryTap(String categoryId, String category) {
    setState(() {
      selectedCategoryId = categoryId;
      selectedCategory = category;
    });
    subController.fetchSubCategories(int.parse(categoryId));
    scrollToSelectedCategory();
  }

  void scrollToSelectedCategory() {
    if (selectedCategoryId == null) return;

    final index = categoryController.categoryList
        .indexWhere((c) => c.id.toString() == selectedCategoryId);
    if (index == -1) return;

    const itemHeight = 90.0;
    final offset = index * itemHeight;

    _categoryScrollController.animateTo(
      offset.clamp(
        _categoryScrollController.position.minScrollExtent,
        _categoryScrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.surface,
      appBar: AppBar(
        title: const Text("Categories"),
        titleTextStyle:  TextStyle(fontSize: context.text16, fontWeight: FontWeight.w500, color: AppColor.title),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        scrolledUnderElevation: 0,
        shadowColor: Colors.transparent,
      ),
      body: Row(
        children: [
          /// LEFT CATEGORY LIST
          Container(
            width: context.sWidth*0.24,
            color: Colors.grey.shade100,
            child: Obx(() {
              if (categoryController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                controller: _categoryScrollController,
                itemCount: categoryController.categoryList.length,
                itemBuilder: (context, index) {
                  final category = categoryController.categoryList[index];

                  return GestureDetector(
                    onTap: () => onCategoryTap(category.id.toString(), category.categoryName.toString()),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        // color: (selectedCategoryId == category.id.toString()) ? AppColor.primary : Colors.white,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: context.sHeight*0.06,
                            child: category.categoryImage != null
                                ? Image.network(
                              category.categoryImage!,
                              height: context.sHeight*0.04,
                              width: context.sHeight*0.04,
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
                              fontWeight: (selectedCategoryId == category.id.toString())?FontWeight.w500:FontWeight.w400,
                              fontSize: context.text12,
                              color: (selectedCategoryId == category.id.toString())
                                  ? AppColor.primary
                                  : AppColor.title,
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(selectedCategory.toString(),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Divider(
                          thickness: 1,
                        ),
                      ),
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
                          child: Text("Please Wait...", style: TextStyle(color: Colors.grey)),
                        ),
                      );
                    }

                    final List<SubCategory> subcategories = subController.subCategories;

                    if (subcategories.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 10.0, left: 20),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text("No Subcategory Available", style: TextStyle(color: Colors.grey)),
                        ),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: subcategories.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 18,
                        crossAxisSpacing: 18,
                        childAspectRatio: 0.8,
                      ),
                      itemBuilder: (_, index) {
                        final sub = subcategories[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ServiceScreen(subcategoryId: sub.id.toString()),
                              ),
                            );
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 64,
                                width: 64,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                padding: EdgeInsets.all(12),
                                child: (sub.subcategoryImage != null && sub.subcategoryImage!.isNotEmpty)
                                    ? ClipOval(
                                  child: Image.network(
                                    sub.subcategoryImage!,
                                    fit: BoxFit.fill,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.image_not_supported_outlined,
                                        color: Colors.grey,
                                      );
                                    },
                                  ),
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