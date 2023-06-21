import 'package:flutter/material.dart';
import 'package:infomentor/widgets/ReWidgets.dart';

class Discussions extends StatefulWidget {
  const Discussions({super.key});

  @override
  State<Discussions> createState() => _DiscussionsState();
}

class _DiscussionsState extends State<Discussions> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('discussions'),
    );
  }
}