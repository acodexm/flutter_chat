import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/ui/pages/auth/login/login_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_translate/flutter_translate.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final store = LoginStore();
  FocusNode passwordFocusNode;

  @override
  void initState() {
    super.initState();
    passwordFocusNode = FocusNode();
    store.setupValidations();
  }

  @override
  void dispose() {
    passwordFocusNode.dispose();
    store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        var currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(translate('login.title')),
        ),
        body: Form(
          child: IgnorePointer(
            ignoring: store.isBusy,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Observer(
                  builder: (context) => Column(
                    children: <Widget>[
                      TextFormField(
                        onChanged: (value) => store.email = value,
                        onFieldSubmitted: (_) => passwordFocusNode.requestFocus(),
                        decoration: InputDecoration(
                          labelText: translate('email.label'),
                          hintText: translate('email.hint'),
                          errorText: store.error.email,
                        ),
                      ),
                      TextFormField(
                        focusNode: passwordFocusNode,
                        onChanged: (value) => store.password = value,
                        onFieldSubmitted: (_) {
                          store.onLogin();
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: translate('password.label'),
                          hintText: translate('password.hint'),
                          errorText: store.error.password,
                        ),
                      ),
                      MaterialButton(
                        child: Text(translate('button.login')),
                        onPressed: () {
                          store.onLogin();
                        },
                        textTheme: ButtonTextTheme.normal,
                        color: theme.primaryColor,
                      ),
                      MaterialButton(
                        child: Text(translate('button.loginGoogle')),
                        onPressed: () {
                          store.loginWithGoogle();
                        },
                        textTheme: ButtonTextTheme.normal,
                        color: theme.primaryColor,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            MaterialButton(
                              onPressed: () {
                                store.onRegisterClick();
                              },
                              child: Text(translate('button.register')),
                            ),
                            Padding(padding: EdgeInsets.all(2.0)),
                            MaterialButton(
                              onPressed: () {
                                store.onForgotPasswordClick();
                              },
                              child: Text(translate('button.forgotPassword')),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
