import 'package:cloud_firestore/cloud_firestore.dart';

class CorrectData {
  int correct;
  int index;

  CorrectData({
    required this.correct,
    required this.index
  });
}

class DivisionData {
  String title;
  String text;

  DivisionData({
    required this.title,
    required this.text
  });
}

class QuestionsData {
  List<DivisionData>? division;
  List<String>? answers;
  List<String>? answersImage;
  List<String>? matchmaking;
  List<String>? matches;
  List<CorrectData>? correct;
  String? definition;
  List<String>? explanation;
  List<String>? images;
  String? question;
  String? subQuestion;
  String? title;
  

  QuestionsData({
    this.division,
    this.answers,
    this.answersImage,
    this.matchmaking,
    this.matches,
    this.correct,
    this.definition,
    this.explanation,
    this.images,
    this.question,
    this.subQuestion,
    this.title,
  });
}

class TestsData {
  String introduction;
  String name;
  int points;
  List<QuestionsData> questions;

  TestsData({
    required this.introduction,
    required this.name,
    required this.points,
    required this.questions,
  });
}

class CapitolsData {
  String name;
  String color;
  String badge;
  String badgeActive;
  String badgeDis;
  int points;
  List<TestsData> tests;
  int weeklyChallenge;

  CapitolsData({
    required this.name,
    required this.color,
    required this.badge,
    required this.badgeActive,
    required this.badgeDis,
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
        String color = data['color'] as String? ?? '';
        String badge = data['badge'] as String? ?? '';
        String badgeActive = data['badgeActive'] as String? ?? '';
        String badgeDis = data['badgeDis'] as String? ?? '';
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
            String testIntroduction = testData['introduction'] as String? ?? '';
            String testName = testData['name'] as String? ?? '';
            int testPoints = testData['points'] as int? ?? 0;

            // Access the "questions" list within the test data
            List<dynamic>? questions =
                testData['questions'] as List<dynamic>?;

            if (questions != null) {
              // Create a list to hold the QuestionsData instances
              List<QuestionsData> questionsDataList = [];

             for (var questionData in questions) {
              // Extract the values from the questionData
              List<String> answers = List<String>.from(
                  questionData['answers'] as List<dynamic>? ?? []);
              List<String> answersImage = List<String>.from(
                  questionData['answersImage'] as List<dynamic>? ?? []);
              List<String> matchmaking = List<String>.from(
                  questionData['matchmaking'] as List<dynamic>? ?? []);
              List<String> matches = List<String>.from(
                  questionData['matches'] as List<dynamic>? ?? []);
              String definition = questionData['definition'] as String? ?? '';
              List<String> explanation = List<String>.from(
                  questionData['explanation'] as List<dynamic>? ?? []);
              List<String> images = List<String>.from(
                  questionData['images'] as List<dynamic>? ?? []);
              String questionText = questionData['question'] as String? ?? '';
              String subQuestion =
                  questionData['subQuestion'] as String? ?? '';
              String title = questionData['title'] as String? ?? '';

              List<dynamic>? correct = 
                  questionData['correct'] as List<dynamic>?;
              
              List<dynamic>? division = 
                  questionData['division'] as List<dynamic>?;


              List<CorrectData> correctDataList = [];


              if (correct != null) {

                  for (var item in correct) {
                      CorrectData cData = CorrectData(
                          correct: item['correct'] as int,
                          index: item['index'] as int
                      );
                      correctDataList.add(cData);
                  }
              }

              List<DivisionData> divisionDataList = [];

              if (division != null) {

                  for (var item in division) {
                      DivisionData dData = DivisionData(
                          title: item['title'] as String,
                          text: item['text'] as String
                      );
                      divisionDataList.add(dData);
                  }
              }

              // Create a QuestionsData instance with the extracted values
              QuestionsData questionsData = QuestionsData(
                division: divisionDataList,
                answers: answers,
                answersImage: answersImage,
                matchmaking: matchmaking, // Add the extracted matchmaking data here
                matches: matches,
                correct: correctDataList,
                definition: definition,
                explanation: explanation,
                images: images,
                question: questionText,
                subQuestion: subQuestion,
                title: title,
              );

              // Add the QuestionsData instance to the list
              questionsDataList.add(questionsData);
          }

              // Create a TestsData instance with the test name, points, and the list of questions
              TestsData testData = TestsData(
                introduction: testIntroduction,
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
            badgeActive: badgeActive,
            badgeDis: badgeDis,
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