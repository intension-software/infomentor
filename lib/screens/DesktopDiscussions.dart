import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infomentor/backend/fetchClass.dart';
import 'package:infomentor/backend/fetchUser.dart';
import 'package:infomentor/screens/Comments.dart';
import 'package:infomentor/screens/CommentsAnswers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:infomentor/widgets/ReWidgets.dart';
import 'dart:async'; // Add this import statement
import 'package:infomentor/Colors.dart';
import 'package:flutter_svg/flutter_svg.dart';




class DesktopDiscussions extends StatefulWidget {
  final UserData? currentUserData;


  DesktopDiscussions({
    Key? key,
    required this.currentUserData,
  }) : super(key: key);

  @override
  _DesktopDiscussionsState createState() => _DesktopDiscussionsState();
}

class _DesktopDiscussionsState extends State<DesktopDiscussions> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;
  List<PostsData> _posts = [];
  PostsData? _selectedPost;
  CommentsData? _selectedComment;
  int? _selectedCommentIndex;
  TextEditingController answerController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  TextEditingController postController = TextEditingController();
  bool _loading = true;
  String? _edit;


  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return "${date.day}.${date.month}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";

  }

  Future<void> fetchPosts() async {
    try {
      ClassData classes = await fetchClass(widget.currentUserData!.schoolClass);
      List<PostsData> posts = [];

      posts.addAll(classes.posts);

      posts.sort((a, b) => b.date.compareTo(a.date));
      if(mounted) {
        setState(() {
          _posts = posts;
          _loading = false;
        });
      }
    } catch (e) {
      print('Error fetching posts: $e');
    }
  }
  

  @override
  void dispose() {
    super.dispose();
  }

  Stream<List<CommentsData>> fetchCommentsStream(String postId) {
  return FirebaseFirestore.instance
      .collection('classes')
      .doc(widget.currentUserData!.schoolClass)
      .snapshots()
      .map((classSnapshot) {
        if (classSnapshot.exists) {
          Map<String, dynamic>? classData = classSnapshot.data();
          if (classData != null) {
            List<dynamic> posts = classData['posts'];
            Map<String, dynamic>? post = posts.firstWhere(
              (item) => item['id'] == postId,
              orElse: () => null,
            );

            if (post != null && post['comments'] is List) {
              List<dynamic> comments = post['comments'];
              List<CommentsData> commentsDataList = comments.map((commentItem) {
                return CommentsData(
                  award: commentItem['award'] ?? false,
                  answers: (commentItem['answers'] as List<dynamic>? ?? []).map<CommentsAnswersData>((answerItem) {
                    if (answerItem is Map<String, dynamic>) {
                      return CommentsAnswersData(
                        award: answerItem['award'] ?? false,
                        date: answerItem['date'] ?? Timestamp.now(),
                        user: answerItem['user'] ?? '',
                        userId: answerItem['userId'] ?? '',
                        value: answerItem['value'] ?? '',
                      );
                    } else {
                      // Handle invalid answer data here
                      return CommentsAnswersData(
                        award: false,
                        date: Timestamp.now(),
                        user: '',
                        userId: '',
                        value: '',
                      );
                    }
                  }).toList(),
                  date: commentItem['date'] ?? Timestamp.now(),
                  user: commentItem['user'] ?? '',
                  userId: commentItem['userId'] ?? '',
                  value: commentItem['value'] ?? '',
                );
              }).toList();

              return commentsDataList;
            }
          }
        }

        return <CommentsData>[]; // Return an empty list if the post or comments don't exist
      })
      .handleError((error) {
        print('Error fetching comments: $error');
        return <CommentsData>[]; // Return an empty list in case of an error
      });
}

  Stream<List<CommentsAnswersData>> fetchAnswersStream(String postId, int commentIndex) {
  return FirebaseFirestore.instance
      .collection('classes')
      .doc(widget.currentUserData!.schoolClass)
      .snapshots()
      .map((classSnapshot) {
        if (classSnapshot.exists) {
          List<dynamic> posts = classSnapshot.get('posts');
          Map<String, dynamic> post =
              posts.firstWhere((item) => item['id'] == postId, orElse: () => {});
          if (post.isNotEmpty) {
            List<dynamic> comments = post['comments'];
            if (commentIndex >= 0 && commentIndex < comments.length) {
              List<dynamic> answers = comments[commentIndex]['answers'];
              List<CommentsAnswersData> answersDataList = answers.map((answerItem) {
                return CommentsAnswersData(
                  award: answerItem['award'],
                  date: answerItem['date'],
                  user: answerItem['user'],
                  userId: answerItem['userId'],
                  value: answerItem['value'],
                );
              }).toList();

              return answersDataList;
            }
          }
        }

        return <CommentsAnswersData>[]; // Return an empty list if the post, comment, or answers don't exist
      })
      .handleError((error) {
        print('Error fetching answers: $error');
        return <CommentsAnswersData>[]; // Return an empty list in case of an error
      });
}


  @override
