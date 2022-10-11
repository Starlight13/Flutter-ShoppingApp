import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class GlobalSnackBar {
  static final GlobalKey<ScaffoldMessengerState> snackbarKey =
      GlobalKey<ScaffoldMessengerState>();

  static void showSnackBar({
    required String snackBarText,
    required bool isError,
  }) async {
    if (SchedulerBinding.instance.schedulerPhase != SchedulerPhase.idle) {
      await SchedulerBinding.instance.endOfFrame;
    }
    snackbarKey.currentState?.hideCurrentSnackBar();
    snackbarKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(snackBarText),
        backgroundColor: isError ? Colors.red : Colors.teal,
      ),
    );
  }
}
