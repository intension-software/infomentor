import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserQuestionsData {
  String answer;
  bool completed;
  bool correct;

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
  bool admin;
  String id;
  String email;
  String name;
  bool active;
  List<String> classes;
  String schoolClass;
  String image;
  String surname;
  bool teacher;
  int points;
  List<UserCapitolsData> capitols;
  List<String> materials;
  List<String> badges;

  UserData({
    required this.admin,
    required this.id,
    required this.email,
    required this.name,
    required this.active,
    required this.classes,
    required this.schoolClass,
    required this.image,
    required this.surname,
    required this.teacher,
    required this.points,
    required this.capitols,
     required this.materials,
    required this.badges,
  });
}

Future<UserData> fetchUser(String userId) async {
  try {
    // Retrieve the Firebase Auth user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Extract the email from the Firebase Auth user
      String id = userId;
      String email = user.email ?? '';

      // Reference to the user document in Firestore
      DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(userId);

      // Retrieve the user document
      DocumentSnapshot userSnapshot = await userRef.get();

      if (userSnapshot.exists) {
        // Extract the fields from the user document
        String name = userSnapshot.get('name') as String? ?? '';
        bool active = userSnapshot.get('active') as bool? ?? false;
        List<String> classes =
            List<String>.from(
                userSnapshot.get('classes') as List<dynamic>? ?? []);
        String schoolClass =
            userSnapshot.get('schoolClass') as String? ?? '';
        String image = userSnapshot.get('image') as String? ?? '';
        String surname = userSnapshot.get('surname') as String? ?? '';
        int points = userSnapshot.get('points') as int? ?? 0;
        List<Map<String, dynamic>> capitols =
            List<Map<String, dynamic>>.from(
                userSnapshot.get('capitols') as List<dynamic>? ?? []);
        List<String> materials =
            List<String>.from(
                userSnapshot.get('materials') as List<dynamic>? ?? []);
        List<String> badges =
            List<String>.from(
                userSnapshot.get('badges') as List<dynamic>? ?? []);
        bool teacher = userSnapshot.get('teacher') as bool? ?? false;
        bool admin = userSnapshot.get('admin') as bool? ?? false;

        // Create a UserData instance
        UserData userData = UserData(
          admin: admin,
          id: id,
          email: email,
          name: name,
          active: active,
          classes: classes,
          schoolClass: schoolClass,
          image: image,
          surname: surname,
          teacher: teacher,
          points: points,
          capitols: [],
          materials: materials,
          badges: badges,
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
                  String questionAnswer = questionData['answer'] as String? ?? '';
                  bool questionCompleted = questionData['completed'] as bool? ?? false;
                  bool questionCorrect = questionData['correct'] as bool? ?? false;

                  // Create a UserQuestionsData instance
                  UserQuestionsData question = UserQuestionsData(
                    answer: questionAnswer,
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


