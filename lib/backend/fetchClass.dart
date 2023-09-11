import 'package:cloud_firestore/cloud_firestore.dart';

class CommentsAnswersData {
  Timestamp date;
  String user;
  String userId;
  String pfp;
  String value;
  bool award;
  CommentsAnswersData({
    required this.userId,
    required this.pfp,
    required this.award,
    required this.date,
    required this.user,
    required this.value,
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
  CommentsData({
    required this.award,
    required this.userId,
    required this.pfp,
    required this.answers,
    required this.date,
    required this.user,
    required this.value,
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
                date: answerItem['date'] as Timestamp? ?? Timestamp.now(),
                pfp: answerItem['pfp'] as String? ?? '',
                userId: answerItem['userId'] as String? ?? '',
                user: answerItem['user'] as String? ?? '',
                value: answerItem['value'] as String? ?? '',
              );
            }).toList();

            return CommentsData(
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
          List<dynamic> comments = posts[postIndex]['comments'];

          if (commentIndex >= 0 && commentIndex < comments.length) {
            // Check if answers list exists within the comment and create it if not
            if (comments[commentIndex]['answers'] == null) {
              comments[commentIndex]['answers'] = [];
            }

            // Append the new answer to the existing list of answers
            comments[commentIndex]['answers'].add({
              'date': answer.date,
              'user': answer.user,
              'userId': answer.userId,
              'pfp': answer.pfp,
              'value': answer.value,
              'award': answer.award,
            });

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

Future<void> toggleCommentAward(String classId, String postId, int commentIndex) async {
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

Future<void> toggleAnswerAward(String classId, String postId, int commentIndex, int answerIndex) async {
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

Future<void> addClass(String className, String school) async {
  try {
    // Reference to the Firestore collection where classes are stored
    CollectionReference classCollection = FirebaseFirestore.instance.collection('classes');

    // Create a new document with a generated ID
    DocumentReference newClassRef = classCollection.doc();

    // Create a ClassData instance with the provided name
    ClassData newClass = ClassData(
      name: className,
      capitolOrder: [0,1],
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

    print('Class added successfully with ID: ${newClassRef.id}');
  } catch (e) {
    print('Error adding class: $e');
    throw Exception('Failed to add class');
  }
}






