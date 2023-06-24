import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DocumentData {
  List<String> answers;
  List<String> answersImage;
  int correct;
  String definition;
  String image;
  String question;
  String subQuestion;
  String title;

  DocumentData({
    required this.answers,
    required this.answersImage,
    required this.correct,
    required this.definition,
    required this.image,
    required this.question,
    required this.subQuestion,
    required this.title,
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
  List<Map<String, dynamic>> capitols;

  UserData({
    required this.email,
    required this.name,
    required this.active,
    required this.schoolClass,
    required this.image,
    required this.surname,
    required this.points,
    required this.capitols,
  });
}

class MaterialData {
  String association;
  String description;
  String image;
  String link;
  String subject;
  String title;
  String type;
  String video;

  MaterialData({
    required this.association,
    required this.description,
    required this.image,
    required this.link,
    required this.subject,
    required this.title,
    required this.type,
    required this.video,
  });
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
  DocumentData? documentData;
  int? documentCount;

  FetchResult({this.documentData, this.documentCount});
}

Future<FetchResult> fetchTests(String testId, int questionIndex) async {
  try {
    // Reference to the document in Firestore
    DocumentReference documentRef =
        FirebaseFirestore.instance.collection('tests').doc(testId);

    // Retrieve the document
    DocumentSnapshot snapshot = await documentRef.get();

    // Check if the document exists
    if (snapshot.exists) {
      // Access the data of the document
      Map<String, dynamic>? data =
          snapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        // Access the "questions" list
        List<dynamic>? questions =
            data['questions'] as List<dynamic>?;

        if (questions != null && questionIndex < questions.length) {
          // Access the question data using the questionIndex
          Map<String, dynamic>? questionData =
              questions[questionIndex] as Map<String, dynamic>?;

          if (questionData != null) {
            // Extract the values from the questionData
            List<String> answers = List<String>.from(
                questionData['answers'] as List<dynamic>? ?? []);
            List<String> answersImage = List<String>.from(
                questionData['answersImage'] as List<dynamic>? ?? []);
            int correct = questionData['correct'] as int? ?? 0;
            String definition = questionData['definition'] as String? ?? '';
            String image = questionData['image'] as String? ?? '';
            String question = questionData['question'] as String? ?? '';
            String subQuestion =
                questionData['subQuestion'] as String? ?? '';
            String title = questionData['title'] as String? ?? '';

            // Create a DocumentData instance
            DocumentData documentData = DocumentData(
              answers: answers,
              answersImage: answersImage,
              correct: correct,
              definition: definition,
              image: image,
              question: question,
              subQuestion: subQuestion,
              title: title,
            );

            // Create a FetchResult instance with documentData and documentCount
            FetchResult result = FetchResult(
              documentData: documentData,
              documentCount: questions.length,
            );

            return result;
          }
        } else {
          print('Question does not exist.');
        }
      }
    } else {
      print('Document does not exist.');
    }
  } catch (e) {
    print('Error fetching document: $e');
  }

  // If the document retrieval fails or does not exist, return FetchResult with null documentData and null documentCount
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

        // Create a UserData instance
        UserData userData = UserData(
          email: email,
          name: name,
          active: active,
          schoolClass: schoolClass,
          image: image,
          surname: surname,
          points: points,
          capitols: capitols,
        );

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

Future<List<MaterialData>> fetchMaterials(String classId) async {
  try {
    // Reference to the class document in Firestore
    DocumentReference classRef =
        FirebaseFirestore.instance.collection('classes').doc(classId);

    // Retrieve the class document
    DocumentSnapshot classSnapshot = await classRef.get();

    if (classSnapshot.exists) {
      // Extract the materials field from the class document
      List<Map<String, dynamic>> materials =
          List<Map<String, dynamic>>.from(
              classSnapshot.get('materials') as List<dynamic>? ?? []);

      // Create MaterialData instances from the materials data
      List<MaterialData> materialDataList = materials.map((material) {
        String image = material['image'] as String? ?? '';
        if (image.isEmpty) {
          // If the image is empty, replace it with a placeholder image
          image = 'placeholder.png'; // Replace with the path to your placeholder image
        }

        return MaterialData(
          association: material['association'] as String? ?? '',
          description: material['description'] as String? ?? '',
          image: image,
          link: material['link'] as String? ?? '',
          subject: material['subject'] as String? ?? '',
          title: material['title'] as String? ?? '',
          type: material['type'] as String? ?? '',
          video: material['video'] as String? ?? '',
        );
      }).toList();

      return materialDataList;
    } else {
      throw Exception('Class document does not exist.');
    }
  } catch (e) {
    print('Error fetching materials: $e');
    rethrow;
  }
}

Future<List<ClassData>> fetchClasses(String userId) async {
  try {
    // Reference to the user document in Firestore
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

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
    rethrow;
  }
}
