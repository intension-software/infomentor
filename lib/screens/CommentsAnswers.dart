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
  final PostsData? post;
  final CommentsData? comment;
  final int? commentIndex;
  void Function(bool, int, String) setEdit;

  CommentsAnswers({
    Key? key,
    required this.comment,
    required this.post,
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
  String formatTimestamp(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return "${date.day}.${date.month}.${date.year}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";

  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CommentsAnswersData>>(
      stream: widget.fetchAnswersStream, // Replace with your stream to fetch answers for the selected comment
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<CommentsAnswersData> answers = snapshot.data!;
          return Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: MediaQuery.of(context).size.width < 1000 ?null :Border.all(
                  color: AppColors.getColor('mono').lightGrey,
                ),
              ),
            width: 900, // set the maximum width to 900
            height: 550,  // or you can set a specific height
            child: Column(
              children: [
                SizedBox(height: 10,),
                Container(
                  width: 900, // set the maximum width to 900
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(bottom: BorderSide(color: AppColors.getColor('mono').lightGrey)),
                    ),
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 108,
                        width: double.infinity,
                        padding: EdgeInsets.all(12),
                         decoration: BoxDecoration(
                            color: AppColors.getColor('primary').lighter,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.post!.user,
                                style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: Theme.of(context).colorScheme.onBackground,
                                  ),
                              ),
                              SizedBox(height: 10,),
                              Text(
                                widget.post!.value,
                              ),
                            
                            ],
                          ),
                      ),
                      SizedBox(height: 20.0),
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
                                widget.comment!.user,
                                style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: Theme.of(context).colorScheme.onBackground,
                                  ),
                              ),
                              Text(
                                formatTimestamp(widget.comment!.date),
                                style: TextStyle(
                                  color: AppColors.getColor('mono').grey,
                                ),
                              ),
                            
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Text(widget.post!.value),
                      SizedBox(height: 10.0),
                      Row(
                        children: [
                          SvgPicture.asset('assets/icons/commentIcon.svg'),
                          Text('Odpovedať',
                            style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(
                              color: AppColors.getColor('mono').darkGrey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ),
                Container(
                  width: 900,
                  height: 250,
                  padding: EdgeInsets.all(12),
                  child:ListView.builder(
                    itemCount: answers.length,
                    itemBuilder: (context, index) {
                      CommentsAnswersData answer = answers[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(bottom: BorderSide(color: AppColors.getColor('mono').lightGrey)),
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
                                      style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: Theme.of(context).colorScheme.onBackground,
                                        ),
                                    ),
                                    Text(
                                      formatTimestamp(answer.date),
                                      style: TextStyle(
                                        color: AppColors.getColor('mono').grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                              if(answer.userId == FirebaseAuth.instance.currentUser!.uid || widget.currentUserData.teacher)SvgDropdownPopupMenuButton(
                                    onUpdateSelected: () {
                                      // Call your updateanswerValue function here
                                      widget.setEdit(true, index, answer.value);
                                    },
                                    onDeleteSelected: () {
                                        // Call your deleteComment function here
                                       MediaQuery.of(context).size.width > 1000 ? showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20.0),
                                              ),
                                              content: Container(
                                                height: 250,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Align(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        'Vymazať príspevok',
                                                        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                                          color: AppColors.getColor('mono').black,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 15,),
                                                    Align(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        'Chystáte sa vymazať váš príspevok z diskusného fóra. Zároveň tým vymažete všetky odpovede žiakov. Táto akcia je nevratná.',
                                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                                                      ),
                                                    ),
                                                    SizedBox(height: 35,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center, // Center-align the buttons horizontally
                                                      children: [
                                                        Container(
                                                          width: 270,
                                                          height: 48,
                                                          child: ReButton(
                                                            activeColor: AppColors.getColor('primary').light, 
                                                            defaultColor: AppColors.getColor('mono').white, 
                                                            disabledColor: AppColors.getColor('mono').lightGrey, 
                                                            focusedColor: AppColors.getColor('mono').lightGrey, 
                                                            hoverColor: AppColors.getColor('mono').lighterGrey, 
                                                            textColor: AppColors.getColor('mono').black,
                                                            iconColor: AppColors.getColor('mono').black, 
                                                            text: 'POKRAČOVAŤ V ÚPRAVÁCH',  
                                                            onTap: () {
                                                              Navigator.of(context).pop();
                                                            }
                                                          ),
                                                        ),
                                                        SizedBox(width: 20,), // Add spacing between buttons
                                                        Container(
                                                          width: 150,
                                                          height: 48,
                                                          child: ReButton(
                                                            activeColor: AppColors.getColor('red').light, 
                                                            defaultColor: AppColors.getColor('red').main, 
                                                            disabledColor: AppColors.getColor('mono').lightGrey, 
                                                            focusedColor: AppColors.getColor('red').light, 
                                                            hoverColor: AppColors.getColor('red').lighter, 
                                                            textColor: AppColors.getColor('mono').white, 
                                                            iconColor: AppColors.getColor('mono').black, 
                                                            text: 'VYMAZAŤ',  
                                                            onTap: () {
                                                              deleteAnswer(widget.currentUserData!.schoolClass, widget.postId ,widget.commentIndex! ,index);
                                                              answers.removeAt(index);
                                                              Navigator.of(context).pop();
                                                            }
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ) : showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20.0),
                                              ),
                                              content: Container(
                                                height: 250,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                ),
                                                // Add content for the AlertDialog here
                                                // For example, you can add form fields to input teacher data
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Spacer(),
                                                        MouseRegion(
                                                          cursor: SystemMouseCursors.click,
                                                          child: GestureDetector(
                                                            child: SvgPicture.asset('assets/icons/xIcon.svg', height: 10,),
                                                            onTap: () {
                                                              Navigator.of(context).pop();
                                                            },
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Align(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                      'Vymazať príspevok',
                                                        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                                          color: AppColors.getColor('mono').black,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 15,),
                                                    Align(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                      'Chystáte sa vymazať váš príspevok z diskusného fóra. Zároveň tým vymažete všetky odpovede žiakov. Táto akcia je nevratná. ',
                                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Align(
                                                      alignment: Alignment.center,
                                                      child:  Container(
                                                        width: 150,
                                                        height: 48,
                                                        child:  ReButton(
                                                          activeColor: AppColors.getColor('red').light, 
                                                          defaultColor: AppColors.getColor('red').main, 
                                                          disabledColor: AppColors.getColor('mono').lightGrey, 
                                                          focusedColor: AppColors.getColor('red').light, 
                                                          hoverColor: AppColors.getColor('red').lighter, 
                                                          textColor: AppColors.getColor('mono').white,
                                                          iconColor: AppColors.getColor('mono').black,
                                                          text: 'VYMAZAŤ',  
                                                          onTap: () {
                                                            deleteAnswer(widget.currentUserData!.schoolClass, widget.postId ,widget.commentIndex! ,index);
                                                            answers.removeAt(index);
                                                            Navigator.of(context).pop();
                                                          }
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      // Call your deleteanswer function here
                                    showEditOption: (!widget.currentUserData.teacher || answer.userId == FirebaseAuth.instance.currentUser!.uid),
                                  ),
                              ],
                            ),
                            SizedBox(height: 10.0),
                            Text(answer.value),
                            if(answer.award || widget.currentUserData!.teacher)Row(
                              children: [
                                Spacer(),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      if(widget.currentUserData.teacher) {
                                        toggleAnswerAward(widget.currentUserData.schoolClass, widget.postId, widget.commentIndex!, index);
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(color: answer.award ? AppColors.getColor('yellow').main : AppColors.getColor('mono').grey),
                                    ),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          height: 15,
                                          answer.award ?  'assets/icons/starYellowIcon.svg' : 'assets/icons/smallStarIcon.svg',
                                          color: answer.award ? AppColors.getColor('yellow').main : AppColors.getColor('mono').grey,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          answer.award ? 'Ocenené' : 'Oceniť',
                                          style: TextStyle(
                                            color: answer.award ? AppColors.getColor('yellow').main : AppColors.getColor('mono').grey,
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
                      );
                    },
                  ),
                )
              ]
            )
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
