import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shopping_app/models/category.dart';
import 'package:shopping_app/services/category_service.dart';

abstract class ICategoryRepo {
  Future<List<Category>> getAllCategories();
}

class CategoryRepo implements ICategoryRepo {
  final ICategoryService _categoryService;

  CategoryRepo({
    required ICategoryService categoryService,
  }) : _categoryService = categoryService;

  @override
  Future<List<Category>> getAllCategories() async {
    try {
      final http.Response response = await _categoryService.getAllCategories();
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body) as List;
        return data.map((e) => Category(name: e)).toList();
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
