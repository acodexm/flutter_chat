import 'package:flutter/material.dart';
import 'package:flutter_chat/ui/pages/chat/chat_list/chat_list_view.dart';
import 'package:flutter_chat/ui/pages/users/user_list_view.dart';
import 'package:flutter_chat/utils/toast.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:mobx/mobx.dart';

part 'main_view_store.g.dart';

class MainViewStore = MainViewStoreBase with _$MainViewStore;

abstract class MainViewStoreBase with Store {
  final views = <Widget>[ChatList(), UserList()];
  @observable
  int index = 0;
  PageController controller = PageController(initialPage: 0, keepPage: true);

  void listen() {
    controller.addListener(() {
      index = controller.page.floor();
    });
  }

  void dispose() {}
  DateTime _currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (_currentBackPressTime == null || now.difference(_currentBackPressTime) > Duration(seconds: 2)) {
      _currentBackPressTime = now;
      showToast(translate('toasts.onExit'));
      return Future.value(false);
    }
    return Future.value(true);
  }

  @action
  void changeTab(int index) {
    this.index = index;
    controller.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
  }
}