Widget build(BuildContext context) {
  if(_loading) return  Center(child: CircularProgressIndicator());
  return PageView(
    controller: _pageController,
    onPageChanged: _onPageChanged,
      children: [
       Container(

        width: 900,
        height: 1080,
        color: Theme.of(context).colorScheme.background,
        child: Column(
          children: [
            Container(
              width: 900,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
               TextField(
                  minLines: 5,
                  maxLines: 20,
                  controller: postController,
                  decoration: InputDecoration(
                    hintText: 'Obsah diskusného príspevku',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8), // Adjust the value for less rounded corners
                      borderSide: BorderSide(color: AppColors.getColor('mono').lightGrey), // Light grey border color
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.getColor('mono').lightGrey), // Light grey border color
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.getColor('mono').lightGrey), // Light grey border color
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),

                SizedBox(height: 8),
                ReButton(
                    activeColor: AppColors.getColor('mono').white, 
                    defaultColor: AppColors.getColor('green').main, 
                    disabledColor: AppColors.getColor('mono').lightGrey, 
                    focusedColor: AppColors.getColor('green').light, 
                    hoverColor: AppColors.getColor('green').light, 
                    textColor: Theme.of(context).colorScheme.onPrimary, 
                    iconColor: AppColors.getColor('mono').black, 
                    text: 'UVEREJNIŤ', 
                    leftIcon: false, 
                    rightIcon: false, 
                    onTap: () async {
                      PostsData newPost = PostsData(
                        comments: [],
                        date: Timestamp.now(),
                        user: widget.currentUserData!.name,
                        userId: FirebaseAuth.instance.currentUser!.uid,
                        value: postController.text,
                        id: _posts.length.toString()
                      );

                      try {
                        await addPost(widget.currentUserData!.schoolClass, newPost);

                        setState(() {
                          _posts.add(newPost);
                          _posts.sort((a, b) => b.date.compareTo(a.date));
                        });

                        postController.clear();
                      } catch (e) {
                        print('Error adding post: $e');
                      }
                    },
                  ),
              ],
            ),
          ),
            Expanded( 
              child: ListView.builder(
                  itemCount: _posts.length,
                  itemBuilder: (context, index) {
                    PostsData post = _posts[index];

                    return Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 900, // Set your maximum width here
                        child: 
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                          onTap: () => _onNavigationItemSelected(1, post),
                          child: Container(
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
                                          post.user,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        Text(
                                          formatTimestamp(post.date),
                                          style: TextStyle(
                                            color: AppColors.getColor('mono').grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    SvgDropdownPopupMenuButton(
                                      onUpdateSelected: () {
                                        // Call your updateCommentValue function here
                                      },
                                      onDeleteSelected: () {
                                        // Call your deleteComment function here
                                        deletePost(widget.currentUserData!.schoolClass, post.id);
                                        _posts.removeWhere((item) => item.id == post.id);
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.0),
                                  Text(post.value),
                                  Row(
                                    children: [
                                      Spacer(),
                                      SvgPicture.asset('assets/icons/smallTextBubbleIcon.svg'),
                                      SizedBox(width: 4.0),
                                      Text(
                                        'odpovede',
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                          )
                        )
                      );
                      },
                    )
            )
          ]
          )
        ),
      if (_selectedPost != null)
      Container(
        width: 900,
        height: 1080,
        child: Column(
          children: [
            Container(
              width: 900,
              alignment: Alignment.topLeft,
              child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: AppColors.getColor('mono').darkGrey,
                  ),
                  onPressed: () => 
                    _onNavigationItemSelected(0),
                ),
            ),
            Expanded(
              child: SingleChildScrollView( 
                child: Comments(fetchCommentsStream: fetchCommentsStream(_selectedPost!.id), onNavigationItemSelected: _onNavigationCommentSelected,),
              ),
            ),
            Container(
                  width: 900,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: AppColors.getColor('primary').main),
                  ),
                  padding: EdgeInsets.only(right: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child:  TextField(
                          minLines: 3,
                          maxLines: 20,
                          controller: commentController,
                          decoration: InputDecoration(
                            hintText: 'Zapoj sa do diskusie',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8), // Adjust the value for less rounded corners
                              borderSide: BorderSide(color: Colors.transparent), // Light grey border color
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.transparent), // Light grey border color
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.transparent), // Light grey border color
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () async {
                          CommentsData newComment = CommentsData(
                            answers: [],  // Initialize answers list with an empty list
                            award: false,
                            date: Timestamp.now(),
                            user: widget.currentUserData!.name,
                            userId: FirebaseAuth.instance.currentUser!.uid,
                            value: commentController.text,
                          );

                          try {
                            await addComment(
                              widget.currentUserData!.schoolClass,
                              _selectedPost!.id,
                              newComment,
                            );

                            setState(() {
                              // Assuming _selectedPost!.comments is of type List<CommentsData>
                              _selectedPost!.comments.add(newComment);
                            });

                            commentController.clear();
                          } catch (e) {
                            print('Error adding comment: $e');
                          }
                        },
                        child: Text('Post'),
                        ),

                    ],
                  ),
                ),
          ],
        ),
      ),
       if (_selectedComment != null)
      Container(
        width: 900,
        height: 1080,
        child: Column(
          children: [
            Container(
              width: 900,
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: AppColors.getColor('mono').darkGrey,
                ),
                onPressed: () => _onNavigationItemSelected(1),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: CommentsAnswers(fetchAnswersStream: fetchAnswersStream(_selectedPost!.id, _selectedCommentIndex!)),
              ),
            ),
            Container(
              width: 900,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: AppColors.getColor('primary').main),
              ),
              padding: EdgeInsets.only(right: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      minLines: 3,
                      maxLines: 20,
                      controller: answerController,
                      decoration: InputDecoration(
                        hintText: 'Zapoj sa do diskusie',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8), // Adjust the value for less rounded corners
                          borderSide: BorderSide(color: Colors.grey), // Light grey border color
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey), // Light grey border color
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey), // Light grey border color
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      if (_selectedComment != null) {
                        CommentsAnswersData newAnswer = CommentsAnswersData(
                          award: false,
                          date: Timestamp.now(),
                          user: widget.currentUserData!.name,
                          userId: FirebaseAuth.instance.currentUser!.uid,
                          value: answerController.text,
                        );

                        try {
                          await addAnswer(
                            widget.currentUserData!.schoolClass,
                            _selectedPost!.id,
                            _selectedCommentIndex!,
                            newAnswer,
                          );

                          setState(() {
                            // Assuming _selectedComment!.answers is of type List<CommentsAnswersData>
                            _selectedComment!.answers.add(newAnswer);
                          });

                          answerController.clear();
                        } catch (e) {
                          print('Error adding answer: $e');
                        }
                      }
                    },
                    child: Text('Post'),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    ]
  );

  
}

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onNavigationCommentSelected(int index, [CommentsData? comment, int? commentIndex]) {
    setState(() {
        _selectedIndex = index;
        _selectedComment = comment;
        _selectedCommentIndex = commentIndex;
        _pageController.animateToPage(
          index,
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
        );
    });
  }

  void _onNavigationItemSelected(int index, [PostsData? post, CommentsData? comment, int? commentIndex]) {
    setState(() {
        _selectedIndex = index;
        _selectedPost = post;
        _selectedComment = comment;
        _selectedCommentIndex = commentIndex;
        _pageController.animateToPage(
          index,
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
        );
    });
  }
}

class SvgDropdownPopupMenuButton extends StatelessWidget {
  final Function() onUpdateSelected;
  final Function() onDeleteSelected;

  SvgDropdownPopupMenuButton({
    required this.onUpdateSelected,
    required this.onDeleteSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            value: 'update',
            child: Text('upraviť'),
          ),
          PopupMenuItem(
            value: 'delete',
            child: Text('vymazať'),
          ),
        ];
      },
      onSelected: (String value) {
        if (value == 'update') {
          onUpdateSelected();
        } else if (value == 'delete') {
          onDeleteSelected();
        }
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              child: Icon(Icons.more_vert),
            ),
          ],
        ),
      ),
    );
  }
}
