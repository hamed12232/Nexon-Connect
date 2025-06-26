import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myapp/core/Components/Custom_NavBar.dart';
import 'package:myapp/core/Components/data.dart';
import 'package:myapp/core/Components/enums.dart';
import 'package:myapp/features/auth/ui/screen/AuthScreen.dart';
import 'package:myapp/features/home/ui/widgets/home_card.dart';

class HomeScreen extends StatefulWidget {
  static  const String routeName = "/home";

  const HomeScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  final user = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 10,
                        ),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    await user.signOut();
                                    Navigator.pushNamed(
                                        context, AuthScreen.routeName);
                                  },
                                  child: SvgPicture.asset(
                                    "assets/icons/menu.svg",
                                    // ignore: deprecated_member_use
                                    color: Color(0xff651CE5),
                                    height: 50,
                                  ),
                                ),
                                SizedBox(width: 20),
                                SvgPicture.asset(
                                  "assets/icons/notification.svg",
                                  height: 30,
                                ),
                                SizedBox(width: 20),
                                SvgPicture.asset(
                                  "assets/icons/search.svg",
                                  height: 30,
                                ),
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
                                                offset: Offset(
                                                  0,
                                                  3,
                                                ), // changes position of shadow
                                              ),
                                            ],
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
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
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 15,
                                        ),
                                        child: SvgPicture.asset(
                                          "assets/icons/tick.svg",
                                          height: 21,
                                          // ignore: deprecated_member_use
                                          color: Color(0xff00d289),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      ...List.generate(posts.length, (index) {
                        Map post = posts[index];
                        return HomeCard(
                          dp: post["dp"],
                          name: post['name'],
                          img: "assets/images/dm$index.jpg",
                          des: post['des'],
                          hash: post['hash'],
                        );
                      }),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: CustomNavBar(selectedMenu: MenuState.home),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
