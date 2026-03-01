import 'package:flutter/material.dart';
import '../../home/data/categories_data.dart';
import '../../service/screen/service_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  int selectedCategoryIndex = 0;
  int bannerIndex = 0;

  final List<String> banners = [
    "https://dummyimage.com/600x200/1976d2/ffffff&text=Banner+1",
    "https://dummyimage.com/600x200/42a5f5/ffffff&text=Banner+2",
  ];

  final List<Map<String, dynamic>> hobbies = [
    {"icon": Icons.menu_book, "title": "Books"},
    {"icon": Icons.fitness_center, "title": "Gym & Fitness"},
    {"icon": Icons.music_note, "title": "Musical Instruments"},
    {"icon": Icons.sports_soccer, "title": "Sports Equipment"},
    {"icon": Icons.palette, "title": "Other Hobbies"},
    {"icon": Icons.arrow_forward_ios, "title": "View All"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Categories"),
        titleTextStyle: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        // elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: Colors.transparent,
      ),
      body: Row(
        children: [
          /// 🔹 LEFT CATEGORY LIST
          Container(
            width: 100,
            color: Colors.grey.shade100,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: categoriesData.length,
              itemBuilder: (context, index) {
                final cat = categoriesData[index];
                final isSelected = index == selectedCategoryIndex;

                return GestureDetector(
                  onTap: () {
                    setState(() => selectedCategoryIndex = index);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.blue.shade50
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 60,
                          child: Icon(
                            cat["icon"] as IconData,
                            size: 28,
                            color: isSelected ? Colors.blue : Colors.grey.shade600,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          cat["title"] as String,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected ? Colors.blue : Colors.grey.shade700,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          /// 🔹 RIGHT CONTENT
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: const [
                      Text("Books, Sports & Hobbies",
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

                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: hobbies.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 18,
                      crossAxisSpacing: 18,
                      childAspectRatio: 0.7,
                    ),
                    itemBuilder: (_, index) {
                      final item = hobbies[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceScreen(),));
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
                              child: Icon(item["icon"] as IconData, size: 28),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item["title"] as String,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}