import 'package:flutter/material.dart';
import 'package:flutter_chat/ui/pages/auth/register/register_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_translate/flutter_translate.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final store = RegisterStore();
  FocusNode passwordFocus;
  FocusNode confirmFocus;

  @override
  void initState() {
    super.initState();
    passwordFocus = FocusNode();
    confirmFocus = FocusNode();
    store.setupValidations();
  }

  @override
  void dispose() {
    store.dispose();
    passwordFocus.dispose();
    confirmFocus.dispose();
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
          title: Text(translate('register.title')),
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
                        onFieldSubmitted: (_) => passwordFocus.requestFocus(),
                        decoration: InputDecoration(
                          labelText: translate('email.label'),
                          hintText: translate('email.hint'),
                          errorText: store.error.email,
                        ),
                      ),
                      TextFormField(
                        focusNode: passwordFocus,
                        onChanged: (value) => store.password = value,
                        onFieldSubmitted: (_) {
                          confirmFocus.requestFocus();
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: translate('password.label'),
                          hintText: translate('password.hint'),
                          errorText: store.error.password,
                        ),
                      ),
                      TextFormField(
                        focusNode: confirmFocus,
                        onChanged: (value) => store.confirmPassword = value,
                        onFieldSubmitted: (_) {
                          store.onRegister();
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: translate('password.confirm.label'),
                          hintText: translate('password.confirm.hint'),
                          errorText: store.error.confirmPassword,
                        ),
                      ),
                      MaterialButton(
                        child: Text(translate('button.register')),
                        onPressed: () {
                          store.onRegister();
                        },
                        textTheme: ButtonTextTheme.normal,
                        color: theme.primaryColor,
                      ),
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
