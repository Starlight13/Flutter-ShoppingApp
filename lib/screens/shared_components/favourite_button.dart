import 'package:flutter/material.dart';
import 'package:shopping_app/screens/shared_components/progress_indicator.dart';

class FavouriteButton extends StatelessWidget {
  const FavouriteButton({
    required this.onPressed,
    required this.conditionRed,
    required this.conditionLoading,
    Key? key,
  }) : super(key: key);

  final Function onPressed;
  final bool conditionRed;
  final bool conditionLoading;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: conditionLoading
          ? const CenteredProgressIndicator()
          : IconButton(
              onPressed: () => onPressed(),
              icon: Icon(
                Icons.favorite,
                color: conditionRed ? Colors.red : Colors.grey,
                size: 30.0,
              ),
            ),
    );
  }
}
