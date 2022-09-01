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
    return TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.lightBlueAccent),
      ),
      onPressed: onPressed,
      child: Text(buttonText, style: buttonTextStyle),
    );
  }
}
