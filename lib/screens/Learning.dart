import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:infomentor/widgets/MaterialCardWidget.dart';
import 'package:infomentor/backend/fetchUser.dart';
import 'package:infomentor/backend/fetchClass.dart';


class Learning extends StatefulWidget {
  @override
  _LearningState createState() => _LearningState();
}

class _LearningState extends State<Learning> {
  bool showAll = true;
  UserData? currentUserData;

  Future<void> fetchUserData() async {
    try {
      // Retrieve the Firebase Auth user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Fetch the user data using the fetchUser function
        UserData userData = await fetchUser(user.uid);
        if (mounted) {
          setState(() {
            currentUserData = userData;
          });
        }
      } else {
        print('User is not logged in.');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  void dispose() {
    // Cancel timers or stop animations...

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( 
        child: Container(
        alignment: Alignment.center,
        width: 1300,
        child: Column(
          children: [
            ToggleButtons(
              children: [
                Text('All'),
                Text('Favorite'),
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
                      return FutureBuilder<ClassData>(
                        future: fetchClass(currentUserData!.schoolClass),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.hasData) {
                            ClassData classData = userSnapshot.data!;
                            List<String> favoriteMaterialIds = classData.materials;

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
    )
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