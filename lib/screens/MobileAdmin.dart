import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:infomentor/Colors.dart';
import 'package:infomentor/backend/fetchClass.dart';
import 'package:infomentor/backend/fetchUser.dart';
import 'package:infomentor/backend/fetchSchool.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infomentor/Colors.dart';
import 'package:infomentor/widgets/ReWidgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';

class MobileAdmin extends StatefulWidget {
  final UserData? currentUserData;
  final void Function() logOut;
  const MobileAdmin({Key? key, required this.currentUserData, required this.logOut});

  @override
  State<MobileAdmin> createState() => _MobileAdminState();
}

class ClassDataWithId {
  final String id;
  final ClassData data;

  ClassDataWithId(this.id, this.data);
}

class UserDataWithId {
  final String id;
  final UserData data;

  UserDataWithId(this.id, this.data);
}

class _MobileAdminState extends State<MobileAdmin> {
  final _formKey = GlobalKey<FormState>();
  List<String>? classes;
  String? schoolName;
  UserData? admin;
  String? adminId;
  bool _class = false;
  bool _addClass = false;
  bool _addUser = false;
  bool _editClass = false;
  bool _editUser = false;
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
  bool _loading = true;
  ClassDataWithId? currentClass;
  UserDataWithId? currentUser;
  String? _selectedClass;

  // Create a list to store class data
  List<ClassDataWithId> classDataList = [];

