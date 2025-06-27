import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MyCustomSideBarIcon extends StatelessWidget {
  const MyCustomSideBarIcon({super.key, this.urlimage});
  final urlimage;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          urlimage,
          // ignore: deprecated_member_use
          color: Color(0xffffffff),
        ),
      ),
    );
  }
}
