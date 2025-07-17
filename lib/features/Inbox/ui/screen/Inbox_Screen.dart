import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myapp/core/Components/Custom_NavBar.dart';
import 'package:myapp/core/Components/enums.dart';
import 'package:myapp/core/helper/services_helper.dart';
import 'package:myapp/features/Inbox/logic/cubit/chat_cubit.dart';
import 'package:myapp/features/Inbox/ui/widget/Chat_list_view.dart';
import 'package:myapp/features/Inbox/ui/widget/showFriendsBottomSheet.dart';
import 'package:myapp/features/discover/logic/cubit/follow_cubit.dart';
import 'package:myapp/features/profile/logic/user_model.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
    user().then((value) {
      setState(() {
        userModel = value;
      });
    });
    super.initState();
  }

  Future<UserModel> user() async {
    return await ServicesHelper().getUser(currentUser.currentUser!.uid);
  }

  UserModel? userModel;
  @override
 
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
                                  // ignore: deprecated_member_use
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
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: BlocBuilder<ChatCubit, ChatState>(
                    builder: (context, state) {
                      if (state is ChatLoading) {
                        return Skeletonizer(
                          enabled: true,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(20),
                            itemCount: 6,
                            itemBuilder:
                                (context, index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Container(
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                          ),
                        );
                      } else if (state is ChatError) {
                        return Center(child: Text(state.error));
                      } else if (state is ChatCreated) {
                        if (state.chats.isEmpty) {
                          return SvgPicture.asset(
                            "assets/images/Group Chat-amico.svg",
                            fit: BoxFit.scaleDown,
                          );
                        } else {
                          return ChatsListView(chats: state.chats, isOnline: userModel!.online);
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
