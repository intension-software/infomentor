import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:infomentor/backend/fetchUser.dart'; // Import the UserData class and fetchUser function
import 'package:infomentor/Colors.dart';
import 'package:flutter_svg/flutter_svg.dart';


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
  UserData? userData;
  String? userId;
  

  @override
  void initState() {
    super.initState();
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      userId = currentUser.uid;
      fetchUser(userId!).then((user) {
        setState(() {
          userData = user;
          isHeartFilled = userData!.materials.contains(widget.materialId);
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
            color: AppColors.getColor('primary').main
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
                            color: AppColors.getColor('mono').white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          widget.type,
                          style: TextStyle(
                            color: AppColors.getColor('mono').white,
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
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.getColor('red').lighter,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.type,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.getColor('red').main,
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
                      icon: (isHeartFilled ? SvgPicture.asset('assets/icons/whiteFilledHeartIcon.svg') : SvgPicture.asset('assets/icons/whiteHeartIcon.svg')),
                        color: AppColors.getColor('mono').white,
                      onPressed: () {
                        toggleFavorite();
                      },
                    ),
                    SizedBox(width: 4,),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.getColor('mono').lighterGrey
                      ),
                      child: IconButton(
                        icon: SvgPicture.asset('assets/icons/linkIcon.svg', color: Colors.black,),
                        onPressed: () {
                          _launchURL(widget.link);
                        },
                      ),
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
          backgroundColor: AppColors.getColor('mono').white, // Set the overlay background color
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(56), // Set the preferred height of the AppBar
            child: AppBar(
              backgroundColor: AppColors.getColor('mono').white,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                color: AppColors.getColor('mono').darkGrey,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
               titleSpacing: 0,
                centerTitle: true, // Center the title horizontally
                title: Text(
                  'Vzdelávacia aktivita',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    width: 900,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(
                        color: AppColors.getColor('mono').lighterGrey
                      ))
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                            width: 900,
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).primaryColor,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    widget.association,
                                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Theme.of(context).colorScheme.onPrimary,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    widget.title,
                                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                                      color: Theme.of(context).colorScheme.onPrimary,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                ],
                              ),
                        ),

                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.getColor('red').lighter,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            widget.type,
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: AppColors.getColor('red').main,
                            ),
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
                        Row(
                          children: [
                            IconButton(
                              icon: (isHeartFilled ? SvgPicture.asset('assets/icons/smallHeartFilledIcon.svg') : SvgPicture.asset('assets/icons/smallHeartIcon.svg')),
                                color: AppColors.getColor('mono').white,
                              onPressed: () {
                                toggleFavorite();
                              },
                            ),
                            IconButton(
                              icon: SvgPicture.asset('assets/icons/linkIcon.svg'),
                              onPressed: () {
                                _launchURL(widget.link);
                              },
                            ),
                          ],
                        ),
                        
                      ],
                    ),
                  ),
                )
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
        userData!.materials.remove(materialId);
      } else {
        userData!.materials.add(materialId);
      }

      isHeartFilled = !isHeartFilled;
    });

    saveUserDataToFirestore(userData!);
  }

 Future<void> saveUserDataToFirestore(UserData userData) async {
    try {
      // Reference to the user document in Firestore
      DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);

      // Convert userData object to a Map
      Map<String, dynamic> userDataMap = {
        'badges': userData.badges,
        'discussionPoints': userData.discussionPoints,
        'weeklyDiscussionPoints': userData.weeklyDiscussionPoints,
        'admin': userData.admin,
        'teacher': userData.teacher,
        'email': userData.email,
        'name': userData.name,
        'active': userData.active,
        'school': userData.school,
        'schoolClass': userData.schoolClass,
        'image': userData.image,
        'surname': userData.surname,
        'materials': userData.materials,
        'points': userData.points,
        'capitols': userData.capitols.map((userCapitolsData) {
          return {
            'id': userCapitolsData.id,
            'name': userCapitolsData.name,
            'image': userCapitolsData.image,
            'completed': userCapitolsData.completed,
            'tests': userCapitolsData.tests.map((userCapitolsTestData) {
              return {
                'name': userCapitolsTestData.name,
                'completed': userCapitolsTestData.completed,
                'points': userCapitolsTestData.points,
                'questions': userCapitolsTestData.questions.map((userQuestionsData) {
                  return {
                    'answer': userQuestionsData.answer.map((userAnswerData) {
                      return {
                        'answer': userAnswerData.answer,
                        'index': userAnswerData.index
                        };
                    }).toList(),
                    'completed': userQuestionsData.completed,
                    'correct': userQuestionsData.correct,
                  };
                }).toList(),
              };
            }).toList(),
          };
        }).toList(),
      };

      // Update the user document in Firestore with the new userDataMap
      await userRef.update(userDataMap);
    } catch (e) {
      print('Error saving user data to Firestore: $e');
      rethrow;
    }
  }
}