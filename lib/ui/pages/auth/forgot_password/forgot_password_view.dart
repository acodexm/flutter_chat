import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/ui/pages/auth/forgot_password/forgot_password_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_translate/flutter_translate.dart';

class ForgotPasswordView extends StatefulWidget {
  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final store = ForgotPasswordStore();

  @override
  void initState() {
    super.initState();
    store.setupValidations();
  }

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        var currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(translate('reset.title')),
        ),
        body: Form(
            child: IgnorePointer(
              ignoring: store.isBusy,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Observer(builder: (context) =>
                      Column(
                        children: <Widget>[
                          TextFormField(
                            onChanged: (value) => store.email = value,
                            onFieldSubmitted: (_) => store.onReset(),
                            decoration: InputDecoration(
                              labelText: translate('email.label'),
                              hintText: translate('email.hint'),
                              errorText: store.error.email,
                            ),
                          ),
                          MaterialButton(
                            child: Text(translate('button.reset')),
                            onPressed: () {
                              store.onReset();
                            },
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
