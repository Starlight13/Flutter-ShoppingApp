import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shopping_app/viewmodels/state_view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StatusSnackBar extends StatelessWidget {
  final IStateViewModel viewModel;
  final Widget child;
  final String? errorMessage;
  final String? successMessage;

  const StatusSnackBar({
    required this.viewModel,
    required this.child,
    this.successMessage,
    this.errorMessage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    if (viewModel.state.value == ViewModelState.success) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              successMessage ??
                  viewModel.successMessage ??
                  localizations.operationSucces,
            ),
            backgroundColor: Colors.teal,
          ),
        );
        viewModel.resetState();
      });
    } else if (viewModel.state.value == ViewModelState.error) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorMessage ??
                  viewModel.errorMessage ??
                  localizations.somethingWrong,
            ),
            backgroundColor: Colors.red,
          ),
        );
        viewModel.resetState();
      });
    }
    return child;
  }
}
