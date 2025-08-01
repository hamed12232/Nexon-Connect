import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nexon/features/Post/logic/cubit/comment_cubit/comment_cubit.dart';
import 'package:nexon/features/Post/ui/screen/comment_bottom_sheet_screen.dart';
import 'package:nexon/features/home/ui/widgets/custom_shader_mask.dart';
import 'package:nexon/features/home/ui/widgets/custom_side_bar_icons.dart';
import 'package:nexon/features/home/ui/widgets/like_button.dart';

class HomeCard extends StatefulWidget {
  final String? dp;
  final String? name;
  final String? des;
  final String img;
  final String? hash;
  final String postId;
  final String user;

  const HomeCard({
    super.key,
    required this.dp,
    required this.name,
    required this.des,
    required this.hash,
    required this.img,
    required this.postId,
    required this.user,
  });
  @override
  // ignore: library_private_types_in_public_api
  _HomeCardState createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Stack(
        children: [
          CustomShaderMaskImage(widget: widget),
          //Side-bar Container
          Positioned(
            right: -5,
            top: MediaQuery.of(context).size.shortestSide < 600
                ? (MediaQuery.of(context).size.width * 1.45 -
                          MediaQuery.of(context).size.width * 1.25) /
                      2
                : (MediaQuery.of(context).size.width * 1.45 -
                          MediaQuery.of(context).size.width * 0.7) /
                      2,
            child: Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.shortestSide < 600
                      ? 115
                      : 180,
                  height: MediaQuery.of(context).size.shortestSide < 600
                      ? MediaQuery.of(context).size.width * 1.25
                      : MediaQuery.of(context).size.width * 0.7,
                  child: ClipPath(
                    clipper: MyCustomClipper(),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: SvgPicture.asset(
                        "assets/icons/side-bar.svg",
                        color: Theme.of(
                          context,
                        ).colorScheme.surface.withOpacity(0.2),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  bottom: 0,
                  left: 0,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: (MediaQuery.of(context).size.width * 1.25) / 8.1,
                      bottom: (MediaQuery.of(context).size.width * 1.25) / 8.1,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        LikeButton(widget: widget),
                        InkWell(
                          onTap: () {
                            showCommentSheet(context, widget.postId);
                          },
                          child: MyCustomSideBarIcon(
                            urlimage: "assets/icons/comment-option.svg",
                          ),
                        ),

                        MyCustomSideBarIcon(
                          urlimage: "assets/icons/bookmark-black-shape.svg",
                        ),
                        MyCustomSideBarIcon(urlimage: "assets/icons/plane.svg"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(widget.dp!),
                      radius: 25,
                    ),
                    SizedBox(width: 10),
                    Text(
                      widget.name!,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  widget.des!,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "#Nexon Connect",
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void showCommentSheet(BuildContext context, String postId) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => BlocProvider(
      create: (context) => CommentCubit()..fetchComments(postId),
      child: CommentBottomSheet(postId: postId),
    ),
  );
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width * 0.64, size.height * 0.1);
    path.cubicTo(
      size.width * 0.64,
      size.height * 0.1,
      size.width * 0.38,
      size.height * 0.1,
      size.width * 0.38,
      size.height * 0.1,
    );
    path.cubicTo(
      size.width * 0.17,
      size.height * 0.1,
      0,
      size.height * 0.14,
      0,
      size.height / 5,
    );
    path.cubicTo(
      0,
      size.height / 5,
      0,
      size.height * 0.8,
      0,
      size.height * 0.8,
    );
    path.cubicTo(
      0,
      size.height * 0.86,
      size.width * 0.17,
      size.height * 0.9,
      size.width * 0.38,
      size.height * 0.9,
    );
    path.cubicTo(
      size.width * 0.38,
      size.height * 0.9,
      size.width * 0.64,
      size.height * 0.9,
      size.width * 0.64,
      size.height * 0.9,
    );
    path.cubicTo(
      size.width * 0.84,
      size.height * 0.9,
      size.width,
      size.height * 0.95,
      size.width,
      size.height,
    );
    path.cubicTo(size.width, size.height, size.width, 0, size.width, 0);
    path.cubicTo(
      size.width,
      size.height * 0.05,
      size.width * 0.84,
      size.height * 0.1,
      size.width * 0.64,
      size.height * 0.1,
    );
    path.cubicTo(
      size.width * 0.64,
      size.height * 0.1,
      size.width * 0.64,
      size.height * 0.1,
      size.width * 0.64,
      size.height * 0.1,
    );
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