  Future<void> fetchSchoolData() async {
    try {
      SchoolData school = await fetchSchool(widget.currentUserData!.school);
      admin = await fetchUser(school.admin);

      setState(() {
        if (mounted) {
          classes = school.classes;
          adminId = school.admin;
          schoolName = school.name;
          _loading = false;
        }
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
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: PageView(
      controller: _pageController,
      onPageChanged: _onPageChanged,
      children: [
        SingleChildScrollView(
          child: ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height, // Set a minimum height to enable scrolling
      ),
      child:Container(
              width: 900,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30,),
                  Container(
                    margin: EdgeInsets.all(12),
                    child: Text(
                    schoolName!,
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: AppColors.getColor('mono').black,
                        ),
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
                          _editUser = true;
                          _teacher = true;
                          _admin = true;
                          _editClass = false;
                          _editUserEmailController.text = admin!.email;
                          _editUserNameController.text = admin!.name;
                          _onNavigationItemSelected(1);
                        });
                      }
                    ),
                  ),
                  SizedBox(height: 30,),
                  Container(
                    margin: EdgeInsets.all(12),
                    width: double.infinity,
                    child:  ReButton(
                      activeColor: AppColors.getColor('primary').light, 
                      defaultColor: AppColors.getColor('primary').main, 
                      disabledColor: AppColors.getColor('mono').lightGrey, 
                      focusedColor: AppColors.getColor('primary').light, 
                      hoverColor: AppColors.getColor('primary').lighter, 
                      textColor: Theme.of(context).colorScheme.onPrimary, 
                      iconColor: AppColors.getColor('mono').black, 
                      text: '+ Pridať žiakov',  
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
                                                _onNavigationItemSelected(2);
                                                _addUser = true;
                                                _teacher = false;
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
                                              text: 'NAHRAŤ .CSV SÚBOR',
                                              onTap: () {
                                                
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
                  SizedBox(height: 30,),
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
                            text: '+', 
                            onTap: () {
                              _onNavigationItemSelected(1);
                              _addClass = true;
                            },
                          ),
                        ),
                      ],
                    ),
                    margin: EdgeInsets.all(12),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    width: 900,
                    height: 350,
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
                                _class = true;
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
                  Center(
                      child: Container(
                          width: 160,
                          height: 40,
                          child: ReButton(
                            activeColor: AppColors.getColor('primary').light, 
                            defaultColor: AppColors.getColor('mono').lighterGrey, 
                            disabledColor: AppColors.getColor('mono').lightGrey, 
                            focusedColor: AppColors.getColor('primary').light, 
                            hoverColor: AppColors.getColor('primary').lighter, 
                            textColor: AppColors.getColor('primary').main, 
                            iconColor: AppColors.getColor('mono').black, 
                            text: 'Odhlásiť sa',
                            rightIcon: 'assets/icons/logoutIcon.svg',
                            onTap: () {
                                widget.logOut();
                            }
                          ),
                        )
                  ),
                  SizedBox(height: 30,)
                ],
              ),
            ),
          ),
        ),
        if(_class) Align(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.all(12),
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
                            _onNavigationItemSelected(0);
                            _class = false;
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
                              currentClass!.data.name,
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
                                _editClassNameController.text = currentClass!.data.name;
                                _editClass = true;
                                _onNavigationItemSelected(2);
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
                                                    _onNavigationItemSelected(2);
                                                    _addUser = true;
                                                    _teacher = true;
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
                                                  text: 'NAHRAŤ .CSV SÚBOR',
                                                  onTap: () {
                                                    
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
                        )
                      ],
                    ),
                    SizedBox(height: 30,),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: currentClass!.data.teachers.length,
                      itemBuilder: (context, index) {
                        final userId = currentClass!.data.teachers[index];
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
                                      currentUser = UserDataWithId(userId, userData);
                                      _editUser = true;
                                      _teacher = true;
                                      _admin = false;
                                      print(userData.email);
                                      print(currentUser!.data.email);
                                      _editUserEmailController.text = userData.email;
                                      _editUserNameController.text = userData.name;
                                      _onNavigationItemSelected(2);
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
                                      height: 250,
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
                                            Row(
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
                                                      _onNavigationItemSelected(2);
                                                      _addUser = true;
                                                      _teacher = false;
                                                    }
                                                  ),
                                                ),
                                                SizedBox(width: 20,),
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
                                                    text: 'NAHRAŤ .CSV SÚBOR',
                                                    onTap: () {
                                                    
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
                      ],
                    ),
                    SizedBox(height: 30,),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: currentClass!.data.students.length,
                      itemBuilder: (context, index) {
                        final userId = currentClass!.data.students[index];
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
                                      currentUser = UserDataWithId(userId, userData);
                                      _editUserEmailController.text = userData.email;
                                      _editUserNameController.text = userData.name;
                                      _editUser = true;
                                      _admin = false;
                                      _teacher = false;
                                      _onNavigationItemSelected(2);
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
          ),
        if(_addClass) Align(
          alignment: Alignment.center,
          child: Container(
            width: 900,
            height: 1080,
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
                        _addClass = false;
                        _onNavigationItemSelected(0);
                      }
                    ),
                    Text(
                      'Späť',
                      style: TextStyle(color: AppColors.getColor('mono').darkGrey),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Pridať triedu',
                          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                color: Theme.of(context).colorScheme.onBackground,
                              ),
                        ),
                      ),
                    ),
                    SizedBox(width: 100,)
                  ],
                ),
                SizedBox(height: 40,),
                Text(
                  'Napíšte názov triedy',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: AppColors.getColor('mono').black,
                      ),
                ),
                SizedBox(height: 10,),
                Text(
                  'Po kliknutí na “ULOŽIŤ” sa vytvorí nová trieda',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.getColor('mono').grey,
                      ),
                ),
                SizedBox(height: 30,),
                Text(
                  'Názov triedy',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.getColor('mono').grey,
                      ),
                ),
                SizedBox(height: 10,),
                reTextField(
                  '1.A',
                  false,
                  _classNameController,
                  AppColors.getColor('mono').white, // assuming white is the default border color you want
                ),
                Spacer(),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   
                  ReButton(
                    activeColor: AppColors.getColor('mono').white, 
                    defaultColor: AppColors.getColor('green').main, 
                    disabledColor: AppColors.getColor('mono').lightGrey, 
                    focusedColor: AppColors.getColor('green').light, 
                    hoverColor: AppColors.getColor('green').light, 
                    textColor: Theme.of(context).colorScheme.onPrimary, 
                    iconColor: AppColors.getColor('mono').black, 
                    text: 'ULOŽIŤ', 
                    isDisabled: _editClassNameController.text == '',
                    onTap: () async {
                      currentClass!.data.name = _editClassNameController.text;
                      editClass(currentClass!.id,
                      ClassData(
                        name: _editClassNameController.text,
                        school: currentClass!.data.school,
                        students: List<String>.from(currentClass!.data.students),
                        teachers: List<String>.from(currentClass!.data.teachers),
                        materials: List<String>.from(currentClass!.data.materials),
                        capitolOrder: List<int>.from(currentClass!.data.capitolOrder),
                        posts: currentClass!.data.posts.map((post) {
                          return PostsData(
                            date: post.date,
                            id: post.id,
                            pfp: post.pfp,
                            userId: post.userId,
                            user: post.user,
                            value: post.value,
                            comments: post.comments.map((comment) {
                              return CommentsData(
                                award: comment.award,
                                userId: comment.userId,
                                pfp: comment.pfp,
                                answers: comment.answers.map((answer) {
                                  return CommentsAnswersData(
                                    award: answer.award,
                                    date: answer.date,
                                    pfp: answer.pfp,
                                    userId: answer.userId,
                                    user: answer.user,
                                    value: answer.value,
                                  );
                                }).toList(),
                                date: comment.date,
                                user: comment.user,
                                value: comment.value,
                              );
                            }).toList(),
                          );
                        }).toList(),
                      ));
                      reShowToast('Trieda úspešne upravená', false, context);
                    },
                  ),
                   ReButton(
                      activeColor: AppColors.getColor('mono').white, 
                      defaultColor: AppColors.getColor('mono').white, 
                      disabledColor: AppColors.getColor('mono').lightGrey, 
                      focusedColor: AppColors.getColor('mono').white, 
                      hoverColor: AppColors.getColor('mono').white, 
                      textColor: Theme.of(context).colorScheme.error, 
                      iconColor: Theme.of(context).colorScheme.error,
                      leftIcon: 'assets/icons/binIcon.svg',
                      text: 'Vymazať triedu', 
                      onTap: () {
                          deleteClass(currentClass!.id, widget.currentUserData!.school);
                          removeClassFromSchool(currentClass!.id, widget.currentUserData!.school);
                          deleteUserFunction(currentClass!.data.students,currentUser!.data, context);
                          deleteUserFunction(currentClass!.data.teachers,currentUser!.data, context);
                          reShowToast('Trieda úspešne vymazaná', false, context);
                        }
                    ),
                  ]
                  ),
                SizedBox(height: 30,),
              ],
            ),
          ),
        ),
        if(_addUser) Align(
          alignment: Alignment.center,
          child: Container(
            margin: EdgeInsets.all(12),
            width: 900,
            height: 1080,
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
                        _onNavigationItemSelected(0);
                        _selectedClass = null;
                        _addUser = false;
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
                          _teacher ? 'Pridať učiteľa' : 'Pridať žiaka',
                          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                color: Theme.of(context).colorScheme.onBackground,
                              ),
                        ),
                      ),
                    ),
                    SizedBox(width: 100,)
                  ],
                ),
                SizedBox(height: 40,),
                Text(
                  'Napíšte triedu, meno a email ${_teacher ? 'učiteľa' : 'žiaka'}',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: AppColors.getColor('mono').black,
                      ),
                ),
                SizedBox(height: 10,),
                Text(
                  'Po kliknutí na “ULOŽIŤ” sa učiteľovi odošle email s prihlasovacími údajmi',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.getColor('mono').grey,
                    ),
                ),
                SizedBox(height: 30,),
                Text(
                  'Vybrať triedu',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.getColor('mono').grey,
                      ),
                ),
                SizedBox(height: 10,),
                DropdownButton<String>(
                  value: _selectedClass,
                  hint: Text('Select a class'),
                  items: classes!.map<DropdownMenuItem<String>>((String classId) {
                    return DropdownMenuItem<String>(
                      value: classId,
                      child: FutureBuilder<ClassData>(
                        future: fetchClass(classId),
                        builder: (BuildContext context, AsyncSnapshot<ClassData> snapshot) {
                            return Text(snapshot.data?.name ?? 'Unknown Class');
                        },
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedClass = newValue ?? '';
                    });
                  },
                ),
                SizedBox(height: 10,),
                Text(
                  'Meno a priezvisko ${_teacher ? 'učiteľa' : 'žiaka'}',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.getColor('mono').grey,
                      ),
                ),
                SizedBox(height: 10,),
                reTextField(
                  'Jožko Mrkvička',
                  false,
                  _userNameController,
                  AppColors.getColor('mono').white, // assuming white is the default border color you want
                ),
                SizedBox(height: 10,),
                Text(
                  'Email ${_teacher ? 'učiteľa' : 'žiaka'}',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.getColor('mono').grey,
                      ),
                ),
                reTextField(
                  'jozko.mrkvicka@gmail.com',
                  false,
                  _userEmailController,
                  AppColors.getColor('mono').white, // assuming white is the default border color you want
                ),
                SizedBox(height: 10,),
                Text(
                  'Heslo ${_teacher ? 'učiteľa' : 'žiaka'}',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.getColor('mono').grey,
                      ),
                ),
                reTextField(
                  'Heslo',
                  false,
                  _userPasswordController,
                  AppColors.getColor('mono').white, // assuming white is the default border color you want
                ),
                SizedBox(height: 50,),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                       ReButton(
                        activeColor: AppColors.getColor('mono').white, 
                        defaultColor: AppColors.getColor('green').main, 
                        disabledColor: AppColors.getColor('mono').lightGrey, 
                        focusedColor: AppColors.getColor('green').light, 
                        hoverColor: AppColors.getColor('green').light, 
                        textColor: Theme.of(context).colorScheme.onPrimary, 
                        iconColor: AppColors.getColor('mono').black, 
                        text: 'ULOŽIŤ', 
                        isDisabled: (_userNameController.text == '' || _userEmailController.text == '' ||_userPasswordController.text == '' || _selectedClass == null),
                        onTap: () {
                            registerUser(widget.currentUserData!.school, _selectedClass!, _userNameController.text, _userEmailController.text, _userPasswordController.text, _teacher, context, currentClass);
                          }
                      ),
                      Text(
                        'Ak učiteľ, ktorého chcete pridať, už má účet v aplikácií, pridáte ho tu.',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.getColor('mono').grey,
                          ),
                      ),
                    ],
                  )
                 
                ),
                SizedBox(height: 30,),
              ],
            ),
          ),
        ),
        if(_editClass) Align(
          alignment: Alignment.center,
          child: Container(
            margin: EdgeInsets.all(12),
            width: 900,
            height: 1080,
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
                        _onNavigationItemSelected(1);
                        _editClass = false;
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
                           '${currentClass!.data.name}/ Upraviť triedu',
                          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                color: Theme.of(context).colorScheme.onBackground,
                              ),
                        ),
                      ),
                    ),
                    SizedBox(width: 100,)
                  ],
                ),
                SizedBox(height: 30,),
                reTextField(
                  '1.A',
                  false,
                  _editClassNameController,
                  AppColors.getColor('mono').white, // assuming white is the default border color you want
                ),
                SizedBox(height: 50,),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ReButton(
                      activeColor: AppColors.getColor('mono').white, 
                      defaultColor: AppColors.getColor('mono').white, 
                      disabledColor: AppColors.getColor('mono').lightGrey, 
                      focusedColor: AppColors.getColor('mono').white, 
                      hoverColor: AppColors.getColor('mono').white, 
                      textColor: Theme.of(context).colorScheme.error, 
                      iconColor: Theme.of(context).colorScheme.error,
                      leftIcon: 'assets/icons/binIcon.svg',
                      text: 'Vymazať triedu', 
                      onTap: () {
                          deleteClass(currentClass!.id, widget.currentUserData!.school);
                          removeClassFromSchool(currentClass!.id, widget.currentUserData!.school);
                          deleteUserFunction(currentClass!.data.students,currentUser!.data, context);
                          deleteUserFunction(currentClass!.data.teachers,currentUser!.data, context);
                          reShowToast('Trieda úspešne vymazaná', false, context);
                        }
                    ),
                  ReButton(
                    activeColor: AppColors.getColor('mono').white, 
                    defaultColor: AppColors.getColor('green').main, 
                    disabledColor: AppColors.getColor('mono').lightGrey, 
                    focusedColor: AppColors.getColor('green').light, 
                    hoverColor: AppColors.getColor('green').light, 
                    textColor: Theme.of(context).colorScheme.onPrimary, 
                    iconColor: AppColors.getColor('mono').black, 
                    text: 'ULOŽIŤ', 
                    isDisabled: _editClassNameController.text == '',
                    onTap: () async {
                      currentClass!.data.name = _editClassNameController.text;
                      editClass(currentClass!.id,
                      ClassData(
                        name: _editClassNameController.text,
                        school: currentClass!.data.school,
                        students: List<String>.from(currentClass!.data.students),
                        teachers: List<String>.from(currentClass!.data.teachers),
                        materials: List<String>.from(currentClass!.data.materials),
                        capitolOrder: List<int>.from(currentClass!.data.capitolOrder),
                        posts: currentClass!.data.posts.map((post) {
                          return PostsData(
                            date: post.date,
                            id: post.id,
                            pfp: post.pfp,
                            userId: post.userId,
                            user: post.user,
                            value: post.value,
                            comments: post.comments.map((comment) {
                              return CommentsData(
                                award: comment.award,
                                userId: comment.userId,
                                pfp: comment.pfp,
                                answers: comment.answers.map((answer) {
                                  return CommentsAnswersData(
                                    award: answer.award,
                                    date: answer.date,
                                    pfp: answer.pfp,
                                    userId: answer.userId,
                                    user: answer.user,
                                    value: answer.value,
                                  );
                                }).toList(),
                                date: comment.date,
                                user: comment.user,
                                value: comment.value,
                              );
                            }).toList(),
                          );
                        }).toList(),
                      ));
                      reShowToast('Trieda úspešne upravená', false, context);
                    },
                  ),
                  ]
                  )
                ),
                SizedBox(height: 30,),
              ],
            ),
          ),
        ),
        if(_editUser) Align(
          alignment: Alignment.center,
          child: Container(
            margin: EdgeInsets.all(12),
            width: 900,
            height: 1080,
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
                        _onNavigationItemSelected(1);
                        _selectedClass = null;
                        _addUser = false;
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
                          _admin ? 'Upraviť srpávcu' : _teacher ? '${currentClass!.data.name} / Upraviť učiteľa' : '${currentClass!.data.name} / Upraviť žiaka',
                          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                color: Theme.of(context).colorScheme.onBackground,
                              ),
                        ),
                      ),
                    ),
                    SizedBox(width: 100,)
                  ],
                ),
                SizedBox(height: 40,),
                Text(
                  'Napíšte triedu, meno a email ${_teacher ? 'učiteľa' : 'žiaka'}',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: AppColors.getColor('mono').black,
                      ),
                ),
                SizedBox(height: 10,),
                Text(
                  'Po kliknutí na “ULOŽIŤ” sa učiteľovi odošle email s prihlasovacími údajmi',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.getColor('mono').grey,
                    ),
                ),
                SizedBox(height: 30,),
                Text(
                  'Meno a priezvisko ${_teacher ? 'učiteľa' : 'žiaka'}',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.getColor('mono').grey,
                      ),
                ),
                SizedBox(height: 10,),
                reTextField(
                  'Jožko Mrkvička',
                  false,
                  _editUserNameController,
                  AppColors.getColor('mono').white, // assuming white is the default border color you want
                ),
                SizedBox(height: 10,),
                Text(
                  'Email ${_teacher ? 'učiteľa' : 'žiaka'}',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.getColor('mono').grey,
                      ),
                ),
                reTextField(
                  'jozko.mrkvicka@gmail.com',
                  false,
                  _editUserEmailController,
                  AppColors.getColor('mono').white, // assuming white is the default border color you want
                ),
                SizedBox(height: 10,),
                Text(
                  'Heslo ${_teacher ? 'učiteľa' : 'žiaka'}',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.getColor('mono').grey,
                      ),
                ),
                reTextField(
                  'Heslo',
                  false,
                  _editUserPasswordController,
                  AppColors.getColor('mono').white, // assuming white is the default border color you want
                ),
                SizedBox(height: 50,),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                       Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ReButton(
                            activeColor: AppColors.getColor('mono').white, 
                            defaultColor: AppColors.getColor('green').main, 
                            disabledColor: AppColors.getColor('mono').lightGrey, 
                            focusedColor: AppColors.getColor('green').light, 
                            hoverColor: AppColors.getColor('green').light, 
                            textColor: Theme.of(context).colorScheme.onPrimary, 
                            iconColor: AppColors.getColor('mono').black, 
                            text: 'ULOŽIŤ', 
                            isDisabled: (_editUserNameController.text == '' || _editUserEmailController.text == '' ||_editUserPasswordController.text == ''),
                            onTap: () {
                                currentUser!.data.name = _editUserNameController.text;
                                currentUser!.data.email = _editUserEmailController.text;

                                saveUserDataToFirestore(currentUser!.data, currentUser!.id, _editUserEmailController.text, _editUserPasswordController.text,currentUser!.data, context );
                              }
                          ),
                          if(!_admin) ReButton(
                            activeColor: AppColors.getColor('mono').white, 
                            defaultColor: AppColors.getColor('mono').white, 
                            disabledColor: AppColors.getColor('mono').lightGrey, 
                            focusedColor: AppColors.getColor('mono').white, 
                            hoverColor: AppColors.getColor('mono').white, 
                            textColor: Theme.of(context).colorScheme.error, 
                            iconColor: Theme.of(context).colorScheme.error,
                            leftIcon: 'assets/icons/binIcon.svg',
                            text: currentUser!.data.teacher ? 'Vymazať učiteľa' : 'Vymazať žiaka',
                            onTap: () {
                                deleteUserFunction([currentUser!.id],currentUser!.data, context);
                              }
                          ),
                        ],
                      ),
                      Text(
                        'Ak učiteľ, ktorého chcete pridať, už má účet v aplikácií, pridáte ho tu.',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.getColor('mono').grey,
                          ),
                      ),
                    ],
                  )
                ),
                SizedBox(height: 30,),
              ],
            ),
          ),
        ),
      ],
      )
    );
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

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

