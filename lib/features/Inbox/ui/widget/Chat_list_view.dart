import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/features/Inbox/logic/models/chat_model.dart';
import 'package:myapp/features/Inbox/ui/widget/Chat_item.dart';
import 'package:myapp/features/profile/logic/user_model.dart';

class ChatsListView extends StatelessWidget {
  const ChatsListView({super.key, required this.chats, required this.isOnline});
  final List<Map<String, dynamic>> chats;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
      itemCount: chats.length,
      itemBuilder: (BuildContext context, int index) {
        final chat = chats[index]["chat"] as ChatModel;
        final otherUser = chats[index]["otherUser"] as UserModel;

        return ChatItem(
          chatId: chat.chatId,
          senderId: otherUser.uid,
          dp: otherUser.image,
          name: otherUser.fullName,
          isOnline: isOnline,
          counter: 1,
          msg: chat.lastMessage,
          time: DateFormat('hh:mm a').format(chat.lastTime),
        );
      },
    );
  }
}
