import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_chat/core/models/enums/enums.dart';

abstract class AnalyticsService {
  Future setUserProperties({@required String userId, String userRole});

  Future logLogin(String loginMethod);

  Future logSignUp(String signUpMethod);

  Future logResetPassword({@required String userId});

  Future logChatCreated({ChatType type});

}

class AnalyticsServiceImpl implements AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics();

  FirebaseAnalyticsObserver getAnalyticsObserver() => FirebaseAnalyticsObserver(analytics: _analytics);

  // User properties tells us what the user is
  Future setUserProperties({@required String userId, String userRole}) async {
    await _analytics.setUserId(userId);
    await _analytics.setUserProperty(name: 'user_role', value: userRole);
    // property to indicate if it's a pro paying member
    // property that might tell us it's a regular poster, etc
  }

  Future logLogin(String loginMethod) async {
    await _analytics.logLogin(loginMethod: loginMethod);
  }

  Future logSignUp(String signUpMethod) async {
    await _analytics.logSignUp(signUpMethod: signUpMethod);
  }

  Future logChatCreated({ChatType type}) async {
    await _analytics.logEvent(
      name: 'create_chat',
      parameters: {'type': type},
    );
  }

  @override
  Future logResetPassword({@required String userId}) async {
    await _analytics.logEvent(
      name: 'reset_password',
      parameters: {'userId': userId},
    );
  }
}
