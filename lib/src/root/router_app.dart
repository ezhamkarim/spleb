import 'package:flutter/material.dart';

import 'screens.dart';

class RouterApp {
  static Route onGenerateRoute(RouteSettings routeSettings) {
    return MaterialPageRoute<void>(
        settings: routeSettings,
        builder: (BuildContext context) {
          switch (routeSettings.name) {
            case AuthScreen.routeName:
              return const AuthScreen();
            default:
              return ExceptionView(routeName: routeSettings.name!);
          }
        });
  }
}
