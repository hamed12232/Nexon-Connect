import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/Components/Custom_NavBar.dart';
import 'package:myapp/core/Components/enums.dart';
import 'package:myapp/features/Post/logic/cubit/likes_cubit/likes_cubit.dart';
import 'package:myapp/features/Post/logic/cubit/post_cubit/post_cubit.dart';
import 'package:myapp/features/Post/logic/model/post_model.dart';
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
  void initState() {
    context.read<PostCubit>().fetchPost();
    super.initState();
  }

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
        body: BlocBuilder<PostCubit, PostState>(
          builder: (context, state) {
            if (state is PostLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PostFailure) {
              return Center(child: Text(state.error));
            } else if (state is PostLoaded) {
              List<PostModel> posts = (state).posts;
              return SizedBox(
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
                              PostModel post = posts[index];
                              String imageUrl = posts[index].userImage;
                              if (imageUrl.contains('?')) {
                                imageUrl +=
                                    "&v=${DateTime.now().millisecondsSinceEpoch}";
                              } else {
                                imageUrl +=
                                    "?v=${DateTime.now().millisecondsSinceEpoch}";
                              }
                              return BlocProvider(
                                key: ValueKey(post.id),
                                create: (context) => LikeCubit()..loadLikes(post.id, post.userId),
                                child: HomeCard(
                                  postId: post.id,
                                  user: post.userId,
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
