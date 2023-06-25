import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:infomentor/widgets/MaterialCardWidget.dart';
import 'package:infomentor/fetch.dart';

class Learning extends StatefulWidget {
  @override
  _LearningState createState() => _LearningState();
}

class _LearningState extends State<Learning> {
  bool showAll = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            ToggleButtons(
              children: [
                Text('Všetky'),
                Text('Uložené'),
              ],
              isSelected: [showAll, !showAll],
              onPressed: (index) {
                setState(() {
                  showAll = index == 0;
                });
              },
            ),
            Expanded(
              child: FutureBuilder<List<LearningData>>(
                future: fetchMaterials(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<LearningData> materials = snapshot.data!;

                    if (!showAll) {
                      // Fetch the user's data
                      return FutureBuilder<UserData>(
                        future: fetchUser(FirebaseAuth.instance.currentUser!.uid),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.hasData) {
                            UserData userData = userSnapshot.data!;
                            List<String> favoriteMaterialIds = userData.materials;

                            // Filter the materials that match the user's favorites
                            materials = materials
                                .where((material) =>
                                    favoriteMaterialIds.contains(material.materialId))
                                .toList();

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
                                  materialId: material.materialId,
                                );
                              },
                            );
                          } else if (userSnapshot.hasError) {
                            return Center(
                              child: Text('Error fetching user data'),
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      );
                    }

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
                          materialId: material.materialId,
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
          ],
        ),
      ),
    );
  }

  Future<List<LearningData>> fetchMaterials() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      String userId = user?.uid ?? '';

      // Reference to the "materials" collection in Firestore
      CollectionReference materialsRef = FirebaseFirestore.instance.collection('materials');

      // Retrieve the materials documents
      QuerySnapshot snapshot = await materialsRef.get();

      // Extract the data from the documents
      List<LearningData> materials = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String materialId = doc.id;

        return LearningData(
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
}

class LearningData {
  final String materialId;
  final String image;
  final String title;
  final String description;
  final String link;
  final String subject;
  final String type;
  final String association;
  final String video;

  LearningData({
    required this.materialId,
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
