import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/core/managers/core_manager.dart';
import 'package:flutter_chat/core/managers/dialog_manager.dart';
import 'package:flutter_chat/core/services/dialog/dialog_service.dart';
import 'package:flutter_chat/core/services/navigation/navigation_service.dart';
import 'package:flutter_chat/locator.dart';
import 'package:flutter_chat/ui/pages/startup/start_up_view.dart';
import 'package:flutter_chat/utils/const.dart';
import 'package:flutter_chat/utils/logger.dart';
import 'package:flutter_chat/utils/router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLogger();
  await Firebase.initializeApp();
  await setupLocator();
  runApp(LocalizedApp(
    await LocalizationDelegate.create(
      fallbackLocale: 'en_US',
      supportedLocales: ['en_US', 'pl_PL'],
    ),
    GeoChat(),
  ));
}

class GeoChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    return CoreManager(
      child: LocalizationProvider(
        state: LocalizationProvider.of(context).state,
        child: MaterialApp(
          title: 'GeoChat',
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            localizationDelegate
          ],
          supportedLocales: localizationDelegate.supportedLocales,
          locale: localizationDelegate.currentLocale,
          builder: (context, child) => Navigator(
            key: locator<DialogService>().dialogNavigationKey,
            onGenerateRoute: (settings) => MaterialPageRoute(builder: (context) => DialogManager(child: child)),
          ),
          navigatorKey: locator<NavigationService>().navigationKey,
          theme: ThemeData(
            primaryColor: themeColor,
            textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Open Sans'),
          ),
          home: StartUpView(),
          onGenerateRoute: generateRoute,
//          debugShowCheckedModeBanner: Provider.of<Flavor>(context) == Flavor.dev,
        ),
      ),
    );
  }
}
