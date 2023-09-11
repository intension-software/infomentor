import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infomentor/backend/fetchClass.dart';
import 'package:infomentor/backend/fetchUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async'; // Add this import statement
import 'package:infomentor/Colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infomentor/widgets/ReWidgets.dart';


class CommentsAnswers extends StatefulWidget {
  final Stream<List<CommentsAnswersData>> fetchAnswersStream;
  final UserData currentUserData;
  final String postId;
  final int? commentIndex;
  void Function(bool, int, String) setEdit;

  CommentsAnswers({
    Key? key,
    required this.fetchAnswersStream,
    required this.setEdit,
    required this.currentUserData,
    required this.commentIndex,
    required this.postId
  }) : super(key: key);

  @override
  State<CommentsAnswers> createState() => _CommentsAnswersState();
}

class _CommentsAnswersState extends State<CommentsAnswers> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CommentsAnswersData>>(
      stream: widget.fetchAnswersStream, // Replace with your stream to fetch answers for the selected comment
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<CommentsAnswersData> answers = snapshot.data!;
          return Container(
            width: 900, // set the maximum width to 900
            height: MediaQuery.of(context).size.height,  // or you can set a specific height
            child: ListView.builder(
              itemCount: answers.length,
              itemBuilder: (context, index) {
                CommentsAnswersData answer = answers[index];
                return Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: AppColors.getColor('mono').lightGrey),
                  ),
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 16.0),
                            child: SvgPicture.asset('assets/profilePicture.svg'),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                answer.user,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              Text(
                                answer.date.toDate().toString(),
                                style: TextStyle(
                                  color: AppColors.getColor('mono').grey,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                         if(FirebaseAuth.instance.currentUser!.uid == answer.userId)SvgDropdownPopupMenuButton(
                              onUpdateSelected: () {
                                // Call your updateCommentValue function here
                                widget.setEdit(true, index, answer.value);
                              },
                              onDeleteSelected: () {
                                // Call your deleteComment function here
                                deleteAnswer(widget.currentUserData!.schoolClass, widget.postId ,widget.commentIndex! ,index);
                                answers.removeAt(index);
                              },
                            ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Text(answer.value),
                      Row(
                        children: [
                          Spacer(),
                          Icon(Icons.thumb_up_outlined, size: 20.0),
                          SizedBox(width: 4.0),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error loading answers');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
