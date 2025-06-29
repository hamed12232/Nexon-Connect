// ✅ ProfileScreen refactored with cleaner image update and user data flow
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/core/Components/Custom_NavBar.dart';
import 'package:myapp/core/Components/Snak_bar.dart';
import 'package:myapp/core/Components/enums.dart';
import 'package:myapp/core/helper/services_helper.dart';
import 'package:myapp/features/Post/logic/cubit/post_cubit/post_cubit.dart';
import 'package:myapp/features/auth/cubit/cubit/auth_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

class ProfileScreen extends StatefulWidget {
  static const String routeName = "/profile";
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final int versionParam;
  File? imageFile;
  String fileName = '';
  final supabase = Supabase.instance.client;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final servicesHelper = ServicesHelper();

  @override
  void initState() {
      versionParam = DateTime.now().millisecondsSinceEpoch;

    fileName = 'profile_$userId.jpg';
    context.read<AuthCubit>().getUserData(userId);
    context.read<PostCubit>().fetchUserPosts(userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is AuthLoading || state is AuthInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is AuthUserLoaded) {
                  return _buildProfileContent(context, state.user);
                } else {
                  return const Center(child: Text("Failed to load user"));
                }
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomNavBar(selectedMenu: MenuState.profile),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, userModel) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(userModel),
          const SizedBox(height: 50),
          _buildAvatar(userModel),
          const SizedBox(height: 30),
          Text(
            "@${userModel.fullName}",
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),
          _buildStats(userModel),
          const SizedBox(height: 20),
          _buildActions(),
          const SizedBox(height: 30),
          _buildTabBar(),
          const SizedBox(height: 15),
          _buildGrid(),
          const SizedBox(height: 300),
        ],
      ),
    );
  }

  Widget _buildHeader(userModel) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset(
            "assets/icons/back-arrow.svg",
            color: Colors.black,
            height: 25,
          ),
          Text(
            userModel.fullName,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
          ),
          SvgPicture.asset("assets/icons/dots.svg", height: 8),
        ],
      ),
    );
  }

  Widget _buildAvatar(userModel) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Stack(
        children: [
          Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider("${userModel.image}?v=${DateTime.now().millisecondsSinceEpoch}"),
                radius: 25,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 10,
            child: InkWell(
              onTap: () async {
                await pickImageGallery();
                if (imageFile != null) {
                  String? newImageUrl = await servicesHelper.uploadImage(
                    imageFile!,
                    fileName,
                  );
                  await servicesHelper.updateUserImage(userId, newImageUrl!);
                  await context.read<AuthCubit>().getUserData(userId);
                  showInSnackBar("Image updated successfully", context);
                } else {
                  showInSnackBar("No image selected", context);
                }
              },
              child: Container(
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xff651CE5),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(userModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 55),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatItem("${userModel.following}", "Following"),
          _buildStatItem("${userModel.followers}", "Followers"),
          _buildStatItem("${userModel.likes}", "Like"),
        ],
      ),
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildFollowButton(),
        const SizedBox(width: 20),
        _buildMessageButton(),
      ],
    );
  }

  Widget _buildFollowButton() {
    return Container(
      width: 100,
      height: 43,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff651CE5), Color(0xff811ce5)],
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff651CE5).withOpacity(0.3),
            blurRadius: 8,
          ),
        ],
      ),
      child: TextButton(
        onPressed: () {},
        child: const Text(
          'Follow',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildMessageButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SvgPicture.asset("assets/icons/mail-outline.svg"),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            "Photos",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Text(
            "Videos",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          Text(
            "Tagged",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return BlocBuilder<PostCubit, PostState>(
      builder: (context, state) {
        if (state is PostLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is PostFailure) return Center(child: Text(state.error));
        if (state is PostLoaded) {
          final posts = state.posts;
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(5),
            itemCount: posts.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 200 / 300,
            ),
            itemBuilder: (context, index) {
              final post = posts[index];
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        post.postImage ?? '',
                        fit: BoxFit.fill,
                        errorBuilder: (_, __, ___) => const Icon(Icons.error),
                        loadingBuilder:
                            (context, child, loadingProgress) =>
                                loadingProgress == null
                                    ? child
                                    : const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          height: 40,
                          width: 70,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(35),
                          ),
                          child: const Center(
                            child: Text(
                              "123k",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
        return const Center(child: Text("Something went wrong"));
      },
    );
  }

  Future<void> pickImageGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => imageFile = File(pickedFile.path));
    }
  }
}
