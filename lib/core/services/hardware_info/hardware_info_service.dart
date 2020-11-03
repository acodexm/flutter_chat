import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter_chat/utils/logger.dart';

abstract class HardwareInfoService {
  String get operatingSystem;

  String get device;

  String get udid;

  Future<void> init();
}

class HardwareInfoServiceImpl implements HardwareInfoService {
  String _operatingSystem;
  String _device;
  String _udid;

  @override
  String get operatingSystem => _operatingSystem;

  @override
  String get device => _device;

  @override
  String get udid => _udid;

  @override
  Future<void> init() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      _udid = iosInfo.identifierForVendor;
      _operatingSystem = 'iOS';
      _device = iosInfo.utsname.machine;
    } else if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      _udid = androidInfo.androidId;
      _operatingSystem = 'Android';
      _device = androidInfo.model;
    }

    Log.d('device: $_device \n udid: $_udid \n operating_system: $_operatingSystem');
  }
}
