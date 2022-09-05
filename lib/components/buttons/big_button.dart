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
    // VR: I propose to create your custom Container with GestureDetector instead of changing theme of TextButton
    return TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(vertical: 15.0)),
        backgroundColor: MaterialStateProperty.all(Colors.teal),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
      ),
      onPressed: onPressed,
      child: Text(buttonText, style: buttonTextStyle),
    );
  }
}