Future<void> saveUserDataToFirestore(
  UserData userData,
  String userId,
  String newEmail,
  String newPassword,
  UserData? currentUser,
  BuildContext context
) async {
  try {
    // Reference to the user document in Firestore
    DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(userId);

    // Call the Firebase Function to update email and password
    final functions = FirebaseFunctions.instance;
    final result = await functions.httpsCallable('createAccount').call({
      'email': newEmail,
      'password': newPassword,
    });

    // Convert userData object to a Map
    Map<String, dynamic> userDataMap = {
      'badges': userData.badges,
      'admin': userData.admin,
      'discussionPoints': userData.discussionPoints,
      'weeklyDiscussionPoints': userData.weeklyDiscussionPoints,
      'teacher': userData.teacher,
      'email': newEmail, // Update the email in Firestore to the new email
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
                      'index': userAnswerData.index,
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
    reShowToast(currentUser!.teacher ? 'Učiteľ úspešne upravený' : 'Žiak úspešne upravený', false, context);
  } catch (e) {
    reShowToast(currentUser!.teacher ? 'Učiteľ sa nepodarilo upraviť' : 'Žiaka sa nepodarilo upraviť', true, context);
    rethrow;
  }
}


 Future<void> registerUser(String schoolId ,String classId, String name, String email, String password, bool teacher, BuildContext context, ClassDataWithId? currentClass) async {
  try {
    final functions = FirebaseFunctions.instance;
    final result = await functions.httpsCallable('createAccount').call({
      'email': email,
      'password': password,
    });

    // updateClassToFirestore(data.schoolClass, result.data['uid']);
    UserData data = UserData(
      admin: false,
      discussionPoints: 0,
      weeklyDiscussionPoints: 0,
      id: '',
      email: email,
      name: name,
      school: schoolId,
      active: false,
      classes: [
        classId,
      ],
      schoolClass: classId,
      image: 'assets/profilePicture.svg',
      surname: '',
      teacher: teacher,
      points: 0,
      capitols: [
        UserCapitolsData(
          completed: false,
          id: '1',
          image: '',
          name: 'Kritické Myslenie',
          tests: [
            UserCapitolsTestData(
              completed: false,
              name: 'Úvod do kritického myslenia',
              points: 0,
              questions: [
                UserQuestionsData(answer: [], completed: false, correct: [false, false, false, false, false]),
                UserQuestionsData(answer: [], completed: false, correct: [false, false, false]),
                UserQuestionsData(answer: [], completed: false, correct: [false]),
                UserQuestionsData(answer: [], completed: false, correct: [false, false, false, false, false, false, false]),
              ],
            ),
            UserCapitolsTestData(
              completed: false,
              name: 'Kognitívne skreslenia',
              points: 0,
              questions: [
                UserQuestionsData(answer: [], completed: false, correct: [false]),
                UserQuestionsData(answer: [], completed: false, correct: [false]),
                UserQuestionsData(answer: [], completed: false, correct: [false]),
                UserQuestionsData(answer: [], completed: false, correct: [false, false]),
                UserQuestionsData(answer: [], completed: false, correct: [false]),
                UserQuestionsData(answer: [], completed: false, correct: [false, false]),
                UserQuestionsData(answer: [], completed: false, correct: [false]),
                UserQuestionsData(answer: [], completed: false, correct: [false, false]),
                UserQuestionsData(answer: [], completed: false, correct: [false]),
                UserQuestionsData(answer: [], completed: false, correct: [false, false, false]),
              ],
            ),
          ],
        ),
        UserCapitolsData(
          completed: false,
          id: '1',
          image: '',
          name: 'Argumentácia',
          tests: [
            UserCapitolsTestData(
              completed: false,
              name: 'Analýza a Tvrdenie',
              points: 0,
              questions: [
                UserQuestionsData(answer: [], completed: false, correct: [false]),
                UserQuestionsData(answer: [], completed: false, correct: [false]),
                UserQuestionsData(answer: [], completed: false, correct: [false]),
                UserQuestionsData(answer: [], completed: false, correct: [false]),
                UserQuestionsData(answer: [], completed: false, correct: [false]),
                UserQuestionsData(answer: [], completed: false, correct: [false]),
                UserQuestionsData(answer: [], completed: false, correct: [false]),
              ],
            ),
            UserCapitolsTestData(
              completed: false,
              name: '1.1 Časti debatného argumentu',
              points: 0,
              questions: [
                UserQuestionsData(answer: [], completed: false, correct: [false]),
                UserQuestionsData(answer: [], completed: false, correct: [false]),
                UserQuestionsData(answer: [], completed: false, correct: [false]),
                UserQuestionsData(answer: [], completed: false, correct: [false]),
                UserQuestionsData(answer: [], completed: false, correct: [false]),
              ],
            ),
            UserCapitolsTestData(
              completed: false,
              name: 'Čo je argument (úvod do argumentu)',
              points: 0,
              questions: [
                UserQuestionsData(answer: [], completed: false, correct: [false, false, false]),
                UserQuestionsData(answer: [], completed: false, correct: [false]),
                UserQuestionsData(answer: [], completed: false, correct: [false]),
                UserQuestionsData(answer: [], completed: false, correct: [false]),
                UserQuestionsData(answer: [], completed: false, correct: [false]),
                UserQuestionsData(answer: [], completed: false, correct: [false]),
                UserQuestionsData(answer: [], completed: false, correct: [false]),
                UserQuestionsData(answer: [], completed: false, correct: [false]),
                UserQuestionsData(answer: [], completed: false, correct: [false, false, false]),
              ],
            ),
            UserCapitolsTestData(
              completed: false,
              name: 'Dôkaz',
              points: 0,
              questions: [
                UserQuestionsData(answer: [], completed: false, correct: [false, false]),
                UserQuestionsData(answer: [], completed: false, correct: [false]),
                UserQuestionsData(answer: [], completed: false, correct: [false]),
                UserQuestionsData(answer: [], completed: false, correct: [false]),
                UserQuestionsData(answer: [], completed: false, correct: [false]),
              ],
            ),
            UserCapitolsTestData(
              completed: false,
              name: '1.1  Silné a slabé argumenty',
              points: 0,
              questions: [
                UserQuestionsData(answer: [], completed: false, correct: [false]),
                UserQuestionsData(answer: [], completed: false, correct: [false]),
                UserQuestionsData(answer: [], completed: false, correct: [false]),
              ],
            ),
            UserCapitolsTestData(
              completed: false,
              name: '1.2  Silné a slabé argumenty',
              points: 0,
              questions: [
                UserQuestionsData(answer: [], completed: false, correct: [false]),
                UserQuestionsData(answer: [], completed: false, correct: [false]),
                UserQuestionsData(answer: [], completed: false, correct: [false]),
              ],
            ),
            UserCapitolsTestData(
              completed: false,
              name: '1. Závery (výroková logika I.)',
              points: 0,
              questions: [
                UserQuestionsData(answer: [], completed: false, correct: [false]),
                UserQuestionsData(answer: [], completed: false, correct: [false]),
                UserQuestionsData(answer: [], completed: false, correct: [false]),
                UserQuestionsData(answer: [], completed: false, correct: [false]),
                UserQuestionsData(answer: [], completed: false, correct: [false]),
                UserQuestionsData(answer: [], completed: false, correct: [false]),
              ],
            ),
            UserCapitolsTestData(
              completed: false,
              name: '1. Predpoklady (výroková logika II.)',
              points: 0,
              questions: [
                UserQuestionsData(answer: [], completed: false, correct: [false]),
                UserQuestionsData(answer: [], completed: false, correct: [false]),
                UserQuestionsData(answer: [], completed: false, correct: [false]),
                UserQuestionsData(answer: [], completed: false, correct: [false]),
                UserQuestionsData(answer: [], completed: false, correct: [false]),
              ],
            ),
          ],
        ),
        
      ],
      materials: [],
      notifications: [],
      badges: [
        'assets/badges/badgeArgDis.svg',
        'assets/badges/badgeManDis.svg',
        'assets/badges/badgeCritDis.svg',
        'assets/badges/badgeDataDis.svg',
        'assets/badges/badgeGramDis.svg',
        'assets/badges/badgeMediaDis.svg',
        'assets/badges/badgeSocialDis.svg',
      ]
    );
    
    // Set the user's ID from Firebase
    data.id = result.data['uid'];



    // Once the user is created in Firebase Auth, add their data to Firestore
    await FirebaseFirestore.instance.collection('users').doc(data.id).set({
      'admin': data.admin,
      'email': data.email,
      'name': data.name,
      'discussionPoints': data.discussionPoints,
      'weeklyDiscussionPoints': data.weeklyDiscussionPoints,
      'active': data.active,
      'classes': data.classes,
      'school': data.school,
      'schoolClass': data.schoolClass,
      'image': data.image,
      'surname': data.surname,
      'teacher': data.teacher,
      'points': data.points,
      'capitols': data.capitols.map((capitol) => {
        'id': capitol.id,
        'name': capitol.name,
        'image': capitol.image,
        'completed': capitol.completed,
        'tests': capitol.tests.map((test) => {
          'name': test.name,
          'completed': test.completed,
          'points': test.points,
          'questions': test.questions.map((question) => {
            'answer': question.answer,
            'completed': question.completed,
            'correct': question.correct
          }).toList(),
        }).toList(),
      }).toList(),
      'notifications': data.notifications,
      'materials': data.materials,
      'badges': data.badges,
    });
    updateClassToFirestore(classId, data.id, teacher, context);

     if (teacher) {
      currentClass!.data.teachers.add(data.id);

    } else {
      currentClass!.data.students.add(data.id);
    }
    
    reShowToast(teacher ? 'Učiteľ úspešne pridaný' : 'Žiak úspešne pridaný', false, context);
  } catch (e) {
    reShowToast(teacher ? 'Učiteľa sa nepodarilo pridať' : 'Žiaka sa nepodarilo pridať', true, context);
  }

  
}

Future<void> updateClassToFirestore(String classId, String userId, bool teacher, BuildContext context) async {
  try {
    ClassData currentClass = await fetchClass(classId);

    DocumentReference classRef =
        FirebaseFirestore.instance.collection('classes').doc(classId);

    Map<String, dynamic> updateData = {};
    if (!teacher) {
      updateData['students'] = FieldValue.arrayUnion([userId]);
    } else {
      updateData['teachers'] = FieldValue.arrayUnion([userId]);
    }

    await classRef.update(updateData);

  } catch (e) {
    reShowToast('Triedu sa nepodarilo upraviť', true, context);
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

Future<void> deleteUserFunction(List<String> userIds, UserData currentUser, BuildContext context) async {
  try {
    for (String userId in userIds) {
      // Find the class document that contains the userId
      final classQuery = await FirebaseFirestore.instance
          .collection('classes')
          .where('students', arrayContains: userId)
          .get();

      // Check if the userId is also in the 'teachers' array
      final teacherQuery = await FirebaseFirestore.instance
          .collection('classes')
          .where('teachers', arrayContains: userId)
          .get();

      // Combine the class and teacher queries to ensure we remove the userId from both arrays
      final combinedQuery = classQuery.docs + teacherQuery.docs;

      for (final classDoc in combinedQuery) {
        // Remove the userId from the 'students' and 'teachers' arrays in the class document
        await classDoc.reference.update({
          'students': FieldValue.arrayRemove([userId]),
          'teachers': FieldValue.arrayRemove([userId]),
        });
      }

      // Call deleteUser(userId) to delete the user document
      await deleteUser(userId);
    }

    // Step 3: Call the deleteAccount cloud function
    // Replace 'your-cloud-function-url' with the actual URL of your deleteAccount function
    final deleteAccountCallable =
        FirebaseFunctions.instance.httpsCallable('deleteAccount');
    await deleteAccountCallable(userIds);

    reShowToast(currentUser.teacher ? 'Učiteľ úspešne vymazaný' : 'Žiak úspešne vymazaný', false, context);
  } catch (error) {
    reShowToast(currentUser.teacher ? 'Učiteľa sa nepodarilo vymazať' : 'Žiaka sa nepodarilo vymazať', true, context);
    throw error;
  }
}