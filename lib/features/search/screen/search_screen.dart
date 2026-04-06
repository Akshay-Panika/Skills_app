import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:skills_app/core/constant/app_color.dart';
import 'package:skills_app/core/constant/app_size.dart';

import '../../category/controller/category_controller.dart';
import '../../home/widget/category_card.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final CategoryController _categoryController =
  Get.put(CategoryController());

  final List<String> recentSearches = const [
    'Python for beginners',
    'UI UX design',
    'Digital Marketing',
    'Data Science',
    'Flutter development',
  ];

  final List<Map<String, dynamic>> recommendations =  [
    {
      'title': 'Top-rated Python & Machine Learning courses near you',
      'icon': Icons.code,
      'color': AppColor.primary.withOpacity(0.3),
      'iconColor': AppColor.primary,
    },
    {
      'title': 'Explore Graphic Design skills from expert tutors',
      'icon': Icons.brush,
      'color': AppColor.primary.withOpacity(0.3),
      'iconColor': AppColor.primary,
    },
    {
      'title': 'Find local & online English Speaking coaches',
      'icon': Icons.record_voice_over,
      'color': AppColor.primary.withOpacity(0.3),
      'iconColor': AppColor.primary,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Column(
        children: [
          _buildHeader(context),
          SizedBox(height: context.sHeight * 0.01),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLocationBar(context),
                  SizedBox(height: context.sHeight * 0.02),
                  _buildRecentSearches(context),
                  SizedBox(height: context.sHeight * 0.02),
                  _buildRecommendations(context),
                  SizedBox(height: context.sHeight * 0.02),
                  _buildCategories(context),
                  SizedBox(height: context.sHeight * 0.03),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Common Title Row (Reusable)
  Widget _sectionTitle(String title, BuildContext context) {
    return Row(
      children: [
        Container(
          width: 5,
          height: 16,
          decoration: BoxDecoration(
            color: AppColor.primary,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: context.text14,
            fontWeight: FontWeight.w700,
            color: AppColor.title,
          ),
        ),
      ],
    );
  }

  // 🔹 HEADER
  Widget _buildHeader(BuildContext context) {
    return Container(
      color: AppColor.primary,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 14,
        left: 12,
        right: 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.menu_book_rounded,
                  color: AppColor.white),
              const SizedBox(width: 8),
              Text(
                'SkillHub',
                style: TextStyle(
                  color: AppColor.white,
                  fontSize: context.text16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: context.sHeight * 0.01),

          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back,
                    color: AppColor.white),
              ),
              Expanded(
                child: Container(
                  height: context.sHeight * 0.05,
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      const FaIcon(FontAwesomeIcons.search,
                          color: AppColor.subtitle, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          style: TextStyle(
                              fontSize: context.text12,
                              color: AppColor.subtitle),
                          decoration: InputDecoration(
                            hintText:
                            'Find Courses, Skills, Tutors...',
                            hintStyle: TextStyle(
                                fontSize: context.text12,
                                color: AppColor.subtitle),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const Icon(Icons.mic,
                          color: AppColor.subtitle),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 🔹 LOCATION BAR
  Widget _buildLocationBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.primary, width: 0.3),
        borderRadius: BorderRadius.circular(6),
        color: AppColor.primary,
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on,
              color: AppColor.white),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Hadapsar, Pune',
              style: TextStyle(
                fontSize: context.text12,
                color: AppColor.white,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '🌐 Online & Offline',
              style: TextStyle(
                fontSize: context.text10,
                fontWeight: FontWeight.w600,
                color: AppColor.title,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 RECENT SEARCHES
  Widget _buildRecentSearches(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _sectionTitle("Recent Searches", context),
              Text(
                "Clear all",
                style: TextStyle(
                  fontSize: context.text12,
                  color: AppColor.primary,
                ),
              )
            ],
          ),
          SizedBox(height: context.sHeight * 0.015),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
            recentSearches.map(_buildTag).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.surface),
        borderRadius: BorderRadius.circular(20),
        color: AppColor.surface,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.history,
              size: 14, color: AppColor.subtitle),
          const SizedBox(width: 6),
          Text(label,
              style:
              const TextStyle(color: AppColor.title)),
        ],
      ),
    );
  }

  // 🔹 RECOMMENDATIONS
  Widget _buildRecommendations(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("Recommended for You", context),
          const SizedBox(height: 4),
          Text(
            'Based on your learning interests',
            style: TextStyle(
                fontSize: context.text12,
                color: AppColor.title),
          ),
          SizedBox(height: context.sHeight * 0.015),
          SizedBox(
            height: context.sHeight * 0.2,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: recommendations.length,
              separatorBuilder: (_, __) =>
              const SizedBox(width: 10),
              itemBuilder: (_, i) =>
                  _buildRecCard(recommendations[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecCard(Map<String, dynamic> rec) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.surface),
        borderRadius: BorderRadius.circular(8),
        color: AppColor.white,
      ),
      child: Column(
        children: [
          Container(
            height: 90,
            decoration: BoxDecoration(
              color: rec['color'],
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8)),
            ),
            child: Center(
              child: Icon(rec['icon'],
                  size: 40, color: rec['iconColor']),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              rec['title'],
              style: const TextStyle(
                  fontSize: 11.5, color: AppColor.title),
            ),
          )
        ],
      ),
    );
  }

  // 🔹 CATEGORIES
  Widget _buildCategories(BuildContext context) {
    return Obx(() {
      if (_categoryController.isLoading.value) {
        return const SizedBox();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16),
            child: _sectionTitle("Popular Skills", context),
          ),
          SizedBox(height: context.sHeight * 0.02),
          SizedBox(
            height: context.sHeight * 0.25,
            child: GridView.builder(
              padding:
              const EdgeInsets.symmetric(horizontal: 10),
              scrollDirection: Axis.horizontal,
              itemCount:
              _categoryController.categoryList.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                mainAxisExtent: 65,
              ),
              itemBuilder: (context, index) {
                final category =
                _categoryController.categoryList[index];
                return CategoryCard(category: category);
              },
            ),
          ),
        ],
      );
    });
  }
}