import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nexon/features/Post/ui/screen/post_screen.dart';

// ignore: camel_case_types
class Custom_appBarWidget extends StatelessWidget {
  const Custom_appBarWidget({super.key, required this.user});
  final FirebaseAuth user;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final logoAsset = isDark
        ? 'assets/img/logo_dark.png'
        : 'assets/images/logo.png';

    return Row(
      children: [
        Row(
          children: [
            SizedBox(width: 50, height: 50, child: Image.asset(logoAsset)),
            SizedBox(width: 10),
            Text(
              "Nexon",
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            //  SizedBox(width: 20),
            //  SvgPicture.asset("assets/icons/search.svg", height: 30),
          ],
        ),

        Spacer(),
        SizedBox(
          width: 70,
          height: 70,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, PostScreen.routeName);
            },
            child: Lottie.asset("assets/images/add.json", fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }
}
