import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:myapp/features/Inbox/logic/cubit/chat_cubit.dart';
import 'package:myapp/features/Inbox/ui/widget/Chat_bubble.dart';

class Conversation extends StatefulWidget {
  final String? dp, name;
  final String chatId;
  final String senderId;

  const Conversation({
    super.key,
    required this.dp,
    required this.name,
    required this.chatId,
    required this.senderId,
  });
  @override
  // ignore: library_private_types_in_public_api
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  final TextEditingController _textController = TextEditingController();
  FirebaseAuth currentUser = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 3,
          leading: GestureDetector(
            onTap: () {
              context.read<ChatCubit>().loadChats(currentUser.currentUser!.uid);
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SvgPicture.asset(
                "assets/icons/back-arrow.svg",
                color: Colors.black,
              ),
            ),
          ),
          titleSpacing: 0,
          backgroundColor: Colors.white,
          title: InkWell(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                    ),
                    height: 45,
                    width: 45,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                          "${widget.dp}",
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.name!,
                        style: TextStyle(
                           fontSize: 19,
                                fontWeight: FontWeight.w700,
                         
                          color: Colors.black,
                         
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Online",
                        style: TextStyle(
                          color: Color(0xff651CE5),
                          fontWeight: FontWeight.w400,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () {},
          ),
          actions: <Widget>[
            SvgPicture.asset("assets/icons/dots.svg", height: 5),
            SizedBox(width: 20),
          ],
        ),
        body: Stack(
          children: [
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
              child: Image.asset("assets/images/background.png",fit: BoxFit.fill,)),
            Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: context.read<ChatCubit>().getMessages(
                      widget.chatId,
                    ),
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

                      return Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          itemCount: messages.length,
                          reverse: true,
                          itemBuilder: (context, index) {
                            final messageData =
                                messages[messages.length - 1 - index].data()
                                    as Map<String, dynamic>?;

                            //       messageData['senderId'] == widget.senderId,
                            //   textStyle: TextStyle(
                            //     color:
                            //         messageData['senderId'] == widget.senderId
                            //             ? Colors.white
                            //             : Colors.black,
                            return ChatBubble(
                              message: messageData!['text'] ?? '',
                              time: DateFormat('hh:mm a').format((messageData['timestamp'] as Timestamp).toDate()),
                              isMe: messageData['senderId'] == widget.senderId,

                              type: "text",
                              replyText: "",
                              isReply: false,
                              replyName: "",
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: BottomAppBar(
                    elevation: 10,
                    color: Theme.of(context).primaryColor,
                    child: Container(
                      constraints: BoxConstraints(maxHeight: 100),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.attach_file,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            onPressed: () {},
                          ),
                          Flexible(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(
                                  30,
                                ), // ده المهم عشان الكيرف
                              ),
                              child: TextField(
                                controller: _textController,
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color:
                                      Theme.of(
                                        context,
                                      ).textTheme.titleLarge!.color,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10.0),
                                  enabledBorder: InputBorder.none,
                                  border: InputBorder.none,

                                  hintText: "Write your message...",
                                  hintStyle: TextStyle(
                                    fontSize: 15.0,
                                    color:
                                        Theme.of(
                                          context,
                                        ).textTheme.titleLarge!.color,
                                  ),
                                ),
                                maxLines: null,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF8E2DE2),
                                    Color(0xFF4A00E0),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Icon(Icons.send, color: Colors.white),
                            ),
                            onPressed: () {
                              if (_textController.text.trim().isNotEmpty) {
                                context.read<ChatCubit>().sendMessage(
                                  chatId: widget.chatId,
                                  senderId: widget.senderId,
                                  text: _textController.text.trim(),
                                );
                                _textController.clear();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Color(0xfff1f5f9),
      ),
    );
  }
}
