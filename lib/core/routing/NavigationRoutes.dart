import 'package:flutter/material.dart';
import 'package:myapp/features/auth/ui/screen/AuthScreen.dart';
import 'package:myapp/features/home/ui/screen/HomeScreen.dart';
import 'package:myapp/features/Inbox/ui/screen/Inbox_Screen.dart';
import 'package:myapp/features/profile/ui/screen/profileScreen.dart';

final Map<String, WidgetBuilder> routes = {
  //SplashPage.routeName: (context) => SplashPage(),
  AuthScreen.routeName: (context) => AuthScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  InboxScreen.routeName: (context) => InboxScreen(),
  // Discover.routeName: (context) => Discover(),
};
