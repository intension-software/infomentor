import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:infomentor/widgets/MaterialCardWidget.dart';
import 'package:infomentor/widgets/MaterialForm.dart';
import 'package:infomentor/backend/fetchUser.dart';
import 'package:infomentor/backend/fetchMaterials.dart';
import 'package:infomentor/backend/fetchClass.dart';
import 'package:infomentor/Colors.dart';
import 'package:infomentor/widgets/ReWidgets.dart';


class Learning extends StatefulWidget {
  final UserData? currentUserData;


  Learning({
    Key? key,
    required this.currentUserData,
  }) : super(key: key);

  @override
  _LearningState createState() => _LearningState();
}

class _LearningState extends State<Learning> {
  bool showAll = true;
   ClassData? currentClassData ;
   final PageController _pageController = PageController();
   int _selectedIndex = 0;

  fetchCurrentClass() async {
    try {
        ClassData classData = await fetchClass(widget.currentUserData!.schoolClass!);
    if (classData != null) {
        // Fetch the user data using the fetchUser function
        if (mounted) {
          setState(() {
            currentClassData = classData;
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
  void initState() {
    super.initState();
    fetchCurrentClass();
  }

  @override
  void dispose() {
    // Cancel timers or stop animations...

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
    controller: _pageController,
    onPageChanged: _onPageChanged,
      children: [
       Center( 
        child: Container(
        alignment: Alignment.center,
        width: 1300,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
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
             if (widget.currentUserData!.teacher)Container(
              width: 900,
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 260,
                  child: widget.currentUserData!.teacher ? ReButton(
                    activeColor: AppColors.getColor('mono').white, 
                    defaultColor: AppColors.getColor('primary').main, 
                    disabledColor: AppColors.getColor('mono').lightGrey, 
                    focusedColor: AppColors.getColor('primary').light, 
                    hoverColor: AppColors.getColor('mono').lighterGrey, 
                    textColor: Theme.of(context).colorScheme.onPrimary, 
                    iconColor: AppColors.getColor('mono').black, 
                    text: '+ PRIDAŤ OBSAH', 
                    leftIcon: false, 
                    rightIcon: false, 
                    onTap: () {
                      _onNavigationItemSelected(1);
                      _selectedIndex = 1;
                    },
                  ) : null,
                ),
              )
            ),
              ]
            ),
            Expanded(
              child: currentClassData == null 
            ? Center(child: CircularProgressIndicator())
            : FutureBuilder<List<MaterialData>>(
                future: fetchMaterials(currentClassData!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<MaterialData> materials = snapshot.data!;

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
                                MaterialData material = materials[index];

                                return MaterialCardWidget(
                                  image: material.image,
                                  title: material.title,
                                  description: material.description,
                                  link: material.link,
                                  subject: material.subject,
                                  type: material.type,
                                  association: material.association,
                                  video: material.video,
                                  materialId: material.materialId!,
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
                        MaterialData material = materials[index];

                        return MaterialCardWidget(
                          image: material.image,
                          title: material.title,
                          description: material.description,
                          link: material.link,
                          subject: material.subject,
                          type: material.type,
                          association: material.association,
                          video: material.video,
                          materialId: material.materialId!,
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
    ),
    Center(
      child: Column(
        children: [
          Container(
            width: 900,
            alignment: Alignment.topLeft,
            child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: AppColors.getColor('mono').darkGrey,
                ),
                onPressed: () => 
                  _onNavigationItemSelected(0),
              ),
          ),
    MaterialForm(currentUserData: widget.currentUserData),

        ]
      )
    ),
      ]
    );
  }
   void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onNavigationItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }
}