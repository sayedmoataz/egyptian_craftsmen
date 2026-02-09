import 'package:flutter/material.dart';

import 'navigation_service.dart';

mixin RouteAwareMixin<T extends StatefulWidget> on State<T> 
    implements RouteAware {
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    NavigationService.instance.routeObserver.subscribe(
      this,
      ModalRoute.of(context)!,
    );
  }

  @override
  void dispose() {
    NavigationService.instance.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    // Called when the current route has been pushed.
  }

  @override
  void didPopNext() {
    // Called when the top route has been popped off, and the current route
    // shows up.
  }

  @override
  void didPop() {
    // Called when the current route has been popped off.
  }

  @override
  void didPushNext() {
    // Called when a new route has been pushed, and the current route is no
    // longer visible.
  }
}