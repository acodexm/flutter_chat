import 'package:flutter_chat/core/services/analytics/analytics_service.dart';
import 'package:flutter_chat/core/services/app_settings/app_settings_service.dart';
import 'package:flutter_chat/core/services/auth/auth_service.dart';
import 'package:flutter_chat/core/services/connectivity/connectivity_service.dart';
import 'package:flutter_chat/core/services/dialog/dialog_service.dart';
import 'package:flutter_chat/core/services/dynamic_links/dynamic_link_service.dart';
import 'package:flutter_chat/core/services/firebase/chat_service.dart';
import 'package:flutter_chat/core/services/firebase/users_service.dart';
import 'package:flutter_chat/core/services/hardware_info/hardware_info_service.dart';
import 'package:flutter_chat/core/services/key_storage/key_storage_service.dart';
import 'package:flutter_chat/core/services/navigation/navigation_service.dart';
import 'package:flutter_chat/core/services/notification/notification_service.dart';
import 'package:flutter_chat/core/services/remote_config/remote_config_service.dart';
import 'package:flutter_chat/core/services/snackbar/snackbar_service.dart';
import 'package:flutter_chat/core/services/storage/cloud_storage_service.dart';
import 'package:flutter_chat/stores/root_store.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator({bool test = false}) async {
  // Device Services
  locator.registerLazySingleton<HardwareInfoService>(() => HardwareInfoServiceImpl());
  locator.registerLazySingleton<ConnectivityService>(() => ConnectivityServiceImpl());
  locator.registerLazySingleton<AppSettingsService>(() => AppSettingsServiceImpl());
  // User Services
  locator.registerLazySingleton<AuthService>(() => AuthServiceImpl());
  locator.registerLazySingleton<CloudStorageService>(() => CloudStorageServiceImpl());
  locator.registerLazySingleton<NotificationService>(() => NotificationServiceImpl());
  locator.registerLazySingleton<NavigationService>(() => NavigationServiceImpl());
  locator.registerLazySingleton<SnackbarService>(() => SnackbarServiceImpl());
  locator.registerLazySingleton<DialogService>(() => DialogServiceImpl());
  locator.registerLazySingleton<DynamicLinkService>(() => DynamicLinkServiceImpl());
  locator.registerLazySingleton<AnalyticsService>(() => AnalyticsServiceImpl());
  locator.registerLazySingleton<ChatService>(() => ChatServiceImpl());
  locator.registerLazySingleton<UserService>(() => UserServiceImpl());
  if (!test) {
    await _setupKeyStorageService();
    await _setupRemoteConfigService();
  }
  locator.registerSingletonAsync(() async {
    final rootStore = RootStore();
    await rootStore.initialize();
    return rootStore;
  });
}

Future<void> _setupRemoteConfigService() async {
  RemoteConfigService remoteConfigService = await RemoteConfigServiceImpl.getInstance();
  locator.registerSingleton(remoteConfigService);
}

Future<void> _setupKeyStorageService() async {
  final instance = await KeyStorageServiceImpl.getInstance();
  locator.registerLazySingleton<KeyStorageService>(() => instance);
}
