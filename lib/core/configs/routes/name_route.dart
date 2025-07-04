import 'package:desktopme/feature/auth/presentation/login_page.dart';
import 'package:desktopme/feature/auth/presentation/main_ui.dart';
import 'package:desktopme/feature/auth/presentation/sign_up_page.dart';
import 'package:desktopme/feature/splash/splash_page.dart';
import 'package:desktopme/feature/todo/presentation/dashBoard_page.dart';
import 'package:flutter/material.dart';
 
class AppRoutes {
  
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'login':
        return MaterialPageRoute(builder: (_) =>   LoginPage());
      case 'signup':
        return MaterialPageRoute(builder: (_) =>   SignUpPage());
      case 'dashBoard':
        return MaterialPageRoute(builder: (_) =>   DashboardPage());
        case 'mainUi':
        return MaterialPageRoute(builder: (_) =>   MainUi());
        case 'splashPage':
        return MaterialPageRoute(builder: (_) =>   SplashPage());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('No route defined')),
          ),
        );
    }
  }
}