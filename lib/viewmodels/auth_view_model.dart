import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/repositories/auth_repo.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum AuthState { loggedOut, enteredEmail, createAccount, loggedIn }

abstract class IAuthViewModel with ChangeNotifier {
  AuthState get authState;
  String authScreenButtonText({required AppLocalizations localizations});
  User? get currentUser;
  void authAction({required String email, required String password});
  String? get emailError;
  String? get passError;
  void setLoggedOutState();
}

class AuthViewModel with ChangeNotifier implements IAuthViewModel {
  final IAuthRepo _authRepo;
  AuthState _authState = AuthState.loggedOut;
  late bool _loggedIn;
  String? _emailError;
  String? _passError;

  AuthViewModel({required IAuthRepo authRepo}) : _authRepo = authRepo {
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
      } else {
        _loggedIn = false;
      }
      notifyListeners();
    });
  }

  @override
  AuthState get authState => _authState;

  @override
  User? get currentUser => _authRepo.getCurrentUser();

  @override
  String? get emailError => _emailError;

  @override
  String? get passError => _passError;

  _setAuthState(AuthState authState) {
    _authState = authState;
    notifyListeners();
  }

  void _setEmailError(String? error) {
    _emailError = error;
    notifyListeners();
  }

  void _setPassError(String? error) {
    _passError = error;
    notifyListeners();
  }

  void _checkIfEmailInUse({required String email}) async {
    if (await _authRepo.checkIfEmailInUse(email: email)) {
      _setAuthState(AuthState.enteredEmail);
    } else {
      _setAuthState(AuthState.createAccount);
    }
  }

  void _createAccount({required String email, required String password}) async {
    final credential =
        _authRepo.createAccount(email: email, password: password);
  }

  void _logIn({required String email, required String password}) {
    //TODO: log in
  }

  @override
  String authScreenButtonText({required AppLocalizations localizations}) {
    switch (_authState) {
      case AuthState.loggedOut:
        return localizations.next;
      case AuthState.enteredEmail:
        return localizations.logIn;
      case AuthState.createAccount:
        return localizations.createAccount;
      case AuthState.loggedIn:
        return '';
    }
  }

  @override
  void authAction({required String email, required String password}) {
    switch (_authState) {
      case AuthState.loggedOut:
        if (_validateEmail(email: email)) _checkIfEmailInUse(email: email);
        break;
      case AuthState.enteredEmail:
        if (_validateEmail(email: email) && password != null) {
          _logIn(email: email, password: password);
        }
        break;
      case AuthState.createAccount:
        if (email != null && password != null) {
          _createAccount(email: email, password: password);
        }
        break;
      case AuthState.loggedIn:
        break;
    }
  }

  bool _validateEmail({required String email}) {
    if (RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email)) {
      _setEmailError(null);
      return true;
    }
    _setEmailError('Invalid email');
    return false;
  }

  @override
  void setLoggedOutState() {
    _setAuthState(AuthState.loggedOut);
  }
}
