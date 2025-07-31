import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:nexon/features/Inbox/logic/cubit/chat_cubit.dart';
import 'package:nexon/features/Inbox/ui/widget/Chat_bubble.dart';
import 'package:nexon/features/Inbox/ui/widget/Conversition.dart';

class CustomChatStreamBuilder extends StatelessWidget {
  const CustomChatStreamBuilder({
    super.key,
    required this.widget,
    required this.currentUser,
  });

  final Conversation widget;
  final FirebaseAuth currentUser;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: context.read<ChatCubit>().getMessages(widget.chatId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: SvgPicture.asset(
                "assets/images/Voice chat-amico.svg",
                fit: BoxFit.scaleDown,
              ),
            );
          }

          final messages = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 10),
            itemCount: messages.length,
            reverse: true,
            itemBuilder: (context, index) {
              final messageData =
                  messages[messages.length - 1 - index].data()
                      as Map<String, dynamic>?;

              return ChatBubble(
                message: messageData!['text'] ?? '',
                time: DateFormat(
                  'hh:mm a',
                ).format((messageData['timestamp'] as Timestamp).toDate()),
                isMe: messageData['senderId'] == currentUser.currentUser!.uid,
                type: "text",
                replyText: "",
                pathRecord: messageData['audioUrl'],
                isReply: false,
                replyName: "",
              );
            },
          );
        },
      ),
    );
  }
}
