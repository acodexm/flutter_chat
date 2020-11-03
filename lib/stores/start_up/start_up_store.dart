import 'package:flutter_chat/core/constants/view_routes.dart';
import 'package:flutter_chat/core/services/auth/auth_service.dart';
import 'package:flutter_chat/core/services/dynamic_links/dynamic_link_service.dart';
import 'package:flutter_chat/core/services/hardware_info/hardware_info_service.dart';
import 'package:flutter_chat/core/services/navigation/navigation_service.dart';
import 'package:flutter_chat/core/services/notification/notification_service.dart';
import 'package:flutter_chat/core/services/remote_config/remote_config_service.dart';
import 'package:flutter_chat/locator.dart';
import 'package:flutter_chat/stores/root_store.dart';
import 'package:mobx/mobx.dart';

part 'start_up_store.g.dart';

class StartUpStore = StartUpStoreBase with _$StartUpStore;

abstract class StartUpStoreBase with Store {
  final _authService = locator<AuthService>();
  final _hardwareInfoService = locator<HardwareInfoService>();
  final _navigationService = locator<NavigationService>();
  final _notificationService = locator<NotificationService>();
  final _dynamicLinkService = locator<DynamicLinkService>();
  final _remoteConfigService = locator<RemoteConfigService>();
  final RootStore rootStore;

  @observable
  bool isInitialized = false;

  StartUpStoreBase(this.rootStore);

  @action
  Future handleStartUpLogic() async {
    await _authService.tryAutoLogin();

    if (await _authService.isUserLoggedIn()) {
      if (!isInitialized) {
        Future.wait([
          _hardwareInfoService.init(),
          _dynamicLinkService.handleDynamicLinks(),
          _remoteConfigService.initialise(),
          _notificationService.configLocalNotification(),
        ]);
        _notificationService.registerFirebaseNotifications(_authService.currentUser.uid);
        isInitialized = true;
      }
      _navigationService.offAndToNamed(ViewRoutes.main);
    } else {
      _navigationService.offAndToNamed(ViewRoutes.login);
    }
  }
}
