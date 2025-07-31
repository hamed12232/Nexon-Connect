import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nexon/features/Inbox/ui/widget/Conversition.dart';

class CustomChatTitleAppBar extends StatelessWidget {
  const CustomChatTitleAppBar({super.key, required this.widget});

  final Conversation widget;

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
                  backgroundImage: CachedNetworkImageProvider("${widget.dp}"),
                ),
              ),
            ),
          ),
          SizedBox(width: 20),
          Text(
            widget.name!,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,

              color: Colors.black,
            ),
          ),
          SizedBox(height: 5),
        ],
      ),
      onTap: () {},
    );
  }
}
