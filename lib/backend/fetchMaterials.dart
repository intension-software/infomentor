import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infomentor/backend/fetchUser.dart'; // Import the UserData class and fetchUser function

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

