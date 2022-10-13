import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/extensions.dart';
import 'package:shopping_app/repositories/auth_repo.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shopping_app/viewmodels/state_view_model.dart';

enum AuthState { loggedOut, enteredEmail, createAccount, loggedIn }

enum LogInMethod { none, email, google, facebook }

enum FirebaseAuthError {
  noError,
  wrongPassword,
  tooManyRequests,
  invalidEmail,
  weakPassword,
  accountExistsWithDifferentCredential
}

abstract class IAuthViewModel extends IStateViewModel {
  ValueNotifier<AuthState> get authState;
  String authScreenButtonText({required AppLocalizations localizations});
  User? get currentUser;
  void authAction({
    required String email,
    required String password,
  });
  String? get emailError;
  String? get passError;
  FirebaseAuthError get authError;
  void setLoggedOutState();
  void logOut();
  bool get isLoading;
  void resetPasswordWithEmail({required String email, onSuccess});
  bool get isLoggedIn;
  void logInWithGoogle();
  void logInWithFacebook();
  String? get photoUrl;
}

class AuthViewModel extends IAuthViewModel {
  final IAuthRepo _authRepo;
  late ValueNotifier<AuthState> _authState;
  String? _emailError;
  String? _passError;
  String? _errorMessage;
  FirebaseAuthError _authError = FirebaseAuthError.noError;
  String? _successMessage;
  final ValueNotifier<ViewModelState> _state =
      ValueNotifier(ViewModelState.idle);
  String? _photoUrl;

  AuthViewModel({required IAuthRepo authRepo}) : _authRepo = authRepo {
    if (currentUser == null) {
      _authState = ValueNotifier(AuthState.loggedOut);
    } else {
      _authState = ValueNotifier(AuthState.loggedIn);
      _setPhotoUrl();
    }
    notifyListeners();
  }

  @override
  String? get errorMessage => _errorMessage;

  @override
  ValueNotifier<ViewModelState> get state => _state;

  @override
  String? get successMessage => _successMessage;

  @override
  bool get isLoading => _state.value == ViewModelState.loading;

  @override
  ValueNotifier<AuthState> get authState => _authState;

  @override
  User? get currentUser => _authRepo.getCurrentUser();

  @override
  String? get emailError => _emailError;

  @override
  String? get passError => _passError;

  @override
  bool get isLoggedIn => _authState.value == AuthState.loggedIn;

  @override
  FirebaseAuthError get authError => _authError;

  @override
  String? get photoUrl => _photoUrl;

