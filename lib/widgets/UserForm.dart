import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:infomentor/widgets/ReWidgets.dart';
import 'package:infomentor/backend/fetchMaterials.dart';
import 'package:file_picker/file_picker.dart';
import 'package:infomentor/Colors.dart';
import 'package:infomentor/backend/fetchUser.dart';
import 'dart:typed_data';  // for Uint8List
import 'package:flutter/foundation.dart';  // for kIsWeb
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infomentor/backend/fetchClass.dart';
import 'package:infomentor/backend/fetchUser.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OptionsData {
  String id;
  ClassData data;

  OptionsData({
    required this.id,
    required this.data
  });
}

class UserForm extends StatefulWidget {
  final UserData? currentUserData;

  UserForm({
    Key? key,
    required this.currentUserData,
  }) : super(key: key);

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();

  List<String>? classStudents;
  List<String>? classTeachers;


  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _schoolClassController = TextEditingController();
  TextEditingController _imageController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();  // Password Controller

  bool _isTeacher = false;
  bool _isAdmin = false;
  String? _class;
  String? _imagePath;

  @override
  void dispose() {
  super.dispose();
}

  // ... [rest of the code for fetching classes, etc. remains the same]

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: 10),
            _buildTextField('Email', _emailController),
            _buildTextField('Name', _nameController),
            _buildTextField('Surname', _surnameController),
            _buildTextField('Password', _passwordController),
            SizedBox(height: 10),
            CheckboxListTile(
              title: Text('Teacher'),
              value: _isTeacher,
              onChanged: (newValue) {
                setState(() {
                  _isTeacher = newValue!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Admin'),
              value: _isAdmin,
              onChanged: (newValue) {
                setState(() {
                  _isAdmin = newValue!;
                });
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles();
                if (result != null) {
                  setState(() {
                    if (kIsWeb) {
                      final Uint8List? fileBytes = result.files.first.bytes;
                    } else {
                      _imagePath = result.files.single.path;
                    }
                  });
                }
              },
              child: Text('Choose Image'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _allFieldsCompleted() ? () {
                if (_formKey.currentState!.validate()) {
                  // Handle submission of form
                  // TODO: Handle data processing here
                  registerUser(
                   UserData(
                    admin: _isAdmin,
                    id: '',
                    email: _emailController.text,
                    name: _nameController.text,
                    active: false,
                    classes: [
                      widget.currentUserData!.schoolClass,
                    ],
                    schoolClass: widget.currentUserData!.schoolClass,
                    image: 'assets/profilePicture.svg',
                    surname: _surnameController.text,
                    teacher: _isTeacher,
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
                  ),
                    _emailController.text,
                    _passwordController.text
                  );
                }
              } : null,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return reTextField(
      label,
      false,
      controller,
      AppColors.mono.white, // assuming white is the default border color you want
    );
  }

  bool _allFieldsCompleted() {
    return
        _emailController.text.isNotEmpty &&
        _nameController.text.isNotEmpty &&
        _surnameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty;
  }

 Future<void> registerUser(UserData data, String email, String password) async {
  try {
    final functions = FirebaseFunctions.instance;
    final result = await functions.httpsCallable('createAccount').call({
      'email': email,
      'password': password,
    });

    updateClassToFirestore(data.schoolClass, result.data['uid']);
    
    // Set the user's ID from Firebase
    data.id = result.data['uid'];

    // Once the user is created in Firebase Auth, add their data to Firestore
    await FirebaseFirestore.instance.collection('users').doc(data.id).set({
      'admin': data.admin,
      'email': data.email,
      'name': data.name,
      'active': data.active,
      'classes': data.classes,
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
  } catch (e) {
    print('Error registering user: $e');
    throw Exception('Failed to register user');
  }
}

Future<void> updateClassToFirestore(String classId, String userId) async {
  try {
    ClassData currentClass = await fetchClass(classId);
    if (mounted) {
      setState(() {
        classStudents = currentClass.students;
        classTeachers = currentClass.teachers;
        if (!_isTeacher) classStudents!.add(userId);
        if (_isTeacher) classTeachers!.add(userId);
      });
    }

    DocumentReference classRef =
        FirebaseFirestore.instance.collection('classes').doc(classId);

    Map<String, dynamic> updateData = {};
    if (!_isTeacher) {
      updateData['students'] = FieldValue.arrayUnion([userId]);
    } else {
      updateData['teachers'] = FieldValue.arrayUnion([userId]);
    }

    await classRef.update(updateData);

  } catch (e) {
    print('Error adding material to class: $e');
    throw Exception('Failed to add user');
  }
}


}
