
class SubCategoryResponse {
  final String category;
  final int count;
  final List<SubCategory> data;

  SubCategoryResponse({
    required this.category,
    required this.count,
    required this.data,
  });

  factory SubCategoryResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<SubCategory> subcategories =
    list.map((i) => SubCategory.fromJson(i)).toList();

    return SubCategoryResponse(
      category: json['category'],
      count: json['count'],
      data: subcategories,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'count': count,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class SubCategory {
  final int id;
  final int category;
  final String subcategoryName;
  final String? subcategoryImage;
  final String categoryName;

  SubCategory({
    required this.id,
    required this.category,
    required this.subcategoryName,
    required this.subcategoryImage,
    required this.categoryName,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'],
      category: json['category'],
      subcategoryName: json['subcategory_name'],
      subcategoryImage: json['subcategory_image'],
      categoryName: json['category_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'subcategory_name': subcategoryName,
      'subcategory_image': subcategoryImage,
      'category_name': categoryName,
    };
  }
}