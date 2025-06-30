import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/features/profile/logic/user_model.dart';

part 'friends_state.dart';

class FriendCubit extends Cubit<FriendState> {
  FriendCubit() : super(FriendInitial());
    final currentUser = FirebaseAuth.instance.currentUser!;

  Future<void> fetchAllUsers() async {
    emit(FriendLoading());
    final currentUser = FirebaseAuth.instance.currentUser;

    try {
      final snapshot = await FirebaseFirestore.instance.collection("users").get();
      List<UserModel> allUsers = [];

      for (var doc in snapshot.docs) {
        if (doc.id == currentUser!.uid) continue;

        final userData = UserModel.fromMap(doc.data(),doc.id);
        allUsers.add(userData);
      }

      // تحميل بيانات المستخدم الحالي
      final currentDoc = await FirebaseFirestore.instance.collection("users").doc(currentUser!.uid).get();
      final currentUserData = UserModel.fromMap(currentDoc.data()!,currentDoc.id);
      final currentFollowing = currentUserData.following;

      emit(FriendLoaded(allUsers: allUsers, currentUser: currentUserData));
    } catch (e) {
      emit(FriendFailure("Failed to fetch users"));
    }
  }

  Future<void> toggleFollow(UserModel targetUser) async {
    final userRef = FirebaseFirestore.instance.collection("users");

    try {
      final currentSnapshot = await userRef.doc(currentUser.uid).get();
      final currentUserData = UserModel.fromMap(currentSnapshot.data()!,currentUser.uid);
      final isFollowing = await _isFollowing(currentUserData.uid, targetUser.uid);

      if (isFollowing) {
        // Unfollow
        await userRef.doc(currentUser.uid).update({
          'following': FieldValue.increment(-1),
        });
        await userRef.doc(targetUser.uid).update({
          'followers': FieldValue.increment(-1),
        });
      } else {
        // Follow
        await userRef.doc(currentUser.uid).update({
          'following': FieldValue.increment(1),
        });
        await userRef.doc(targetUser.uid).update({
          'followers': FieldValue.increment(1),
        });
      }

      fetchAllUsers(); // تحديث الحالة
    } catch (e) {
      emit(FriendFailure("Follow/Unfollow failed"));
    }
  }

  Future<bool> _isFollowing(String currentUserId, String targetUserId) async {
    final postRef = FirebaseFirestore.instance.collection("users");
    final currentSnapshot = await postRef.doc(currentUserId).get();
    final currentData = UserModel.fromMap(currentSnapshot.data()!,currentSnapshot.id);

    // ممكن تخزن following IDs في array في المستقبل، هنا نستخدم العدد فقط
    return false; // حاليا نرجع false دائمًا
  }
}
