import 'package:cloud_firestore/cloud_firestore.dart';

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
