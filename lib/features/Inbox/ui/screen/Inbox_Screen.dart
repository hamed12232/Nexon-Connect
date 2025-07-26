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
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    // Load user data
    final user = await ServicesHelper().getUser(currentUser.currentUser!.uid);
    if (mounted) {
      setState(() {
        userModel = user;
      });
    }

    // Load chats with real-time listening
    if (mounted) {
      context.read<ChatCubit>().loadChats(currentUser.currentUser!.uid);
    }
  }

  @override
  void dispose() {
    super.dispose();
    context.read<ChatCubit>().close();
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
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.surface,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              builder: (_) => BlocProvider(
                                create: (context) => FollowCubit()
                                  ..loadSuggestedUsers(
                                    currentUser.currentUser!.uid,
                                  ),
                                child: Showfriendsbottomsheet(
                                  user1: currentUser.currentUser!.uid,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
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
                  child: BlocConsumer<ChatCubit, ChatState>(
                    listenWhen: (previous, current) =>
                        previous is ChatCreated &&
                        current is ChatCreated &&
                        previous.chats != current.chats,
                    listener: (context, state) {
                      // Handle any side effects here if needed
                      if (state is ChatError) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(state.error)));
                      }
                    },
                    builder: (context, state) {
                      if (state is ChatLoading) {
                        return Skeletonizer(
                          enabled: true,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(20),
                            itemCount: 6,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Container(
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).dividerColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        );
                      } else if (state is ChatError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Error: ${state.error}"),
                              SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  context.read<ChatCubit>().loadChats(
                                    currentUser.currentUser!.uid,
                                  );
                                },
                                child: Text("Retry"),
                              ),
                            ],
                          ),
                        );
                      } else if (state is ChatCreated) {
                        if (state.chats.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/images/Group Chat-amico.svg",
                                  fit: BoxFit.scaleDown,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  "No conversations yet",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return ChatsListView(
                            chats: state.chats,
                            isOnline: userModel?.online ?? false,
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
