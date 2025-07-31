import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexon/core/helper/services_helper.dart';
import 'package:nexon/features/Post/logic/cubit/comment_cubit/comment_cubit.dart';
import 'package:nexon/features/Post/logic/model/comment_model.dart';

class CommentBottomSheet extends StatefulWidget {
  final String postId;

  const CommentBottomSheet({super.key, required this.postId});

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              "Comments",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Expanded(
              child: BlocBuilder<CommentCubit, CommentState>(
                builder: (context, state) {
                  if (state is CommentLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CommentLoaded) {
                    return ListView.builder(
                      itemCount: state.comments.length,
                      itemBuilder: (context, index) {
                        final comment = state.comments[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(comment.userImage),
                          ),
                          title: Text(comment.username),
                          subtitle: Text(comment.text),
                        );
                      },
                    );
                  } else if (state is CommentFailure) {
                    return Center(child: Text(state.error));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,

                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: "Add a comment...",
                          //   border: InputBorder.none,
                        ),
                        onSubmitted: (value) {
                          _sendComment();
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Color(0xff651CE5)),
                      onPressed: _sendComment,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendComment() async {
    if (_controller.text.trim().isEmpty) return;
    final userModel = await ServicesHelper().getUser(user.uid);
    final newComment = CommentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userModel.uid,
      username: userModel.fullName,
      userImage: userModel.image,
      text: _controller.text.trim(),
      createdAt: DateTime.now(),
    );
    context.read<CommentCubit>().addComment(widget.postId, newComment);
    _controller.clear();
  }
}
