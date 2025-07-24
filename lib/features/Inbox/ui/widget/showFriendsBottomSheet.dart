import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myapp/features/Inbox/logic/cubit/chat_cubit.dart';
import 'package:myapp/features/discover/logic/cubit/follow_cubit.dart';

class Showfriendsbottomsheet extends StatelessWidget {
  const Showfriendsbottomsheet({super.key, required this.user1});
  final String user1;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        const Text(
          "Friends",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const Divider(),
        Expanded(
          child: BlocBuilder<FollowCubit, FollowState>(
            builder: (context, state) {
              if (state is FollowLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is FollowFailure) {
                return Center(
                  child: Text(
                    state.error,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              } else if (state is FollowLoaded) {
                if (state.users.isEmpty) {
                  return Center(
                    child: Text(
                      "No Friends found",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                  itemCount: state.users.length,
                  itemBuilder: (BuildContext context, int index) {
                    final user = state.users[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                          user['image'],
                        ),
                      ),
                      title: Text(
                        user['fullName'],
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      subtitle: Text(
                        "Tap To Message",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      trailing: GestureDetector(
                        onTap: () async {
                          await context.read<ChatCubit>().createChatAndLoad(
                            user1,
                            user.id,
                          );

                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.secondary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: SvgPicture.asset(
                              "assets/icons/mail-outline.svg",
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
              return Center(
                child: Text(
                  "Something went wrong",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
