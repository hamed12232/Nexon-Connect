import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/core/Components/Custom_NavBar.dart';
import 'package:myapp/core/Components/Snak_bar.dart';
import 'package:myapp/core/Components/enums.dart';
import 'package:myapp/core/helper/services_helper.dart';
import 'package:myapp/features/auth/cubit/cubit/auth_cubit.dart';
import 'package:myapp/features/profile/logic/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = "/profile";
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? imageFile;
  String fileName = '';
  final SupabaseClient supabase = Supabase.instance.client;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final ServicesHelper servicesHelper = ServicesHelper();
  bool uploaded = false;
  UserModel? userModel;

  @override
  void initState() {
    fileName = 'profile_$userId.jpg';
    loadUserData();
    super.initState();
  }

  Future<void> loadUserData() async {
    userModel = await context.read<AuthCubit>().getUserData(userId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (userModel == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Colors.deepPurple),
        ),
      );
    }
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            _buildProfileContent(context),
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomNavBar(selectedMenu: MenuState.profile),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 50),
            _buildAvatar(),
            const SizedBox(height: 30),
            _buildUsername(),
            const SizedBox(height: 20),
            _buildStats(),
            const SizedBox(height: 20),
            _buildActions(),
            const SizedBox(height: 30),
            _buildTabBar(),
            const SizedBox(height: 15),
            _buildGrid(),
            const SizedBox(height: 300),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ignore: deprecated_member_use
          SvgPicture.asset(
            "assets/icons/back-arrow.svg",
            // ignore: deprecated_member_use
            color: Colors.black,
            height: 25,
          ),
          Text(
            userModel!.fullName,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 25,
            ),
          ),
          SvgPicture.asset("assets/icons/dots.svg", height: 8),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
              borderRadius: BorderRadius.circular(100),
              color: Colors.white,
            ),
            height: 200,
            width: 200,
            child: Padding(
              padding: EdgeInsets.all(4.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(userModel!.image),

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
                String? newImageUrl=  await servicesHelper.uploadImage(imageFile!, fileName);
                  await servicesHelper.updateUserImage(userId, newImageUrl!);
                  await loadUserData();
                  setState(() {});
                } else {
                  // ignore: use_build_context_synchronously
                  showInSnackBar("No image selected", context);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white,
                ),
                height: 55,
                width: 55,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xff651CE5),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsername() {
    return Text(
      "@${userModel!.fullName}",
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w700,
        fontSize: 25,
      ),
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 55),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatItem("${userModel!.following}", "Following"),
          _buildStatItem("${userModel!.followers}", "Followers"),
          _buildStatItem("${userModel!.likes}", "Like"),
        ],
      ),
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
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
      width: 100.0,
      height: 43.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff651CE5).withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 5),
          ),
        ],
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.1, 0.9],
          colors: [Color(0xff651CE5), Color(0xff811ce5)],
        ),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        onPressed: () {},
        child: const Text(
          'Follow',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildMessageButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          // ignore: deprecated_member_use
          color: Colors.grey.withOpacity(0.2),
        ),
        height: 50,
        width: 50,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
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
        children: [
          const Text(
            "Photos",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          const Text(
            "Videos",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const Text(
            "Tagged",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          SvgPicture.asset("assets/icons/two dots.svg", height: 20),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(5),
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 200 / 300,
      ),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.asset(
                  "assets/images/px$index.jpg",
                  fit: BoxFit.fill,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Container(
                    height: 40,
                    width: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      color: Colors.white,
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

  // Future<void> uploadProfileImage() async {
  //   final bucket = supabase.storage.from('images');
  //   try {
  //     //final filename = DateTime.now().millisecondsSinceEpoch.toString();
  //     final path = "uploads/$fileName";
  //     await bucket.upload(
  //       path,
  //       imageFile!,
  //       fileOptions: FileOptions(upsert: true),
  //     );
  //     showInSnackBar("upload successful image", context);
  //     setState(() {
  //       uploaded = true;
  //     });
  //   } catch (e) {
  //     showInSnackBar("Failed to upload image", context);
  //     print(e.toString());
  //     setState(() {
  //       uploaded = false;
  //     });
  //   }
  // }

  Future<void> pickImageGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }
}
