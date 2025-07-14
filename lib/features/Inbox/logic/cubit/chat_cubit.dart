import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/helper/services_helper.dart';
import 'package:myapp/features/Inbox/logic/models/chat_model.dart';
import 'package:uuid/uuid.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createChat(String user1Id, String user2Id) async {
    try {
      final snapshot =
          await _firestore
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

  Future<void> loadChats(String userId) async {
    emit(ChatLoading());
    try {
      final snapshot =
          await _firestore
              .collection("chats")
              .where("users", arrayContains: userId)
              .get();

      List<Map<String, dynamic>> chatsWithUsers = [];

      for (var doc in snapshot.docs) {
        final chat = ChatModel.fromJson(doc.data());
        final otherUserId = chat.users.firstWhere((id) => id != userId);

        final otherUser = await ServicesHelper().getUser(otherUserId);

        chatsWithUsers.add({"chat": chat, "otherUser": otherUser});
      }

      emit(ChatCreated(chatsWithUsers));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> createChatAndLoad(String user1Id, String user2Id) async {
    await createChat(user1Id, user2Id);
    await loadChats(user1Id);
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
      final messageDoc =
          _firestore
              .collection("chats")
              .doc(chatId)
              .collection("messages")
              .doc();

      await messageDoc.set({
        "id": messageDoc.id,
        "senderId": senderId,
        "text": text,
        "timestamp": FieldValue.serverTimestamp(),
        "repliedToMessageId": repliedToMessageId ?? "",
        "repliedToText": repliedToText ?? "",
        "repliedToSenderId": repliedToSenderId ?? "",
      });

      await _firestore.collection("chats").doc(chatId).update({
        "lastMessage": text,
        "lastTime": FieldValue.serverTimestamp(),
      });

      emit(MessageSent());
    } catch (e) {
      emit(ChatError(e.toString()));
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
}
