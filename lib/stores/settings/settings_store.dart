import 'package:flutter_chat/core/constants/view_routes.dart';
import 'package:flutter_chat/core/models/dialog/dialog_request.dart';
import 'package:flutter_chat/core/services/app_settings/app_settings_service.dart';
import 'package:flutter_chat/core/services/auth/auth_service.dart';
import 'package:flutter_chat/core/services/dialog/dialog_service.dart';
import 'package:flutter_chat/core/services/key_storage/key_storage_service.dart';
import 'package:flutter_chat/core/services/navigation/navigation_service.dart';
import 'package:flutter_chat/locator.dart';
import 'package:flutter_chat/stores/root_store.dart';
import 'package:flutter_chat/utils/logger.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:mobx/mobx.dart';

part 'settings_store.g.dart';

class SettingsStore = SettingsStoreBase with _$SettingsStore;

abstract class SettingsStoreBase with Store {
  final RootStore rootStore;
  final _authService = locator<AuthService>();
  final _keyStorageService = locator<KeyStorageService>();
  final _appSettingsService = locator<AppSettingsService>();
  final _dialogService = locator<DialogService>();
  final _navigationService = locator<NavigationService>();
  @observable
  bool notificationsEnabled = false;

  SettingsStoreBase(this.rootStore);

  @action
  Future<void> init() async {
    notificationsEnabled = _keyStorageService.hasNotificationsEnabled;
  }

  Future<void> openAppSettings() async {
    Log.d('User has opened app settings');
    await _appSettingsService.openAppSettings();
  }

  Future<void> signOut() async {
    var response = await _dialogService.showDialog(DialogRequest(
      title: translate('dialogs.signOut.title'),
      description: translate('dialogs.singOut.description'),
      cancelButton: translate('button.cancel'),
    ));
    if (response.confirmed) {
      Log.d('User has signed out');
      await _authService.signOut();
      _navigationService.offAllNamed(ViewRoutes.login);
    }
  }

  @action
  void toggleNotificationsEnabled() {
    notificationsEnabled = !notificationsEnabled;
    _keyStorageService.hasNotificationsEnabled = notificationsEnabled;
  }
}
