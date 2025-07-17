
import 'package:flutter/material.dart';

class LoggingNavigatorObserver extends NavigatorObserver {
  List<String?> routeStack = <String?>[];

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    routeStack.add(route.settings.name);
    _logStack();
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    routeStack.removeLast();
    _logStack();
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    routeStack.removeLast();
    _logStack();
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    routeStack.removeLast();
    routeStack.add(newRoute!.settings.name);
  }

  void _logStack() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('Current navigation stack: $routeStack');
    });
  }
}
