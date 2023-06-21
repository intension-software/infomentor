import 'package:flutter/material.dart';
import 'package:infomentor/widgets/ReWidgets.dart';
import 'package:infomentor/screens/Test.dart';


class Challenges extends StatefulWidget {
  const Challenges({super.key});

  @override
  State<Challenges> createState() => _ChallengesState();
}

class _ChallengesState extends State<Challenges> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child:  Test(),
    );
  }
}