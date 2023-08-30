import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infomentor/backend/fetchClass.dart';
import 'package:infomentor/backend/fetchUser.dart';
import 'package:infomentor/screens/Comments.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:infomentor/widgets/ReWidgets.dart';
import 'dart:async'; // Add this import statement
import 'package:infomentor/Colors.dart';
import 'package:flutter_svg/flutter_svg.dart';




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
  final PageController _pageController = PageController();
  int _selectedIndex = 0;
  List<PostsData> _posts = [];
  bool _showOverlay = false;
  PostsData? _selectedPost;
  OverlayEntry? _overlayEntry;
  TextEditingController commentController = TextEditingController();
  TextEditingController postController = TextEditingController();


  @override
  void initState() {
    super.initState();
    fetchPosts();
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
        });
      }
    } catch (e) {
      print('Error fetching posts: $e');
    }
  }

  void _toggleCommentsOverlay([PostsData? post]) {
    if(mounted) {
      setState(() {
        if (_showOverlay && _selectedPost == post) {
          _showOverlay = false;
          _overlayEntry?.remove();
          _overlayEntry = null;
          _selectedPost = null;
        } else {
          _selectedPost = post;
          _showOverlay = true;
          if (_overlayEntry == null) {
            _createOverlayEntry();
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  void _createOverlayEntry() {
    if (_overlayEntry != null) return;

    TextEditingController commentController = TextEditingController();

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: Colors.white,
              ),
            ),
            Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: AppColors.getColor('mono').grey,
                  ),
                  onPressed: _toggleCommentsOverlay,
                ),
              ),
              backgroundColor: Colors.transparent,
              body: Comments(fetchCommentsStream: fetchCommentsStream(_selectedPost!.id)),
              bottomNavigationBar: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: AppColors.getColor('mono').lightGrey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: commentController,
                        decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
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
                          date: Timestamp.now(),
                          like: false,
                          user: widget.currentUserData!.name,
                          value: commentController.text,
                        );

                        try {
                          await addComment(
                              widget.currentUserData!.schoolClass, _selectedPost!.id, newComment);

                          setState(() {
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
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  Stream<List<CommentsData>> fetchCommentsStream(String postId) {
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
        List<CommentsData> commentsDataList =
            comments.map((commentItem) {
          return CommentsData(
            date: commentItem['date'],
            like: commentItem['like'],
            user: commentItem['user'],
            value: commentItem['value'],
          );
        }).toList();

        return commentsDataList;
      }
    }

    return <CommentsData>[]; // Return an empty list if the post or comments don't exist
  }).handleError((error) {
    print('Error fetching comments: $error');
    return <CommentsData>[]; // Return an empty list in case of an error
  });
}

  @override
Widget build(BuildContext context) {
  return PageView(
    controller: _pageController,
    onPageChanged: _onPageChanged,
      children: [
      
       Container( 
        child: Column(
          children: [
            Container(
              width: 900,
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 260,
                  child: widget.currentUserData!.teacher ? ReButton(
                    activeColor: AppColors.getColor('mono').white, 
                    defaultColor: AppColors.getColor('primary').main, 
                    disabledColor: AppColors.getColor('mono').lightGrey, 
                    focusedColor: AppColors.getColor('primary').light, 
                    hoverColor: AppColors.getColor('mono').lighterGrey, 
                    textColor: Theme.of(context).colorScheme.onPrimary, 
                    iconColor: AppColors.getColor('mono').black, 
                    text: '+ VYTVORIŤ PRÍSPEVOK', 
                    leftIcon: false, 
                    rightIcon: false, 
                    onTap: () {
                      _onNavigationItemSelected(2);
                      _selectedIndex = 1;
                    },
                  ) : null,
                ),
              )
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
                          onTap: () => MediaQuery.of(context).size.width < 1000 ? _toggleCommentsOverlay(post) : _onNavigationItemSelected(1, post),
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
                                          post.date.toDate().toString(),
                                          style: TextStyle(
                                            color: AppColors.getColor('mono').grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.0),
                                  Text(post.value),
                                  Row(
                                    children: [
                                      Spacer(),
                                      Icon(Icons.chat_bubble_outline, size: 20.0),
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
      if (_selectedPost != null)Column(
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
              child: Comments(fetchCommentsStream: fetchCommentsStream(_selectedPost!.id)),
            ),
           ),
          Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: AppColors.getColor('mono').lightGrey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: commentController,
                        decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
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
                          date: Timestamp.now(),
                          like: false,
                          user: widget.currentUserData!.name,
                          value: commentController.text,
                        );

                        try {
                          await addComment(
                              widget.currentUserData!.schoolClass, _selectedPost!.id, newComment);

                          setState(() {
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
      Column(
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
          Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: AppColors.getColor('mono').lightGrey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: postController,
                        decoration: InputDecoration(
                          hintText: 'Add a post...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async {
                        PostsData newPost = PostsData(
                          comments: [],
                          date: Timestamp.now(),
                          user: widget.currentUserData!.name,
                          value: postController.text,
                          id: _posts.length.toString()
                        );

                        try {
                          await addPost(widget.currentUserData!.schoolClass, newPost);

                          setState(() {
                            _posts.add(newPost);
                          });

                          postController.clear();
                        } catch (e) {
                          print('Error adding post: $e');
                        }
                      },
                      child: Text('Post'),
                    ),

                  ],
                ),
              ),
        ],
      )
    ]
  );
}
  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onNavigationItemSelected(int index, [PostsData? post]) {
    setState(() {
       if (_showOverlay && _selectedPost == post) {
        _selectedPost = null;
        _selectedIndex = 0;
        _pageController.animateToPage(
          0,
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      } else {
        _selectedPost = post;
        _selectedIndex = index;
        _pageController.animateToPage(
          index,
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      }
      
    });
  }
}
