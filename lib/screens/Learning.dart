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
   bool _loading = true;

  fetchCurrentClass() async {
    try {
        ClassData classData = await fetchClass(widget.currentUserData!.schoolClass!);
    if (classData != null) {
        // Fetch the user data using the fetchUser function
        if (mounted) {
          setState(() {
            currentClassData = classData;
            _loading = false;
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
    if(_loading) return Center(child: CircularProgressIndicator());
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: PageView(
      controller: _pageController,
      onPageChanged: _onPageChanged,
        children: [
        Center( 
          child: Container(
          alignment: Alignment.center,
          width: 900,
          child: Column(
            children: [
              SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          showAll = true;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: showAll ? AppColors.getColor('mono').lighterGrey : Colors.white,
                        ),
                        width: 150,
                        height: 30,
                        alignment: Alignment.center,
                        child: Text('Všetky'),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          showAll = false;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: showAll ? Colors.white : AppColors.getColor('mono').lighterGrey,
                        ),
                        width: 150,
                        height: 30,
                        alignment: Alignment.center,
                        child: Text('Uložené'),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
              if (widget.currentUserData!.teacher && MediaQuery.of(context).size.width > 1000)Container(
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
                child: FutureBuilder<List<MaterialData>>(
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
              if (widget.currentUserData!.teacher && MediaQuery.of(context).size.width < 1000)Container(
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
              SizedBox(height: 20,)
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
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppColors.getColor('mono').darkGrey,
                    ),
                    onPressed: () => _onNavigationItemSelected(0),
                  ),
                  Text(
                    'Späť',
                    style: TextStyle(color: AppColors.getColor('mono').darkGrey),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Pridať obsah',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                    ),
                  ),
                  SizedBox(width: 100,)
                ],
              ),
            ),
            MaterialForm(currentUserData: widget.currentUserData),
          ]
        )
      ),
        ]
      )
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