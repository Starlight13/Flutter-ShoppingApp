import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final IAuthViewModel authViewModel = context.watch<IAuthViewModel>();
    if (authViewModel.state.value == ViewModelState.success) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              authViewModel.successMessage ?? localizations.operationSucces,
            ),
            backgroundColor: Colors.teal,
          ),
        );
        authViewModel.resetState();
      });
    } else if (authViewModel.state.value == ViewModelState.error) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        String? errorText;
        switch (_authViewModel.authError) {
          case FirebaseAuthError.noError:
            errorText =
                _authViewModel.errorMessage ?? localizations.somethingWrong;
            break;
          case FirebaseAuthError.wrongPassword:
            errorText = localizations.wrongPassword;
            break;
          case FirebaseAuthError.tooManyRequests:
            errorText = localizations.tooManyRequests;
            break;
          case FirebaseAuthError.invalidEmail:
            errorText = localizations.invalidEmail;
            break;
          case FirebaseAuthError.weakPassword:
            errorText = localizations.weakPassword;
            break;
          case FirebaseAuthError.accountExistsWithDifferentCredential:
            errorText = localizations.accountExistsWithDifferentCredential;
            break;
        }
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorText),
            backgroundColor: Colors.red,
          ),
        );
        authViewModel.resetState();
      });
    }
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
                    hintText: localizations.email,
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
                  child:
                      authViewModel.authState.value == AuthState.enteredEmail ||
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
                                    hintText: localizations.password,
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
                                      child: Text(localizations.forgotPassword),
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
                  localizations: localizations,
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
              Text(localizations.orSignIn),
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
