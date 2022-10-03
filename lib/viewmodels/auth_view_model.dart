import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/extensions.dart';
import 'package:shopping_app/globals.dart';
import 'package:shopping_app/repositories/auth_repo.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum AuthState { loggedOut, enteredEmail, createAccount, loggedIn }

abstract class IAuthViewModel with ChangeNotifier {
  AuthState get authState;
  String authScreenButtonText({required AppLocalizations localizations});
  User? get currentUser;
  void authAction({
    required String email,
    required String password,
  });
  String? get emailError;
  String? get passError;
  void setLoggedOutState();
  void logOut();
  bool get isLoading;
  void resetPasswordWithEmail({required String email, onSuccess});
  bool get isLoggedIn;
}

class AuthViewModel with ChangeNotifier implements IAuthViewModel {
  final IAuthRepo _authRepo;
  late AuthState _authState;
  String? _emailError;
  String? _passError;
  bool _isLoading = false;

  AuthViewModel({required IAuthRepo authRepo}) : _authRepo = authRepo {
    if (currentUser == null) {
      _authState = AuthState.loggedOut;
    } else {
      _authState = AuthState.loggedIn;
    }
    notifyListeners();
  }

  @override
  bool get isLoading => _isLoading;

  @override
  AuthState get authState => _authState;

  @override
  User? get currentUser => _authRepo.getCurrentUser();

  @override
  String? get emailError => _emailError;

  @override
  String? get passError => _passError;

  @override
  bool get isLoggedIn => _authState == AuthState.loggedIn;

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
        return 'Logged in';
    }
  }

  @override
  void authAction({
    required String email,
    required String password,
  }) {
    _setEmailError(null);
    _setPassError(null);
    try {
      switch (_authState) {
        case AuthState.loggedOut:
          if (_validateEmail(email: email)) _checkIfEmailInUse(email: email);
          break;
        case AuthState.enteredEmail:
          if (_validateEmail(email: email) && password.isNotEmpty) {
            _logIn(email: email, password: password);
          }
          break;
        case AuthState.createAccount:
          if (_validateEmail(email: email) &&
              _validatePassword(password: password)) {
            _createAccount(email: email, password: password);
          }
          break;
        case AuthState.loggedIn:
          break;
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'invalid-email') {
        //TODO: translate
        _showSnackBar(snackBarText: 'Invalid email', isError: true);
      }
    }
  }

  @override
  void setLoggedOutState() {
    _setAuthState(AuthState.loggedOut);
  }

  @override
  void logOut() async {
    _setLoading(true);
    _authRepo.logOut();
    _setAuthState(AuthState.loggedOut);
    _showSnackBar(snackBarText: 'You have logged out', isError: false);
    _setLoading(false);
  }

  @override
  void resetPasswordWithEmail({required String email, onSuccess}) {
    try {
      _authRepo.sendResetPasswordEmail(email: email);
      _showSnackBar(
        snackBarText: 'A reset password link was sent to $email',
        isError: false,
      );
    } on FirebaseAuthException catch (e) {
      _handleFirebaseException(e);
    } catch (e) {
      _showSnackBar(snackBarText: e.toString(), isError: true);
    }
  }

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
    _setLoading(true);
    try {
      if (await _authRepo.checkIfEmailInUse(email: email)) {
        _setAuthState(AuthState.enteredEmail);
      } else {
        _setAuthState(AuthState.createAccount);
      }
    } on FirebaseAuthException catch (e) {
      _handleFirebaseException(e);
    } catch (e) {
      _showSnackBar(snackBarText: e.toString(), isError: true);
    }
    _setLoading(false);
  }

  void _createAccount({required String email, required String password}) async {
    _setLoading(true);
    try {
      final credential =
          await _authRepo.createAccount(email: email, password: password);
      if (credential != null) {
        _setAuthState(AuthState.loggedIn);
        _showSnackBar(
          snackBarText: 'You have successfully created an account',
          isError: false,
        );
      }
    } on FirebaseAuthException catch (e) {
      _handleFirebaseException(e);
    } catch (e) {
      _showSnackBar(snackBarText: e.toString(), isError: true);
    }
    _setLoading(false);
  }

  void _logIn({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      final credential =
          await _authRepo.logIn(email: email, password: password);
      if (credential != null) {
        _setAuthState(AuthState.loggedIn);
        _showSnackBar(
          snackBarText: 'You have successfully logged in',
          isError: false,
        );
      }
    } on FirebaseAuthException catch (e) {
      _handleFirebaseException(e);
    } catch (e) {
      _showSnackBar(snackBarText: e.toString(), isError: true);
    }
    _setLoading(false);
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

  bool _validatePassword({required String password}) {
    if (password.isEmpty) {
      _setPassError('Please enter password');
    } else if (password.characters.length < 8) {
      _setPassError('Password should be at least 8 characters long');
    } else if (!password.containsUppercase) {
      _setPassError('Password should contain at least 1 uppercase letter');
    } else if (!password.containsLowercase) {
      _setPassError('Password should contain at least 1 lowercase letter');
    } else if (!password.containsDigits) {
      _setPassError('Password should contain at least 1 digit');
    } else {
      _setPassError(null);
      return true;
    }
    return false;
  }

  void _setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void _handleFirebaseException(FirebaseAuthException authException) {
    String errorDescription = 'Error occured';
    switch (authException.code) {
      case 'wrong-password':
        errorDescription = 'The entered password is incorrect';
        break;
      case 'too-many-requests':
        errorDescription =
            'Access to this account has been temporarily disabled due to many failed login attempts';
        break;
      case 'invalid-email':
      case 'auth/invalid-email':
        errorDescription = 'The entered email is invalid';
        break;
      case 'weak-password':
        errorDescription = 'The entered password is too weak';
        break;
    }
    _showSnackBar(snackBarText: errorDescription, isError: true);
  }

  _showSnackBar({required String snackBarText, required bool isError}) {
    snackbarKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(snackBarText),
        backgroundColor: isError ? Colors.red : Colors.teal,
      ),
    );
  }
}
