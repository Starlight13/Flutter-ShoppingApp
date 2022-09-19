import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/models/circle_transition_arguments.dart';
import 'package:shopping_app/screens/cart_screen/cart_screen.dart';
import 'package:shopping_app/screens/products_screen/components/circle_transition_clipper.dart';
import 'package:shopping_app/screens/products_screen/products_screen.dart';
import 'package:shopping_app/screens/unknown_page.dart';
import 'package:shopping_app/services/locator_service.dart';
import 'package:shopping_app/viewmodels/cart_view_model.dart';
import 'package:shopping_app/viewmodels/category_view_model.dart';
import 'package:shopping_app/viewmodels/product_view_model.dart';
import 'package:shopping_app/screens/product_details_screen.dart/product_details_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  setupLocator();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ICartViewModel>(
          create: (_) => sl.get(),
        ),
        ChangeNotifierProvider<ICategoryViewModel>(
          create: (_) => sl.get(),
        ),
        ChangeNotifierProvider<IProductViewModel>(
          create: (_) => sl.get(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        primaryColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          titleTextStyle: const TextStyle(
            fontSize: 20.0,
            color: Colors.black,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black.withOpacity(0.9),
          ),
        ),
      ),
      initialRoute: ProductsScreen.id,
      routes: {
        ProductsScreen.id: (context) => const ProductsScreen(),
        CartScreen.id: ((context) => const CartScreen()),
      },
      onGenerateRoute: (settings) {
        if (settings.name == ProductDetailsScreen.id) {
          final arguments = settings.arguments as CircleTransitionArguments;
          return PageRouteBuilder(
            pageBuilder: ((context, animation, secondaryAnimation) {
              return const ProductDetailsScreen();
            }),
            transitionDuration: const Duration(milliseconds: 500),
            reverseTransitionDuration: const Duration(milliseconds: 400),
            transitionsBuilder: (context, animation, _, child) {
              double beginRadius = 0.0;
              double endRadius = MediaQuery.of(context).size.height / 1.5;

              Offset screenCenter = Offset(
                MediaQuery.of(context).size.width / 2,
                MediaQuery.of(context).size.height / 2,
              );

              var radiusTween = Tween(begin: beginRadius, end: endRadius);
              var centerOffsetTweeen =
                  Tween(begin: arguments.circleStartCenter, end: screenCenter);

              var radiusTweenAnimation = animation.drive(radiusTween);
              var centerOffsetTweenAnimation =
                  animation.drive(centerOffsetTweeen);

              return ClipPath(
                clipper: CircleTransitionClipper(
                  center: centerOffsetTweenAnimation.value,
                  radius: radiusTweenAnimation.value,
                ),
                child: Stack(
                  children: [
                    Container(
                      color: Colors.white,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                    ),
                    Opacity(
                      opacity: animation.value,
                      child: child,
                    ),
                  ],
                ),
              );
            },
            settings: RouteSettings(arguments: arguments.productId),
          );
        }
        return MaterialPageRoute(builder: (_) => const UnknownPage());
      },
    );
  }
}
