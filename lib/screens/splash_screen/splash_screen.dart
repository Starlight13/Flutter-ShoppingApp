import 'package:flutter/material.dart';
import 'package:shopping_app/screens/products_screen/products_screen.dart';

class SplashScreen extends StatefulWidget {
  static String id = 'splash';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 1),
      (() => Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: ((context, animation, secondaryAnimation) {
                return const ProductsScreen();
              }),
              transitionDuration: const Duration(seconds: 1),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                final screenSize = MediaQuery.of(context).size;
                return Stack(
                  children: [
                    Container(
                      height: screenSize.height,
                      width: screenSize.width,
                      color: Colors.white,
                    ),
                    Opacity(
                      opacity: animation.value,
                      child: child,
                    ),
                  ],
                );
              },
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Hero(
              tag: 'cart',
              child: Icon(
                Icons.shopping_cart,
                size: 100.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
