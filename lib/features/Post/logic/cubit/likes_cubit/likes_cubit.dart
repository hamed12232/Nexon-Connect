import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
part 'likes_state.dart';

class LikeCubit extends Cubit<LikesState> {
  LikeCubit() : super(LikesInitial());

  Future<void> loadLikes(String postId, String uid) async {
    emit(LikesLoading());
    try {
      final doc = await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .get();
      final likes = List<String>.from(doc['likes'] ?? []);
      final isLiked = likes.contains(uid);
      emit(LikesLoaded(likes.length, isLiked));
    } catch (e) {
      emit(LikesFailure("Failed to load likes"));
    }
  }

  Future<void> toggleLike(String postId, String uid) async {
    try {
      final doc = FirebaseFirestore.instance.collection('posts').doc(postId);
      final snapshot = await doc.get();
      final likes = List<String>.from(snapshot['likes'] ?? []);

      bool isLikedNow;

      if (likes.contains(uid)) {
        likes.remove(uid);
        isLikedNow = false;
      } else {
        likes.add(uid);
        isLikedNow = true;
      }

      // حدّث الداتا في Firestore
      await doc.update({
        'likes': likes,
        'likesCount': likes.length, 
      });

      emit(LikesLoaded(likes.length, isLikedNow));
    } catch (e) {
      emit(LikesFailure("Something went wrong"));
    }
  }
}
