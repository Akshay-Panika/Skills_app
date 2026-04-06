import 'package:flutter/material.dart';
import 'package:skills_app/core/widget/app_card.dart';

import '../../../core/constant/app_color.dart';
import '../../../core/constant/app_size.dart';
import '../../category/model/category_model.dart';
import '../../category/screen/category_screen.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        AppCard(
          height: context.sHeight*0.07,
          width: double.infinity,
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.zero,
          color: AppColor.surface,
          hasBorder: true,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              category.categoryImage ?? "",
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryScreen(categoryId: category.id.toString(),category: category.categoryName.toString()),)),
        ),
        Text(
          category.categoryName ?? "",
          textAlign: TextAlign.center,
          maxLines: 2,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          style:  TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: context.text10,
              height: 1.2,
              color: AppColor.subtitle
          ),
        )
      ],
    );  }
}
