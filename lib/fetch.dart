import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuestionsData {
  List<String> answers;
  List<String> answersImage;
  int correct;
  String definition;
  String explanation;
  String image;
  String question;
  String subQuestion;
  String title;

  QuestionsData({
    required this.answers,
    required this.answersImage,
    required this.correct,
    required this.definition,
    required this.explanation,
    required this.image,
    required this.question,
    required this.subQuestion,
    required this.title,
  });
}

class TestsData {
  String name;
  int points;
  List<QuestionsData> questions;

  TestsData({
    required this.name,
    required this.points,
    required this.questions,
  });
}

class CapitolsData {
  String name;
  int color;
  String badge;
  int points;
  List<TestsData> tests;

  CapitolsData({
    required this.name,
    required this.color,
    required this.badge,
    required this.points,
    required this.tests,
  });
}

class UserCapitolsData {
  String id;
  String name;
  String image;
  bool completed;
  List<UserCapitolsTestData> tests;

  UserCapitolsData({
    required this.id,
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
  List<bool> questions;

  UserCapitolsTestData({
    required this.name,
    required this.completed,
    required this.points,
    required this.questions,
  });
}

class UserData {
  String email;
  String name;
  bool active;
  String schoolClass;
  String image;
  String surname;
  int points;
  List<UserCapitolsData> capitols;
  List<String> materials;

  UserData({
    required this.email,
    required this.name,
    required this.active,
    required this.schoolClass,
    required this.image,
    required this.surname,
    required this.points,
    required this.capitols,
    required this.materials,
  });
}

class MaterialData {
  String materialId;
  String association;
  String description;
  String image;
  String link;
  String subject;
  String title;
  String type;
  String video;

  MaterialData({
    required this.materialId,
    required this.association,
    required this.description,
    required this.image,
    required this.link,
    required this.subject,
    required this.title,
    required this.type,
    required this.video,
  }) {
    if (image.isEmpty) {
      // If the image is empty, replace it with a placeholder image
      this.image = 'placeholder.png'; // Replace with the path to your placeholder image
    }
  }
}

class ClassData {
  String name;
  String school;
  List<String> students;
  String teacher;

  ClassData({
    required this.name,
    required this.school,
    required this.students,
    required this.teacher,
  });
}

class FetchResult {
  CapitolsData? capitolsData;

  FetchResult({this.capitolsData});
}

Future<FetchResult> fetchCapitols(String capitolsId) async {
  try {
    // Reference to the document in Firestore
    DocumentReference documentRef =
        FirebaseFirestore.instance.collection('capitols').doc(capitolsId);

    // Retrieve the document
    DocumentSnapshot snapshot = await documentRef.get();

    // Check if the document exists
    if (snapshot.exists) {
      // Access the data of the document
      Map<String, dynamic>? data =
          snapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        // Extract the values from the data
        String name = data['name'] as String? ?? '';
        int color = data['color'] as int;
        String badge = data['badge'] as String? ?? '';
        int points = data['points'] as int? ?? 0;

        // Access the "tests" list
        List<dynamic>? tests = data['tests'] as List<dynamic>?;

        if (tests != null) {
          // Create a list to hold the TestsData instances
          List<TestsData> testsDataList = [];

          // Iterate over the tests data
          for (var testData in tests) {
            // Extract the test name and points
            String testName = testData['name'] as String? ?? '';
            int testPoints = testData['points'] as int? ?? 0;

            // Access the "questions" list within the test data
            List<dynamic>? questions =
                testData['questions'] as List<dynamic>?;

            if (questions != null) {
              // Create a list to hold the QuestionsData instances
              List<QuestionsData> questionsDataList = [];

              // Iterate over the questions data
              for (var questionData in questions) {
                // Extract the values from the questionData
                List<String> answers = List<String>.from(
                    questionData['answers'] as List<dynamic>? ?? []);
                List<String> answersImage = List<String>.from(
                    questionData['answersImage'] as List<dynamic>? ?? []);
                int correct = questionData['correct'] as int? ?? 0;
                String definition = questionData['definition'] as String? ?? '';
                String explanation = questionData['explanation'] as String? ?? '';
                String image = questionData['image'] as String? ?? '';
                String question = questionData['question'] as String? ?? '';
                String subQuestion =
                    questionData['subQuestion'] as String? ?? '';
                String title = questionData['title'] as String? ?? '';

                // Create a QuestionsData instance with the extracted values
                QuestionsData questionsData = QuestionsData(
                  answers: answers,
                  answersImage: answersImage,
                  correct: correct,
                  definition: definition,
                  explanation: explanation,
                  image: image,
                  question: question,
                  subQuestion: subQuestion,
                  title: title,
                );

                // Add the QuestionsData instance to the list
                questionsDataList.add(questionsData);
              }

              // Create a TestsData instance with the test name, points, and the list of questions
              TestsData testData = TestsData(
                name: testName,
                points: testPoints,
                questions: questionsDataList,
              );

              // Add the TestsData instance to the list
              testsDataList.add(testData);
            }
          }

          // Create a CapitolsData instance with the name, badge, points, and the list of tests
          CapitolsData capitolsData = CapitolsData(
            name: name,
            color: color,
            badge: badge,
            points: points,
            tests: testsDataList,
          );

          // Create a FetchResult instance with capitolsData
          FetchResult result = FetchResult(
            capitolsData: capitolsData,
          );

          return result;
        } else {
          print('Tests do not exist.');
        }
      }
    } else {
      print('Document does not exist.');
    }
  } catch (e) {
    print('Error fetching document: $e');
  }

  // If the document retrieval fails or does not exist, return FetchResult with null capitolsData
  FetchResult result = FetchResult();
  return result;
}

Future<UserData> fetchUser(String userId) async {
  try {
    // Retrieve the Firebase Auth user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Extract the email from the Firebase Auth user
      String email = user.email ?? '';

      // Reference to the user document in Firestore
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(userId);

      // Retrieve the user document
      DocumentSnapshot userSnapshot = await userRef.get();

      if (userSnapshot.exists) {
        // Extract the fields from the user document
        String name = userSnapshot.get('name') as String? ?? '';
        bool active = userSnapshot.get('active') as bool? ?? false;
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

        // Create a UserData instance
        UserData userData = UserData(
          email: email,
          name: name,
          active: active,
          schoolClass: schoolClass,
          image: image,
          surname: surname,
          points: points,
          capitols: [],
          materials: materials,
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
                // Create a list to hold the questions completion status
                List<bool> questionsDataList = [];

                // Iterate over the questions data
                for (var questionData in questions) {
                  // Extract the question completion status
                  bool questionCompleted = questionData as bool? ?? false;

                  // Add the question completion status to the list
                  questionsDataList.add(questionCompleted);
                }

                // Create a UserCapitolsTestData instance with the test name, completion status, points, and questions
                UserCapitolsTestData testData = UserCapitolsTestData(
                  name: testName,
                  completed: testCompleted,
                  points: testPoints,
                  questions: questionsDataList,
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

Future<List<MaterialData>> fetchMaterials(UserData user) async {
  try {
    // Reference to the "materials" collection in Firestore
    CollectionReference materialsRef =
        FirebaseFirestore.instance.collection('materials');

    // Retrieve the materials documents
    QuerySnapshot snapshot = await materialsRef.get();

    // Extract the data from the documents
    List<MaterialData> materials = snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String materialId = doc.id;

      return MaterialData(
        materialId: materialId,
        image: data['image'] as String? ?? '',
        title: data['title'] as String? ?? '',
        description: data['description'] as String? ?? '',
        link: data['link'] as String? ?? '',
        subject: data['subject'] as String? ?? '',
        type: data['type'] as String? ?? '',
        association: data['association'] as String? ?? '',
        video: data['video'] as String? ?? '',
      );
    }).toList();

    // Filter the materials based on the favorited material IDs
    if (!user.materials.isEmpty) {
      materials = materials
          .where((material) => user.materials.contains(material.materialId))
          .toList();
    }

    return materials;
  } catch (e) {
    print('Error fetching materials: $e');
    throw Exception('Failed to fetch materials');
  }
}

Future<List<ClassData>> fetchClasses(String classId) async {
  try {
    // Reference to the user document in Firestore
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('classes').doc(classId);

    // Retrieve the user document
    DocumentSnapshot userSnapshot = await userRef.get();

    if (userSnapshot.exists) {
      // Extract the classes field from the user document
      List<Map<String, dynamic>> classes =
          List<Map<String, dynamic>>.from(
              userSnapshot.get('classes') as List<dynamic>? ?? []);

      // Create ClassData instances from the classes data
      List<ClassData> classDataList = classes.map((classItem) {
        return ClassData(
          name: classItem['name'] as String? ?? '',
          school: classItem['school'] as String? ?? '',
          students: List<String>.from(classItem['students'] as List<dynamic>? ?? []),
          teacher: classItem['teacher'] as String? ?? '',
        );
      }).toList();

      return classDataList;
    } else {
      throw Exception('User document does not exist.');
    }
  } catch (e) {
    print('Error fetching classes: $e');
    throw Exception('Failed to fetch classes');
  }
}
