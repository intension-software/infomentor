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

Future<DocumentData?> fetchTests(String testId, String questionId) async {
  try {
    // Reference to the document in Firestore
    DocumentReference documentRef = FirebaseFirestore.instance
        .collection('tests')
        .doc(testId)
        .collection('questions')
        .doc(questionId);

    // Retrieve the document
    DocumentSnapshot snapshot = await documentRef.get();

    // Check if the document exists
    if (snapshot.exists) {
      // Access the data of the document
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        // Extract the values from the data
        List<String> answers =
            List<String>.from(data['answers'] as List<dynamic>? ?? []);
        List<String> answersImage =
            List<String>.from(data['answersImage'] as List<dynamic>? ?? []);
        int correct = data['correct'] as int? ?? 0;
        String definition = data['definition'] as String? ?? '';
        String image = data['image'] as String? ?? '';
        String question = data['question'] as String? ?? '';
        String subQuestion = data['subQuestion'] as String? ?? '';
        String title = data['title'] as String? ?? '';

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

        return documentData;
      }
    } else {
      print('Document does not exist.');
    }
  } catch (e) {
    print('Error fetching document: $e');
  }

  return null; // Return null if the document retrieval fails or does not exist
}
