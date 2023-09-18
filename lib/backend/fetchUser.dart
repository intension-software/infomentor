import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserNotificationsData {
  String id;
  bool seen;

  UserNotificationsData({
    required this.id,
    required this.seen,
  });
}

class UserAnswerData {
  int? answer;
  int? index;

  UserAnswerData({
    required this.answer,
    required this.index
  });
}

class UserQuestionsData {
  List<UserAnswerData> answer;
  bool completed;
  List<bool> correct;

  UserQuestionsData({
    required this.answer,
    required this.completed,
    required this.correct
  });
}

class UserCapitolsData {
  String? id;
  String name;
  String image;
  bool completed;
  List<UserCapitolsTestData> tests;

  UserCapitolsData({
    this.id,
    required this.name,
    required this.image,
    required this.completed,
    required this.tests,
  });
}

class UserCapitolsTestData {
  String name;
  bool completed;
  int points;
  List<UserQuestionsData> questions;

  UserCapitolsTestData({
    required this.name,
    required this.completed,
    required this.points,
    required this.questions,
  });
}

class UserData {
  int discussionPoints;
  int weeklyDiscussionPoints;
  bool admin;
  String id;
  String email;
  String name;
  bool active;
  String school;
  List<String> classes;
  String schoolClass;
  String image;
  String surname;
  bool teacher;
  int points;
  List<UserCapitolsData> capitols;
  List<String> materials;
  List<String> badges;
  List<UserNotificationsData> notifications;

  UserData({
    required this.admin,
    required this.discussionPoints,
    required this.weeklyDiscussionPoints,
    required this.id,
    required this.email,
    required this.name,
    required this.active,
    required this.school,
    required this.classes,
    required this.schoolClass,
    required this.image,
    required this.surname,
    required this.teacher,
    required this.points,
    required this.capitols,
     required this.materials,
    required this.badges,
    required this.notifications
  });
}

