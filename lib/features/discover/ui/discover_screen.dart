import 'package:flutter/material.dart';
import 'package:myapp/core/Components/Custom_NavBar.dart';
import 'package:myapp/core/Components/data.dart';
import 'package:myapp/core/Components/enums.dart';

class DiscoverScreen extends StatefulWidget {
  static const  String routeName = "/discover";

  const DiscoverScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<DiscoverScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                itemCount: friends.length,
                itemBuilder: (BuildContext context, int index) {
                  Map friend = friends[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                    child: ListTile(
                      leading: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white,
                        ),
                        height: 55,
                        width: 55,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: CircleAvatar(
                            backgroundImage: AssetImage(friend["dp"]),
                          ),
                        ),
                      ),
                      contentPadding: EdgeInsets.all(0),
                      title: Text(friend['name']),
                      subtitle: Text(friend['status']),
                      trailing: Container(
                        width: 100.0,
                        height: 38.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xff651CE5).withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: Offset(0, 5),
                            ),
                          ],
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            stops: [0.1, 0.9],
                            colors: friend['isAccept']
                                ? [
                                    Colors.black.withOpacity(0.5),
                                    Colors.grey,
                                  ]
                                : [
                                    Color(0xff651CE5),
                                    Color(0xff811ce5),
                                  ],
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            // Handle follow/unfollow
                          },
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            backgroundColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          child: Text(
                            friend['isAccept'] ? 'Unfollow' : 'Follow',
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {},
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 0,
              child: CustomNavBar(selectedMenu: MenuState.discover),
            ),
          ],
        ),
      ),
    );
  }
}
