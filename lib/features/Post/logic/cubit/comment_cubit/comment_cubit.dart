// comment_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nexon/features/Post/logic/model/comment_model.dart';
part 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  CommentCubit() : super(CommentInitial());

  Future<void> fetchComments(String postId) async {
    emit(CommentLoading());
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .orderBy('createdAt', descending: true)
          .get();

      final comments = snapshot.docs
          .map((doc) => CommentModel.fromMap(doc.data()))
          .toList();

      emit(CommentLoaded(comments));
    } catch (e) {
      emit(CommentFailure("Failed to load comments"));
    }
  }

  Future<void> addComment(String postId, CommentModel comment) async {
    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(comment.id)
          .set(comment.toMap());

      fetchComments(postId);
    } catch (e) {
      emit(CommentFailure("Failed to add comment"));
    }
  }
}