  @override
  String authScreenButtonText({required AppLocalizations localizations}) {
    switch (_authState.value) {
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
      switch (_authState.value) {
        case AuthState.loggedOut:
          if (_validateEmail(email: email)) _checkIfEmailInUse(email: email);
          break;
        case AuthState.enteredEmail:
          if (_validateEmail(email: email) && password.isNotEmpty) {
            _logInWithMethod(
              LogInMethod.email,
              email: email,
              password: password,
            );
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
        _setAuthError(FirebaseAuthError.invalidEmail);
        _setState(ViewModelState.error);
      }
    }
  }

  @override
  void setLoggedOutState() {
    _setAuthState(AuthState.loggedOut);
  }

  @override
  void logOut() async {
    _setState(ViewModelState.loading);
    _authRepo.logOut();
    _setAuthState(AuthState.loggedOut);
    _setSuccessMessage('You have logged out');
    _setState(ViewModelState.success);
  }

  @override
  void resetPasswordWithEmail({required String email, onSuccess}) {
    try {
      _authRepo.sendResetPasswordEmail(email: email);
      _setSuccessMessage('A reset password link was sent to $email');
      _setState(ViewModelState.success);
    } on FirebaseAuthException catch (e) {
      _handleFirebaseException(e);
    } catch (e) {
      _setErrorMessage(e.toString());
      _setState(ViewModelState.error);
    }
  }

  @override
  void logInWithGoogle() {
    _logInWithMethod(LogInMethod.google);
  }

  @override
  void logInWithFacebook() {
    _logInWithMethod(LogInMethod.facebook);
  }

  void _logInWithMethod(
    LogInMethod logInMethod, {
    String? email,
    String? password,
  }) async {
    _setState(ViewModelState.loading);
    try {
      UserCredential? credential;
      switch (logInMethod) {
        case LogInMethod.email:
          if (email != null && password != null) {
            credential = await _emailLogIn(email: email, password: password);
          }
          break;
        case LogInMethod.google:
          credential = await _googleLogIn();
          break;
        case LogInMethod.facebook:
          credential = await _facebookLogin();
          break;
        case LogInMethod.none:
          return;
      }
      if (credential != null) {
        _setPhotoUrl();
        _setAuthState(AuthState.loggedIn);
        _setSuccessMessage('You have successfully logged in');
        _setState(ViewModelState.success);
      } else {
        if (logInMethod == LogInMethod.facebook) {
          throw FirebaseAuthException(code: 'social-sign-in-canceled');
        }
      }
    } on FirebaseAuthException catch (e) {
      _handleFirebaseException(e);
    } catch (e) {
      _setErrorMessage(e.toString());
      _setState(ViewModelState.error);
    }
  }

  void _setAuthState(AuthState authState) {
    _authState.value = authState;
    _authState.notifyListeners();
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
    _setState(ViewModelState.loading);
    try {
      if (await _authRepo.checkIfEmailInUse(email: email)) {
        _setAuthState(AuthState.enteredEmail);
      } else {
        _setAuthState(AuthState.createAccount);
      }
    } on FirebaseAuthException catch (e) {
      _handleFirebaseException(e);
      _setState(ViewModelState.error);
    } catch (e) {
      _setErrorMessage(e.toString());
      _setState(ViewModelState.error);
    }
    _setState(ViewModelState.idle);
  }

  void _createAccount({required String email, required String password}) async {
    _setState(ViewModelState.loading);
    try {
      final credential =
          await _authRepo.createAccount(email: email, password: password);
      if (credential != null) {
        _setAuthState(AuthState.loggedIn);
        _setSuccessMessage('You have successfully created an account');
        _setState(ViewModelState.success);
      }
    } on FirebaseAuthException catch (e) {
      _handleFirebaseException(e);
      _setState(ViewModelState.error);
    } catch (e) {
      _setErrorMessage(e.toString());
      _setState(ViewModelState.error);
    }
  }

  Future<UserCredential?> _emailLogIn({
    required String email,
    required String password,
  }) async {
    _setState(ViewModelState.loading);
    return await _authRepo.logIn(email: email, password: password);
  }

  Future<UserCredential?> _googleLogIn() async {
    return await _authRepo.logInWithGoogle();
  }

  Future<UserCredential?> _facebookLogin() async {
    return await _authRepo.logInWithFacebook();
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

  void _handleFirebaseException(FirebaseAuthException authException) {
    switch (authException.code) {
      case 'wrong-password':
        _setAuthError(FirebaseAuthError.wrongPassword);
        break;
      case 'too-many-requests':
        _setAuthError(FirebaseAuthError.tooManyRequests);
        break;
      case 'invalid-email':
      case 'auth/invalid-email':
        _setAuthError(FirebaseAuthError.invalidEmail);
        break;
      case 'weak-password':
        _setAuthError(FirebaseAuthError.weakPassword);
        break;
      case 'account-exists-with-different-credential':
        _setAuthError(FirebaseAuthError.accountExistsWithDifferentCredential);
        break;
      case 'social-sign-in-canceled':
        _setState(ViewModelState.idle);
        return;
    }
    _setState(ViewModelState.error);
  }

  @override
  void resetState() {
    _setErrorMessage(null);
    _setSuccessMessage(null);
    _setAuthError(FirebaseAuthError.noError);
    _setState(ViewModelState.idle);
  }

  void _setState(ViewModelState newState) async {
    _state.value = newState;
    _state.notifyListeners();
    notifyListeners();
  }

  void _setSuccessMessage(String? sucessMessage) {
    _successMessage = sucessMessage;
  }

  void _setErrorMessage(String? errorMessage) {
    _errorMessage = errorMessage;
  }

  void _setAuthError(FirebaseAuthError error) {
    _authError = error;
  }

  void _setPhotoUrl() async {
    _setState(ViewModelState.loading);
    if (currentUser?.providerData.first.providerId == 'facebook.com') {
      _photoUrl = await _authRepo.facebookPhotoURL();
    } else {
      _photoUrl = currentUser?.photoURL;
    }
    _setState(ViewModelState.idle);
  }
}
