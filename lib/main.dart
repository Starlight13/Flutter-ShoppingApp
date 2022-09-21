import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/models/circle_transition_arguments.dart';
import 'package:shopping_app/screens/cart_screen/cart_screen.dart';
import 'package:shopping_app/screens/products_screen/components/circle_transition_clipper.dart';
import 'package:shopping_app/screens/products_screen/products_screen.dart';
import 'package:shopping_app/screens/splash_screen/splash_screen.dart';
import 'package:shopping_app/screens/unknown_page.dart';
import 'package:shopping_app/services/locator_service.dart';
import 'package:shopping_app/viewmodels/cart_view_model.dart';
import 'package:shopping_app/viewmodels/category_view_model.dart';
import 'package:shopping_app/viewmodels/product_view_model.dart';
import 'package:shopping_app/screens/product_details_screen/product_details_screen.dart';
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
            fontFamily: 'Raleway',
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
        fontFamily: 'Montserrat',
      ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => const SplashScreen(),
        ProductsScreen.id: (context) => const ProductsScreen(),
        CartScreen.id: ((context) => const CartScreen()),
      },
      onGenerateRoute: (settings) {
        if (settings.name == ProductDetailsScreen.id) {
          try {
            final arguments = settings.arguments as CircleTransitionArguments;
            return PageRouteBuilder(
              pageBuilder: ((context, animation, secondaryAnimation) {
                return const ProductDetailsScreen();
              }),
              transitionDuration: const Duration(milliseconds: 500),
              reverseTransitionDuration: const Duration(milliseconds: 400),
              transitionsBuilder: (context, animation, _, child) {
                return LayoutBuilder(
                  builder: ((context, constraints) {
                    Offset screenCenter = Offset(
                      constraints.maxWidth / 2,
                      constraints.maxHeight / 2,
                    );

                    var radiusTween =
                        Tween(begin: 0.0, end: constraints.maxHeight / 1.5);
                    var circleOffsetTween = Tween(
                      begin: arguments.circleStartCenter,
                      end: screenCenter,
                    );

                    var radiusTweenAnimation = animation.drive(radiusTween);
                    var centerOffsetTweenAnimation =
                        animation.drive(circleOffsetTween);

                    return ClipPath(
                      clipper: CircleTransitionClipper(
                        center: centerOffsetTweenAnimation.value,
                        radius: radiusTweenAnimation.value,
                      ),
                      child: Stack(
                        children: [
                          Container(
                            color: Colors.white,
                            height: constraints.maxHeight,
                            width: constraints.maxWidth,
                          ),
                          Opacity(
                            opacity: animation.value,
                            child: child,
                          ),
                        ],
                      ),
                    );
                  }),
                );
              },
              settings: RouteSettings(arguments: arguments.product),
            );
          } catch (error) {
            if (error is TypeError) {
              return MaterialPageRoute(
                builder: (_) => const ProductDetailsScreen(),
                settings: settings,
              );
            }
          }
        }
        return MaterialPageRoute(builder: (_) => const UnknownPage());
      },
    );
  }
}
