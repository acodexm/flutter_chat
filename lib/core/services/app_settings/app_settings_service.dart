import 'package:app_settings/app_settings.dart';

abstract class AppSettingsService {
  Future<void> openAppSettings();
}

class AppSettingsServiceImpl implements AppSettingsService {
  @override
  Future<void> openAppSettings() => AppSettings.openAppSettings();
}
