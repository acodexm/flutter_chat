import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class EmailTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function onFieldSubmitted;
  final Function validator;

  const EmailTextField({
    Key key,
    this.controller,
    this.onFieldSubmitted,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email),
        hintText: translate('email.hint'),
        contentPadding: const EdgeInsets.all(8),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(12),
          ),
        ),
      ),
    );
  }
}

class PasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function onFieldSubmitted;
  final Function validator;
  final String hint;

  const PasswordTextField({Key key, this.controller, this.focusNode, this.onFieldSubmitted, this.validator, this.hint})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      focusNode: focusNode,
      obscureText: true,
      textInputAction: TextInputAction.send,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        hintText: hint ?? translate('password.hint'),
        prefixIcon: Icon(Icons.lock),
        contentPadding: const EdgeInsets.all(8),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(12),
          ),
        ),
      ),
    );
  }
}
