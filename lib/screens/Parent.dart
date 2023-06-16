import 'package:flutter/material.dart';
import 'package:infomentor/widgets/ReWidgets.dart';

class Parent extends StatefulWidget {
  const Parent({super.key});

  @override
  State<Parent> createState() => _ParentState();
}

class _ParentState extends State<Parent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    bottomNavigationBar: reBottomNavigation(),
    body: Container(),
    );
  }
}
