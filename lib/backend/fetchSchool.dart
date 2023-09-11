import 'package:cloud_firestore/cloud_firestore.dart';

class SchoolData {
  String name;
  String admin;
  List<String> classes;

  SchoolData({
    required this.name,
    required this.admin,
    required this.classes,
  });
}

Future<SchoolData> fetchSchool(String schoolId) async {
  try {
    // Reference to the school document in Firestore
    DocumentReference schoolRef =
        FirebaseFirestore.instance.collection('schools').doc(schoolId);

    // Retrieve the school document
    DocumentSnapshot schoolSnapshot = await schoolRef.get();

    if (schoolSnapshot.exists) {
      // Extract the data from the school document
      final data = schoolSnapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        final classes = data['classes'] as List<dynamic>;

        return SchoolData(
          name: data['name'] as String? ?? '',
          admin: data['admin'] as String? ?? '',
          classes: classes.map((classId) => classId as String).toList(),
        );
      } else {
        throw Exception('Retrieved document data is null.');
      }
    } else {
      throw Exception('School document does not exist.');
    }
  } catch (e) {
    print('Error fetching school: $e');
    throw Exception('Failed to fetch school');
  }
}
