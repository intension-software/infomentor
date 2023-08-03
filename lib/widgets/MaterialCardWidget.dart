import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:infomentor/backend/fetchUser.dart'; // Import the UserData class and fetchUser function
import 'package:infomentor/Colors.dart';
import 'package:infomentor/backend/fetchClass.dart';


class MaterialCardWidget extends StatefulWidget {
  final String materialId;
  final String image;
  final String title;
  final String subject;
  final String type;
  final String description;
  final String association;
  final String link;
  final String video;

  MaterialCardWidget({
    required this.materialId,
    required this.image,
    required this.title,
    required this.subject,
    required this.type,
    required this.description,
    required this.association,
    required this.link,
    required this.video,
  });

  @override
  _MaterialCardWidgetState createState() => _MaterialCardWidgetState();
}

class _MaterialCardWidgetState extends State<MaterialCardWidget> {
  bool isHeartFilled = false;
  ClassData? classData;
  String? userId;
  

  @override
  void initState() {
    super.initState();
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      userId = currentUser.uid;
      fetchClass(userId!).then((schoolClass) {
        setState(() {
          classData = schoolClass;
          isHeartFilled = classData!.materials.contains(widget.materialId);
        });
      });
    }
  }

  @override
  void dispose() {
    // Cancel timers or stop animations...
  
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String imageAsset = widget.image.isEmpty ? 'assets/placeholder.png' : widget.image;

    return MouseRegion(
         cursor: SystemMouseCursors.click,
         child: GestureDetector(
        onTap: () {
          _showOverlay(context);
        },
        child: Container(
          margin: EdgeInsets.all(12),
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage(imageAsset),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.all(8),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20), // Adjust spacing from the top for the text
                        Text(
                          widget.title,
                          style: TextStyle(
                            color: AppColors.mono.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          widget.subject,
                          style: TextStyle(
                            color: AppColors.mono.white,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          widget.type,
                          style: TextStyle(
                            color: AppColors.mono.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.mono.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Text(
                    widget.type,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        isHeartFilled ? Icons.favorite : Icons.favorite_outline,
                        color: AppColors.mono.white,
                      ),
                      onPressed: () {
                        toggleFavorite();
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.link,
                        color: AppColors.mono.white,
                      ),
                      onPressed: () {
                        _launchURL(widget.link);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  void _showOverlay(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: AppColors.mono.white, // Set the overlay background color
          appBar: AppBar(
            backgroundColor: AppColors.mono.white, // Set the appbar background color
            elevation: 0, // Remove the appbar elevation
            leading: SizedBox(
              height: 30, // Set the height of the button
              width: 60, // Set the width of the button
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                color: AppColors.mono.lightGrey, // Set the color of the back button to black
                onPressed: () {
                  Navigator.of(context).pop(); // Navigate back when the back button is pressed
                },
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.subject,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.type,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.description,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.association,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      InkWell(
                        onTap: () {
                          _launchURL(widget.link);
                        },
                        child: Row(
                          children: [
                            Icon(Icons.link),
                            SizedBox(width: 8),
                            Text(
                              'Go to Link',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.blue.main,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.video,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void toggleFavorite() {
    final String materialId = widget.materialId;

    setState(() {
      if (isHeartFilled) {
        classData!.materials.remove(materialId);
      } else {
        classData!.materials.add(materialId);
      }

      isHeartFilled = !isHeartFilled;
    });

    saveClassDataToFirestore(classData!);
  }

  Future<void> saveClassDataToFirestore(ClassData userData) async {
  try {
    // Reference to the user document in Firestore
    DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(userId);

    // Convert userData object to a Map
    Map<String, dynamic> classDataMap = {
      'materials': classData!.materials,
      'name': classData!.name,
      'posts': classData!.posts.map((classPostsData) {
        return {
          'id': classPostsData.id,
          'date': classPostsData.date,
          'user': classPostsData.user,
          'value': classPostsData.value,
          'comments': classPostsData.comments.map((classCommentsData) {
            return {
              'date': classCommentsData.date,
              'like': classCommentsData.like,
              'user': classCommentsData.user,
              'value': classCommentsData.value,
            };
          }).toList(),
        };
      }).toList(),
    };

    // Update the user document in Firestore with the new userDataMap
    await userRef.update(classDataMap);
  } catch (e) {
    print('Error saving user data to Firestore: $e');
    rethrow;
  }
}
}