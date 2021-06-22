import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:honk_clone/ui/auth/providers/auth_state.dart';
import 'package:honk_clone/ui/auth/providers/auth_state_notifier.dart';
import 'package:honk_clone/widgets/loading_button.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: ProviderListener(
          provider: authNotifierProvider,
          onChange: (context, dynamic state) {
            if (state is AuthErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(
                    state.message!,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              );
            }
            if (state is AuthLoadedState) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  "/conversations_page", (route) => false);
            }
          },
          child: Consumer(builder: (context, watch, _) {
            bool passwordState = watch(togglePasswordStateprovider).state;

            final icon = Icon(
              passwordState ? Icons.visibility_off : Icons.visibility,
            );
            AuthState auth = watch(authNotifierProvider);
            final loading = auth is AuthLoadingState;

            print(loading);
            return Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Sign in",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 20.0),
                        TextFormField(
                          textAlignVertical: TextAlignVertical.center,
                          controller: _usernameController,
                          decoration: InputDecoration(
                            hintText: "Username",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please select a usernmae';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          textAlignVertical: TextAlignVertical.center,
                          controller: _passwordController,
                          obscureText: passwordState,
                          decoration: InputDecoration(
                            hintText: "Password",
                            suffixIcon: Padding(
                              padding: EdgeInsets.only(left: 24),
                              child: GestureDetector(
                                child: icon,
                                onTap: () {
                                  final passwordStateProvider =
                                      context.read(togglePasswordStateprovider);
                                  passwordStateProvider.state =
                                      !passwordStateProvider.state;
                                },
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        LoadingButton(
                          text: "Sign In",
                          loading: loading,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final password = _passwordController.text;
                              final username = _usernameController.text;

                              final auth =
                                  context.read(authNotifierProvider.notifier);

                              FocusScope.of(context).unfocus();
                              auth.signIn(
                                username: username,
                                password: password,
                              );
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
