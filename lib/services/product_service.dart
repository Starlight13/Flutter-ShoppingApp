import 'package:http/http.dart' as http;

abstract class IProductService {
  Future<http.Response> getProductById({
    required int productId,
  });

  Future<http.Response> getProductsByCategory({
    required String categoryName,
  });

  Future<http.Response> getAllProducts();

  Future<http.Response> searchProducts({required String query});
}

class ProductService implements IProductService {
  @override
  Future<http.Response> getProductById({required int productId}) {
    final url = Uri.https('dummyjson.com', 'products/$productId');
    return http.get(url);
  }

  @override
  Future<http.Response> getProductsByCategory({required String categoryName}) {
    final url = Uri.https('dummyjson.com', 'products/category/$categoryName');

    return http.get(url);
  }

  @override
  Future<http.Response> getAllProducts() {
    final url = Uri.https('dummyjson.com', 'products');
    return http.get(url);
  }

  @override
  Future<http.Response> searchProducts({required String query}) {
    final queryParams = {
      'q': query,
    };
    var url = Uri.https('dummyjson.com', 'products/search', queryParams);
    return http.get(url);
  }
}
