import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/Inbox/logic/cubit/chat_cubit.dart';
import 'package:myapp/features/Inbox/ui/widget/Conversition.dart';

class ChatItem extends StatefulWidget {
  final String? dp;
  final String? name;
  final String? time;
  final String? msg;
  final bool? isOnline;
  final String chatId;
  final String senderId;
  final int unreadCount;

  const ChatItem({
    super.key,
    required this.dp,
    required this.name,
    required this.time,
    required this.msg,
    required this.isOnline,
    required this.chatId,
    required this.senderId,
    required this.unreadCount,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  FirebaseAuth currentUser = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        leading: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(0),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white,
                ),
                height: 55,
                width: 55,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider("${widget.dp}"),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0.0,
              left: 6.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                height: 13,
                width: 13,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.isOnline! ? Color(0xff651CE5) : Colors.grey,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    height: 9,
                    width: 9,
                  ),
                ),
              ),
            ),
          ],
        ),
        title: Text(
          "${widget.name}",
          maxLines: 1,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "${widget.msg}",
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 13),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            SizedBox(height: 10),
            Text(
              "${widget.time}",
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 11),
            ),
            SizedBox(height: 5),
            widget.unreadCount == 0
                ? SizedBox()
                : Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Color(0xff00d289),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(minWidth: 11, minHeight: 11),
                    child: Padding(
                      padding: EdgeInsets.only(top: 1, left: 5, right: 5),
                      child: Text(
                        "${widget.unreadCount}",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
          ],
        ),
        onTap: () {
          log("Chat tapped: ${widget.chatId}");
          context.read<ChatCubit>().markChatAsRead(
            widget.chatId,
            currentUser.currentUser!.uid,
          );

          Navigator.of(context, rootNavigator: true)
              .push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return Conversation(
                      chatId: widget.chatId,
                      senderId: widget.senderId,
                      dp: widget.dp,
                      name: widget.name,
                    );
                  },
                ),
              )
              .then((value) {
                log('Returned from conversation, refreshing chats');

                if (mounted) {
                  context.read<ChatCubit>().refreshChats(
                    currentUser.currentUser!.uid,
                  );
                }
              });
        },
      ),
    );
  }
}
