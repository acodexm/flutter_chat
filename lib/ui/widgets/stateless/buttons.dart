import 'package:flutter/material.dart';
import 'package:flutter_chat/ui/widgets/loading.dart';
import 'package:flutter_translate/flutter_translate.dart';

class SubmitButton extends StatelessWidget {
  final bool busy;
  final Function onPressed;
  final String btnText;

  const SubmitButton({
    Key key,
    this.busy,
    @required this.onPressed,
    @required this.btnText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return busy
        ? Loading()
        : MaterialButton(
            child: Text(btnText),
            onPressed: onPressed,
            textTheme: ButtonTextTheme.primary,
            color: theme.primaryColor,
          );
  }
}

class SignInButton extends StatelessWidget {
  final bool busy;
  final Function onPressed;

  const SignInButton({
    Key key,
    this.busy,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return busy
        ? Loading()
        : MaterialButton(
      child: Text(translate('login.button')),
            onPressed: onPressed,
            textTheme: ButtonTextTheme.primary,
            color: theme.primaryColor,
          );
  }
}

class SignInGoogleButton extends StatelessWidget {
  final bool busy;
  final Function onPressed;

  const SignInGoogleButton({
    Key key,
    this.busy,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return busy
        ? Loading()
        : MaterialButton(
      child: Text(translate('login.googleButton')),
      onPressed: onPressed,
      textTheme: ButtonTextTheme.normal,
      color: theme.primaryColor,
          );
  }
}
