import 'package:flutter/material.dart';

class SquareButton extends StatelessWidget {
  const SquareButton({
    required this.onPressed,
    required this.child,
    this.buttonSize = 30.0,
    this.buttonColor = Colors.teal,
    this.iconColor = Colors.white,
    this.borderColor = Colors.teal,
    Key? key,
  }) : super(key: key);

  final Function() onPressed;
  final Color buttonColor;
  final Color iconColor;
  final Widget child;
  final double buttonSize;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(buttonColor),
        padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
        minimumSize: MaterialStateProperty.all(Size(buttonSize, buttonSize)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0), side: BorderSide(width: 1, color: borderColor)),
        ),
      ),
      child: child,
    );
  }
}
