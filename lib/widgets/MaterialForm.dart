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
import 'package:flutter_svg/flutter_svg.dart';

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
  final Future<void> fetch;


  MaterialForm({
    Key? key,
    required this.fetch,
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
  void dispose() {
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return  Flexible(
        child:SingleChildScrollView(
            child: Form(
            key: _formKey,
            child: Container(
      width: 900,
      padding: EdgeInsets.all(12),
      child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 8),
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.getColor('red').lighter,
                        border: Border.all(
                          color: _type == 'Video' ? AppColors.getColor('red').main : AppColors.getColor('red').lighter,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Radio(
                            value: 'Video',
                            groupValue: _type,
                            onChanged: (newValue) {
                              setState(() {
                                if (newValue != null) _type = newValue;
                              });
                            },
                            activeColor: AppColors.getColor('red').main,
                          ),
                          Text(
                            'Video',
                            style: TextStyle(
                              color: AppColors.getColor('red').main,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10), // Add some spacing between the radio buttons
                    Container(
                      height: 30,
                      padding: EdgeInsets.only(right: 8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.getColor('red').lighter,
                        border: Border.all(
                          color: _type == 'Podujatie' ? AppColors.getColor('red').main : AppColors.getColor('red').lighter,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Radio(
                            value: 'Podujatie',
                            groupValue: _type,
                            onChanged: (newValue) {
                              setState(() {
                                if (newValue != null) _type = newValue;
                              });
                            },
                            activeColor: AppColors.getColor('red').main,
                          ),
                          Text(
                            'Podujatie',
                            style: TextStyle(
                              color: AppColors.getColor('red').main,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10), // Add some spacing between the radio buttons
                    Container(
                      height: 30,
                      padding: EdgeInsets.only(right: 8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.getColor('red').lighter,
                        border: Border.all(
                          color: _type == 'Projekt' ? AppColors.getColor('red').main : AppColors.getColor('red').lighter,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Radio(
                            value: 'Projekt',
                            groupValue: _type,
                            onChanged: (newValue) {
                              setState(() {
                                if (newValue != null) _type = newValue;
                              });
                            },
                            activeColor: AppColors.getColor('red').main,

                          ),
                          Text(
                            'Projekt',
                            style: TextStyle(
                              color: AppColors.getColor('red').main,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10), // Add some spacing between the radio buttons
                    Container(
                      height: 30,
                      padding: EdgeInsets.only(right: 8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.getColor('red').lighter,
                        border: Border.all(
                          color: _type == 'Textový materiál' ? AppColors.getColor('red').main : AppColors.getColor('red').lighter,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Radio(
                            value: 'Textový materiál',
                            groupValue: _type,
                            onChanged: (newValue) {
                              setState(() {
                                if (newValue != null) _type = newValue;
                              });
                            },
                            activeColor: AppColors.getColor('red').main,
                          ),
                          Text(
                            'Textový materiál',
                            style: TextStyle(
                              color: AppColors.getColor('red').main,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Text('Názov'),
                SizedBox(height: 15),
                _buildTextField('Názov', _titleController),
                SizedBox(height: 15),
                Text('Autor'),
                SizedBox(height: 15),
                _buildTextField('Autor', _associationController),
                SizedBox(height: 15),
                Text('Popis (nepovinné)'),
                SizedBox(height: 15),
                _buildTextField('Popis', _descriptionController),
                SizedBox(height: 15),
                // File input for image
                Text('Link'),
                SizedBox(height: 15),
                _buildTextField('Link', _linkController),
                // Drop-down for class
                SizedBox(height: 15),
                Text(
                    'Ukážka',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                Container(
                      width: 900,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.getColor('mono').lighterGrey
                        ),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                              width: 900,
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(context).primaryColor,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      _associationController.text,
                                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                        color: Theme.of(context).colorScheme.onPrimary,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      _titleController.text,
                                      style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                                        color: Theme.of(context).colorScheme.onPrimary,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                  ],
                                ),
                          ),

                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.getColor('red').lighter,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _type ?? '',
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: AppColors.getColor('red').main,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            _descriptionController.text,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            width: 180,
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: AppColors.getColor('mono').lighterGrey
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 10,),
                                SvgPicture.asset('assets/icons/linkIcon.svg'),
                                Text('Navštíviť odkaz', style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                color: AppColors.getColor('primary').main,
                              ),)
                              ],
                            )
                          )
                        ],
                      ),
                    ),
                SizedBox(height: 10),
                Center(
                  child: Container(
                    width: 225,
                    height: 50,
                    child: ReButton(
                      activeColor: AppColors.getColor('green').light, 
                      defaultColor: AppColors.getColor('green').main, 
                      disabledColor: AppColors.getColor('mono').lightGrey, 
                      focusedColor: AppColors.getColor('green').light, 
                      hoverColor: AppColors.getColor('green').lighter, 
                      textColor: AppColors.getColor('mono').white, 
                      iconColor: AppColors.getColor('mono').black,
                      isDisabled: !_allFieldsCompleted(),
                      text: 'PRIDAŤ DO APLIKÁCIE',
                      onTap: () {
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
                            widget.fetch;
                            reShowToast('Obsah pridaný', false, context);
                          }
                      }
                    ),
                  )
                )
                
              ],
            ),
          )
        )
      )
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return reTextField(
      label,
      false,
      controller,
      AppColors.getColor('mono').white, // assuming white is the default border color you want
      
    );
}

  bool _allFieldsCompleted() {
    return
        _associationController.text.isNotEmpty &&
        _linkController.text.isNotEmpty &&
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
