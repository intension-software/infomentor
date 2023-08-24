import 'package:flutter/material.dart';
import 'package:infomentor/backend/fetchUser.dart';
import 'package:infomentor/backend/fetchClass.dart';
import 'package:infomentor/backend/fetchNotifications.dart';
import 'package:infomentor/backend/fetchMaterials.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CompleteNotification {
  final NotificationsData notification;
  final PostsData? postData;
  final CommentsData? commentData;
  final MaterialData? materialData;

  CompleteNotification({
    required this.notification,
    this.postData,
    this.commentData,
    this.materialData,
  });
}

class Notifications extends StatefulWidget {
  final UserData? currentUserData;

  Notifications({required this.currentUserData});

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  late Future<List<CompleteNotification>> _notificationsData;

  @override
  void initState() {
    super.initState();
    _notificationsData = _fetchCompleteNotifications(widget.currentUserData!);
  }

  Future<List<CompleteNotification>> _fetchCompleteNotifications(UserData userData) async {
    List<NotificationsData> notifications = await fetchNotifications(userData);
    List<CompleteNotification> completeNotifications = [];

    for (var notif in notifications) {
      switch (notif.type.type) {
        case 'post':
          {
            PostsData? postData = await _fetchPostById(userData.schoolClass, notif.type.id);
            completeNotifications.add(CompleteNotification(notification: notif, postData: postData));
          }
          break;
        case 'comment':
          {
            String postId = notif.type.id;
            String commentIndex = notif.type.commentIndex;
            CommentsData? commentData = await _fetchCommentById(userData.schoolClass, postId, commentIndex);
            completeNotifications.add(CompleteNotification(notification: notif, commentData: commentData));
          }
          break;
        case 'learning':
          {
            MaterialData? materialData = await _fetchMaterialById(userData.schoolClass, notif.type.id);
            completeNotifications.add(CompleteNotification(notification: notif, materialData: materialData));
          }
          break;
        default:
          {
            completeNotifications.add(CompleteNotification(notification: notif));
          }
      }
    }

    return completeNotifications;
}

String formatTimestamp(Timestamp timestamp) {
  DateTime date = timestamp.toDate();
  return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
}

@override
Widget build(BuildContext context) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Upozornenia",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        FutureBuilder<List<CompleteNotification>>(
          future: _notificationsData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("No notifications available."));
              }

              List<CompleteNotification> unseenNotifications = snapshot.data!.where((completeNotif) {
                return widget.currentUserData!.notifications.any((userNotif) => !userNotif.seen);
              }).toList();

              return Column(
                children: unseenNotifications.map((completeNotif) {
                  return _buildNotificationItem(completeNotif);
                }).toList(),
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ],
    ),
  );
}

Widget _buildNotificationItem(CompleteNotification completeNotification) {
  return Container(
    width: 900,
    padding: EdgeInsets.all(16),
    margin: EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: Colors.grey)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset('assets/profilePicture.svg'),
            ),
            SizedBox(width: 10),
            Container(
              height: 40,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(completeNotification.notification.title),
                  Text(formatTimestamp(completeNotification.notification.date)),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(completeNotification.notification.content),
        SizedBox(height: 10),
        _getTypeContainer(completeNotification),
      ],
    ),
  );
}

Widget _getTypeContainer(CompleteNotification completeNotification) {
  if (completeNotification.notification.type.type == 'post' && completeNotification.postData != null) {
    return _getPostOrCommentContainer(
      completeNotification.postData!.user,
      completeNotification.postData!.date,
      completeNotification.postData!.value,
    );
  }

  if (completeNotification.notification.type.type == 'comment' && completeNotification.commentData != null) {
    return _getPostOrCommentContainer(
      completeNotification.commentData!.user,
      completeNotification.commentData!.date,
      completeNotification.commentData!.value,
    );
  }

  if (completeNotification.notification.type.type == 'learning' && completeNotification.materialData != null) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Material: ${completeNotification.materialData!.title}"),
        Text("Description: ${completeNotification.materialData!.description}"),
        // ... You can display other material properties here ...
      ],
    );
  }

  switch (completeNotification.notification.type.type) {
    case 'challenge':
      return Container(
      );
    default:
      return Container();
  }
}

Future<MaterialData?> _fetchMaterialById(String classId, String materialId) async {
  try {
    ClassData classData = await fetchClass(classId);
    List<MaterialData> materials = await fetchMaterials(classData);
    for (MaterialData material in materials) {
        print(material.title);

      if (material.materialId == materialId) {
        return material;
      }
    }
    return null;
  } catch (e) {
    print('Error fetching material by ID: $e');
    throw Exception('Failed to fetch material');
  }
}

Widget _getPostOrCommentContainer(String user, Timestamp date, String value) {
  return Container(
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(user),
        SizedBox(height: 4),
        Text(formatTimestamp(date)),
        SizedBox(height: 4),
        Text(value),
      ],
    ),
  );
}

Future<PostsData?> _fetchPostById(String classId, String postId) async {
    try {
      ClassData classData = await fetchClass(classId);
      for (PostsData post in classData.posts) {
        if (post.id == postId) {
          return post;
        }
      }
      return null;
    } catch (e) {
      print('Error fetching post by ID: $e');
      throw Exception('Failed to fetch post');
    }
  }

  Future<CommentsData?> _fetchCommentById(String classId, String postId, String commentIndex) async {
    try {
      ClassData classData = await fetchClass(classId);
      for (PostsData post in classData.posts) {
        if (post.id == postId) {
          int idx = int.parse(commentIndex);
          if (idx < post.comments.length) {
            return post.comments[idx];
          }
        }
      }
      return null;
    } catch (e) {
      print('Error fetching comment by ID: $e');
      throw Exception('Failed to fetch comment');
    }
  }
}
