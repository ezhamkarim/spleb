import 'package:flutter/material.dart';
import 'package:spleb/src/auth/auth_wrapper.dart';
import 'package:spleb/src/project/issue/issue_list_screen.dart';

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
            case BukuLogScreen.routeName:
              var arg = routeSettings.arguments as BukuLogScreenArg;
              return BukuLogScreen(
                projek: arg.projek,
                userClicked: arg.userClicked,
                viewOnly: arg.viewOnly,
                bukuLogQuality: arg.bukuLogQuality,
              );
            case BukuLogOSHEScreen.routeName:
              var arg = routeSettings.arguments as BukuLogScreenArg;
              return BukuLogOSHEScreen(
                projek: arg.projek,
                userClicked: arg.userClicked,
                viewOnly: arg.viewOnly,
                bukuLogOSHE: arg.bukuLogOSHE,
              );

            case BukuLogListScreen.routeName:
              var arg = routeSettings.arguments as BukuLogListArg;
              return BukuLogListScreen(
                showBook: arg.showBook,
                projek: arg.projek,
              );
            case DaftarProjek.routeName:
              var arg = routeSettings.arguments as DaftarProjekArg;
              return DaftarProjek(
                isEdit: arg.isEdit,
                projek: arg.projek,
                personInCharge: arg.personInCharge,
              );
            case IssueListScreen.routeName:
              var projekId = routeSettings.arguments as String;

              return IssueListScreen(projekId: projekId);

            case PdfApp.routeName:
              var projekId = routeSettings.arguments as String;
              return PdfApp(path: projekId);
            case BukuPanduanScreen.routeName:
              return const BukuPanduanScreen();
            case DaftarIssue.routeName:
              var arg = routeSettings.arguments as String;
              return DaftarIssue(projekId: arg);
            case ProjectScreen.routeName:
              return const ProjectScreen();
            case ProjectScreenViewOnly.routeName:
              var arg = routeSettings.arguments as ProjectScreenArg;
              return ProjectScreenViewOnly(
                projectId: arg.id,
                currentUser: arg.currentUser,
              );
            default:
              return ExceptionView(routeName: routeSettings.name!);
          }
        });
  }
}
