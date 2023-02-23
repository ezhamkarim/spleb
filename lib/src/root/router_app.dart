import 'package:flutter/material.dart';

import 'screens.dart';

class RouterApp {
  static Route onGenerateRoute(RouteSettings routeSettings) {
    return MaterialPageRoute<void>(
        settings: routeSettings,
        builder: (BuildContext context) {
          switch (routeSettings.name) {
            case LoginScreen.routeName:
              return const LoginScreen();
            default:
              return ExceptionView(routeName: routeSettings.name!);
          }
        });
  }
}
