import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../service/screen/service_screen.dart';
import '../../subcategory/controller/subategory_controller.dart';
import '../../subcategory/model/subcategory_model.dart';
import '../../subcategory/repository/subcategory_repository.dart';
import '../controller/category_controller.dart';


class CategoryScreen extends StatefulWidget {
  final String categoryId;
  const CategoryScreen({super.key, required this.categoryId});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final CategoryController categoryController = Get.put(CategoryController());
  final SubCategoryController subController =
  Get.put(SubCategoryController(repository: SubCategoryRepository()));

  String? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    selectedCategoryId = widget.categoryId;

    // Fetch subcategories for initial category
    subController.fetchSubCategories(int.parse(selectedCategoryId!));
  }

  void onCategoryTap(String categoryId) {
    setState(() {
      selectedCategoryId = categoryId;
    });
    subController.fetchSubCategories(int.parse(categoryId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      appBar: AppBar(
        title: const Text("Categories"),
        titleTextStyle: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        scrolledUnderElevation: 0,
        shadowColor: Colors.transparent,
      ),
      body: Row(
        children: [
          /// LEFT CATEGORY LIST
          Container(
            width: 100,
            color: Colors.grey.shade100,
            child: Obx(() {
              if (categoryController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                itemCount: categoryController.categoryList.length,
                itemBuilder: (context, index) {
                  final category = categoryController.categoryList[index];

                  return GestureDetector(
                    onTap: () => onCategoryTap(category.id.toString()),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: (selectedCategoryId == category.id.toString())
                            ? Colors.blue.shade50
                            : Colors.white,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 60,
                            child: category.categoryImage != null
                                ? Image.network(
                              category.categoryImage!,
                              height: 40,
                              width: 40,
                              errorBuilder:
                                  (context, error, stackTrace) {
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
                              fontSize: 11,
                              color: (selectedCategoryId ==
                                  category.id.toString())
                                  ? Colors.blueAccent
                                  : Colors.black87,
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: const [
                      Text("Subcategories",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      SizedBox(width: 8),
                      Expanded(
                          child: Divider(
                            thickness: 1,
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                /// SUBCATEGORY GRID
                Expanded(
                  child: Obx(() {
                    if (subController.isLoading.value) {
                      return Padding(
                        padding:  EdgeInsets.only(top: 10.0,left: 20),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text("Please Wait...", style: TextStyle(color: Colors.grey),)),
                      );
                    }

                    final List<SubCategory> subcategories =
                        subController.subCategories;

                    if (subcategories.isEmpty) {
                      return Padding(
                        padding:  EdgeInsets.only(top: 10.0,left: 20),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text("No Subcategory Available", style: TextStyle(color: Colors.grey),)),
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ServiceScreen(
                                    subcategoryId: sub.id.toString(),
                                  ),
                                ));
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 64,
                                width: 64,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  shape: BoxShape.circle,
                                ),
                                child: sub.subcategoryImage.isNotEmpty
                                    ? Image.network(
                                  sub.subcategoryImage,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) {
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