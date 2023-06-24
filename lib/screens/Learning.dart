import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infomentor/widgets/MaterialCardWidget.dart';

class Learning extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: FutureBuilder<List<LearningData>>(
          future: fetchMaterials(), // Call the function to fetch materials
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<LearningData> materials = snapshot.data!;

              return ListView.builder(
                itemCount: materials.length,
                itemBuilder: (context, index) {
                  LearningData material = materials[index];

                  return MaterialCardWidget(
                    image: material.image,
                    title: material.title,
                    description: material.description,
                    link: material.link,
                    subject: material.subject,
                    type: material.type,
                    association: material.association,
                    video: material.video,
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error fetching materials'),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }


  Future<List<LearningData>> fetchMaterials() async {
    try {
      // Reference to the "materials" collection in Firestore
      CollectionReference materialsRef =
          FirebaseFirestore.instance.collection('materials');

      // Retrieve the materials documents
      QuerySnapshot snapshot = await materialsRef.get();

      // Extract the data from the documents
      List<LearningData> materials = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        return LearningData(
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
}

class LearningData {
  final String image;
  final String title;
  final String description;
  final String link;
  final String subject;
  final String type;
  final String association;
  final String video;

  LearningData({
    required this.image,
    required this.title,
    required this.description,
    required this.link,
    required this.subject,
    required this.type,
    required this.association,
    required this.video,
  });
}
