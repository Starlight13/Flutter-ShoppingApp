import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/screens/shared_components/primary_action_button.dart';
import 'package:shopping_app/viewmodels/auth_view_model.dart';

class AuthScreen extends StatelessWidget {
  static String id = 'authorisation';

  AuthScreen({super.key});

  final _emailController = TextEditingController();
  final _passController = TextEditingController();

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
              Visibility(
                visible: authViewModel.authState == AuthState.enteredEmail ||
                    authViewModel.authState == AuthState.createAccount,
                child: Container(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: SizedBox(
                    width: 300.0,
                    child: TextField(
                      controller: _passController,
                      obscureText: true,
                      obscuringCharacter: '*',
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
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              PrimaryActionButton(
                onTap: () {
                  print(_emailController.text);
                  authViewModel.authAction(
                    email: _emailController.text,
                    password: _passController.text,
                  );
                },
                text: authViewModel.authScreenButtonText(
                  localizations: localizations,
                ),
                width: 300.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RectangleTextField extends StatelessWidget {
  const RectangleTextField({
    this.hint,
    this.icon,
    this.width = 300.0,
    Key? key,
  }) : super(key: key);

  final String? hint;
  final Icon? icon;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300.0,
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        enableSuggestions: false,
        autocorrect: false,
        decoration: InputDecoration(
          prefixIcon: icon,
          hintText: hint,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }
}
