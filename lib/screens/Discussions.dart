import 'package:flutter/material.dart';
import 'package:infomentor/backend/fetchUser.dart';
import 'package:infomentor/screens/DesktopDiscussions.dart';
import 'package:infomentor/screens/MobileDiscussions.dart';




class Discussions extends StatefulWidget {
  final UserData? currentUserData;


  Discussions({
    Key? key,
    required this.currentUserData,
  }) : super(key: key);

  @override
  _DiscussionsState createState() => _DiscussionsState();
}

class _DiscussionsState extends State<Discussions> {
  @override
  void initState() {
    super.initState();
  }


  

  @override
  void dispose() {
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
    return Container(
      child: 
        MediaQuery.of(context).size.width < 1000 ? MobileDiscussions(currentUserData: widget.currentUserData,) : DesktopDiscussions(currentUserData: widget.currentUserData)
    );
  }
}
