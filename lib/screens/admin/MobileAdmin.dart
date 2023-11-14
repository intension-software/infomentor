import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:infomentor/Colors.dart';
import 'package:infomentor/backend/fetchClass.dart';
import 'package:infomentor/backend/userController.dart';
import 'package:infomentor/backend/convert.dart';
import 'package:infomentor/backend/fetchSchool.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infomentor/Colors.dart';
import 'package:infomentor/widgets/ReWidgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:infomentor/screens/admin/MobileClasses.dart';
import 'package:infomentor/screens/admin/AddUser.dart';
import 'package:infomentor/screens/admin/AddExistingUser.dart';
import 'package:infomentor/screens/admin/UpdateUser.dart';
import 'package:infomentor/screens/admin/AddClass.dart';
import 'package:infomentor/screens/admin/UpdateClass.dart';
import 'package:infomentor/screens/admin/Csv.dart';



class MobileAdmin extends StatefulWidget {
  final Future<void> fetch;
  final UserData? currentUserData;
  final void Function() logOut;
  const MobileAdmin({Key? key, required this.fetch, required this.currentUserData, required this.logOut});

  @override
  State<MobileAdmin> createState() => _MobileAdminState();
}

class _MobileAdminState extends State<MobileAdmin> {
  
  List<String>? classes;
  List<String>? teachers;
  String? schoolName;
  UserData? admin;
  String? adminId;
  bool _teacher = false;
  bool _admin = false;
  final PageController _pageController = PageController();
  int _selectedIndex = 0;
  TextEditingController _classNameController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _userEmailController = TextEditingController();
  TextEditingController _userPasswordController = TextEditingController();
  TextEditingController _editUserNameController = TextEditingController();
  TextEditingController _editUserEmailController = TextEditingController();
  TextEditingController _editUserPasswordController = TextEditingController();
  TextEditingController _editClassNameController = TextEditingController();
  TextEditingController _messageController = TextEditingController();
  bool _loading = true;
  ClassDataWithId? currentClass;
  UserDataWithId? currentUser;
  String? _selectedClass;
  String _type = 'Nahlásenie problému';
  FileProcessingResult? table;

