import 'package:flutter/material.dart';
import 'package:flutter_chat/core/constants/view_routes.dart';
import 'package:flutter_chat/core/models/chat/chat_response.dart';
import 'package:flutter_chat/core/services/auth/auth_service.dart';
import 'package:flutter_chat/locator.dart';
import 'package:flutter_chat/ui/pages/auth/forgot_password/forgot_password_view.dart';
import 'package:flutter_chat/ui/pages/auth/login/login_view.dart';
import 'package:flutter_chat/ui/pages/auth/register/register_view.dart';
import 'package:flutter_chat/ui/pages/chat/chat_room/chat_room_view.dart';
import 'package:flutter_chat/ui/pages/main/main_view.dart';
import 'package:flutter_chat/ui/pages/settings/settings_view.dart';
import 'package:flutter_chat/ui/pages/startup/start_up_view.dart';
import 'package:flutter_translate/flutter_translate.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case ViewRoutes.splash:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: StartUpView(),
      );
    case ViewRoutes.main:
      return _getProtectedPageRoute(
        roles: ['admin', 'user', 'premium'],
        routeName: settings.name,
        viewToShow: MainView(),
      );
    case ViewRoutes.login:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: LoginView(),
      );
    case ViewRoutes.register:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: RegisterView(),
      );
    case ViewRoutes.forgotPassword:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: ForgotPasswordView(),
      );
    case ViewRoutes.settings:
      return _getProtectedPageRoute(
        roles: ['admin', 'user', 'premium'],
        routeName: settings.name,
        viewToShow: SettingsView(),
      );
    case ViewRoutes.chat:
      String chatId;
      ChatResponse chat;
      if (settings.arguments is String) {
        chatId = settings.arguments;
      } else if (settings.arguments is ChatResponse) {
        chat = settings.arguments as ChatResponse;
      }
      return _getProtectedPageRoute(
        roles: ['admin', 'user', 'premium'],
        routeName: settings.name,
        viewToShow: ChatRoomView(chat: chat, chatId: chatId),
      );
    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(child: Text(translate('routes.notFound', args: {'route': settings.name}))),
        ),
      );
  }
}

PageRoute _getPageRoute({String routeName, Widget viewToShow}) {
  return MaterialPageRoute(
    settings: RouteSettings(name: routeName),
    builder: (_) => viewToShow,
  );
}

PageRoute _getProtectedPageRoute({String routeName, Widget viewToShow, List<String> roles}) {
  final _authService = locator<AuthService>();
  if (_authService.currentUser == null) {
    return MaterialPageRoute(
      settings: RouteSettings(name: ViewRoutes.login),
      builder: (_) => LoginView(),
    );
  }
  if (!roles.contains(_authService.currentUser.role))
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(child: Text(translate('routes.unauthorised'))),
      ),
    );
  return MaterialPageRoute(
    settings: RouteSettings(name: routeName),
    builder: (_) => viewToShow,
  );
}
