import 'package:cloud_firestore/cloud_firestore.dart';

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

class FetchResult {
  DocumentData? documentData;
  int? documentCount;

  FetchResult({this.documentData, this.documentCount});
}

Future<FetchResult> fetchTests(String testId, int questionIndex) async {
  try {
    // Reference to the document in Firestore
    DocumentReference documentRef = FirebaseFirestore.instance.collection('tests').doc(testId);

    // Retrieve the document
    DocumentSnapshot snapshot = await documentRef.get();

    // Check if the document exists
    if (snapshot.exists) {
      // Access the data of the document
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        // Access the "questions" list
        List<dynamic>? questions = data['questions'] as List<dynamic>?;

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
            String subQuestion = questionData['subQuestion'] as String? ?? '';
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
