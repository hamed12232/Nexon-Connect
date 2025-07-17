import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:myapp/core/Components/local_notification.dart';
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
              height: 60,
              width: 60,
              // ignore: deprecated_member_use
            ),
            SizedBox(width: 10),
            Text(
              "Nexon",
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
            ),
            SizedBox(width: 10),

            InkWell(
              onTap: () {
                Navigator.pushNamed(context, PostScreen.routeName);
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(0xff651CE5),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Lottie.asset("assets/images/add.json"),
              ),
            ),
            //  SizedBox(width: 20),
            //  SvgPicture.asset("assets/icons/search.svg", height: 30),
          ],
        ),
        Spacer(),
        Container(
          width: 150,
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
          ),
          child: Wrap(
            direction: Axis.horizontal,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey
                            // ignore: deprecated_member_use
                            .withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                      ),
                      height: 45,
                      width: 45,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: CircleAvatar(
                          backgroundImage: AssetImage(
                            'assets/images/avtar.jpg',
                          ),
                          radius: 25,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Alina",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      LocalNotification().showRepeatedNotification();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: SvgPicture.asset(
                        "assets/icons/tick.svg",
                        height: 21,
                        // ignore: deprecated_member_use
                        color: Color(0xff00d289),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
