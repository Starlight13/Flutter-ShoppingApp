import 'package:get_it/get_it.dart';
import 'package:shopping_app/repositories/category_repo.dart';
import 'package:shopping_app/repositories/products_repo.dart';
import 'package:shopping_app/services/category_service.dart';
import 'package:shopping_app/services/product_service.dart';

final GetIt sl = GetIt.I;

void setupLocator() {
  // // Services
  sl.registerLazySingleton<ICategoryService>(() => CategoryService());
  sl.registerLazySingleton<IProductService>(() => ProductService());

  // Repositories
  sl.registerLazySingleton<ICategoryRepo>(
    () => CategoryRepo(categoryService: sl.get()),
  );
  sl.registerLazySingleton<IProductsRepo>(
    () => ProductsRepo(productService: sl.get()),
  );
}
