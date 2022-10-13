import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:google_sign_in/google_sign_in.dart';
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

  Future<UserCredential?> logInWithGoogle();

  Future<UserCredential?> logInWithFacebook();

  Future<String?> facebookPhotoURL();
}

class AuthRepo implements IAuthRepo {
  final IAuthService _authService;
  AccessToken? facebookToken;

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
  Future<UserCredential?> logInWithGoogle() async {
    final googleUser = await _authService.logInWithGoogle();
    // ignore: unnecessary_null_comparison
    if (googleUser == null) {
      throw FirebaseAuthException(code: 'social-sign-in-canceled');
    }
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await _authService.logInWithCreadential(credential);
  }

  @override
  Future<UserCredential?> logInWithFacebook() async {
    final LoginResult loginResult = await _authService.logInWithFacebook();
    if (loginResult.accessToken != null) {
      facebookToken = loginResult.accessToken!;
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);
      return await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
    }
    return null;
  }

  @override
  Future<String?> facebookPhotoURL() async {
    final user = getCurrentUser();
    final token = await FacebookAuth.instance.accessToken;
    if (user != null && token != null) {
      return '${user.photoURL}?height=500&access_token=${token.token}';
    }
    return null;
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
