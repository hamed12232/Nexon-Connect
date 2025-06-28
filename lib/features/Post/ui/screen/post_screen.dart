import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/core/Components/Snak_bar.dart';
import 'package:myapp/features/Post/logic/cubit/post_cubit.dart';

class PostScreen extends StatefulWidget {
  static const routeName = "/PostScreen";

  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  File? imageFile;
  TextEditingController textController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFF651CE5); // نفس لون الـ Gradient الأساسي

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Create Post',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await context.read<PostCubit>().createPost(
                text: textController.text,
                imageFile: imageFile,
              );
              Navigator.pop(context);
              showInSnackBar("Post created successfully", context);
            },
            child: Text(
              'Post',
              style: TextStyle(
                color: themeColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage('assets/images/guestImage.avif'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: const InputDecoration(
                      hintText: "What's on your mind?",
                      hintStyle: TextStyle(fontSize: 16),
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                    style: const TextStyle(fontSize: 18),
                    keyboardType: TextInputType.multiline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Stack(
              children: [
                GestureDetector(
                  onTap: pickImageGallery,
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'Tap to add image/video',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                if (imageFile != null)
                  Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.file(imageFile!, fit: BoxFit.cover),
                  ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildIconButton(
                  icon: FontAwesomeIcons.image,
                  label: 'Photo',
                  color: Colors.green,
                ),
                _buildIconButton(
                  icon: FontAwesomeIcons.video,
                  label: 'Video',
                  color: Colors.red,
                ),
                _buildIconButton(
                  icon: FontAwesomeIcons.smile,
                  label: 'Feeling',
                  color: Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          // ignore: deprecated_member_use
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Future<void> pickImageGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }
}
