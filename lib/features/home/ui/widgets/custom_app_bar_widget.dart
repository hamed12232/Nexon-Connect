import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:myapp/features/Post/ui/screen/post_screen.dart';

// ignore: camel_case_types
class Custom_appBarWidget extends StatelessWidget {
  const Custom_appBarWidget({super.key, required this.user});
  final FirebaseAuth user;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
     Row(
          children: [
            Image.asset(
              "assets/images/logo.png",
              height: 70,
              width: 70,
              // ignore: deprecated_member_use
            ),
            SizedBox(width: 10),
            Text(
              "Nexon",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
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
                child: Lottie.asset(
                  "assets/images/add.json",
                  fit: BoxFit.cover,
                ),
              ),
            ),

      ],
    );
  }
}
