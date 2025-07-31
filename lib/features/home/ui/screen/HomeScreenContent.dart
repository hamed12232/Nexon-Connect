import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexon/core/Components/Custom_NavBar.dart';
import 'package:nexon/core/Components/enums.dart';
import 'package:nexon/features/Post/logic/cubit/likes_cubit/likes_cubit.dart';
import 'package:nexon/features/Post/logic/cubit/post_cubit/post_cubit.dart';
import 'package:nexon/features/Post/logic/model/post_model.dart';
import 'package:nexon/features/home/ui/widgets/custom_app_bar_widget.dart';
import 'package:nexon/features/home/ui/widgets/home_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key, required this.user});

  final FirebaseAuth user;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: BlocBuilder<PostCubit, PostState>(
          builder: (context, state) {
            if (state is PostLoading) {
              return Skeletonizer(
                enabled: true,
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: 5,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Container(
                      height: 300,
                      decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              );
            } else if (state is PostFailure) {
              return Center(child: Text(state.error));
            } else if (state is PostLoaded) {
              List<PostModel> posts = (state).posts;
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
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
                              PostModel post = posts[index];
                              String imageUrl = posts[index].userImage;
                              return BlocProvider(
                                key: ValueKey(post.id),
                                create: (context) => LikeCubit()
                                  ..loadLikes(post.id, user.currentUser!.uid),
                                child: HomeCard(
                                  postId: post.id,
                                  user: user.currentUser!.uid,
                                  dp: imageUrl,
                                  name: post.username,
                                  des: post.text!,
                                  hash: post.id,
                                  img: post.postImage!,
                                ),
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
              );
            }

            return const Center(child: Text("Something went wrong"));
          },
        ),
      ),
    );
  }
}
