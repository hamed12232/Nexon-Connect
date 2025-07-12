import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/Components/firebase_local_notification.dart';
part 'follow_state.dart';

class FollowCubit extends Cubit<FollowState> {
  FollowCubit() : super(FollowInitial());

  final _firestore = FirebaseFirestore.instance;

  Future<void> toggleFollow(String currentUserId, String targetUserId) async {
    try {
      final currentUserDoc = _firestore.collection("users").doc(currentUserId);
      final targetUserDoc = _firestore.collection("users").doc(targetUserId);
      final targetUserSnapshot = await targetUserDoc.get();
      final currentUserSnapshot = await currentUserDoc.get();
      final following = List<String>.from(
        currentUserSnapshot['following'] ?? [],
      );

      final isFollowing = following.contains(targetUserId);

      if (isFollowing) {
        // Unfollow
        await currentUserDoc.update({
          "following": FieldValue.arrayRemove([targetUserId]),
        });
        await targetUserDoc.update({
          "followers": FieldValue.arrayRemove([currentUserId]),
        });
      } else {
        // Follow
        await currentUserDoc.update({
          "following": FieldValue.arrayUnion([targetUserId]),
        });
        await targetUserDoc.update({
          "followers": FieldValue.arrayUnion([currentUserId]),
        });
        await FirebaseLocalNotification().sendPushNotification(
          deviceToken: targetUserSnapshot['fcmToken'] ?? "null",
          follower: currentUserSnapshot["fullName"],
        );
      }

      await loadSuggestedUsers(currentUserId);
    } catch (e) {
      log(e.toString());
      emit(FollowFailure(e.toString()));
    }
  }

  Future<void> loadSuggestedUsers(String currentUserId) async {
    emit(FollowLoading());
    try {
      final usersSnapshot = await _firestore.collection("users").get();
      final currentUser = usersSnapshot.docs.firstWhere(
        (doc) => doc.id == currentUserId,
      );
      final following = List<String>.from(currentUser['following'] ?? []);

      final suggestedUsers =
          usersSnapshot.docs.where((doc) => doc.id != currentUserId).toList();

      emit(FollowLoaded(users: suggestedUsers, following: following));
    } catch (e) {
      print(e.toString());
      emit(FollowFailure("Failed to load users"));
    }
  }
}
