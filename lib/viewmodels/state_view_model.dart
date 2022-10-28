import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum ViewModelState { idle, loading, success, error }

abstract class IStateViewModel with ChangeNotifier {
  String? get errorMessage;
  ValueNotifier<ViewModelState> get state;
  String? get successMessage;
  void resetState();
}
