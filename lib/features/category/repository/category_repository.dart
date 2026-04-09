
import 'package:flutter/cupertino.dart';
import 'package:skills_app/core/network/api_client.dart';
import 'package:skills_app/features/category/model/category_model.dart';

class CategoryRepository {

  static Future<CategoryResponseModel?> getCategory()async{

    try{
      final response = await ApiClient.dio.get('category/');

      if(response.statusCode == 200){
        return CategoryResponseModel.fromJson(response.data);
      }
    }catch(e){
      debugPrint('Category Api Error: $e');
    }
    return null;
  }
}