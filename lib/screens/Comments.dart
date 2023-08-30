import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infomentor/backend/fetchClass.dart';
import 'package:infomentor/backend/fetchUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async'; // Add this import statement
import 'package:infomentor/Colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Comments extends StatefulWidget {
  final Stream<List<CommentsData>> fetchCommentsStream;

  Comments({
    Key? key,
    required this.fetchCommentsStream,
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
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Text(comment.value),
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
