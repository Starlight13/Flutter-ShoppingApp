import 'package:flutter/material.dart';
import 'package:shopping_app/constants.dart';

class BigButton extends StatelessWidget {
  final Function() onPressed;
  final String buttonText;

  const BigButton(
    this.buttonText, {
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.teal,
        ),
        child: Text(
          buttonText,
          style: buttonTextStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
