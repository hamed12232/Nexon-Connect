import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/Components/firebase_notification.dart';
import 'package:myapp/core/helper/services_helper.dart';
import 'package:myapp/features/Inbox/logic/models/chat_model.dart';
import 'package:uuid/uuid.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  final _firestore = ServicesHelper().firestore;
  StreamSubscription<QuerySnapshot>? _chatsSubscription;

  @override
  Future<void> close() {
    _chatsSubscription?.cancel();
    return super.close();
  }

  Future<void> createChat(String user1Id, String user2Id) async {
    try {
      final snapshot = await _firestore
          .collection("chats")
          .where("users", arrayContains: user1Id)
          .get();

      ChatModel? existingChat;

      for (var doc in snapshot.docs) {
        List users = doc['users'];
        if (users.contains(user2Id)) {
          existingChat = ChatModel.fromJson(doc.data());
          break;
        }
      }

      final otherUser = await ServicesHelper().getUser(user2Id);

      if (existingChat != null) {
        emit(
          ChatCreated([
            {"chat": existingChat, "otherUser": otherUser},
          ]),
        );
      } else {
        final chatModel = ChatModel(
          chatId: Uuid().v4(),
          users: [user1Id, user2Id],
          senderName: otherUser.fullName,
          senderImage: otherUser.image,
          lastMessage: "",
          lastTime: DateTime.now(),
          isActive: false,
        );

        await _firestore
            .collection("chats")
            .doc(chatModel.chatId)
            .set(chatModel.toJson());

        emit(
          ChatCreated([
            {"chat": chatModel, "otherUser": otherUser},
          ]),
        );
      }
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  // Updated method to listen to real-time changes
  Future<void> loadChats(String userId) async {
    emit(ChatLoading());

    try {
      // Cancel existing subscription if any
      await _chatsSubscription?.cancel();

      // Listen to real-time changes
      _chatsSubscription = _firestore
          .collection("chats")
          .where("users", arrayContains: userId)
          .orderBy("lastTime", descending: true)
          .snapshots()
          .listen((snapshot) async {
            try {
              List<Future<Map<String, dynamic>>> futures = [];

              for (var doc in snapshot.docs) {
                futures.add(() async {
                  final chat = ChatModel.fromJson(doc.data());
                  final otherUserId = chat.users.firstWhere(
                    (id) => id != userId,
                  );
                  final otherUser = await ServicesHelper().getUser(otherUserId);
                  final unreadCount = await _calculateUnreadCount(
                    chat.chatId,
                    userId,
                  );

                  final updatedChat = ChatModel(
                    chatId: chat.chatId,
                    users: chat.users,
                    senderName: chat.senderName,
                    senderImage: chat.senderImage,
                    lastMessage: chat.lastMessage,
                    lastTime: chat.lastTime,
                    isActive: chat.isActive,
                    unreadCount: unreadCount,
                  );

                  return {"chat": updatedChat, "otherUser": otherUser};
                }());
              }

              final chatsWithUsers = await Future.wait(futures);
              emit(ChatCreated(chatsWithUsers));
            } catch (e) {
              emit(ChatError(e.toString()));
            }
          });
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<int> _calculateUnreadCount(String chatId, String currentUserId) async {
    try {
      final messagesSnapshot = await _firestore
          .collection("chats")
          .doc(chatId)
          .collection("messages")
          .where(
            "senderId",
            isNotEqualTo: currentUserId,
          ) // Messages not from current user
          .where("isRead", isEqualTo: false) // That are unread
          .get();

      return messagesSnapshot.docs.length;
    } catch (e) {
      return 0;
    }
  }

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
    String? repliedToMessageId,
    String? repliedToText,
    String? repliedToSenderId,
  }) async {
    try {
      // 1. إرسال الرسالة
      final messageDoc = _firestore
          .collection("chats")
          .doc(chatId)
          .collection("messages")
          .doc();

      await messageDoc.set({
        "id": messageDoc.id,
        "senderId": senderId,
        "text": text,
        "timestamp": DateTime.now(),
        "repliedToMessageId": repliedToMessageId ?? "",
        "repliedToText": repliedToText ?? "",
        "repliedToSenderId": repliedToSenderId ?? "",
        "isRead": false,
      });

      // 2. تحديث معلومات المحادثة
      await _firestore.collection("chats").doc(chatId).update({
        "lastMessage": text,
        "lastTime": DateTime.now(),
      });

      // 3. إرسال الإشعار
      await _sendNotificationIfNeeded(chatId, senderId, text);

      emit(MessageSent());
    } catch (e) {
      log("Error sending message: $e");
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _sendNotificationIfNeeded(
    String chatId,
    String senderId,
    String messageText,
  ) async {
    try {
      // الحصول على معرف المستخدم الآخر
      final chatDoc = await _firestore.collection("chats").doc(chatId).get();
      final otherUserId = chatDoc['users'].firstWhere((id) => id != senderId);

      // التحقق من وجود رسائل غير مقروءة من المرسل
      final unreadCount = await _firestore
          .collection("chats")
          .doc(chatId)
          .collection("messages")
          .where("senderId", isEqualTo: senderId)
          .where("isRead", isEqualTo: false)
          .get();

      // إرسال إشعار فقط للرسالة الأولى غير المقروءة
      if (unreadCount.docs.length == 1) {
        await _sendPushNotification(otherUserId, messageText);
      }
    } catch (e) {
      log("Error checking notification: $e");
    }
  }

  Future<void> _sendPushNotification(String userId, String messageText) async {
    try {
      final userDoc = await _firestore.collection("users").doc(userId).get();

      if (!userDoc.exists) return;

      final userData = userDoc.data() as Map<String, dynamic>;
      final fcmToken = userData['fcmToken'];
      final userName = userData['fullName'] ?? 'Someone';

      if (fcmToken != null && fcmToken.toString().isNotEmpty) {
        await FirebaseNotification().sendPushNotification(
          deviceToken: fcmToken,
          title: "New message from $userName",
          bodye: messageText,
        );
        log("Notification sent successfully");
      }
    } catch (e) {
      log("Error sending notification: $e");
    }
  }

  Stream<QuerySnapshot> getMessages(String chatId) {
    return _firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  Future<void> markChatAsRead(String chatId, String currentUserId) async {
    try {
      // Get all unread messages in this chat that are not from current user
      final unreadMessages = await _firestore
          .collection("chats")
          .doc(chatId)
          .collection("messages")
          .where("senderId", isNotEqualTo: currentUserId)
          .where("isRead", isEqualTo: false)
          .get();

      // Mark all as read in a batch
      final batch = _firestore.batch();
      for (var doc in unreadMessages.docs) {
        batch.update(doc.reference, {"isRead": true});
      }

      if (unreadMessages.docs.isNotEmpty) {
        await batch.commit();
      }
    } catch (e) {
      log("Error marking chat as read: $e");
    }
  }

  Future<void> refreshChats(String userId) async {
    await loadChats(userId);
  }
}
