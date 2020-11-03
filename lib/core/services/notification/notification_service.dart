import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_chat/core/constants/view_routes.dart';
import 'package:flutter_chat/core/services/auth/auth_service.dart';
import 'package:flutter_chat/core/services/navigation/navigation_service.dart';
import 'package:flutter_chat/locator.dart';
import 'package:flutter_chat/utils/logger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract class NotificationService {
  void registerFirebaseNotifications(String currentUserId);

  Future<bool> configLocalNotification();

  Future<void> showNotification(message);
}

class NotificationServiceImpl implements NotificationService {
  final _navigationService = locator<NavigationService>();
  final _authService = locator<AuthService>();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void registerFirebaseNotifications(String currentUserId) {
    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        Log.d('onMessage: $message');
        return;
      },
      onResume: (Map<String, dynamic> message) {
        Log.d('onResume: $message');
        if (message['data']['chatId'] != null) {
          Log.d('go to chat : ${message['data']['chatId']}');
          _navigationService.toNamed(ViewRoutes.chat,
              arguments: message['data']['chatId']);
        }
        return;
      },
      onLaunch: (Map<String, dynamic> message) {
        Log.d('onLaunch: $message');
        if (message['data']['chatId'] != null) {
          Log.d('go to chat : ${message['data']['chatId']}');
          _navigationService.toNamed(ViewRoutes.chat,
              arguments: message['data']['chatId']);
        }
        return;
      },
    );

    firebaseMessaging.getToken().then((token) {
      Log.d('device token: $token');
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('tokens')
          .doc(token)
          .set({
        'pushToken': token,
        'createdAt': FieldValue.serverTimestamp(), // optional
        'platform': Platform.operatingSystem,
      });
    }).catchError((err) {
      Log.e('Error firebaseMessaging.getToken', e: err);
    });
  }

  Future<bool> configLocalNotification() async {
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    return flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(message) {
    Log.d(message);
    throw UnimplementedError();
    // return Future.value();
//    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
//      'com.acodexm.geochat',
//      'Flutter GeoChat',
//      'channel description',
//      playSound: true,
//      enableVibration: true,
//      importance: Importance.Max,
//      priority: Priority.High,
//
//    );
//    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
//    var platformChannelSpecifics =
//        new NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
//    return flutterLocalNotificationsPlugin.show(
//        0, message['title'].toString(), message['body'].toString(), platformChannelSpecifics,
//        payload: json.encode(message));
  }
}
