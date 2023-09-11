import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infomentor/backend/fetchClass.dart';
import 'package:infomentor/backend/fetchUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async'; // Add this import statement
import 'package:infomentor/Colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infomentor/widgets/ReWidgets.dart';

class Comments extends StatefulWidget {
  final Stream<List<CommentsData>> fetchCommentsStream;
  final void Function(int, [CommentsData?, int?]) onNavigationItemSelected;
  final UserData currentUserData;
  final String postId;
  void Function(bool, int, String) setEdit;
  Comments({
    Key? key,
    required this.setEdit,
    required this.onNavigationItemSelected,
    required this.fetchCommentsStream,
    required this.currentUserData,
    required this.postId
  }) : super(key: key);

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CommentsData>>(
      stream: widget.fetchCommentsStream, // Replace with your stream to fetch comments for the selected post
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<CommentsData> comments = snapshot.data!;
          return Container(
            width: 900, // set the maximum width to 900
            height: MediaQuery.of(context).size.height,  // or you can set a specific height
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                CommentsData comment = comments[index];
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                onTap: () {
                    if (MediaQuery.of(context).size.width < 1000) {
                      widget.onNavigationItemSelected(4,comment,index);
                    } else  {
                      widget.onNavigationItemSelected(2,comment,index);
                    }
                  },
                child:Container(
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
                          child: SvgPicture.asset('assets/profilePicture.svg')
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                            Text(
                              comment.user,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              comment.date.toDate().toString(),
                              style: TextStyle(
                                color: AppColors.getColor('mono').grey,
                              ),
                            ),
                           
                          ],
                        ),
                        Spacer(),
                         if(comment.userId == FirebaseAuth.instance.currentUser!.uid)SvgDropdownPopupMenuButton(
                              onUpdateSelected: () {
                                // Call your updateCommentValue function here
                                widget.setEdit(true, index, comment.value);
                              },
                              onDeleteSelected: () {
                                // Call your deleteComment function here
                                deleteComment(widget.currentUserData!.schoolClass, widget.postId ,index);
                                comments.removeAt(index);
                              },
                            ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Text(comment.value),
                    if(comment.award || widget.currentUserData!.teacher)Row(
                      children: [
                        Spacer(),
                        InkWell(
                          onTap: () {
                            setState(() {
                              toggleCommentAward(widget.currentUserData.schoolClass, widget.postId, index);
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: comment.award ? AppColors.getColor('yellow').main : AppColors.getColor('mono').grey),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  height: 15,
                                  comment.award ?  'assets/icons/starYellowIcon.svg' : 'assets/icons/smallStarIcon.svg',
                                  color: comment.award ? AppColors.getColor('yellow').main : AppColors.getColor('mono').grey,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  comment.award ? 'Ocenené' : 'Oceniť',
                                  style: TextStyle(
                                    color: comment.award ? AppColors.getColor('yellow').main : AppColors.getColor('mono').grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 4.0),
                      ],
                    ),
                  ],
                ),
                )
                )
              );
            },
            )
          );
        } else if (snapshot.hasError) {
          return Text('Error loading comments');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
