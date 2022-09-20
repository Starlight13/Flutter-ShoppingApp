import 'package:flutter/material.dart';
import 'package:shopping_app/models/category.dart';
import 'package:shopping_app/repositories/category_repo.dart';
import 'package:shopping_app/repositories/products_repo.dart';
import 'package:shopping_app/models/product.dart';

abstract class ICategoryViewModel with ChangeNotifier {
  bool get isLoading;
  int get categoriesCount;
  List<Category> get categories;
  Category? get selectedCategory;
  Product findById(int id);
  void setSelectedCategory(Category? category);
  Future fetchProductsForCategory(Category category);
}

class CategoryViewModel with ChangeNotifier implements ICategoryViewModel {
  final ICategoryRepo _categoryRepo;
  final IProductsRepo _productsRepo;
  List<Category> _categories = [];
  Category? _selectedCategory;
  bool _isLoading = false;

  CategoryViewModel({
    required ICategoryRepo categoryRepo,
    required IProductsRepo productsRepo,
  })  : _categoryRepo = categoryRepo,
        _productsRepo = productsRepo {
    _fetchCategories();
  }

  @override
  List<Category> get categories => _categories;

  @override
  int get categoriesCount => _categories.length;

  @override
  bool get isLoading => _isLoading;

  @override
  Category? get selectedCategory => _selectedCategory;

  @override
  void setSelectedCategory(Category? category) {
    _selectedCategory = category;
  }

  void _setLoadingState(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void _fetchCategories() async {
    _setLoadingState(true);
    _categories = await _categoryRepo.getAllCategories();
    _setLoadingState(false);
  }

  @override
  Future fetchProductsForCategory(Category category) async {
    if (category.products.isEmpty) {
      category.products.addAll(
        await _productsRepo.getProductsByCategory(
          categoryName: category.name,
        ),
      );
    }
  }

  @override
  Product findById(int id) {
    if (_selectedCategory != null) {
      return _selectedCategory!.products
          .firstWhere((product) => product.id == id);
    } else {
      throw Exception('No category is selected');
    }
  }
}
