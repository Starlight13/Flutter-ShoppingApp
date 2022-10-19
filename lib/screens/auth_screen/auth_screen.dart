import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/screens/shared_components/global_snack_bar.dart';
import 'package:shopping_app/screens/shared_components/primary_action_button.dart';
import 'package:shopping_app/screens/shared_components/progress_indicator.dart';
import 'package:shopping_app/viewmodels/auth_view_model.dart';
import 'package:shopping_app/viewmodels/state_view_model.dart';

class AuthScreen extends StatefulWidget {
  static String id = 'authorisation';

  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  late IAuthViewModel _authViewModel;
  late AppLocalizations _localizations;

  void popListener() {
    if (_authViewModel.authState.value == AuthState.loggedIn) {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _authViewModel = context.read<IAuthViewModel>();
    _authViewModel.authState.addListener(popListener);
    _authViewModel.state.addListener(() {
      if (_authViewModel.state.value == ViewModelState.success) {
        GlobalSnackBar.showSnackBar(
          snackBarText:
              _authViewModel.successMessage ?? _localizations.operationSucces,
          isError: false,
        );
        _authViewModel.resetState();
      } else if (_authViewModel.state.value == ViewModelState.error) {
        String? errorText;
        switch (_authViewModel.authError) {
          case FirebaseAuthError.noError:
            errorText =
                _authViewModel.errorMessage ?? _localizations.somethingWrong;
            break;
          case FirebaseAuthError.wrongPassword:
            errorText = _localizations.wrongPassword;
            break;
          case FirebaseAuthError.tooManyRequests:
            errorText = _localizations.tooManyRequests;
            break;
          case FirebaseAuthError.invalidEmail:
            errorText = _localizations.invalidEmail;
            break;
          case FirebaseAuthError.weakPassword:
            errorText = _localizations.weakPassword;
            break;
          case FirebaseAuthError.accountExistsWithDifferentCredential:
            errorText = _localizations.accountExistsWithDifferentCredential;
            break;
        }
        GlobalSnackBar.showSnackBar(
          snackBarText: errorText,
          isError: true,
        );
        _authViewModel.resetState();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _localizations = AppLocalizations.of(context)!;
    final IAuthViewModel authViewModel = context.watch<IAuthViewModel>();
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 300.0,
                child: TextField(
                  controller: _emailController,
                  onChanged: (value) {
                    if (authViewModel.authState.value ==
                            AuthState.enteredEmail ||
                        authViewModel.authState.value ==
                            AuthState.createAccount) {
                      authViewModel.setLoggedOutState();
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email_outlined),
                    hintText: _localizations.email,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    errorText: authViewModel.emailError,
                  ),
                ),
              ),
              SizedBox(
                width: 300.0,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    _passController.clear();
                    return SizeTransition(
                      sizeFactor: animation,
                      axis: Axis.vertical,
                      axisAlignment: -1,
                      child: Container(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: child,
                      ),
                    );
                  },
                  child: authViewModel.authState.value ==
                              AuthState.enteredEmail ||
                          authViewModel.authState.value ==
                              AuthState.createAccount
                      ? Column(
                          children: [
                            TextField(
                              controller: _passController,
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.key),
                                hintText: _localizations.password,
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                errorText: authViewModel.passError,
                                errorMaxLines: 2,
                              ),
                            ),
                            Visibility(
                              visible: authViewModel.authState.value ==
                                  AuthState.enteredEmail,
                              child: GestureDetector(
                                onTap: () =>
                                    _authViewModel.resetPasswordWithEmail(
                                  email: _emailController.text,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text(_localizations.forgotPassword),
                                ),
                              ),
                            )
                          ],
                        )
                      : null,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              PrimaryActionButton(
                onTap: () {
                  authViewModel.authAction(
                    email: _emailController.text,
                    password: _passController.text,
                  );
                },
                text: authViewModel.authScreenButtonText(
                  localizations: _localizations,
                ),
                width: 300.0,
              ),
              const SizedBox(
                height: 20.0,
              ),
              Visibility(
                visible: _authViewModel.isLoading,
                child: const CenteredProgressIndicator(),
              ),
              Text(_localizations.orSignIn),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => _authViewModel.logInWithGoogle(),
                    child: Image.asset(
                      'assets/google.png',
                      width: 40.0,
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      _authViewModel.logInWithFacebook();
                    },
                    child: Image.asset(
                      'assets/facebook.png',
                      width: 40.0,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _authViewModel.authState.removeListener(popListener);
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }
}
