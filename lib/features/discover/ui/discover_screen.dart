import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/Components/Custom_NavBar.dart';
import 'package:myapp/core/Components/enums.dart';
import 'package:myapp/features/discover/logic/cubit/follow_cubit.dart';

class DiscoverScreen extends StatefulWidget {
  static const String routeName = "/discover";

  const DiscoverScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<DiscoverScreen> {
  final cUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FollowCubit()..loadSuggestedUsers(cUser!.uid),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: BlocBuilder<FollowCubit, FollowState>(
                  builder: (context, state) {
                    if (state is FollowLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is FollowFailure) {
                      return Center(child: Text(state.error));
                    } else if (state is FollowLoaded) {
                      final following = state.following;
                      return ListView.builder(
                        padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                        itemCount: state.users.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 10,
                            ),
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
                                    backgroundImage: CachedNetworkImageProvider(
                                      state.users[index]['image'],
                                    ),
                                  ),
                                ),
                              ),
                              contentPadding: EdgeInsets.all(0),
                              title: Text(state.users[index]['fullName']),
                              subtitle: Text(state.users[index]['email']),
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
                                    colors:
                                        following.contains(
                                          state.users[index].id,
                                        )
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
                                    context.read<FollowCubit>().toggleFollow(
                                      cUser!.uid,
                                      state.users[index].id,
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    backgroundColor: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                  ),
                                  child: Text(
                                    following.contains(state.users[index].id)
                                        ? 'Unfollow'
                                        : 'Follow',
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
                      );
                    } else {
                      return const Center(child: Text("No Suggested Users"));
                    }
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
      ),
    );
  }
}
