
import 'dart:async';

import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/config/services/local_storage_service/flutter_secure_storage_service_impl.dart';
import 'package:amptive/src/config/services/local_storage_service/storage_service.dart';
import 'package:amptive/src/config/utils/extensions/string_extensions.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:flutter/widgets.dart' show BuildContext;
import 'package:go_router/go_router.dart';

FutureOr<String?> tgRedirect(
  BuildContext _,
  GoRouterState goRouterState,
) async {
  final ATLocalStorageService storage = FlutterSecureStorageServiceImpl();

  // final Uri uri = goRouterState.uri;

  // //For incoming deeplinks.
  // final List<String> segments = uri.pathSegments;
  // if (segments.length >= 2 && segments[0] == 'content') {
  //   final String targetScreen = segments[0];
  //   final String id = segments[1];

  //   // Rebuild a local route that preserves the id and all UTM params
  //   final String utmParams = uri.queryParameters.entries
  //       .map((MapEntry<String, String> e) =>
  //         '${e.key}=${Uri.encodeComponent(e.value)}',
  //       ).join('&');
    
  //   String fullTargetScreenPath = '';
  //   if(targetScreen == 'content'){
  //     fullTargetScreenPath = '${ATRoutes.contentDetailScreen1.addSlash}?id=$id'
  //     '${utmParams.isNotEmpty ? '&$utmParams' : ''}';
  //   }

  //   return fullTargetScreenPath;
  // }

  // // Handle space deep links
  // if (segments.length >= 2 && segments[0] == 'space') {
  //   final String spaceId = segments[1];
    
  //   final String utmParams = uri.queryParameters.entries
  //       .map((MapEntry<String, String> e) =>
  //         '${e.key}=${Uri.encodeComponent(e.value)}',
  //       ).join('&');
    
  //   return '${ATRoutes.spaceDetailsScreen.addSlash}?id=$spaceId'
  //     '${utmParams.isNotEmpty ? '&$utmParams' : ''}';
  // }


  // if(segments[0] == ATRoutes.splashScreen){
  //   return ATRoutes.splashScreen.addSlash;
  // }


  final bool shouldRedirect =
      await storage.get(ATStrings.shouldRedirect) == 'true';

  if (shouldRedirect) {
    await storage.remove(ATStrings.shouldRedirect);

    final bool isExistingUser =
        await storage.get(ATStrings.isExistingUser) == 'true';
    final bool isLoggedIn = await storage.get(ATStrings.accessToken) != null;

    if (isExistingUser) {
      if (isLoggedIn) {
        return ATRoutes.dashboard.addSlash;
      } else {
        return ATRoutes.temporaryLoginScreen.addSlash;
      }
    } else {
      return ATRoutes.onboardingScreen.addSlash;
    }
  }

  return null;
}
