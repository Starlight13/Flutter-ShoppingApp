import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopping_app/services/auth_service.dart';

enum AuthenticationState { loggedOut, enteredEmail, createAccount, loggedIn }

abstract class IAuthRepo {
  Future<bool> checkIfEmailInUse({required String email});

  Future<UserCredential>? createAccount({
    required String email,
    required String password,
  });

  User? getCurrentUser();
  Future<UserCredential?> logIn({
    required String email,
    required String password,
  });

  void logOut();

  void sendResetPasswordEmail({required String email});
}

class AuthRepo implements IAuthRepo {
  final IAuthService _authService;

  AuthRepo({required IAuthService authService}) : _authService = authService;

  @override
  Future<UserCredential>? createAccount({
    required String email,
    required String password,
  }) {
    return _authService.createUser(email: email, password: password);
  }

  @override
  Future<bool> checkIfEmailInUse({required String email}) async {
    try {
      final list = await _authService.fetchSignInMethodsForEmail(email: email);
      return list != null && list.isNotEmpty;
    } catch (error) {
      rethrow;
    }
  }

  @override
  User? getCurrentUser() {
    return _authService.getCurrentUser();
  }

  @override
  Future<UserCredential?> logIn({
    required String email,
    required String password,
  }) async {
    return await _authService.logIn(email: email, password: password);
  }

  @override
  Future logOut() async {
    return await _authService.logOut();
  }

  @override
  Future sendResetPasswordEmail({required String email}) async {
    return await _authService.sendPasswordResetEmail(email: email);
  }
}
