import 'package:flutter/material.dart';
import 'package:infomentor/Colors.dart';
import 'package:infomentor/widgets/ReWidgets.dart';
import 'package:infomentor/backend/fetchClass.dart';
import 'package:infomentor/backend/userController.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MobileClasses extends StatefulWidget {
  final UserData? currentUserData;
  void Function(int) onNavigationItemSelected;
  String? selectedClass;
  void Function(bool) teacher;
  TextEditingController editClassNameController;
  ClassDataWithId? currentClass;
  List<String>? classes;
  TextEditingController editUserNameController;
  TextEditingController editUserEmailController;
  void Function(String, UserData) currentUser;
  bool admin;

  MobileClasses(
    {
      Key? key, required this.currentUserData,
      required this.onNavigationItemSelected,
      required this.selectedClass,
      required this.teacher,
      required this.editClassNameController, 
      required this.currentClass,
      required this.classes,
      required this.editUserNameController,
      required this.editUserEmailController,
      required this.admin,
      required this.currentUser
    }
  );

  @override
  State<MobileClasses> createState() => _MobileClassesState();
}

class _MobileClassesState extends State<MobileClasses> {
  @override
  Widget build(BuildContext context) {
    return  Align(
      alignment: Alignment.center,
      child: Container(
        width: 900,
        height: 1080,
        child: SingleChildScrollView(
      child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppColors.getColor('mono').darkGrey,
                    ),
                    onPressed: () {
                      widget.onNavigationItemSelected(0);
                    },
                  ),
                  Text(
                    'Späť',
                    style: TextStyle(color: AppColors.getColor('mono').darkGrey),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        widget.currentClass!.data.name,
                        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                    ),
                  ),
                  SizedBox(width: 100,),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          // Update the currentClass when a class is tapped
                          widget.editClassNameController.text = widget.currentClass!.data.name;
                          widget.onNavigationItemSelected(6);
                        });
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/icons/editIcon.svg'),
                          Text(
                            'Upraviť',
                            style: TextStyle(color: AppColors.getColor('mono').darkGrey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40,),
              Row(
                children: [
                  SizedBox(width: 5,),
                  Text(
                    'Učitelia',
                    style: TextStyle(color: AppColors.getColor('mono').darkGrey),
                  ),
                  Spacer(),
                  Container(
                    height: 40,
                    width: 150,
                    child: ReButton(
                      activeColor: AppColors.getColor('primary').light, 
                      defaultColor: AppColors.getColor('mono').lighterGrey, 
                      disabledColor: AppColors.getColor('mono').lightGrey, 
                      focusedColor: AppColors.getColor('primary').light, 
                      hoverColor: AppColors.getColor('primary').lighter, 
                      textColor: AppColors.getColor('primary').main, 
                      iconColor: AppColors.getColor('mono').black, 
                      text: '+ Pridať',  
                      onTap: () {
                        showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            content: Container(
                              height: 300,
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              // Add content for the AlertDialog here
                              // For example, you can add form fields to input teacher data
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Spacer(),
                                      MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: GestureDetector(
                                          child: SvgPicture.asset('assets/icons/xIcon.svg', height: 10,),
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                    'Pridať učiteľa',
                                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                        color: AppColors.getColor('mono').black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15,),
                                  Container(
                                    width: 250,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Potrebné údaje:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),),
                                        Text(' 1. Trieda', style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),),
                                        Text(' 2. Meno a Priezvisko', style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),),
                                        Text(' 3. Emailová adresa', style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),),
                                        Text(' 4. Heslo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 35,),
                                  Align(
                                    alignment: Alignment.center,
                                    child:
                                      Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 291,
                                          height: 48,
                                          child:  ReButton(
                                            activeColor: AppColors.getColor('primary').light, 
                                            defaultColor: AppColors.getColor('mono').lighterGrey, 
                                            disabledColor: AppColors.getColor('mono').lightGrey, 
                                            focusedColor: AppColors.getColor('primary').light, 
                                            hoverColor: AppColors.getColor('primary').lighter, 
                                            textColor: AppColors.getColor('primary').main, 
                                            iconColor: AppColors.getColor('mono').black, 
                                            text: 'PRIRADIŤ EXISTUJÚCI PROFILE',  
                                            onTap: () async {
                                                widget.onNavigationItemSelected(3);
                                                Navigator.of(context).pop();
                                            }
                                          ),
                                        ),
                                        SizedBox(height: 20,),
                                        Container(
                                          width: 270,
                                          height: 48,
                                          child: ReButton(
                                            activeColor: AppColors.getColor('mono').white, 
                                            defaultColor: AppColors.getColor('green').main, 
                                            disabledColor: AppColors.getColor('mono').lightGrey, 
                                            focusedColor: AppColors.getColor('green').light, 
                                            hoverColor: AppColors.getColor('green').light, 
                                            textColor: Theme.of(context).colorScheme.onPrimary, 
                                            iconColor: AppColors.getColor('mono').black, 
                                            text: 'VYTVORIŤ NOVÝ PROFIL',
                                            onTap: () {
                                                Navigator.of(context).pop();
                                                widget.onNavigationItemSelected(2);
                                                widget.teacher(true);
                                              
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                      },
                    ),
                  ),
                  SizedBox(width: 5,),
                ],
              ),
              SizedBox(height: 30,),
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.currentClass!.data.teachers.length,
                itemBuilder: (context, index) {
                  final userId = widget.currentClass!.data.teachers[index];
                  return FutureBuilder<UserData>(
                    future: fetchUser(userId),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.hasError) {
                        print('Error fetching user data: ${userSnapshot.error}');
                        return Text('Error: ${userSnapshot.error}');
                      } else if (!userSnapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        UserData userData = userSnapshot.data!;
                        return MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                setState(() {
                                widget.currentUser(userId, userData);
                                widget.teacher(true);
                                widget.admin = false;
                                widget.editUserEmailController.text = userData.email;
                                widget.editUserNameController.text = userData.name;
                              });
                              widget.onNavigationItemSelected(4);
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(10),
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(color: AppColors.getColor('mono').lightGrey),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '${userData.name} ${userData.surname}',
                                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                          color: AppColors.getColor('mono').black,
                                        ),
                                  ),
                                  Spacer(),
                                  SvgPicture.asset('assets/icons/rightIcon.svg', color: AppColors.getColor('mono').grey, height: 12)
                                ],
                              ),
                            ),
                          )
                        ); 
                      }
                    },
                  );
                },
              ),
              SizedBox(height: 15,),
              Row(
                children: [
                  SizedBox(width: 5,),
                  Text(
                    'Žiaci',
                    style: TextStyle(color: AppColors.getColor('mono').darkGrey),
                  ),
                  Spacer(),
                  Container(
                    height: 40,
                    width: 150,
                    child:ReButton(
                      activeColor: AppColors.getColor('primary').light, 
                      defaultColor: AppColors.getColor('mono').lighterGrey, 
                      disabledColor: AppColors.getColor('mono').lightGrey, 
                      focusedColor: AppColors.getColor('primary').light, 
                      hoverColor: AppColors.getColor('primary').lighter, 
                      textColor: AppColors.getColor('primary').main, 
                      iconColor: AppColors.getColor('mono').black, 
                      text: '+ Pridať',  
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              content: Container(
                                height: 300,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                // Add content for the AlertDialog here
                                // For example, you can add form fields to input teacher data
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Spacer(),
                                        MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: GestureDetector(
                                            child: SvgPicture.asset('assets/icons/xIcon.svg', height: 10,),
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                      'Pridať žiaka',
                                        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                          color: AppColors.getColor('mono').black,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 15,),
                                    Container(
                                      width: 250,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Potrebné údaje:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),),
                                          Text(' 1. Trieda', style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),),
                                          Text(' 2. Meno a Priezvisko', style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),),
                                          Text(' 3. Emailová adresa', style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),),
                                          Text(' 4. Heslo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 35,),
                                    Align(
                                      alignment: Alignment.center,
                                      child:
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 270,
                                            height: 48,
                                            child:  ReButton(
                                              activeColor: AppColors.getColor('primary').light, 
                                              defaultColor: AppColors.getColor('mono').lighterGrey, 
                                              disabledColor: AppColors.getColor('mono').lightGrey, 
                                              focusedColor: AppColors.getColor('primary').light, 
                                              hoverColor: AppColors.getColor('primary').lighter, 
                                              textColor: AppColors.getColor('primary').main, 
                                              iconColor: AppColors.getColor('mono').black, 
                                              text: 'PRIDAŤ MANUÁLNE',  
                                              onTap: () async {
                                                Navigator.of(context).pop();
                                                widget.onNavigationItemSelected(2);
                                                widget.teacher(false);
                                              }
                                            ),
                                          ),
                                          SizedBox(height: 20,),
                                          Container(
                                            width: 270,
                                            height: 48,
                                            child: ReButton(
                                              activeColor: AppColors.getColor('mono').white, 
                                              defaultColor: AppColors.getColor('green').main, 
                                              disabledColor: AppColors.getColor('mono').lightGrey, 
                                              focusedColor: AppColors.getColor('green').light, 
                                              hoverColor: AppColors.getColor('green').light, 
                                              textColor: Theme.of(context).colorScheme.onPrimary, 
                                              iconColor: AppColors.getColor('mono').black, 
                                              text: 'NAHRAŤ .CSV/.XLSX SÚBOR',
                                              onTap: () {
                                                Navigator.of(context).pop();
                                                widget.onNavigationItemSelected(7);
                                              
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 5,),
                ],
              ),
              SizedBox(height: 30,),
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.currentClass!.data.students.length,
                itemBuilder: (context, index) {
                  final userId = widget.currentClass!.data.students[index];
                  return FutureBuilder<UserData>(
                    future: fetchUser(userId),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.hasError) {
                        print('Error fetching user data: ${userSnapshot.error}');
                        return Text('Error: ${userSnapshot.error}');
                      } else if (!userSnapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        UserData userData = userSnapshot.data!;
                        return MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                               setState(() {
                                widget.currentUser(userId, userData);
                                widget.editUserEmailController.text = userData.email;
                                widget.editUserNameController.text = userData.name;
                                widget.admin = false;
                                widget.teacher(false);
                                widget.onNavigationItemSelected(4);
                              });
                            },
                            child: Container(
                              height: 56,
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: AppColors.getColor('mono').lightGrey,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${userData.name} ${userData.surname}',
                                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                          color: AppColors.getColor('mono').black,
                                        ),
                                  ),
                                  SvgPicture.asset('assets/icons/rightIcon.svg', color: AppColors.getColor('mono').grey, height: 12),
                                ],
                              ),
                            ),
                          )
                        ); 
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}







