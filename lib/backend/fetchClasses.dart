import 'package:cloud_firestore/cloud_firestore.dart';

class CommentsData {
  Timestamp date;
  bool like;
  String user;
  String value;
  CommentsData({
    required this.date,
    required this.like,
    required this.user,
    required this.value,
  });
}

class PostsData {
  List<CommentsData> comments;
  Timestamp date;
  String id;
  String user;
  String value;
  PostsData({
    required this.comments,
    required this.date,
    required this.id,
    required this.user,
    required this.value,
  });
}

class ClassData {
  String name;
  List<PostsData> posts;
  String school;
  List<String> students;
  String teacher;

  ClassData({
    required this.name,
    required this.posts,
    required this.school,
    required this.students,
    required this.teacher,
  });
}

Future<List<ClassData>> fetchClasses(String classId) async {
  try {
    // Reference to the class document in Firestore
    DocumentReference classRef =
        FirebaseFirestore.instance.collection('classes').doc(classId);

    // Retrieve the class document
    DocumentSnapshot classSnapshot = await classRef.get();

    if (classSnapshot.exists) {
      // Extract the classes field from the class document
      final data = classSnapshot.data() as Map<String, dynamic>?;

      if (data != null) {

        if (data.containsKey('posts')) { // Update field name to "posts"
          final posts = data['posts'] as List<dynamic>; // Update field name to "posts"

          // Create ClassData instances from the posts data
          List<ClassData> classDataList = posts.map((postItem) {
            List<Map<String, dynamic>> comments =
                List<Map<String, dynamic>>.from(
                    postItem['comments'] as List<dynamic>? ?? []);

            // Create CommentsData instances from the comments data
            List<CommentsData> commentsDataList = comments.map((commentItem) {
              return CommentsData(
                date: commentItem['date'] as Timestamp? ?? Timestamp.now(),
                like: commentItem['like'] as bool? ?? false,
                user: commentItem['user'] as String? ?? '',
                value: commentItem['value'] as String? ?? '',
              );
            }).toList();

            return ClassData(
              name: postItem['name'] as String? ?? '', // Update field name to "name"
              school: postItem['school'] as String? ?? '', // Update field name to "school"
              students: List<String>.from(postItem['students'] as List<dynamic>? ?? []),
              teacher: postItem['teacher'] as String? ?? '',
              posts: [
                PostsData(
                  comments: commentsDataList,
                  date: postItem['date'] as Timestamp? ?? Timestamp.now(),
                  id: postItem['id'] as String? ?? '',
                  user: postItem['user'] as String? ?? '',
                  value: postItem['value'] as String? ?? '',
                ),
              ],
            );
          }).toList();

          return classDataList;
        } else {
          throw Exception('Field "posts" does not exist in the class document.'); // Update field name to "posts"
        }
      } else {
        throw Exception('Retrieved document data is null.');
      }
    } else {
      throw Exception('Class document does not exist.');
    }
  } catch (e) {
    print('Error fetching classes: $e');
    throw Exception('Failed to fetch classes');
  }
}



Future<void> addComment(String classId, String postId, CommentsData comment) async {
  try {
    // Reference to the class document in Firestore
    DocumentReference classRef =
        FirebaseFirestore.instance.collection('classes').doc(classId);

    // Retrieve the class document
    DocumentSnapshot classSnapshot = await classRef.get();

    if (classSnapshot.exists) {
      // Extract the class data from the class document
      final classData = classSnapshot.data() as Map<String, dynamic>?;

      if (classData != null) {
        // Extract the posts field from the class data
        List<Map<String, dynamic>> posts =
            List<Map<String, dynamic>>.from(
                classData['posts'] as List<dynamic>? ?? []);

        print('Current posts: $posts');

        // Find the post with the matching postId
        int postIndex = posts.indexWhere((postItem) => postItem['id'] == postId);

        if (postIndex != -1) {
          // Add the comment to the post
          if (posts[postIndex]['comments'] == null) {
            posts[postIndex]['comments'] = [];
          }

          posts[postIndex]['comments'].add({
            'date': comment.date,
            'like': comment.like,
            'user': comment.user,
            'value': comment.value,
          });

          // Update the posts field within the class data
          classData['posts'] = posts;

          // Update the class document in Firestore
          await classRef.update(classData);

          return;
        } else {
          throw Exception('Invalid post ID.');
        }
      } else {
        throw Exception('Retrieved class data is null.');
      }
    } else {
      throw Exception('Class document does not exist.');
    }
  } catch (e) {
    print('Error adding comment: $e');
    throw Exception('Failed to add comment');
  }
}



Future<void> addPost(String classId, PostsData post) async {
  try {
    // Reference to the class document in Firestore
    DocumentReference classRef =
        FirebaseFirestore.instance.collection('classes').doc(classId);

    // Retrieve the class document
    DocumentSnapshot classSnapshot = await classRef.get();

    if (classSnapshot.exists) {
      // Extract the classes field from the class document
      List<Map<String, dynamic>> classes =
          List<Map<String, dynamic>>.from(
              classSnapshot.get('classes') as List<dynamic>? ?? []);

      // Find the class with the matching classId
      int classIndex = classes.indexWhere((classItem) => classItem['classId'] == classId);

      if (classIndex != -1) {
        // Add the post to the class
        classes[classIndex]['posts'].add({
          'comments': [],
          'date': FieldValue.serverTimestamp(),
          'user': post.user,
          'value': post.value,
        });

        // Update the class document in Firestore
        await classRef.update({'classes': classes});

        return;
      }
    }

    throw Exception('Class does not exist.');
  } catch (e) {
    print('Error adding post: $e');
    throw Exception('Failed to add post');
  }
}
