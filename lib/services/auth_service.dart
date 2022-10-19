import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:google_sign_in/google_sign_in.dart';

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

  Future<GoogleSignInAccount?> logInWithGoogle();

  Future<LoginResult> logInWithFacebook();

  Future<UserCredential> logInWithCreadential(AuthCredential credential);
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

  @override
  Future<GoogleSignInAccount?> logInWithGoogle() async {
    final googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'profile',
      ],
    );
    return await googleSignIn.signIn();
  }

  @override
  Future<LoginResult> logInWithFacebook() async {
    return await FacebookAuth.instance.login();
  }

  @override
  Future<UserCredential> logInWithCreadential(AuthCredential credential) async {
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
