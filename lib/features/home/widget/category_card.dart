import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
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
          child: CachedNetworkImage(
            imageUrl: category.categoryImage.toString(),
            fit: BoxFit.cover,
            width: context.sHeight*0.1,
            height: context.sHeight*0.1,
            placeholder: (context, url) => Container(
              color: Colors.grey[100],
              alignment: Alignment.center,
              child: FaIcon(
                FontAwesomeIcons.chalkboardTeacher,
                color: Colors.grey[400],
                size: 25,
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[200],
              child: const Icon(Icons.broken_image_outlined, color: Colors.grey, size: 25),
            ),
          ),
          onTap: () {
            Get.toNamed('/category', parameters: {
              'id': category.id.toString(),
              'name': category.categoryName.toString(),
            });
          },
          // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryScreen(
          //     categoryId: category.id.toString(),
          //     category: category.categoryName.toString()),)),
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
