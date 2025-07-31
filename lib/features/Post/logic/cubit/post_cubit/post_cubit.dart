import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:nexon/core/helper/services_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nexon/features/Post/logic/model/post_model.dart';
import 'package:uuid/uuid.dart';
part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final ServicesHelper servicesHelper = ServicesHelper();
  PostCubit() : super(PostInitial());

  Future<void> createPost({required String? text, File? imageFile}) async {
    emit(PostLoading());

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(PostFailure("User not found"));
        return;
      }

      final userModel = await servicesHelper.getUser(user.uid);

      String? imageUrl;
      if (imageFile != null) {
        final fileName = DateTime.now().millisecondsSinceEpoch.toString();
        imageUrl = await servicesHelper.uploadImage(imageFile, fileName);
      }

      final postId = const Uuid().v4();

      PostModel postModel = PostModel(
        id: postId,
        userId: userModel.uid,
        username: userModel.fullName,
        userImage: userModel.image,
        text: text,
        postImage: imageUrl,
        createdAt: DateTime.now(),
        likes: [],
        comments: [],
      );

      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .set(postModel.toMap());

      await fetchPost();
    } catch (e) {
      emit(PostFailure("Failed to create post"));
    }
  }

  Future<void> fetchPost() async {
    emit(PostLoading());
    try {
      final snapshot = await servicesHelper.firestore
          .collection("posts")
          .orderBy("created_at", descending: true)
          .get();

      final posts = snapshot.docs
          .map((doc) => PostModel.fromJson(doc.data()))
          .toList();
      emit(PostLoaded(posts));
    } catch (e) {
      emit(PostFailure(e.toString()));
    }
  }

  Future<void> fetchUserPosts(String userId) async {
    emit(PostLoading());
    try {
      final snapshot = await servicesHelper.firestore
          .collection('posts')
          .where('user_id', isEqualTo: userId)
          .orderBy('created_at', descending: true)
          .get();

      final posts = snapshot.docs.map((doc) {
        return PostModel.fromJson(doc.data());
      }).toList();

      emit(PostLoaded(posts));
    } catch (e) {
      emit(PostFailure(e.toString()));
    }
  }
}
