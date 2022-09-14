import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shopping_app/models/product.dart';
import 'package:shopping_app/services/product_service.dart';

abstract class IProductsRepo {
  Future<Product> getProductById({
    required int productId,
  });

  Future<List<Product>> getProductsByCategory({
    required String categoryName,
  });

  Future<List<Product>> getAllProducts();

  Future<List<Product>> searchProducts({required String query});
}

class ProductsRepo implements IProductsRepo {
  final IProductService _productService;

  ProductsRepo({
    required IProductService productService,
  }) : _productService = productService;

  @override
  Future<Product> getProductById({required int productId}) async {
    final http.Response response =
        await _productService.getProductById(productId: productId);
    return Product.fromMap(jsonDecode(response.body));
  }

  @override
  Future<List<Product>> getProductsByCategory({
    required String categoryName,
  }) async {
    try {
      final http.Response response = await _productService
          .getProductsByCategory(categoryName: categoryName);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['products'] as List;
        return data.map((e) => Product.fromMap(e)).toList();
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<Product>> getAllProducts() async {
    try {
      final http.Response response = await _productService.getAllProducts();
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['products'] as List;
        return data.map((e) => Product.fromMap(e)).toList();
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<Product>> searchProducts({required String query}) async {
    try {
      final response = await _productService.searchProducts(query: query);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['products'] as List;
        return data.map((e) => Product.fromMap(e)).toList();
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
