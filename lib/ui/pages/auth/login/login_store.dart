import 'package:flutter_chat/core/constants/view_routes.dart';
import 'package:flutter_chat/core/services/auth/auth_service.dart';
import 'package:flutter_chat/core/services/navigation/navigation_service.dart';
import 'package:flutter_chat/locator.dart';
import 'package:flutter_chat/utils/toast.dart';
import 'package:flutter_chat/utils/validators.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:mobx/mobx.dart';

part 'login_store.g.dart';

class LoginStore = _LoginStore with _$LoginStore;

abstract class _LoginStore with Store {
  final _authService = locator<AuthService>();
  final _navigationService = locator<NavigationService>();
  final FormErrorState error = FormErrorState();
  @observable
  bool isBusy = false;
  @observable
  String email = '';
  @observable
  String password = '';

  @computed
  bool get canLogin => !error.hasErrors;

  List<ReactionDisposer> _disposers;

  void setupValidations() {
    _disposers = [
      reaction((_) => email, _validateEmail),
      reaction((_) => password, _validatePassword),
    ];
  }

  void dispose() {
    _disposers.forEach((d) {
      d();
    });
  }

  @action
  void _validateEmail(String value) {
    error.email = validateEmail(value);
  }

  @action
  void _validatePassword(String value) {
    error.password = validatePassword(value);
  }

  void _validateAll() {
    _validateEmail(email);
    _validatePassword(password);
  }

  @action
  Future<void> _login() async {
    isBusy = true;
    if (await _authService.signInWithEmailAndPassword(email.trim(), password.trim())) {
      isBusy = false;
      _navigationService.offAndToNamed(ViewRoutes.splash);
    } else {
      showToast(translate('toasts.onLoginFailed'));
    }
    isBusy = false;
  }

  void onLogin() {
    _validateAll();
    if (canLogin) {
      _login();
    }
  }

  @action
  Future<void> loginWithGoogle() async {
    isBusy = true;
    if (await _authService.signInWithGoogle()) {
      isBusy = false;
      _navigationService.offAndToNamed(ViewRoutes.main);
    } else {
      showToast(translate('toasts.onLoginFailed'));
    }
    isBusy = false;
  }

  void onRegisterClick() {
    _navigationService.toNamed(ViewRoutes.register);
  }

  void onForgotPasswordClick() {
    _navigationService.toNamed(ViewRoutes.forgotPassword);
  }
}

class FormErrorState = _FormErrorState with _$FormErrorState;

abstract class _FormErrorState with Store {
  @observable
  String email;

  @observable
  String password;

  @computed
  bool get hasErrors => email != null || password != null;
}
