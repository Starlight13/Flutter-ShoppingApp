import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    required this.onTap,
    required this.title,
    Key? key,
  }) : super(key: key);

  final Function() onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 25.0,
          color: Colors.white,
        ),
      ),
    );
  }
}
