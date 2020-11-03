import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_chat/core/constants/view_routes.dart';
import 'package:flutter_chat/core/services/navigation/navigation_service.dart';
import 'package:flutter_chat/locator.dart';
import 'package:flutter_chat/utils/logger.dart';

abstract class DynamicLinkService {
  Future<void> handleDynamicLinks();

  Future<String> createFirstEventLink(String title);
}

class DynamicLinkServiceImpl implements DynamicLinkService {
  final NavigationService _navigationService = locator<NavigationService>();

  Future<void> handleDynamicLinks() async {
    // Get the initial dynamic link if the app is opened with a dynamic link
    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();

    // handle link that has been retrieved
    _handleDeepLink(data);

    // Register a link callback to fire if the app is opened up from the background
    // using a dynamic link.
    FirebaseDynamicLinks.instance.onLink(onSuccess: (PendingDynamicLinkData dynamicLink) async {
      // handle link that has been retrieved
      _handleDeepLink(dynamicLink);
    }, onError: (OnLinkErrorException e) async {
      Log.d('Link Failed: ${e.message}');
    });
  }

  void _handleDeepLink(PendingDynamicLinkData data) {
    final Uri deepLink = data?.link;
    if (deepLink != null) {
      Log.d('_handleDeepLink | deeplink: $deepLink');

      var isEvent = deepLink.pathSegments.contains('event');
      if (isEvent) {
        var title = deepLink.queryParameters['title'];
        if (title != null) {
          _navigationService.toNamed(ViewRoutes.chat, arguments: title);
        }
      }
    }
  }

  Future<String> createFirstEventLink(String title) async {
    /*TODO
    * in future this is one of the options to enforce installation of the app
    * this will allow also joining events or group chats
    * */
    throw UnimplementedError();
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://filledstacks.page.link',
      link: Uri.parse('https://www.geochat.com/event?title=$title'),
      androidParameters: AndroidParameters(
        packageName: 'com.acodexm.flutter_chat',
      ),

      // Other things to add as an example. We don't need it now
      iosParameters: IosParameters(
        bundleId: 'com.example.ios',
        minimumVersion: '1.0.1',
        appStoreId: '123456789',
      ),
      googleAnalyticsParameters: GoogleAnalyticsParameters(
        campaign: 'example-promo',
        medium: 'social',
        source: 'orkut',
      ),
      itunesConnectAnalyticsParameters: ItunesConnectAnalyticsParameters(
        providerToken: '123456',
        campaignToken: 'example-promo',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'Example of a Dynamic Link',
        description: 'This link works whether app is installed or not!',
      ),
    );

    final Uri dynamicUrl = await parameters.buildUrl();

    return dynamicUrl.toString();
  }
}
