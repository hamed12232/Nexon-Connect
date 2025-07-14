import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:myapp/core/Components/Custom_NavBar.dart';
import 'package:myapp/core/Components/enums.dart';
import 'package:myapp/features/Inbox/logic/cubit/chat_cubit.dart';
import 'package:myapp/features/Inbox/logic/models/chat_model.dart';
import 'package:myapp/features/Inbox/ui/widget/Chat_item.dart';
import 'package:myapp/features/Inbox/ui/widget/showFriendsBottomSheet.dart';
import 'package:myapp/features/discover/logic/cubit/follow_cubit.dart';
import 'package:myapp/features/profile/logic/user_model.dart';

class InboxScreen extends StatefulWidget {
  static const String routeName = "/inbox";

  const InboxScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<InboxScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  FirebaseAuth currentUser = FirebaseAuth.instance;
  @override
  void initState() {
    context.read<ChatCubit>().loadChats(currentUser.currentUser!.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              useSafeArea: true,
                              isScrollControlled: true,
                              backgroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              builder:
                                  (_) => BlocProvider(
                                    create:
                                        (context) =>
                                            FollowCubit()..loadSuggestedUsers(
                                              currentUser.currentUser!.uid,
                                            ),
                                    child: Showfriendsbottomsheet(
                                      user1: currentUser.currentUser!.uid,
                                    ),
                                  ),
                            );
                            // context.read<ChatCubit>().createChat(currentUser.currentUser!.uid, "QYn9zhHJH8drNneWtjnp1nczcOl2");
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(
                                    0,
                                    3,
                                  ), // changes position of shadow
                                ),
                              ],
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white,
                            ),
                            height: 55,
                            width: 55,
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xff651CE5),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Icon(Icons.add, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 18),
                      Text(
                        "Start Conversation",
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: BlocBuilder<ChatCubit, ChatState>(
                    builder: (context, state) {
                      if (state is ChatLoading) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is ChatError) {
                        return Center(child: Text(state.error));
                      } else if (state is ChatCreated) {
                        if (state.chats.isEmpty) {
                          return Center(child: Text("Tap To Add Chats"));
                        } else {
                          return ListView.builder(
                            padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                            itemCount: state.chats.length,
                            itemBuilder: (BuildContext context, int index) {
                              final chat =
                                  state.chats[index]["chat"] as ChatModel;
                              final otherUser =
                                  state.chats[index]["otherUser"] as UserModel;

                              return ChatItem(
                                dp: otherUser.image,
                                name: otherUser.fullName,
                                isOnline: chat.isActive,
                                counter: 1,
                                msg: chat.lastMessage,
                                time: DateFormat(
                                  'hh:mm a',
                                ).format(chat.lastTime),
                              );
                            },
                          );
                        }
                      } else {
                        return Center(child: Text("Something went wrong"));
                      }
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              child: CustomNavBar(selectedMenu: MenuState.inbox),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
