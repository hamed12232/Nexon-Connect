import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nexon/features/home/ui/widgets/fullScreenImage.dart';
import 'package:nexon/features/home/ui/widgets/home_card.dart';

class CustomShaderMaskImage extends StatelessWidget {
  const CustomShaderMaskImage({super.key, required this.widget});

  final HomeCard widget;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(35.0)),
      child: ShaderMask(
        shaderCallback: (rect) {
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Theme.of(context).colorScheme.background.withOpacity(0.6),
            ],
          ).createShader(Rect.fromLTRB(0, 300, rect.width, rect.height - 1));
        },
        blendMode: BlendMode.darken,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FullScreenImage(imagePath: widget.img),
              ),
            );
          },
          child: Container(
            height: MediaQuery.of(context).size.width * 1.45,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(widget.img),
              ),
              borderRadius: BorderRadius.circular(35),
            ),
          ),
        ),
      ),
    );
  }
}
