import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infomentor/screens/Profile.dart';
import 'package:infomentor/backend/fetchUser.dart';
import 'package:infomentor/backend/fetchCapitols.dart';
import 'package:infomentor/Colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infomentor/backend/fetchClass.dart';
import 'dart:html' as html;

class OptionsData {
  String id;
  ClassData data;

  OptionsData({
    required this.id,
    required this.data
  });
}

class DropDown extends StatefulWidget {
  final UserData? currentUserData;
  final VoidCallback? onUserDataChanged;

  DropDown({
    Key? key,
    required this.currentUserData,
    this.onUserDataChanged,
  }) : super(key: key);

  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  String? dropdownValue;
  List<OptionsData>? options;
  bool isMobile = false;
  bool isDesktop = false;

  final userAgent = html.window.navigator.userAgent.toLowerCase();

  @override
void initState() {
  super.initState();
  final userAgent = html.window.navigator.userAgent.toLowerCase();
    isMobile = userAgent.contains('mobile');
    isDesktop = userAgent.contains('macintosh') ||
        userAgent.contains('windows') ||
        userAgent.contains('linux');
  fetchOptions();
}


Future<void> fetchOptions() async {
  try {
    if (widget.currentUserData != null && widget.currentUserData!.classes != null) {
          dropdownValue = widget.currentUserData!.schoolClass;
      options = await Future.wait(widget.currentUserData!.classes.map((id) async {
        ClassData classData = await fetchClass(id);
        return OptionsData(id: id, data: classData);
      }).toList());
      setState(() {});
    } else {
      print('Error: Current user data or classes is null');
    }
  } catch (e) {
    print('Error while fetching options: $e');
  }
}



  void handleSelection(String selectedId) {
    setState(() {
      dropdownValue = selectedId;
    });
    myFunction(selectedId);
  }
  void myFunction(String parameter) {
    widget.currentUserData!.schoolClass = parameter;
    saveUserDataToFirestore(widget.currentUserData!).then((_) {
      if (widget.onUserDataChanged != null) {
        widget.onUserDataChanged!(); // Call the callback when the data has been saved
      }
    });
  }
@override
Widget build(BuildContext context) {
  bool isDropdownOpen = false; // Track the open state of the dropdown

  return options == null
      ? CircularProgressIndicator()
      : ClipRRect(
          borderRadius: BorderRadius.circular(30.0), // Rounded corners for the entire popup
          child: Container(
            width: 138,
            height: isMobile ? 20 : 40,
            decoration: BoxDecoration(
              color: AppColors.getColor('mono').lighterGrey, // Set the background color to grey or transparent
              borderRadius: BorderRadius.circular(0.0), // Rounded corners for the button
            ),
            child: PopupMenuButton<String>(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // Adjust the border radius as needed
              ),
              offset: Offset(0, 40), 
              tooltip: '', // Remove the tooltip
              icon: Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Row(
                  children: [
                    Text(
                      dropdownValue != null ? 'Trieda: ${options!.firstWhere((option) => option.id == dropdownValue)!.data.name}' : '',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color:  AppColors.getColor('primary').main ,
                    ),
                    ),
                    Spacer(),
                    SvgPicture.asset('assets/icons/downIcon.svg', color: AppColors.getColor('primary').main),
                  ],
                ),
              ),
              onSelected: (String? newValue) {
                handleSelection(newValue!);
                setState(() {
                  isDropdownOpen = !isDropdownOpen; // Toggle the dropdown open state
                });
              },
              onCanceled: () {
                setState(() {
                  isDropdownOpen = !isDropdownOpen; // Toggle the dropdown open state when canceled
                });
              },
              itemBuilder: (BuildContext context) {
                return options!.map((OptionsData value) {
                  return PopupMenuItem<String>(
                    value: value.id,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8), // Add padding to make it rounded
                          child: Text(value.data.name),
                        ),
                      ],
                    ),
                  );
                }).toList();
              },
            ),
          ),
        );
}














  Future<void> saveUserDataToFirestore(UserData userData) async {
    try {
      DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);
      Map<String, dynamic> userDataMap = {
        'email': userData.email,
        'discussionPoints': userData.discussionPoints,
        'weeklyDiscussionPoints': userData.weeklyDiscussionPoints,
        'name': userData.name,
        'active': userData.active,
        'school': userData.school,
        'schoolClass': userData.schoolClass,
        'image': userData.image,
        'surname': userData.surname,
        'teacher': userData.teacher,
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
                    'answer': userQuestionsData.answer,
                    'completed': userQuestionsData.completed
                  };
                }).toList(),
              };
            }).toList(),
          };
        }).toList(),
        'materials': userData.materials,
      };
      await userRef.update(userDataMap);
    } catch (e) {
      print('Error saving user data to Firestore: $e');
      rethrow;
    }
  }
}
