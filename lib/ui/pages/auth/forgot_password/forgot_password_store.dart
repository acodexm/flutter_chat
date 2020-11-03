import 'package:flutter_chat/core/constants/view_routes.dart';
import 'package:flutter_chat/core/services/auth/auth_service.dart';
import 'package:flutter_chat/core/services/navigation/navigation_service.dart';
import 'package:flutter_chat/locator.dart';
import 'package:flutter_chat/utils/toast.dart';
import 'package:flutter_chat/utils/validators.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:mobx/mobx.dart';

part 'forgot_password_store.g.dart';

class ForgotPasswordStore = _ForgotPasswordStore with _$ForgotPasswordStore;

abstract class _ForgotPasswordStore with Store {
  final _authService = locator<AuthService>();
  final _navigationService = locator<NavigationService>();
  final FormErrorState error = FormErrorState();

  @observable
  bool isBusy = false;
  @observable
  String email = '';

  @computed
  bool get canReset => !error.hasErrors;

  List<ReactionDisposer> _disposers;

  void setupValidations() {
    _disposers = [
      reaction((_) => email, _validateEmail),
    ];
  }

  void dispose() {
    _disposers.forEach((d) {
      d();
    });
  }

  void onReset() {
    _validateAll();
    if (canReset) {
      _reset();
    }
  }

  @action
  void _validateEmail(String value) {
    error.email = validateEmail(value);
  }

  void _validateAll() {
    _validateEmail(email);
  }

  @action
  Future<void> _reset() async {
    isBusy = true;
    if (await _authService.sendPasswordResetEmail(email.trim())) {
      isBusy = false;
      _navigationService.offAndToNamed(ViewRoutes.splash);
    } else {
      showToast(translate('toasts.onResetPasswordFailed'));
    }
    isBusy = false;
  }
}

class FormErrorState = _FormErrorState with _$FormErrorState;

abstract class _FormErrorState with Store {
  @observable
  String email;

  @computed
  bool get hasErrors => email != null;
}
