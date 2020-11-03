import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/ui/pages/main/main_view_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_translate/flutter_translate.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final model = MainViewStore();

  @override
  void initState() {
    super.initState();
    model.listen();
  }

  @override
  void dispose() {
    model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) => Scaffold(
        body: WillPopScope(
          child: PageView(controller: model.controller, children: model.views),
          onWillPop: model.onWillPop,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: model.index,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              title: Text(translate('home.title')),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              title: Text(translate('explore.title')),
            ),
          ],
          onTap: model.changeTab,
        ),
      ),
    );
  }
}
