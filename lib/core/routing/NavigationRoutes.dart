import 'package:flutter/material.dart';
import 'package:myapp/features/Post/ui/screen/post_screen.dart';
import 'package:myapp/features/auth/ui/screen/AuthScreen.dart';
import 'package:myapp/features/discover/ui/discover_screen.dart';
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
      case PostScreen.routeName:
        return MaterialPageRoute(builder: (context) => const PostScreen());
      case ProfileScreen.routeName:
        return MaterialPageRoute(builder: (context) => const ProfileScreen());
      case DiscoverScreen.routeName:
        return MaterialPageRoute(builder: (context) => const DiscoverScreen());
      
      default:
        return MaterialPageRoute(builder: (context) => const AuthScreen());
    }
  }
}
