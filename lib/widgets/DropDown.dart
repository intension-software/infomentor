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

  @override
void initState() {
  super.initState();
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
    return options == null ? CircularProgressIndicator() : DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        handleSelection(newValue!);
      },
      items: options!.map<DropdownMenuItem<String>>((OptionsData value) {
        return DropdownMenuItem<String>(
          value: value.id,  // If you want the selection value to be the ID
          child: Row(
            children: [
              Text(value.data.name),
              if (value.id == dropdownValue) Icon(Icons.check),
            ],
          ),
        );
      }).toList(),
    );
  }



  Future<void> saveUserDataToFirestore(UserData userData) async {
    try {
      DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);
      Map<String, dynamic> userDataMap = {
        'email': userData.email,
        'name': userData.name,
        'active': userData.active,
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
