import 'package:flutter/material.dart';
import 'package:flutter_chat/locator.dart';
import 'package:flutter_chat/stores/root_store.dart';
import 'package:flutter_chat/ui/pages/profile/profile_view.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_translate/flutter_translate.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final model = locator<RootStore>().settingsStore;

  @override
  void initState() {
    super.initState();
    model.init();
  }

  @override
  void dispose() {
//    model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('settings.title')),
      ),
      body: ListView(
        children: <Widget>[
          ProfileView(),
          ListTile(
            title: Text(translate('settings.appSettings')),
            subtitle: Text(translate('settings.appSettingsDesc')),
            trailing: Icon(Icons.launch),
            onTap: model.openAppSettings,
          ),
          Observer(
            builder: (context) => ListTile(
              onTap: model.toggleNotificationsEnabled,
              title: Text(translate('settings.notifications')),
              subtitle: Text(translate('settings.notificationsDesc')),
              trailing: Switch.adaptive(
                value: model.notificationsEnabled,
                onChanged: (_) => model.toggleNotificationsEnabled(),
              ),
            ),
          ),
          ListTile(
            title: Text(translate('settings.signOut')),
            subtitle: Text(translate('settings.signOutDesc')),
            trailing: Icon(Icons.exit_to_app),
            onTap: model.signOut,
          ),
        ],
      ),
    );
  }
}
