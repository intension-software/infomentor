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




class MobileDiscussions extends StatefulWidget {
  final UserData? currentUserData;


  MobileDiscussions({
    Key? key,
    required this.currentUserData,
  }) : super(key: key);

  @override
  _MobileDiscussionsState createState() => _MobileDiscussionsState();
}

class _MobileDiscussionsState extends State<MobileDiscussions> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;
  List<PostsData> _posts = [];
  PostsData? _selectedPost;
  CommentsData? _selectedComment;
  int? _selectedCommentIndex;
  TextEditingController answerController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  TextEditingController postController = TextEditingController();
  TextEditingController editAnswerController = TextEditingController();
  TextEditingController editCommentController = TextEditingController();
  TextEditingController editPostController = TextEditingController();
  bool _loading = true;
  bool _edit = false;
  bool _editComment = false;
  bool _editAnswer = false;
  bool _add = false;
  bool _library = false;
  int? _editIndex;


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
                        userId: answerItem['userId'],
                        pfp: answerItem['pfp'],
                        user: answerItem['user'] ?? '',
                        value: answerItem['value'] ?? '',
                      );
                    } else {
                      // Handle invalid answer data here
                      return CommentsAnswersData(
                        award: false,
                        userId: '',
                        pfp: '',
                        date: Timestamp.now(),
                        user: '',
                        value: '',
                      );
                    }
                  }).toList(),
                  userId: commentItem['userId'],
                  pfp: commentItem['pfp'],
                  date: commentItem['date'] ?? Timestamp.now(),
                  user: commentItem['user'] ?? '',
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
                  userId: answerItem['userId'],
                  pfp: answerItem['pfp'],
                  user: answerItem['user'],
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
            if(widget.currentUserData!.teacher)Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ReButton(
                    activeColor: AppColors.getColor('mono').white, 
                    defaultColor: AppColors.getColor('green').main, 
                    disabledColor: AppColors.getColor('mono').lightGrey, 
                    focusedColor: AppColors.getColor('green').light, 
                    hoverColor: AppColors.getColor('green').light, 
                    textColor: Theme.of(context).colorScheme.onPrimary, 
                    iconColor: AppColors.getColor('mono').black, 
                    text: 'Pridať príspevok', 
                    leftIcon: false, 
                    rightIcon: false, 
                    onTap: () {
                      _onNavigationItemSelected(1);
                      setState(() {
                        _add = true;
                      });
                    }
                  ),
                  ReButton(
                    activeColor: AppColors.getColor('mono').white, 
                    defaultColor: AppColors.getColor('mono').lighterGrey, 
                    disabledColor: AppColors.getColor('mono').lightGrey, 
                    focusedColor: AppColors.getColor('mono').lightGrey,
                    hoverColor: AppColors.getColor('mono').lightGrey,
                    textColor: Theme.of(context).primaryColor, 
                    iconColor: AppColors.getColor('mono').black,
                    text: 'Vybrať z knižnice', 
                    leftIcon: false, 
                    rightIcon: false, 
                    onTap: () {
                      _onNavigationItemSelected(1);
                      setState(() {
                        _library = true;
                      });
                    }
                  ),
              ],
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
                          onTap: () => _onNavigationItemSelected(3, post),
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
                                     if(FirebaseAuth.instance.currentUser!.uid == post.userId)SvgDropdownPopupMenuButton(
                                      onUpdateSelected: () {
                                        // Call your updateCommentValue function here
                                        _editIndex = index;
                                        _edit = true;
                                        editPostController.text = post.value;
                                        _onNavigationCommentSelected(1);
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
      if(_add) Container(
        color: Theme.of(context).colorScheme.background,
              width: 900,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 900,
                  alignment: Alignment.topLeft,
                  child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: AppColors.getColor('mono').darkGrey,
                      ),
                      onPressed: () {
                        _add = false;
                        _onNavigationItemSelected(0);
                      }
                    ),
                ),
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
                        userId: FirebaseAuth.instance.currentUser!.uid,
                        user: widget.currentUserData!.name,
                        pfp: widget.currentUserData!.image,
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
      if(_library)Container(
        color: Theme.of(context).colorScheme.background,
        width: 900,
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
                  onPressed: () {
                    _library = false;
                    _onNavigationItemSelected(0);
                  }
                ),
            ),
          ],
        ),
      ),
      if (_edit) Container(
        color: Theme.of(context).colorScheme.background,
        width: 900,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 900,
              alignment: Alignment.topLeft,
              child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: AppColors.getColor('mono').darkGrey,
                  ),
                  onPressed: () {
                    _edit = false;
                    _onNavigationItemSelected(0);
                  }
                ),
            ),
            Container(
              width: 900,
              child: TextField(
              minLines: 5,
              maxLines: 30,
              controller: editPostController,
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
            ),
            SizedBox(height: 8),
            Container(
              width: 900,
              child: Row(
              children: [
                Spacer(),
                 ReButton(
                activeColor: AppColors.getColor('mono').white, 
                defaultColor: AppColors.getColor('green').main, 
                disabledColor: AppColors.getColor('mono').lightGrey, 
                focusedColor: AppColors.getColor('green').light, 
                hoverColor: AppColors.getColor('green').light, 
                textColor: Theme.of(context).colorScheme.onPrimary, 
                iconColor: AppColors.getColor('mono').black, 
                text: 'UVEREJNIŤ ZMENY', 
                leftIcon: false, 
                rightIcon: false, 
                onTap: () async {
                    int postIndex = _editIndex!;// You need to set this to the appropriate index.

                    // Check if the postIndex is valid
                    if (postIndex >= 0 && postIndex < _posts.length) {
                      // Get the post to be edited
                      PostsData postToEdit = _posts[postIndex];

                      // Update the post value with the new text
                      postToEdit.value = editPostController.text;

                      try {
                        // Call a function to update the post in Firestore
                        await updatePostValue(
                          widget.currentUserData!.schoolClass,
                          postToEdit.id,
                          postToEdit.value,
                        );

                        setState(() {
                          // Update the local _posts list with the edited post
                          _posts[postIndex] = postToEdit;
                          _posts.sort((a, b) => b.date.compareTo(a.date));
                        });

                        editPostController.clear();
                      } catch (e) {
                        print('Error updating post: $e');
                      }
                    } else {
                      print('Invalid post index');
                    }
                  },
                 )
              ],
            ),
            )
          ],
        ),
      ),
      if (_selectedPost != null)
      Container(
        width: 900,
        height: 1080,
        color: Theme.of(context).colorScheme.background,
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
                child: Comments(
                  fetchCommentsStream: fetchCommentsStream(_selectedPost!.id),
                  onNavigationItemSelected: _onNavigationCommentSelected,
                  currentUserData: widget.currentUserData!,
                  postId: _selectedPost!.id,
                  setEdit: (bool edit, int index, String value) {
                    setState(() {
                      _editComment = edit;
                      _editIndex = index;
                      editCommentController.text = value;
                    });
                  },
                ),
              ),
            ),
            if(_editComment) Container(
              width: 900,
              child: Row(
                children: [
                  Text('Upraviť príspevok'),
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: AppColors.getColor('mono').darkGrey,
                    ),
                    onPressed: () {
                      setState(() {
                        _editComment = false;
                        _editIndex = null;
                        editCommentController.text = '';
                      });
                    },
                  ),
                ],
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
                        controller: _editComment ? editCommentController : commentController,
                        decoration: InputDecoration(
                          hintText: _editComment ? 'Upraviť odpoveď' : 'Zapoj sa do diskusie',
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
                    ReButton(
                      activeColor: AppColors.getColor('mono').white, 
                      defaultColor: AppColors.getColor('primary').main, 
                      disabledColor: AppColors.getColor('mono').lightGrey, 
                      focusedColor: AppColors.getColor('primary').light, 
                      hoverColor: AppColors.getColor('mono').lighterGrey, 
                      textColor: Theme.of(context).colorScheme.onPrimary, 
                      iconColor: AppColors.getColor('mono').black, 
                      text: _editComment ? 'Uložiť úpravy' : 'Odpovedať', 
                      leftIcon: false, 
                      rightIcon: false, 
                      onTap: () async {
                        if (_editComment) {
                          int commentIndex = _editIndex!; // You need to set this to the appropriate index.

                          // Check if the commentIndex is valid
                          if (commentIndex >= 0 && commentIndex < _selectedPost!.comments.length) {
                            // Get the comment to be edited
                            CommentsData commentToEdit = _selectedPost!.comments[commentIndex];

                            // Update the comment value with the new text
                            commentToEdit.value = editCommentController.text;

                            try {
                              // Call a function to update the comment in Firestore
                              await updateCommentValue(
                                widget.currentUserData!.schoolClass,
                                _selectedPost!.id,
                                commentIndex, // Pass the comment index to identify which comment to edit
                                commentToEdit.value,
                              );

                              setState(() {
                                // Update the local _selectedPost!.comments list with the edited comment
                                _selectedPost!.comments[commentIndex] = commentToEdit;
                                _editIndex = null;
                                _editComment = false;
                              });

                              editCommentController.clear();
                            } catch (e) {
                              print('Error updating comment: $e');
                            }
                          } else {
                            print('Invalid comment index');
                          }
                        } else {
                          CommentsData newComment = CommentsData(
                            answers: [],  // Initialize answers list with an empty list
                            award: false,
                            date: Timestamp.now(),
                            user: widget.currentUserData!.name,
                            pfp: widget.currentUserData!.image,
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
                        }
                      },
                    ) 
                  ],
                ),
              ),
          ],
        ),
      ),
       if (_selectedComment != null)
      Container(
        color: Theme.of(context).colorScheme.background,
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
                child: CommentsAnswers(fetchAnswersStream: fetchAnswersStream(_selectedPost!.id, _selectedCommentIndex!), commentIndex: _selectedCommentIndex, currentUserData: widget.currentUserData!, postId: _selectedPost!.id, setEdit: (bool edit, int index, String value) {
                    setState(() {
                      _editAnswer = edit;
                      _editIndex = index;
                      editAnswerController.text = value;
                    });
                  },),
              ),
            ),
            if(_editAnswer) Container(
              width: 900,
              child: Row(
                children: [
                  Text('Upraviť príspevok'),
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: AppColors.getColor('mono').darkGrey,
                    ),
                    onPressed: () {
                      setState(() {
                        _editAnswer = false;
                        _editIndex = null;
                        editAnswerController.text = '';
                      });
                    },
                  ),
                ],
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
                      controller: _editAnswer ? editAnswerController : answerController,
                      decoration: InputDecoration(
                        hintText: _editAnswer ? 'Upraviť odpoveď' : 'Zapoj sa do diskusie',
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
                  ReButton(
                    activeColor: AppColors.getColor('mono').white,
                    defaultColor: AppColors.getColor('primary').main,
                    disabledColor: AppColors.getColor('mono').lightGrey,
                    focusedColor: AppColors.getColor('primary').light,
                    hoverColor: AppColors.getColor('mono').lighterGrey,
                    textColor: Theme.of(context).colorScheme.onPrimary,
                    iconColor: AppColors.getColor('mono').black,
                    text: _editAnswer ? 'Uložiť úpravy' : 'Odpovedať',
                    leftIcon: false,
                    rightIcon: false,
                    onTap: () async {
                      if (_editAnswer) {
                        int answerIndex = _editIndex!; // You need to set this to the appropriate index.

                        // Check if the answerIndex is valid
                        if (answerIndex >= 0 && answerIndex < _selectedComment!.answers.length) {
                          // Get the answer to be edited
                          CommentsAnswersData answerToEdit = _selectedComment!.answers[answerIndex];

                          // Update the answer value with the new text
                          answerToEdit.value = editAnswerController.text;

                          try {
                            // Call a function to update the answer in Firestore
                            await updateAnswerValue(
                              widget.currentUserData!.schoolClass,
                              _selectedPost!.id,
                              _selectedCommentIndex!, // Pass the comment index to identify which comment to edit
                              answerIndex, // Pass the answer index to identify which answer to edit
                              answerToEdit.value,
                            );

                            setState(() {
                              // Update the local _selectedComment!.answers list with the edited answer
                              _selectedComment!.answers[answerIndex] = answerToEdit;
                              _editIndex = null;
                              _editAnswer = false;
                            });

                            editAnswerController.clear();
                          } catch (e) {
                            print('Error updating answer: $e');
                          }
                        } else {
                          print('Invalid answer index');
                        }
                      } else {
                        CommentsAnswersData newAnswer = CommentsAnswersData(
                          award: false,
                          date: Timestamp.now(),
                          user: widget.currentUserData!.name,
                          pfp: widget.currentUserData!.image,
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
