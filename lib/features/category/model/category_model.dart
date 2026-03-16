import 'category_model.dart';

class CategoryResponseModel {

  int? count;
  List<CategoryModel>? data;

  CategoryResponseModel({
    this.count,
    this.data,
  });

  factory CategoryResponseModel.fromJson(Map<String, dynamic> json) {

    return CategoryResponseModel(

      count: json["count"],

      data: (json["data"] as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList(),

    );

  }

}

class CategoryModel {

  int? id;
  String? categoryName;
  String? categoryImage;

  CategoryModel({
    this.id,
    this.categoryName,
    this.categoryImage,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {

    return CategoryModel(
      id: json["id"],
      categoryName: json["category_name"],
      categoryImage: json["category_image"],
    );

  }

}