import 'package:http/http.dart' as http;

abstract class ICategoryService {
  Future<http.Response> getAllCategories();
}

class CategoryService implements ICategoryService {
  @override
  Future<http.Response> getAllCategories() async {
    final url = Uri.https('dummyjson.com', 'products/categories');
    return http.get(url);
  }
}
