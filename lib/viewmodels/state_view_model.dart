import 'package:flutter/foundation.dart';
import 'package:shopping_app/screens/shared_components/global_snack_bar.dart';

enum ViewModelState { idle, loading, success, error }

abstract class IStateViewModel with ChangeNotifier {
  String? get errorMessage;
  ValueNotifier<ViewModelState> get state;
  String? get successMessage;
  void resetState();

  void snackBarListener(IStateViewModel viewModel) {
    if (viewModel.state.value == ViewModelState.success) {
      GlobalSnackBar.showSnackBar(
        snackBarText:
            viewModel.successMessage ?? 'Operation completed successfully',
        isError: false,
      );
      viewModel.resetState();
    } else if (viewModel.state.value == ViewModelState.error) {
      GlobalSnackBar.showSnackBar(
        snackBarText: viewModel.errorMessage ?? 'Something went wrong',
        isError: true,
      );
      viewModel.resetState();
    }
  }
}
