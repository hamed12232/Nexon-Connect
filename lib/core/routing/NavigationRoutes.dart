import 'package:flutter/material.dart';
import 'package:myapp/features/Post/ui/screen/post_screen.dart';
import 'package:myapp/features/auth/ui/screen/AuthScreen.dart';
import 'package:myapp/features/discover/ui/discover_screen.dart';
import 'package:myapp/features/home/ui/screen/HomeScreen.dart';
import 'package:myapp/features/Inbox/ui/screen/Inbox_Screen.dart';
import 'package:myapp/features/profile/logic/user_model.dart';
import 'package:myapp/features/profile/ui/screen/profileScreen.dart';
import 'package:myapp/features/profile/ui/screen/SettingsPrivacypage.dart';
import 'package:myapp/features/profile/ui/widget/PrivacyPolicyScreen.dart';
import 'package:myapp/features/profile/ui/widget/SupportAndHelpScreen.dart';
import 'package:myapp/features/profile/ui/widget/accountSection.dart';
import 'package:myapp/features/profile/ui/widget/changePassword.dart';
import 'package:myapp/features/auth/ui/screen/forgot_password.dart';

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

      case SettingsPrivacyPage.routeName:
        final userModel = settings.arguments as UserModel;
        return MaterialPageRoute(
          builder: (context) => SettingsPrivacyPage(
            imgurl: userModel.image,
            name: userModel.fullName,
            email: userModel.email,
          ),
        );

      case Changepassword.routeName:
        final String email = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => Changepassword(email: email),
        );

      case ComplateProfileScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => const ComplateProfileScreen(),
        );
      case PrivacyPolicyScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => const PrivacyPolicyScreen(),
        );
      case ContactSupportScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => const ContactSupportScreen(),
        );
      case ForgotPasswordScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => const ForgotPasswordScreen(),
        );

      default:
        return MaterialPageRoute(builder: (context) => const AuthScreen());
    }
  }
}
