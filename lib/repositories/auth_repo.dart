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
}

class AuthRepo implements IAuthRepo {
  final IAuthService _authService;

  AuthRepo({required IAuthService authService}) : _authService = authService;

  @override
  Future<UserCredential>? createAccount({
    required String email,
    required String password,
  }) {
    try {
      return _authService.createUser(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Future<bool> checkIfEmailInUse({required String email}) async {
    try {
      final list = await _authService.fetchSignInMethodsForEmail(email: email);
      if (list.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print(error);
      return true;
    }
  }

  @override
  User? getCurrentUser() {
    return _authService.getCurrentUser();
  }
}
