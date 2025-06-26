import 'package:flutter/material.dart';
import 'package:myapp/features/auth/ui/screen/AuthScreen.dart';
import 'package:myapp/features/home/ui/screen/HomeScreen.dart';
import 'package:myapp/features/Inbox/ui/screen/Inbox_Screen.dart';
import 'package:myapp/features/profile/ui/screen/profileScreen.dart';

class NavigationRoutes {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AuthScreen.routeName:
        return MaterialPageRoute(builder: (context) => const AuthScreen());

      case HomeScreen.routeName:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      case InboxScreen.routeName:
        return MaterialPageRoute(builder: (context) => const InboxScreen());
      case ProfileScreen.routeName:
        return MaterialPageRoute(builder: (context) => const ProfileScreen());
      default:
        return MaterialPageRoute(builder: (context) => const AuthScreen());
    }
  }
}
