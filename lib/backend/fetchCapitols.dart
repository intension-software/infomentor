import 'package:cloud_firestore/cloud_firestore.dart';

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
  int colorLight;
  int colorLighter;
  String badge;
  int points;
  List<TestsData> tests;
  int weeklyChallenge;

  CapitolsData({
    required this.name,
    required this.color,
    required this.colorLight,
    required this.colorLighter,
    required this.badge,
    required this.points,
    required this.tests,
    required this.weeklyChallenge,
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
        int colorLight = data['color'] as int;
        int colorLighter = data['color'] as int;
        String badge = data['badge'] as String? ?? '';
        int points = data['points'] as int? ?? 0;
        int weeklyChallenge = data['weeklyChallenge'] as int? ?? 0;
        

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
            colorLight: colorLight,
            colorLighter: colorLighter,
            badge: badge,
            points: points,
            tests: testsDataList,
            weeklyChallenge: weeklyChallenge,
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