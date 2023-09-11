import 'package:flutter/material.dart';
import 'package:infomentor/Colors.dart';
import 'package:infomentor/backend/fetchClass.dart';
import 'package:infomentor/backend/fetchUser.dart';
import 'package:infomentor/backend/fetchSchool.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infomentor/Colors.dart';
import 'package:infomentor/widgets/ReWidgets.dart';

class DesktopAdmin extends StatefulWidget {
  final UserData? currentUserData;
  const DesktopAdmin({Key? key, required this.currentUserData});

  @override
  State<DesktopAdmin> createState() => _DesktopAdminState();
}

class _DesktopAdminState extends State<DesktopAdmin> {
  List<String>? classes;
  String? schoolName;
  UserData? admin;
  bool _addClass = false;
  bool _addUser = false;
  bool _editClass = false;
  bool _editUser = false;
  final PageController _pageController = PageController();
  int _selectedIndex = 0;
  TextEditingController _classNameController = TextEditingController();
  bool _loading = true;
  String currentClass = '';

  // Create a list to store class data
  List<ClassData?> classDataList = [];

  Future<void> fetchSchoolData() async {
    try {
      SchoolData school = await fetchSchool(widget.currentUserData!.school);
      admin = await fetchUser(school.admin);

      setState(() {
        if (mounted) {
          classes = school.classes;
          schoolName = school.name;
          _loading = false;
        }
      });

      // Fetch class data once and store it in classDataList
      for (String classId in classes!) {
        ClassData classData = await fetchClass(classId);
        classDataList.add(classData);
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
    return PageView(
      controller: _pageController,
      onPageChanged: _onPageChanged,
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            alignment: Alignment.center,
            width: 900,
            height: 1080,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30,),
                Row(
                  children: [
                    Text(
                      schoolName!,
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                            color: AppColors.getColor('mono').black,
                          ),
                    ),
                    Spacer(),
                    Container(
                      child:  ReButton(
                        activeColor: AppColors.getColor('primary').light, 
                        defaultColor: AppColors.getColor('primary').main, 
                        disabledColor: AppColors.getColor('mono').lightGrey, 
                        focusedColor: AppColors.getColor('primary').light, 
                        hoverColor: AppColors.getColor('primary').lighter, 
                        textColor: Theme.of(context).colorScheme.onPrimary, 
                        iconColor: AppColors.getColor('mono').black, 
                        text: '+ Pridať žiakov', 
                        leftIcon: false, 
                        rightIcon: false, 
                        onTap: () {
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30,),
                Container(
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
                      Text('>')
                    ],
                  ),
                ),
                SizedBox(height: 30,),
                Row(
                  children: [
                    Text(
                      'Triedy',
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                            color: AppColors.getColor('mono').darkGrey,
                          ),
                    ),
                    Spacer(),
                    Container(
                      child:  ReButton(
                        activeColor: AppColors.getColor('primary').light, 
                        defaultColor: AppColors.getColor('mono').lighterGrey, 
                        disabledColor: AppColors.getColor('mono').lightGrey, 
                        focusedColor: AppColors.getColor('primary').light, 
                        hoverColor: AppColors.getColor('primary').lighter, 
                        textColor: AppColors.getColor('primary').main, 
                        iconColor: AppColors.getColor('mono').black, 
                        text: '+ Pridať triedu', 
                        leftIcon: false, 
                        rightIcon: false, 
                        onTap: () {
                          _onNavigationItemSelected(1);
                          _addClass = true;
                        },
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 900,
                  height: 300, // Set a fixed height for your ListView.builder
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                        shrinkWrap: true, // Ensure the ListView.builder only takes the necessary space
                        itemCount: classDataList.length, // Use the classDataList length
                        itemBuilder: (context, index) {
                          final classData = classDataList[index]; // Get the ClassData at the current index

                          if (classData == null) {
                            // Show loading indicator for classes that are still being fetched
                            return CircularProgressIndicator();
                          }

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                // Update the currentClass when a class is tapped
                                currentClass = classData.name;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.getColor('mono').lightGrey,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(
                                child: Text(
                                  classData.name,
                                  style: TextStyle(
                                    color: AppColors.getColor('mono').black,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
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
                Align(
                  alignment: Alignment.center,
                  child: ReButton(
                    activeColor: AppColors.getColor('mono').white, 
                    defaultColor: AppColors.getColor('green').main, 
                    disabledColor: AppColors.getColor('mono').lightGrey, 
                    focusedColor: AppColors.getColor('green').light, 
                    hoverColor: AppColors.getColor('green').light, 
                    textColor: Theme.of(context).colorScheme.onPrimary, 
                    iconColor: AppColors.getColor('mono').black, 
                    text: 'ULOŽIŤ', 
                    leftIcon: false, 
                    rightIcon: false,
                    isDisabled: _classNameController.text == '',
                    onTap: () async {
                      addClass(_classNameController.text, widget.currentUserData!.school);
                    },
                  ),
                ),
                SizedBox(height: 30,),
              ],
            ),
          ),
        ),
      ],
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
