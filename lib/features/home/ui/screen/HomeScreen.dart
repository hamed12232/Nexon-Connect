import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/core/Components/Custom_NavBar.dart';
import 'package:myapp/core/Components/data.dart';
import 'package:myapp/core/Components/enums.dart';
import 'package:myapp/features/home/ui/widgets/custom_app_bar_widget.dart';
import 'package:myapp/features/home/ui/widgets/home_card.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";
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
                        child: Custom_appBarWidget(user: user),
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
