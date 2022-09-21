import 'package:firebase_auth/firebase_auth.dart';

enum AuthenticationState { loggedOut, enteredEmail, createAccount, loggedIn }

abstract class IAuthService {
  Future<UserCredential> createUser({
    required String email,
    required String password,
  });

  Future<List<String>> fetchSignInMethodsForEmail({
    required String email,
  });

  User? getCurrentUser();
}

class AuthService extends IAuthService {
  @override
  Future<UserCredential> createUser({
    required String email,
    required String password,
  }) {
    return FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<List<String>> fetchSignInMethodsForEmail({required String email}) {
    try {
      return FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
    } catch (error) {
      print(error);
      return Future.delayed(Duration.zero, (() => []));
    }
  }

  @override
  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }
}
