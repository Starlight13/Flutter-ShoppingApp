import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/screens/shared_components/primary_action_button.dart';
import 'package:shopping_app/screens/shared_components/progress_indicator.dart';
import 'package:shopping_app/services/locator_service.dart';
import 'package:shopping_app/viewmodels/auth_view_model.dart';

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
    if (_authViewModel.authState == AuthState.loggedIn) {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _authViewModel = sl.get();
    _authViewModel.addListener(popListener);
  }

  @override
  void dispose() {
    _authViewModel.removeListener(popListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final IAuthViewModel authViewModel = context.watch<IAuthViewModel>();
    final localizations = AppLocalizations.of(context)!;
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
                    if (authViewModel.authState == AuthState.enteredEmail ||
                        authViewModel.authState == AuthState.createAccount) {
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
                  child: authViewModel.authState == AuthState.enteredEmail ||
                          authViewModel.authState == AuthState.createAccount
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
                              visible: authViewModel.authState ==
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
