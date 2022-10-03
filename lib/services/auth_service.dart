import 'package:firebase_auth/firebase_auth.dart';

enum AuthenticationState { loggedOut, enteredEmail, createAccount, loggedIn }

abstract class IAuthService {
  Future<UserCredential>? createUser({
    required String email,
    required String password,
  });

  Future<List<String>>? fetchSignInMethodsForEmail({
    required String email,
  });

  User? getCurrentUser();

  Future<UserCredential>? logIn({
    required String email,
    required String password,
  });

  Future<void> logOut();

  Future<void> sendPasswordResetEmail({required String email});
}

class AuthService extends IAuthService {
  @override
  Future<UserCredential>? createUser({
    required String email,
    required String password,
  }) {
    return FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) {
    return FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  @override
  Future<List<String>>? fetchSignInMethodsForEmail({required String email}) {
    return FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
  }

  @override
  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  @override
  Future<UserCredential>? logIn({
    required String email,
    required String password,
  }) {
    return FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> logOut() {
    return FirebaseAuth.instance.signOut();
  }
}
