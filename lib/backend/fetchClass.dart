import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infomentor/backend/fetchSchool.dart';
import 'package:infomentor/widgets/ReWidgets.dart';
import 'package:infomentor/backend/userController.dart';
import 'package:infomentor/backend/fetchNotifications.dart';

class ClassDataWithId {
  final String id;
  final ClassData data;

  ClassDataWithId(this.id, this.data);
}

class CommentsAnswersData {
  Timestamp date;
  String user;
  String userId;
  String pfp;
  String value;
  bool award;
  bool teacher;
  CommentsAnswersData({
    required this.userId,
    required this.pfp,
    required this.award,
    required this.date,
    required this.user,
    required this.value,
    required this.teacher
  });
}

class CommentsData {
  List<CommentsAnswersData> answers;
  Timestamp date;
  String user;
  String userId;
  String pfp;
  String value;
  bool award;
  bool teacher;
  CommentsData({
    required this.award,
    required this.userId,
    required this.pfp,
    required this.answers,
    required this.date,
    required this.user,
    required this.value,
    required this.teacher
  });
}

class PostsData {
  List<CommentsData> comments;
  Timestamp date;
  String id;
  String user;
  String userId;
  String pfp;
  String value;
  PostsData({
    required this.comments,
    required this.userId,
    required this.pfp,
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
  List<String> teachers;
  List<String> materials;
  List<int> capitolOrder;

  ClassData({
    required this.name,
    required this.posts,
    required this.school,
    required this.students,
    required this.teachers,
    required this.materials,
    required this.capitolOrder,
  });
}

Future<ClassData> fetchClass(String classId) async {
  try {
    // Reference to the class document in Firestore
    DocumentReference classRef =
        FirebaseFirestore.instance.collection('classes').doc(classId);

    // Retrieve the class document
    DocumentSnapshot classSnapshot = await classRef.get();

    if (classSnapshot.exists) {
      // Extract the data from the class document
      final data = classSnapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        final posts = data['posts'] as List<dynamic>;

        // Create PostsData instances from the posts data
        List<PostsData> postsDataList = posts.map((postItem) {
          List<Map<String, dynamic>> comments =
              List<Map<String, dynamic>>.from(
                  postItem['comments'] as List<dynamic>? ?? []);

          // Create CommentsData instances from the comments data
          List<CommentsData> commentsDataList = comments.map((commentItem) {
            List<Map<String, dynamic>> answers =
                List<Map<String, dynamic>>.from(
                    commentItem['answers'] as List<dynamic>? ?? []);

            // Create CommentsAnswersData instances from the answers data
            List<CommentsAnswersData> answersDataList = answers.map((answerItem) {
              return CommentsAnswersData(
                award: answerItem['award'] as bool? ?? false,
                teacher: answerItem['teacher'] as bool? ?? false,
                date: answerItem['date'] as Timestamp? ?? Timestamp.now(),
                pfp: answerItem['pfp'] as String? ?? '',
                userId: answerItem['userId'] as String? ?? '',
                user: answerItem['user'] as String? ?? '',
                value: answerItem['value'] as String? ?? '',
              );
            }).toList();

            return CommentsData(
              teacher: commentItem['teacher'] as bool? ?? false,
              award: commentItem['award'] as bool? ?? false,
              answers: answersDataList,
              pfp: commentItem['pfp'] as String? ?? '',
              userId: commentItem['userId'] as String? ?? '',
              date: commentItem['date'] as Timestamp? ?? Timestamp.now(),
              user: commentItem['user'] as String? ?? '',
              value: commentItem['value'] as String? ?? '',
            );
          }).toList();

          return PostsData(
            comments: commentsDataList,
            date: postItem['date'] as Timestamp? ?? Timestamp.now(),
            id: postItem['id'] as String? ?? '',
            pfp: postItem['pfp'] as String? ?? '',
            userId: postItem['userId'] as String? ?? '',
            user: postItem['user'] as String? ?? '',
            value: postItem['value'] as String? ?? '',
          );
        }).toList();

        return ClassData(
          name: data['name'] as String? ?? '',
          school: data['school'] as String? ?? '',
          students: List<String>.from(data['students'] as List<dynamic>? ?? []),
          teachers: List<String>.from(data['teachers'] as List<dynamic>? ?? []),
          posts: postsDataList,
          materials: List<String>.from(data['materials'] as List<dynamic>? ?? []),
          capitolOrder: List<int>.from(data['capitolOrder'] as List<dynamic>? ?? []),
        );
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

Future<List<ClassData>> fetchClasses(List<String> classIds) async {
  List<ClassData> classes = [];
  for (String id in classIds) {
    try {
      ClassData classData = await fetchClass(id);
      classes.add(classData);
    } catch (e) {
      print('Error fetching class data for id $id: $e');
    }
  }
  return classes;
}

Future<void> editClass(String classId, ClassData newClassData) async {
  try {
    // Reference to the class document in Firestore
    DocumentReference classRef =
        FirebaseFirestore.instance.collection('classes').doc(classId);

    // Convert the newClassData object to a Map
    Map<String, dynamic> classDataMap = {
      'name': newClassData.name,
      'school': newClassData.school,
      'students': newClassData.students,
      'teachers': newClassData.teachers,
      'materials': newClassData.materials,
      'capitolOrder': newClassData.capitolOrder,
      'posts': newClassData.posts.map((post) {
        return {
          'date': post.date,
          'id': post.id,
          'pfp': post.pfp,
          'userId': post.userId,
          'user': post.user,
          'value': post.value,
          'comments': post.comments.map((comment) {
            return {
              'award': comment.award,
              'date': comment.date,
              'pfp': comment.pfp,
              'userId': comment.userId,
              'user': comment.user,
              'value': comment.value,
              'answers': comment.answers.map((answer) {
                return {
                  'award': answer.award,
                  'date': answer.date,
                  'pfp': answer.pfp,
                  'userId': answer.userId,
                  'user': answer.user,
                  'value': answer.value,
                };
              }).toList(),
            };
          }).toList(),
        };
      }).toList(),
    };

    // Update the class document with the new data
    await classRef.update(classDataMap);
  } catch (e) {
    print('Error editing class: $e');
    throw Exception('Failed to edit class');
  }
}

Future<void> deleteClass(String classId, String school, void Function(String)? removeSchoolData) async {
  try {
    // Reference to the class document in Firestore
    DocumentReference classRef =
        FirebaseFirestore.instance.collection('classes').doc(classId);

    // Retrieve the class document
    DocumentSnapshot classSnapshot = await classRef.get();

    if (classSnapshot.exists) {
      // Delete the class document
      await classRef.delete();

      // Remove the class from the school's classes list
      await removeClassFromSchool(classId, school);

      if (removeSchoolData != null) removeSchoolData(classId);

      print('Class deleted successfully with ID: $classId');
    } else {
      throw Exception('Class document does not exist.');
    }
  } catch (e) {
    print('Error deleting class: $e');
    throw Exception('Failed to delete class');
  }
}

Future<void> removeClassFromSchool(String classId, String school) async {
  try {
    // Reference to the school document in Firestore
    DocumentReference schoolRef =
        FirebaseFirestore.instance.collection('schools').doc(school);

    // Retrieve the school document
    DocumentSnapshot schoolSnapshot = await schoolRef.get();

    if (schoolSnapshot.exists) {
      // Extract the school data from the school document
      final schoolData = schoolSnapshot.data() as Map<String, dynamic>?;

      if (schoolData != null) {
        // Extract the classes field from the school data
        List<String> classes =
            List<String>.from(schoolData['classes'] as List<dynamic>? ?? []);

        // Remove the classId from the classes list
        classes.remove(classId);

        // Update the classes field within the school data
        schoolData['classes'] = classes;

        // Update the school document in Firestore
        await schoolRef.update(schoolData);

      } else {
        throw Exception('Retrieved school data is null.');
      }
    } else {
      throw Exception('School document does not exist.');
    }
  } catch (e) {
    print('Error removing class from school: $e');
    throw Exception('Failed to remove class from school');
  }
}



Future<void> addComment(String classId, String postId, CommentsData comment, ) async {
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

        int postIndex = posts.indexWhere((postItem) => postItem['id'] == postId);

        if (postIndex != -1) {
          // Add the comment to the post
          if (posts[postIndex]['comments'] == null) {
            posts[postIndex]['comments'] = [];
          }

          List<Map<String, dynamic>> comments =
              List<Map<String, dynamic>>.from(posts[postIndex]['comments'] as List<dynamic>? ?? []);

          comments.add({
            'award': false,
            'teacher': comment.teacher,
            'date': comment.date,
            'user': comment.user,
            'userId': comment.userId,
            'pfp': comment.pfp,
            'value': comment.value,
            'answers': <Map<String, dynamic>>[],
          });

          // Update the comments field within the post data
          posts[postIndex]['comments'] = comments;

          // Update the posts field within the class data
          classData['posts'] = posts;

          // Update the class document in Firestore
          await classRef.update(classData);

          sendNotification([comment.userId] , 'Na váš príspevok niekto odpovedal.', 'Diskusia', TypeData(
          id: postId,
            commentIndex: (posts[postIndex]['comments'].length-1).toString(),
            answerIndex: '',
            type: 'post'
          ));

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

Future<void> addAnswer(String classId, String postId, int commentIndex, CommentsAnswersData answer) async {
  try {
    // Reference to the class document in Firestore
    DocumentReference classRef = FirebaseFirestore.instance.collection('classes').doc(classId);

    // Retrieve the class document
    DocumentSnapshot classSnapshot = await classRef.get();

    if (classSnapshot.exists) {
      final classData = classSnapshot.data() as Map<String, dynamic>?;

      if (classData != null) {
        List<Map<String, dynamic>> posts = List<Map<String, dynamic>>.from(classData['posts'] ?? []);

        int postIndex = posts.indexWhere((postItem) => postItem['id'] == postId);

        if (postIndex != -1) {
          List<dynamic> comments = posts[postIndex]['comments'];

          if (commentIndex >= 0 && commentIndex < comments.length) {
            // Initialize answers list if it doesn't exist
            if (comments[commentIndex]['answers'] == null) {
              comments[commentIndex]['answers'] = [];
            }

            // Add the answer
            Map<String, dynamic> answerData = {
              'date': answer.date,
              'user': answer.user,
              'userId': answer.userId,
              'pfp': answer.pfp,
              'value': answer.value,
              'award': answer.award,
              'teacher': answer.teacher,
            };
            comments[commentIndex]['answers'].add(answerData);

            // Get the index of the new answer
            int newAnswerIndex = comments[commentIndex]['answers'].length - 1;

            // Update the comments field within the post data
            posts[postIndex]['comments'] = comments;

            // Update the posts field within the class data
            classData['posts'] = posts;

            // Update the class document in Firestore
            await classRef.update(classData);

            // Send the notification with the correct answerIndex
            sendNotification(
              [answer.userId],
              'Na váš komentár niekto odpovedal.',
              'Diskusia',
              TypeData(
                id: postId,
                commentIndex: commentIndex.toString(),
                answerIndex: newAnswerIndex.toString(), // Correct index
                type: 'answer'
              )
            );

            return;
          } else {
            throw Exception('Invalid comment index.');
          }
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
    print('Error adding answer: $e');
    throw Exception('Failed to add answer');
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
      // Extract the data from the class document
      Map<String, dynamic> classData = classSnapshot.data() as Map<String, dynamic>;

      if (classData != null) {
        // Extract the posts field from the class data
        List<Map<String, dynamic>> posts =
            List<Map<String, dynamic>>.from(classData['posts'] as List<dynamic>? ?? []);

        // Add the new post to the posts list
        posts.add({
          'comments': post.comments.map((comment) => {
            'date': comment.date,
            'user': comment.user,
            'userId': comment.userId,
            'pfp': comment.pfp,
            'value': comment.value
          }).toList(),
          'userId': post.userId,
          'pfp': post.pfp,
          'date': post.date,
          'id': post.id,
          'user': post.user,
          'value': post.value,
        });

        // Update the posts field within the class data
        classData['posts'] = posts;

        // Update the class document in Firestore
        await classRef.update(classData);

        List<String> studentIds = List<String>.from(classData['students'] as List<dynamic>);

        sendNotification(studentIds , 'Nový príspevok od učiteľa', 'Diskusia', TypeData(
          id: (posts.length - 1).toString(),
          commentIndex: '',
          answerIndex: '',
          type: 'post'
        ));

        return;
      } else {
        throw Exception('Retrieved class data is null.');
      }
    } else {
      throw Exception('Class document does not exist.');
    }
  } catch (e) {
    print('Error adding post: $e');
    throw Exception('Failed to add post');
  }
}

Future<void> updateCommentValue(String classId, String postId, int commentIndex, String updatedValue) async {
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

        // Find the post with the matching postId
        int postIndex = posts.indexWhere((postItem) => postItem['id'] == postId);

        if (postIndex != -1) {
          // Find the comment with the matching commentIndex
          List<Map<String, dynamic>> comments =
              List<Map<String, dynamic>>.from(
                  posts[postIndex]['comments'] as List<dynamic>? ?? []);
          if (commentIndex >= 0 && commentIndex < comments.length) {
            // Update the 'value' field of the comment at the found index
            comments[commentIndex]['value'] = updatedValue;

            // Update the posts field within the class data
            classData['posts'] = posts;

            // Update the class document in Firestore
            await classRef.update(classData);

            return;
          } else {
            throw Exception('Invalid comment index.');
          }
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
    print('Error updating comment value: $e');
    throw Exception('Failed to update comment value');
  }
}

Future<void> updateAnswerValue(String classId, String postId, int commentIndex, int answerIndex, String updatedValue) async {
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

        // Find the post with the matching postId
        int postIndex = posts.indexWhere((postItem) => postItem['id'] == postId);

        if (postIndex != -1) {
          // Find the comment with the matching commentIndex
          List<dynamic> comments =
              List<dynamic>.from(
                  posts[postIndex]['comments'] as List<dynamic>? ?? []);
          if (commentIndex >= 0 && commentIndex < comments.length) {
            // Find the answer with the matching answerIndex
            List<Map<String, dynamic>> answers = List<Map<String, dynamic>>.from(
              comments[commentIndex]['answers'] as List<dynamic>? ?? [],
            );
            if (answerIndex >= 0 && answerIndex < answers.length) {
              // Update the 'value' field of the answer at the found index
              answers[answerIndex]['value'] = updatedValue;

              // Update the posts field within the class data
              classData['posts'] = posts;

              // Update the class document in Firestore
              await classRef.update(classData);

              return;
            } else {
              throw Exception('Invalid answer index.');
            }
          } else {
            throw Exception('Invalid comment index.');
          }
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
    print('Error updating answer value: $e');
    throw Exception('Failed to update answer value');
  }
}


Future<void> updatePostValue(String classId, String postId, String updatedValue) async {
  try {
    // Reference to the class document in Firestore
    DocumentReference classRef =
        FirebaseFirestore.instance.collection('classes').doc(classId);

    // Retrieve the class document
    DocumentSnapshot classSnapshot = await classRef.get();

    if (classSnapshot.exists) {
      // Extract the data from the class document
      Map<String, dynamic> classData = classSnapshot.data() as Map<String, dynamic>;

      if (classData != null) {
        // Extract the posts field from the class data
        List<Map<String, dynamic>> posts =
            List<Map<String, dynamic>>.from(classData['posts'] as List<dynamic>? ?? []);

        // Find the index of the post to be updated
        int postIndex = posts.indexWhere((postItem) => postItem['id'] == postId);

        if (postIndex != -1) {
          // Update the 'value' field of the post at the found index
          posts[postIndex]['value'] = updatedValue;

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
    print('Error updating post value: $e');
    throw Exception('Failed to update post value');
  }
}


Future<void> deletePost(String classId, String postId) async {
  try {
    // Reference to the class document in Firestore
    DocumentReference classRef =
        FirebaseFirestore.instance.collection('classes').doc(classId);

    // Retrieve the class document
    DocumentSnapshot classSnapshot = await classRef.get();

    if (classSnapshot.exists) {
      // Extract the data from the class document
      Map<String, dynamic> classData = classSnapshot.data() as Map<String, dynamic>;

      if (classData != null) {
        // Extract the posts field from the class data
        List<Map<String, dynamic>> posts =
            List<Map<String, dynamic>>.from(classData['posts'] as List<dynamic>? ?? []);

        // Find the index of the post to be deleted
        int postIndex = posts.indexWhere((postItem) => postItem['id'] == postId);

        if (postIndex != -1) {
          // Remove the post from the list
          posts.removeAt(postIndex);

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
    print('Error deleting post: $e');
    throw Exception('Failed to delete post');
  }
}

Future<void> deleteComment(String classId, String postId, int commentIndex) async {
  try {
    // Reference to the class document in Firestore
    DocumentReference classRef =
        FirebaseFirestore.instance.collection('classes').doc(classId);

    // Retrieve the class document
    DocumentSnapshot classSnapshot = await classRef.get();

    if (classSnapshot.exists) {
      // Extract the data from the class document
      Map<String, dynamic> classData = classSnapshot.data() as Map<String, dynamic>;

      if (classData != null) {
        // Extract the posts field from the class data
        List<Map<String, dynamic>> posts =
            List<Map<String, dynamic>>.from(classData['posts'] as List<dynamic>? ?? []);

        // Find the index of the post to be deleted
        int postIndex = posts.indexWhere((postItem) => postItem['id'] == postId);

        if (postIndex != -1) {
          // Find the comment with the matching commentIndex
          List<Map<String, dynamic>> comments =
              List<Map<String, dynamic>>.from(
                  posts[postIndex]['comments'] as List<dynamic>? ?? []);

          if (commentIndex >= 0 && commentIndex < comments.length) {
            // Remove the comment from the list
            comments.removeAt(commentIndex);

            // Update the comments field within the post data
            posts[postIndex]['comments'] = comments;

            // Update the posts field within the class data
            classData['posts'] = posts;

            // Update the class document in Firestore
            await classRef.update(classData);

            return;
          } else {
            throw Exception('Invalid comment index.');
          }
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
    print('Error deleting comment: $e');
    throw Exception('Failed to delete comment');
  }
}

Future<void> deleteAnswer(String classId, String postId, int commentIndex, int answerIndex) async {
  try {
    // Reference to the class document in Firestore
    DocumentReference classRef = FirebaseFirestore.instance.collection('classes').doc(classId);

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

        // Find the post with the matching postId
        int postIndex = posts.indexWhere((postItem) => postItem['id'] == postId);

        if (postIndex != -1) {
          // Find the comment with the matching commentIndex
          List<dynamic> comments =
              List<dynamic>.from(
                  posts[postIndex]['comments'] as List<dynamic>? ?? []);
          if (commentIndex >= 0 && commentIndex < comments.length) {
            // Find the answer with the matching answerIndex
            List<Map<String, dynamic>> answers = List<Map<String, dynamic>>.from(
              comments[commentIndex]['answers'] as List<dynamic>? ?? [],
            );
            if (answerIndex >= 0 && answerIndex < answers.length) {
              // Remove the answer from the list
              answers.removeAt(answerIndex);

              // Update the answers field within the comment data
              comments[commentIndex]['answers'] = answers;

              // Update the comments field within the post data
              posts[postIndex]['comments'] = comments;

              // Update the posts field within the class data
              classData['posts'] = posts;

              // Update the class document in Firestore
              await classRef.update(classData);

              return;
            } else {
              throw Exception('Invalid answer index.');
            }
          } else {
            throw Exception('Invalid comment index.');
          }
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
    print('Error deleting answer: $e');
    throw Exception('Failed to delete answer');
  }
}

Future<void> toggleCommentAward(String classId, String postId, int commentIndex, String userId) async {
  try {
    // Reference to the class document in Firestore
    DocumentReference classRef = FirebaseFirestore.instance.collection('classes').doc(classId);

    // Retrieve the class document
    DocumentSnapshot classSnapshot = await classRef.get();

    if (classSnapshot.exists) {
      // Extract the class data from the class document
      final classData = classSnapshot.data() as Map<String, dynamic>?;

      if (classData != null) {
        // Extract the posts field from the class data
        List<Map<String, dynamic>> posts = List<Map<String, dynamic>>.from(
          classData['posts'] as List<dynamic>? ?? [],
        );

        // Find the post with the matching postId
        int postIndex = posts.indexWhere((postItem) => postItem['id'] == postId);

        if (postIndex != -1) {
          // Find the comment with the matching commentIndex
          List<Map<String, dynamic>> comments = List<Map<String, dynamic>>.from(
            posts[postIndex]['comments'] as List<dynamic>? ?? [],
          );

          if (commentIndex >= 0 && commentIndex < comments.length) {
            // Toggle the 'award' field of the comment at the found index
            comments[commentIndex]['award'] = !(comments[commentIndex]['award'] ?? false);

            // Update the posts field within the class data
            classData['posts'] = posts;

            // Update the class document in Firestore
            await classRef.update(classData);
            await incrementDiscussionPoints(userId, 1, comments[commentIndex]['award']);

            return;
          } else {
            throw Exception('Invalid comment index.');
          }
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
    print('Error toggling comment award: $e');
    throw Exception('Failed to toggle comment award');
  }
}

Future<void> toggleAnswerAward(String classId, String postId, int commentIndex, int answerIndex, String userId) async {
  try {
    // Reference to the class document in Firestore
    DocumentReference classRef = FirebaseFirestore.instance.collection('classes').doc(classId);

    // Retrieve the class document
    DocumentSnapshot classSnapshot = await classRef.get();

    if (classSnapshot.exists) {
      // Extract the class data from the class document
      final classData = classSnapshot.data() as Map<String, dynamic>?;

      if (classData != null) {
        // Extract the posts field from the class data
        List<Map<String, dynamic>> posts = List<Map<String, dynamic>>.from(
          classData['posts'] as List<dynamic>? ?? [],
        );

        // Find the post with the matching postId
        int postIndex = posts.indexWhere((postItem) => postItem['id'] == postId);

        if (postIndex != -1) {
          // Find the comment with the matching commentIndex
          List<Map<String, dynamic>> comments = List<Map<String, dynamic>>.from(
            posts[postIndex]['comments'] as List<dynamic>? ?? [],
          );

          if (commentIndex >= 0 && commentIndex < comments.length) {
            // Find the answer with the matching answerIndex
            List<Map<String, dynamic>> answers = List<Map<String, dynamic>>.from(
              comments[commentIndex]['answers'] as List<dynamic>? ?? [],
            );

            if (answerIndex >= 0 && answerIndex < answers.length) {
              // Toggle the 'award' field of the answer at the found index
              answers[answerIndex]['award'] = !(answers[answerIndex]['award'] ?? false);

              // Update the posts field within the class data
              classData['posts'] = posts;

                await incrementDiscussionPoints(userId, -1, answers[answerIndex]['award']);

              // Update the class document in Firestore
              await classRef.update(classData);

              return;
            } else {
              throw Exception('Invalid answer index.');
            }
          } else {
            throw Exception('Invalid comment index.');
          }
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
    print('Error toggling answer award: $e');
    throw Exception('Failed to toggle answer award');
  }
}

Future<void> addClass(String className, String school, void Function(ClassDataWithId)? addSchoolData, String? adminId) async {
  try {
    // Reference to the Firestore collection where classes are stored
    CollectionReference classCollection = FirebaseFirestore.instance.collection('classes');

    // Create a new document with a generated ID
    DocumentReference newClassRef = classCollection.doc();

    // Create a ClassData instance with the provided name
    ClassData newClass = ClassData(
      name: className,
      capitolOrder: [0,1,2,3,4,5,6],
      materials: [],
      posts: [],
      school: school,
      students: [],
      teachers: [],
    );

    // Convert the ClassData instance to a Map
    Map<String, dynamic> classData = {
      'name': newClass.name,
      'capitolOrder': newClass.capitolOrder,
      'materials': newClass.materials,
      'posts': newClass.posts,
      'school': newClass.school,
      'students': newClass.students,
      'teachers': newClass.teachers,
    };

    // Add the class data to Firestore
    await newClassRef.set(classData);

    addClassToSchool(newClassRef.id, school);

    if(adminId != null) updateClasses(adminId, newClassRef.id);
    
    if (addSchoolData != null) addSchoolData(ClassDataWithId(newClassRef.id, newClass));
    print('Class added successfully with ID: ${newClassRef.id}');
  } catch (e) {
    print('Error adding class: $e');
    throw Exception('Failed to add class');
  }
}






