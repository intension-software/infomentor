import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infomentor/backend/fetchClasses.dart';
import 'package:infomentor/backend/fetchUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async'; // Add this import statement
import 'package:infomentor/Colors.dart';



class Discussions extends StatefulWidget {
  const Discussions({Key? key}) : super(key: key);

  @override
  _DiscussionsState createState() => _DiscussionsState();
}

class _DiscussionsState extends State<Discussions> {
  List<PostsData> _posts = [];
  UserData? userData;
  bool _showOverlay = false;
  PostsData? _selectedPost;
  OverlayEntry? _overlayEntry;


  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  Future<void> fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        userData = await fetchUser(user.uid);
        if (mounted) {
          setState(() {
            userData = userData;
          });
          fetchPosts();
        }
      } else {
        print('User is not logged in.');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> fetchPosts() async {
    try {
      List<ClassData> classes = await fetchClasses(userData!.schoolClass);
      List<PostsData> posts = [];

      for (ClassData classData in classes) {
        posts.addAll(classData.posts);
      }

      posts.sort((a, b) => b.date.compareTo(a.date));

      setState(() {
        _posts = posts;
      });
    } catch (e) {
      print('Error fetching posts: $e');
    }
  }

  void _toggleCommentsOverlay([PostsData? post]) {
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
                    color: AppColors.mono.grey,
                  ),
                  onPressed: _toggleCommentsOverlay,
                ),
              ),
              backgroundColor: Colors.transparent,
              body: StreamBuilder<List<CommentsData>>(
                stream: fetchCommentsStream(_selectedPost!.id), // Replace with your stream to fetch comments for the selected post
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<CommentsData> comments = snapshot.data!;
                    return ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        CommentsData comment = comments[index];
                        return Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: AppColors.mono.lightGrey),
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
                                    child: CircleAvatar(
                                      backgroundImage: AssetImage('assets/profilePicture.png'),
                                      radius: 24.0,
                                    ),
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
                                          color: AppColors.mono.grey,
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
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error loading comments');
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              bottomNavigationBar: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: AppColors.mono.lightGrey,
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
                          user: userData!.name,
                          value: commentController.text,
                        );

                        try {
                          await addComment(
                              userData!.schoolClass, _selectedPost!.id, newComment);

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
      .doc(userData!.schoolClass)
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
  return ListView.builder(
    itemCount: _posts.length,
    itemBuilder: (context, index) {
      PostsData post = _posts[index];

      return MouseRegion(
         cursor: SystemMouseCursors.click,
          child: GestureDetector(
        onTap: () => _toggleCommentsOverlay(post),
        child: Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: AppColors.mono.lightGrey),
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
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/profilePicture.png'),
                      radius: 24.0,
                    ),
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
                          color: AppColors.mono.grey,
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
      );
    },
  );
}
}
