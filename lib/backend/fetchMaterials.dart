import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infomentor/backend/fetchClass.dart'; // Import the schoolClassData class and fetchschoolClass function

class MaterialData {
  String? materialId;
  String association;
  String description;
  String image;
  String link;
  String subject;
  String title;
  String type;
  String video;

  MaterialData({
    this.materialId,
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

Future<List<MaterialData>> fetchMaterials(ClassData schoolClass) async {
  try {
    // Reference to the "materials" collection in Firestore
    CollectionReference materialsRef =
        FirebaseFirestore.instance.collection('materials');

    // Only proceed if there are material IDs to look up
    if (schoolClass.materials.isEmpty) {
      return [];
    }

    // Construct a query to fetch only the materials whose IDs match those in the schoolClass's materials list
    Query materialsQuery = materialsRef.where(FieldPath.documentId, whereIn: schoolClass.materials);

    // Retrieve the materials documents
    QuerySnapshot snapshot = await materialsQuery.get();

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

    return materials;
  } catch (e) {
    print('Error fetching materials: $e');
    throw Exception('Failed to fetch materials');
  }
}


