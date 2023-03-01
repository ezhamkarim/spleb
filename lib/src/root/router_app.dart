import 'package:flutter/material.dart';
import 'package:spleb/src/auth/auth_wrapper.dart';

import 'screens.dart';

class RouterApp {
  static Route onGenerateRoute(RouteSettings routeSettings) {
    return MaterialPageRoute<void>(
        settings: routeSettings,
        builder: (BuildContext context) {
          switch (routeSettings.name) {
            case AuthWrapper.routeName:
              return const AuthWrapper();
            case LoginScreen.routeName:
              return const LoginScreen();
            case RegisterScreen.routeName:
              return const RegisterScreen();
            case DaftarRole.routeName:
              return const DaftarRole();
            case SenaraiRole.routeName:
              return const SenaraiRole();
            case DaftarProjek.routeName:
              return const DaftarProjek();
            case ProjectScreenViewOnly.routeName:
              var arg = routeSettings.arguments as ProjectScreenArg;
              return ProjectScreenViewOnly(
                projectId: arg.id,
                userRole: arg.userRole,
              );
            default:
              return ExceptionView(routeName: routeSettings.name!);
          }
        });
  }
}
