import 'package:dexter_mobile/screens/auth/login.dart';
import 'package:dexter_mobile/screens/auth/signup.dart';
import 'package:dexter_mobile/screens/auth/splash.dart';
import 'package:dexter_mobile/screens/others/demo.dart';
import 'package:dexter_mobile/screens/pages/detailitem.dart';
import 'package:dexter_mobile/screens/root.dart';
import 'package:flutter/material.dart';

class RouteManager {
  static const String splash = "splash";
  static const String login = "login";
  static const String signup = "signup";
  static const String root = "root";
  static const String itemDetail = "itemDetail";
  static const String demo = "demo";
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (constext) => const SplashScreen());

      case login:
        return MaterialPageRoute(builder: (constext) => const LogInScreen());

      case signup:
        return MaterialPageRoute(builder: (constext) => const SignUpScreen());

      case root:
        return MaterialPageRoute(builder: (constext) => const RootScreen());

      case itemDetail:
        return MaterialPageRoute(builder: (constext) => const DetailItem());

      default:
        return MaterialPageRoute(builder: (constext) => const DemoScreen());
    }
  }
}
