import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myapp/features/Post/logic/cubit/likes_cubit/likes_cubit.dart';
import 'package:myapp/features/home/ui/widgets/home_card.dart';

class LikeButton extends StatelessWidget {
  const LikeButton({super.key, required this.widget});

  final HomeCard widget;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LikeCubit, LikesState>(
      builder: (context, state) {
        if (state is LikesLoading || state is LikesInitial) {
          return const CircularProgressIndicator(strokeWidth: 2);
        } else if (state is LikesLoaded) {
          return GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                // ignore: deprecated_member_use
                color: Colors.white.withOpacity(0.4),
              ),
              height: 60,
              width: 60,
              child: Padding(
                padding: const EdgeInsets.all(17.0),
                child: SvgPicture.asset(
                  state.isLiked
                      ? "assets/icons/heart-shape-silhouette.svg"
                      : "assets/icons/heart-shape-outine.svg",
                  // ignore: deprecated_member_use
                  color: state.isLiked ? Color(0xff651CE5) : Color(0xffffffff),
                ),
              ),
            ),
            onTap: () async {
              await context.read<LikeCubit>().toggleLike(
                widget.postId,
                widget.user,
              );
            },
          );
        } else if (state is LikesFailure) {
          return const Text("Error loading likes");
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
