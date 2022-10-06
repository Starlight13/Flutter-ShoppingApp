import 'package:get_it/get_it.dart';
import 'package:shopping_app/repositories/auth_repo.dart';
import 'package:shopping_app/repositories/category_repo.dart';
import 'package:shopping_app/repositories/favourites_repo.dart';
import 'package:shopping_app/repositories/products_repo.dart';
import 'package:shopping_app/services/auth_service.dart';
import 'package:shopping_app/services/category_service.dart';
import 'package:shopping_app/services/favourites_service.dart';
import 'package:shopping_app/services/product_service.dart';
import 'package:shopping_app/viewmodels/auth_view_model.dart';
import 'package:shopping_app/viewmodels/cart_view_model.dart';
import 'package:shopping_app/viewmodels/category_view_model.dart';
import 'package:shopping_app/viewmodels/favourites_view_model.dart';
import 'package:shopping_app/viewmodels/product_view_model.dart';

final GetIt sl = GetIt.I;

void setupLocator() {
  // // Services
  sl.registerLazySingleton<ICategoryService>(() => CategoryService());
  sl.registerLazySingleton<IProductService>(() => ProductService());
  sl.registerLazySingleton<IAuthService>(
    () => AuthService(),
  );
  sl.registerLazySingleton<IFavouritesService>(() => FavouritesService());

  // Repositories
  sl.registerLazySingleton<ICategoryRepo>(
    () => CategoryRepo(categoryService: sl.get()),
  );
  sl.registerLazySingleton<IProductsRepo>(
    () => ProductsRepo(productService: sl.get()),
  );
  sl.registerLazySingleton<IAuthRepo>(
    () => AuthRepo(authService: sl.get()),
  );
  sl.registerLazySingleton<IFavoutiresRepo>(
    () => FavouritesRepo(favouritesService: sl.get()),
  );

  // View models
  sl.registerLazySingleton<ICategoryViewModel>(
    () => CategoryViewModel(categoryRepo: sl.get(), productsRepo: sl.get()),
  );
  sl.registerLazySingleton<IProductViewModel>(
    () => ProductViewModel(),
  );
  sl.registerLazySingleton<ICartViewModel>(
    () => CartViewModel(),
  );
  sl.registerLazySingleton<IAuthViewModel>(
    () => AuthViewModel(authRepo: sl.get()),
  );
  sl.registerLazySingleton<IFavouritesViewModel>(
    () => FavouritesViewModel(favoutiresRepo: sl.get(), productsRepo: sl.get()),
  );
}
