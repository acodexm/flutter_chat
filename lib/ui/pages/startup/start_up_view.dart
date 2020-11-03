import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat/locator.dart';
import 'package:flutter_chat/stores/root_store.dart';
import 'package:flutter_chat/ui/widgets/loading.dart';

class StartUpView extends StatefulWidget {
  @override
  _StartUpViewState createState() => _StartUpViewState();
}

class _StartUpViewState extends State<StartUpView> {
  final store = locator<RootStore>().startUpStore;

  @override
  void initState() {
    super.initState();
    store.handleStartUpLogic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Loading(),
      ),
    );
  }
}
