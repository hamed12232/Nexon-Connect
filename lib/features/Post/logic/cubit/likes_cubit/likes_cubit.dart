// like_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
part 'likes_state.dart';

class LikeCubit extends Cubit<LikesState> {
  LikeCubit() : super(LikesInitial());

  Future<void> loadLikes(String postId, String uid) async {
    emit(LikesLoading());
    try {
      final doc =
          await FirebaseFirestore.instance
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
    final likes = List<String>.from(snapshot['likes']);

    final isLikedNow = !likes.contains(uid);
    emit(LikesLoaded(likes.length,isLikedNow ));

    if (isLikedNow) {
      likes.add(uid);
    } else {
      likes.remove(uid);
    }

    await doc.update({ 'likes': likes,
      'likesCount': likes.length,});
  } catch (e) {
    emit(LikesFailure("Something went wrong"));
  }
}

}
