import 'package:flutter/material.dart';
import 'package:nexon/core/Components/bubble_indication_painter.dart';

class BuildMenuBar extends StatelessWidget {
  const BuildMenuBar({
    super.key,
    required this.pageController,
    this.onSignInButtonPress,
    this.onSignUpButtonPress,
  });
  final PageController pageController;
  final Color left = Colors.black;
  final Color right = Colors.white;
  final void Function()? onSignInButtonPress;
  final void Function()? onSignUpButtonPress;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.0,
      height: 50.0,
      decoration: BoxDecoration(
        color: Color(0x552B2B2B),
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: CustomPaint(
        painter: TabIndicationPainter(pageController: pageController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                ),
                onPressed: onSignInButtonPress,
                child: Text(
                  "Existing",
                  style: TextStyle(
                    color: left,
                    fontSize: 16.0,
                    fontFamily: "WorkSansSemiBold",
                  ),
                ),
              ),
            ),
            //Container(height: 33.0, width: 1.0, color: Colors.white),
            Expanded(
              child: TextButton(
                style: TextButton.styleFrom(
                  splashFactory: NoSplash.splashFactory, // يمنع splash
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.black,
                ),
                onPressed: onSignUpButtonPress,
                child: Text(
                  "New",
                  style: TextStyle(
                    color: left,
                    fontSize: 16.0,
                    fontFamily: "WorkSansSemiBold",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
