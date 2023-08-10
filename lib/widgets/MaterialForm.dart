import 'package:flutter/material.dart';
import 'package:infomentor/widgets/ReWidgets.dart';
import 'package:infomentor/backend/fetchMaterials.dart';
import 'package:file_picker/file_picker.dart';
import 'package:infomentor/Colors.dart';
import 'package:infomentor/backend/fetchUser.dart';
import 'dart:typed_data';  // for Uint8List
import 'package:flutter/foundation.dart';  // for kIsWeb
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


class MaterialForm extends StatefulWidget {
  final UserData? currentUserData;


  MaterialForm({
    Key? key,
    required this.currentUserData,
  }) : super(key: key);

  @override
  _MaterialFormState createState() => _MaterialFormState();
}

class _MaterialFormState extends State<MaterialForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the TextFields
  TextEditingController _associationController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _linkController = TextEditingController();
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _videoController = TextEditingController();

  List<String>? classMaterials;


  // Variables to hold state
  String? _type;
  String? _class;
  String? _imagePath;

  List<OptionsData>? classes; // example list of classes

  Future<void> fetchOptions() async {
  try {
    if (widget.currentUserData != null && widget.currentUserData!.classes != null) {
      _class = widget.currentUserData!.schoolClass;
      classes = await Future.wait(widget.currentUserData!.classes.map((id) async {
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


  @override
  void initState() {
    super.initState();

    fetchOptions();

    // Adding listeners for all controllers
    _addListener(_associationController);
    _addListener(_descriptionController);
    _addListener(_linkController);
    _addListener(_subjectController);
    _addListener(_titleController);
    _addListener(_videoController);
  }

  _addListener(TextEditingController controller) {
    controller.addListener(() {
      setState(() {});  // Trigger rebuild when any text changes
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 10),
             DropdownButtonFormField<String>(
              value: _class,
              onChanged: (newValue) {
                setState(() {
                  _class = newValue!;
                });
              },
              items: classes?.map<DropdownMenuItem<String>>((OptionsData value) {
                return DropdownMenuItem<String>(
                  value: value.id,
                  child: Row(
                    children: [
                      Text(value.data.name),
                      if (value.id == _class) Icon(Icons.check),
                    ],
                  ),
                );
              }).toList() ?? [],
              decoration: InputDecoration(labelText: 'Choose Class'),
            ),
              SizedBox(height: 10),
              // Checkbox tiles for type
              CheckboxListTile(
                title: Text('Type 1'),
                value: _type == 'Type 1',
                onChanged: (newValue) {
                  setState(() {
                    if (newValue == true) _type = 'Type 1';
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Type 2'),
                value: _type == 'Type 2',
                onChanged: (newValue) {
                  setState(() {
                    if (newValue == true) _type = 'Type 2';
                  });
                },
              ),
              SizedBox(height: 10),
              _buildTextField('Association', _associationController),
              SizedBox(height: 10),
              _buildTextField('Description', _descriptionController),
              SizedBox(height: 10),
              // File input for image
              
              _buildTextField('Link', _linkController),
              SizedBox(height: 10),
              _buildTextField('Subject', _subjectController),
              SizedBox(height: 10),
              _buildTextField('Title', _titleController),
              SizedBox(height: 10),
              _buildTextField('Video', _videoController),
              SizedBox(height: 10),
              // Drop-down for class
              
              ElevatedButton(
                  onPressed: () async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles();
                      if (result != null) {
                          setState(() {
                              if (kIsWeb) {
                                  final Uint8List? fileBytes = result.files.first.bytes;
                                  // TODO: Process the fileBytes as needed
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
                onPressed: _allFieldsCompleted()
                  ? () {
                      if (_formKey.currentState!.validate()) {
                        // Handle submission of form
                        MaterialData data = MaterialData(
                          association: _associationController.text,
                          description: _descriptionController.text,
                          image: _imagePath ?? 'placeholder.png',
                          link: _linkController.text,
                          subject: _subjectController.text,
                          title: _titleController.text,
                          type: _type!,
                          video: _videoController.text,
                        );
                        // TODO: Handle data as needed
                        addMaterialToFirestore(data);
                      }
                    }
                  : null,  // <-- If fields are not completed, button is disabled
                child: Text('Submit'),
              ),
            ],
          ),
        )
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
        _associationController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _linkController.text.isNotEmpty &&
        _subjectController.text.isNotEmpty &&
        _titleController.text.isNotEmpty &&
        _type != null;
}

Future<void> addMaterialToFirestore(MaterialData material) async {
  try {
    CollectionReference materialsRef =
        FirebaseFirestore.instance.collection('materials');

    // Add the material data to Firestore and get the DocumentReference of the new document
    DocumentReference docRef = await materialsRef.add({
      'association': material.association,
      'description': material.description,
      'image': material.image,
      'link': material.link,
      'subject': material.subject,
      'title': material.title,
      'type': material.type,
      'video': material.video,
    });

    // Update the materialId field with the Firestore-generated ID
    material.materialId = docRef.id;


    updateClassToFirestore(_class!, docRef.id);

  } catch (e) {
    print('Error adding material: $e');
    throw Exception('Failed to add material');
  }
}

Future<void> updateClassToFirestore(String classId, String materialId) async {
  try {
    ClassData currentClass = await fetchClass(classId);
    if (mounted) {
      setState(() {
          classMaterials = currentClass.materials;
        classMaterials!.add(materialId);
      });
    }

    DocumentReference classRef =
        FirebaseFirestore.instance.collection('classes').doc(classId);

    // Add the material data to Firestore and get the DocumentReference of the new document
    await classRef.update({
      'materials': FieldValue.arrayUnion([materialId])
    });

  } catch (e) {
    print('Error adding material to class: $e');
    throw Exception('Failed to add materialId');
  }
}

}
