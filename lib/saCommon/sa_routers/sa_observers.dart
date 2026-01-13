import 'package:flutter/material.dart';
import 'index.dart';

class RouteObservers<R extends Route<dynamic>> extends RouteObserver<R> {
  Route<dynamic>? curRoute;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    curRoute = route; // Update current route
    var name = route.settings.name ?? '';
    if (name.isNotEmpty) RoutePages.history.add(name);
    print('didPush');
    print(RoutePages.history);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    curRoute = previousRoute; // Update current route to previous route
    RoutePages.history.remove(route.settings.name);
    print('didPop');
    print(RoutePages.history);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      curRoute = newRoute; // Update current route
      var index = RoutePages.history.indexWhere((element) {
        return element == oldRoute?.settings.name;
      });
      var name = newRoute.settings.name ?? '';
      if (name.isNotEmpty) {
        if (index > 0) {
          RoutePages.history[index] = name;
        } else {
          RoutePages.history.add(name);
        }
      }
    }
    print('didReplace');
    print(RoutePages.history);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    RoutePages.history.remove(route.settings.name);
    print('didRemove');
    print(RoutePages.history);
  }

  @override
  void didStartUserGesture(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didStartUserGesture(route, previousRoute);
  }

  @override
  void didStopUserGesture() {
    super.didStopUserGesture();
  }
}
