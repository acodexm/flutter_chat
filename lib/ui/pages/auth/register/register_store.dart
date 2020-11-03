import 'package:flutter_chat/core/constants/view_routes.dart';
import 'package:flutter_chat/core/services/auth/auth_service.dart';
import 'package:flutter_chat/core/services/navigation/navigation_service.dart';
import 'package:flutter_chat/locator.dart';
import 'package:flutter_chat/utils/toast.dart';
import 'package:flutter_chat/utils/validators.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:mobx/mobx.dart';

part 'register_store.g.dart';

class RegisterStore = _RegisterStore with _$RegisterStore;

abstract class _RegisterStore with Store {
  final _authService = locator<AuthService>();
  final _navigationService = locator<NavigationService>();
  final FormErrorState error = FormErrorState();
  @observable
  bool isBusy = false;
  @observable
  String email = '';
  @observable
  String password = '';
  @observable
  String confirmPassword = '';

  @computed
  bool get canRegister => !error.hasErrors;

  List<ReactionDisposer> _disposers;

  void setupValidations() {
    _disposers = [
      reaction((_) => email, _validateEmail),
      reaction((_) => password, _validatePassword),
      reaction((_) => confirmPassword, _validateConfirmPassword)
    ];
  }

  @action
  void _validateEmail(String value) {
    error.email = validateEmail(value);
  }

  @action
  void _validatePassword(String value) {
    error.password = validatePassword(value);
  }

  @action
  void _validateConfirmPassword(String value) {
    error.confirmPassword = validateConfirmPassword(password, value);
  }

  void dispose() {
    _disposers.forEach((d) {
      d();
    });
  }

  void _validateAll() {
    _validateEmail(email);
    _validatePassword(password);
    _validateConfirmPassword(confirmPassword);
  }

  void onRegister() {
    _validateAll();
    if (canRegister) {
      _register();
    }
  }

  @action
  Future<void> _register() async {
    isBusy = true;
    if (await _authService.registerWithEmailAndPassword(email.trim(), password.trim())) {
      isBusy = false;
      _navigationService.offAndToNamed(ViewRoutes.splash);
    } else {
      showToast(translate('toasts.onRegisterFailed'));
    }
    isBusy = false;
  }
}

class FormErrorState = _FormErrorState with _$FormErrorState;

abstract class _FormErrorState with Store {
  @observable
  String email;

  @observable
  String password;

  @observable
  String confirmPassword;

  @computed
  bool get hasErrors => email != null || password != null || confirmPassword != null;
}