Future<UserData> fetchUser(String userId) async {
  try {
    // Retrieve the Firebase Auth user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String id = userId;
      DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(userId);
      DocumentSnapshot userSnapshot = await userRef.get();

      if (userSnapshot.exists) {
        // Extracting the fields
        String email = userSnapshot.get('email') as String? ?? '';
        String name = userSnapshot.get('name') as String? ?? '';
        bool active = userSnapshot.get('active') as bool? ?? false;
        List<String> classes = List<String>.from(userSnapshot.get('classes') as List<dynamic>? ?? []);
        String school = userSnapshot.get('school') as String? ?? '';
        String schoolClass = userSnapshot.get('schoolClass') as String? ?? '';
        String image = userSnapshot.get('image') as String? ?? '';
        String surname = userSnapshot.get('surname') as String? ?? '';
        int points = userSnapshot.get('points') as int? ?? 0;
        int discussionPoints = userSnapshot.get('discussionPoints') as int? ?? 0;
        int weeklyDiscussionPoints = userSnapshot.get('weeklyDiscussionPoints') as int? ?? 0;
        List<Map<String, dynamic>> capitols = List<Map<String, dynamic>>.from(userSnapshot.get('capitols') as List<dynamic>? ?? []);
        List<String> materials = List<String>.from(userSnapshot.get('materials') as List<dynamic>? ?? []);
        List<String> badges = List<String>.from(userSnapshot.get('badges') as List<dynamic>? ?? []);
        bool teacher = userSnapshot.get('teacher') as bool? ?? false;
        bool admin = userSnapshot.get('admin') as bool? ?? false;

        // Extracting notifications data
        List<Map<String, dynamic>> rawNotifications = List<Map<String, dynamic>>.from(userSnapshot.get('notifications') as List<dynamic>? ?? []);
        List<UserNotificationsData> notificationsList = [];
        for (var notificationData in rawNotifications) {
          String notificationId = notificationData['id'] as String? ?? '';
          bool notificationSeen = notificationData['seen'] as bool? ?? false;

          UserNotificationsData notification = UserNotificationsData(
            id: notificationId,
            seen: notificationSeen,
          );

          notificationsList.add(notification);
        }

        UserData userData = UserData(
          admin: admin,
          discussionPoints: discussionPoints,
          weeklyDiscussionPoints: weeklyDiscussionPoints,
          id: id,
          email: email,
          name: name,
          active: active,
          school: school,
          classes: classes,
          schoolClass: schoolClass,
          image: image,
          surname: surname,
          teacher: teacher,
          points: points,
          capitols: [],
          materials: materials,
          badges: badges,
          notifications: notificationsList,
        );

        // Iterate over the capitols data
        for (var capitolData in capitols) {
          // Extract the values from the capitolData
          String capitolId = capitolData['id'] as String? ?? '';
          String capitolName = capitolData['name'] as String? ?? '';
          String capitolImage = capitolData['image'] as String? ?? '';
          bool capitolCompleted = capitolData['completed'] as bool? ?? false;

          // Access the "tests" list within the capitolData
          List<dynamic>? tests = capitolData['tests'] as List<dynamic>?;

          if (tests != null) {
            // Create a list to hold the UserCapitolsTestData instances
            List<UserCapitolsTestData> testsDataList = [];

            // Iterate over the tests data
            for (var testData in tests) {
              // Extract the test name, completion status, points, and questions
              String testName = testData['name'] as String? ?? '';
              bool testCompleted = testData['completed'] as bool? ?? false;
              int testPoints = testData['points'] as int? ?? 0;
              List<dynamic>? questions = testData['questions'] as List<dynamic>?;

              if (questions != null) {
                // Create a list to hold the UserQuestionsData instances
                List<UserQuestionsData> questionsDataList = [];

                // Iterate over the questions data
               for (var questionData in questions) {
              // Extract the question answer and completion status
                  bool questionCompleted = questionData['completed'] as bool? ?? false;
                  List<bool> questionCorrect = List<bool>.from(
                        questionData['correct'] as List<dynamic>? ?? []);

                  List<UserAnswerData> answersDataList = [];  // Initialized outside the if block

                  List<dynamic>? answers = questionData['answer'] as List<dynamic>?;

                  if (answers != null) {
                    for (var answerData in answers) {
                      int answer = answerData['answer'] as int? ?? 0;
                      int index = answerData['index'] as int? ?? 0;

                      UserAnswerData answerItem = UserAnswerData(
                        answer: answer,
                        index: index,
                      );
                      answersDataList.add(answerItem);
                    }
                  }

                  UserQuestionsData question = UserQuestionsData(
                    answer: answersDataList,
                    completed: questionCompleted,
                    correct: questionCorrect,
                  );

                  // Add the UserQuestionsData instance to the list
                  questionsDataList.add(question);
                }


                // Create a UserCapitolsTestData instance with the test name, completion status, points, and questions
                UserCapitolsTestData testData = UserCapitolsTestData(
                  name: testName,
                  completed: testCompleted,
                  points: testPoints,
                  questions: questionsDataList,  // Updated from questionsDataList
                );

                // Add the UserCapitolsTestData instance to the list
                testsDataList.add(testData);
              }
            }

            // Create a UserCapitolsData instance with the capitol id, name, image, completion status, and the list of tests
            UserCapitolsData capitolData = UserCapitolsData(
              id: capitolId,
              name: capitolName,
              image: capitolImage,
              completed: capitolCompleted,
              tests: testsDataList,
            );

            // Add the UserCapitolsData instance to the list
            userData.capitols.add(capitolData);
          }
        }

        return userData;
      } else {
        throw Exception('User document does not exist.');
      }
    } else {
      throw Exception('User is not logged in.');
    }
  } catch (e) {
    print('Error fetching user data: $e');
    rethrow;
  }
}


