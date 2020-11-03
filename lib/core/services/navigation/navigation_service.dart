import 'package:flutter/material.dart';

abstract class NavigationService {
  GlobalKey<NavigatorState> get navigationKey;

  void pop();

  Future<dynamic> toNamed(String routeName, {dynamic arguments});

  Future<dynamic> offAllNamed(String routeName, {dynamic arguments});

  Future<dynamic> offAndToNamed(String routeName, {dynamic arguments});
}

class NavigationServiceImpl implements NavigationService {
  GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  void pop() {
    return _navigationKey.currentState.pop();
  }

  Future<dynamic> toNamed(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState.pushNamed(routeName, arguments: arguments);
  }

  @override
  Future offAllNamed(String routeName, {arguments}) {
    return _navigationKey.currentState
        .pushNamedAndRemoveUntil(routeName, (Route<dynamic> _) => false, arguments: arguments);
  }

  @override
  Future offAndToNamed(String routeName, {arguments}) {
    return _navigationKey.currentState.popAndPushNamed(routeName, arguments: arguments);
  }
}