  Future<File?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      return File(result.files.single.path!);
    } else {
      // User canceled the picker
      return null;
    }
  }


  // Create a list to store class data
  List<ClassDataWithId> classDataList = [];

  Future<void> sendMessage(String message, String type) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance; // Create an instance of FirebaseFirestore

    await firestore.collection('mail').add(
      {
        'to': ['support@info-mat.sk'],
        'message': {
          'subject': type,
          'text': message
        },
      },
    ).then(
      (value) {
        print('Queued email for delivery!');
      },
    );
    
    reShowToast( 'Správa odoslaná', false, context);
  }

  Future<void> fetchSchoolData() async {
    try {
      SchoolData school = await fetchSchool(widget.currentUserData!.school);
      admin = await fetchUser(school.admin);


      setState(() {
        if (mounted) {
          classes = school.classes;
          teachers = school.teachers;
          adminId = school.admin;
          schoolName = school.name;
          _loading = false;
        }
        classDataList = [];
      });

      // Fetch class data once and store it in classDataList with IDs
      for (String classId in classes!) {
        ClassData classData = await fetchClass(classId);
        classDataList.add(ClassDataWithId(classId, classData));
      }
    } catch (e) {
      print('Error fetching school data: $e');
    }
  }


  @override
  void initState() {
    super.initState();
    fetchSchoolData(); // Fetch the user data when the app starts
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return Center(child: CircularProgressIndicator());
    return _buildScreen(_selectedIndex);
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return SingleChildScrollView(
          child: Container(
              width: 900,
              height: MediaQuery.of(context).size.height - 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30,),
                  Container(
                    width: 900,
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).primaryColor
                    ),
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          schoolName!,
                          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text(
                          '${widget.currentUserData!.name}  {meno učiteľa prihlaseného v účte}',
                          style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                   MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      child: Container(
                            margin: EdgeInsets.all(12),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: AppColors.getColor('mono').lightGrey),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      admin!.name,
                                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                            color: AppColors.getColor('mono').black,
                                          ),
                                    ),
                                    SizedBox(height: 10,),
                                    Text(
                                      'Správa účtu',
                                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                            color: AppColors.getColor('mono').grey,
                                          ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                SvgPicture.asset('assets/icons/rightIcon.svg', color: AppColors.getColor('mono').grey, height: 12)
                              ],
                            ),
                          ),
                      onTap:  () async {
                        setState(() {
                          currentUser = UserDataWithId(adminId!, admin!);
                          _teacher = true;
                          _admin = true;
                          _editUserEmailController.text = admin!.email;
                          _editUserNameController.text = admin!.name;
                          _onNavigationItemSelected(4);
                        });
                      }
                    ),
                  ),
                  SizedBox(height: 5,),
                  Container(
                    child: Row(
                      children: [
                        Text(
                          'Triedy',
                          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                color: AppColors.getColor('mono').darkGrey,
                              ),
                        ),
                        Spacer(),
                        Container(
                          width: 53,
                          height: 36,
                          child:  ReButton(
                            activeColor: AppColors.getColor('primary').light, 
                            defaultColor: AppColors.getColor('mono').lighterGrey, 
                            disabledColor: AppColors.getColor('mono').lightGrey, 
                            focusedColor: AppColors.getColor('primary').light, 
                            hoverColor: AppColors.getColor('primary').lighter, 
                            textColor: AppColors.getColor('primary').main, 
                            iconColor: AppColors.getColor('mono').black, 
                            text: '', 
                            rightIcon: 'assets/icons/plusIcon.svg',
                            onTap: () {
                              _onNavigationItemSelected(5);
                            },
                          ),
                        ),
                      ],
                    ),
                    margin: EdgeInsets.all(12),
                  ),
                  SizedBox(height: 5,),
                  Expanded(
                   child: ListView.builder(
                      itemCount: classDataList.length,
                      itemBuilder: (context, index) {
                        final classData = classDataList[index];
                        if (classData == null) {
                          // Show loading indicator for classes that are still being fetched
                          return CircularProgressIndicator();
                        }

                        return MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                // Update the currentClass when a class is tapped
                                currentClass = classData;
                                _selectedClass = classData.id;
                                _onNavigationItemSelected(1);
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              height: 56,
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
                                    classData.data.name,
                                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                          color: AppColors.getColor('mono').black,
                                        ),
                                  ),
                                  SvgPicture.asset('assets/icons/rightIcon.svg', color: AppColors.getColor('mono').grey, height: 12),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Spacer(),
                  Center(
                    child: Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10),
                              width: 190,
                              height: 40,
                              child: ReButton(
                                activeColor: AppColors.getColor('primary').light, 
                                defaultColor: AppColors.getColor('mono').lighterGrey, 
                                disabledColor: AppColors.getColor('mono').lightGrey, 
                                focusedColor: AppColors.getColor('primary').light, 
                                hoverColor: AppColors.getColor('primary').lighter, 
                                textColor: AppColors.getColor('primary').main, 
                                iconColor: AppColors.getColor('mono').black, 
                                text: 'Kontaktuje nás',
                                rightIcon: 'assets/icons/messageIcon.svg',
                                onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                          builder: (BuildContext context, StateSetter setState) {
                                            return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20.0),
                                          ),
                                          content: Container(
                                            width: 500,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min, // Ensure the dialog takes up minimum height
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
                                                SizedBox(height: 30,),
                                                  Text(
                                                    'Moja správa je',
                                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(height: 10,),
                                                  Container(
                                                    padding: EdgeInsets.only(right: 8),
                                                    height: 30,
                                                    width: 200,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(8),
                                                      color: _type == 'Nahlásenie problému' ? AppColors.getColor('primary').lighter : AppColors.getColor('mono').lighterGrey,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Radio(
                                                          value: 'Nahlásenie problému',
                                                            groupValue: _type,
                                                            onChanged: (newValue) {
                                                              setState(() {
                                                                if (newValue != null) _type = newValue;
                                                              });
                                                            },
                                                            activeColor: AppColors.getColor('primary').main,
                                                          ),
                                                        Text(
                                                          'Nahlásenie problému',
                                                          style: TextStyle(
                                                            color:  _type == 'Nahlásenie problému' ? AppColors.getColor('primary').main : AppColors.getColor('mono').darkGrey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 10,),
                                                  Container(
                                                    padding: EdgeInsets.only(right: 8),
                                                    height: 30,
                                                    width: 100,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(8),
                                                      color: _type == 'Otázka' ? AppColors.getColor('primary').lighter : AppColors.getColor('mono').lighterGrey,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                          Radio(
                                                          value: 'Otázka',
                                                            groupValue: _type,
                                                            onChanged: (newValue) {
                                                              setState(() {
                                                                if (newValue != null) _type = newValue;
                                                              });
                                                            },
                                                            activeColor: AppColors.getColor('primary').main,
                                                          ),
                                                        Text(
                                                          'Otázka',
                                                          style: TextStyle(
                                                            color: _type == 'Otázka' ? AppColors.getColor('primary').main : AppColors.getColor('mono').darkGrey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 10,),
                                                  Text(
                                                    'Správa',
                                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(height: 10,),
                                                  reTextField(
                                                    'Popíš svoj problém s aplikáciou alebo nám napíš otázku.',
                                                    false,
                                                    _messageController,
                                                    AppColors.getColor('mono').lightGrey, // assuming white is the default border color you want
                                                  ),
                                                SizedBox(height: 30,),
                                                  Center(
                                                    child: ReButton(
                                                    activeColor: AppColors.getColor('mono').white, 
                                                    defaultColor: AppColors.getColor('green').main, 
                                                    disabledColor: AppColors.getColor('mono').lightGrey, 
                                                    focusedColor: AppColors.getColor('green').light, 
                                                    hoverColor: AppColors.getColor('green').light, 
                                                    textColor: Theme.of(context).colorScheme.onPrimary, 
                                                    iconColor: AppColors.getColor('mono').black, 
                                                    text: 'ODOSLAŤ',
                                                    onTap: () {
                                                      if(_messageController.text != '') {
                                                        sendMessage(_messageController.text, _type);
                                                        Navigator.of(context).pop();
                                                        _messageController.text = '';
                                                      }
                                                    },
                                                  ),
                                                ),
                                                
                                                SizedBox(height: 30,),
                                              ],
                                            ),
                                          )
                                        );
                                          }
                                        );
                                      },
                                    );
                                }
                              )
                            ),
                            
                          SizedBox(width: 5,),
                          Container(
                            margin: EdgeInsets.only(top: 10),

                          width: 160,
                          height: 40,
                          child: ReButton(
                            activeColor: AppColors.getColor('red').light, 
                            defaultColor: AppColors.getColor('red').main, 
                            disabledColor: AppColors.getColor('mono').lightGrey, 
                            focusedColor: AppColors.getColor('red').light, 
                            hoverColor: AppColors.getColor('red').lighter, 
                            textColor: AppColors.getColor('mono').white, 
                            iconColor: AppColors.getColor('mono').white, 
                            text: 'Odhlásiť sa',
                            rightIcon: 'assets/icons/logoutIcon.svg',
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    content: Container(
                                      width: 328,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min, // Ensure the dialog takes up minimum height
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
                                              'Odhlásiť sa',
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                                    color: AppColors.getColor('mono').black,
                                                  ),
                                            ),
                                          ),
                                          SizedBox(height: 30,),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Po odhlásení sa z aplikácie budeš musieť znovu zadať svoje používeteľské meno a heslo.',
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          SizedBox(height: 30,),
                                            ReButton(
                                            activeColor: AppColors.getColor('mono').white, 
                                            defaultColor: AppColors.getColor('red').main, 
                                            disabledColor: AppColors.getColor('mono').lightGrey, 
                                            focusedColor: AppColors.getColor('red').light, 
                                            hoverColor: AppColors.getColor('red').light, 
                                            textColor: Theme.of(context).colorScheme.onPrimary, 
                                            iconColor: AppColors.getColor('mono').black, 
                                            text: 'ODHLÁSIŤ SA',
                                            onTap: () {
                                              widget.logOut();
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          SizedBox(height: 30,),
                                        ],
                                      ),
                                    )
                                  );
                                },
                              );
                            }
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                ],
              ),
            ),
        );
      case 1:
        return MobileClasses(currentUserData: widget.currentUserData,
        onNavigationItemSelected: _onNavigationItemSelected, 
        selectedClass: _selectedClass, 
        teacher: (bool value) {
          setState(() {
            _teacher = value;
          });
        }, 
        editClassNameController:
        _editClassNameController, 
        currentClass: currentClass, 
        classes: classes, 
        editUserNameController: 
        _editUserNameController, 
        editUserEmailController: _editUserEmailController, 
        admin: _admin,
        currentUser: (String userId, UserData userData) {
          setState(() {
            currentUser = UserDataWithId(userId, userData);
          });
        }
      );
      case 2:
        return AddUser(
          classes: classes,
          currentClass: currentClass,
          currentUserData: widget.currentUserData,
          onNavigationItemSelected: _onNavigationItemSelected,
          selectedClass: _selectedClass,
          teacher: _teacher,
          userEmailController: _userEmailController,
          userNameController: _userNameController,
          userPasswordController: _userPasswordController,
        );
      case 3:
        return AddExistingUser(
          classes: classes,
          currentClass: currentClass,
          currentUserData: widget.currentUserData,
          onNavigationItemSelected: _onNavigationItemSelected,
          selectedClass: _selectedClass,
          teachers: teachers,
        );
      case 4:
        return UpdateUser(
          admin: _admin,
          currentClass: currentClass,
          setAdmin: () {
            setState(() {
              _admin = false;
            });
          },
          currentUser: currentUser,
          editUserEmailController: _editUserEmailController,
          editUserNameController: _editUserNameController,
          editUserPasswordController: _editUserPasswordController,
          onNavigationItemSelected: _onNavigationItemSelected,
          teacher: _teacher,
          changeEmail: (String email) {
            setState(() {
              currentUser!.data.email = email;
            });
          },
          changeName: (String name) {
            setState(() {
              currentUser!.data.name = name;
            });
          },
        );
      case 5:
        return AddClass(
          classes: classes!,
          currentUserData: widget.currentUserData,
          onNavigationItemSelected: _onNavigationItemSelected,
          teacher: _teacher,
          classNameController: _classNameController, 
          addSchoolData: (ClassDataWithId classData) {
            classDataList.add(classData);
          }
        );
      case 6:
        return UpdateClass(
        classes: classes!,  
        currentUserData: widget.currentUserData, 
        onNavigationItemSelected: _onNavigationItemSelected, 
        selectedClass: _selectedClass, 
        teacher: _teacher, 
        editClassNameController: _editClassNameController, 
        currentClass: currentClass, 
        currentUser: currentUser,
        removeSchoolData: (String classId) {
          classDataList.removeWhere((element) => element.id == classId);
        },
      );
      case 7:
        return Csv(
        currentUserData: widget.currentUserData, 
        onNavigationItemSelected: _onNavigationItemSelected, 
        selectedClass: _selectedClass, 
        currentClass: currentClass,
        classes: classes!,
      );
      default:
        return Container();
    }
  }

   void _onNavigationItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

Future<Map<String, String>> fetchClassNames(List<String> classIds) async {
  final Map<String, String> classNames = {};

  for (final classId in classIds) {
    final classData = await fetchClass(classId); // Replace with your fetchClass implementation
    classNames[classId] = classData?.name ?? 'Unknown Class';
  }

  return classNames;
}









