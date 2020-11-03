import 'package:flutter_translate/flutter_translate.dart';
import 'package:validators/validators.dart';

String validateRequired(String value) {
  if (isNull(value) || value.trim().isEmpty) {
    return translate('value.error.empty');
  }
  return null;
}

String validateNotNull(dynamic value) {
  if (value == null) {
    return translate('value.error.empty');
  }
  return null;
}

String validateEmail(String value) {
  if (!isEmail(value)) {
    return translate('email.error.invalid');
  }
  return validateRequired(value);
}

String validatePassword(String value) {
  if (isNull(value) || value.isEmpty) {
    return translate('password.error.empty');
  } else if (value.contains(' ')) {
    return translate('password.error.whitespace');
  } else if (value.length <= 6) {
    return translate('password.error.short');
  }
  return null;
}

String validateConfirmPassword(String password, String value) {
  if (password != value) {
    return translate('password.error.not_mach');
  }
  return validatePassword(value);
}
