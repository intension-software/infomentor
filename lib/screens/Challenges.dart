import 'package:flutter/material.dart';
import 'package:infomentor/screens/Test.dart';
import 'package:infomentor/widgets/ReWidgets.dart';

class Challenges extends StatefulWidget {
  const Challenges({super.key});

  @override
  State<Challenges> createState() => _ChallengesState();
}

class _ChallengesState extends State<Challenges> {
  bool isOverlayVisible = false;
  late OverlayEntry overlayEntry;

  void toggleOverlayVisibility() {
    setState(() {
      isOverlayVisible = !isOverlayVisible;
    });
    if (isOverlayVisible) {
      overlayEntry = createOverlayEntry();
      Overlay.of(context)!.insert(overlayEntry);
    } else {
      overlayEntry.remove();
    }
  }

  OverlayEntry createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Positioned.fill(
        child: Test(testId: "test", overlay: toggleOverlayVisibility),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: reButton(context, "TEST 0", 0xff4b4fb3, 0xffffffff, 0xffffffff, toggleOverlayVisibility)
      ),
    );
  }
}
