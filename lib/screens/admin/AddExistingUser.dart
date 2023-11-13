import 'package:flutter/material.dart';
import 'package:infomentor/Colors.dart';
import 'package:infomentor/backend/fetchSchool.dart';
import 'package:infomentor/screens/admin/MobileAdmin.dart';
import 'package:infomentor/widgets/ReWidgets.dart';
import 'package:infomentor/backend/fetchClass.dart';
import 'package:infomentor/backend/userController.dart';

class AddExistingUser extends StatefulWidget {
  final UserData? currentUserData;
  void Function(int) onNavigationItemSelected;
  String? selectedClass;
  ClassDataWithId? currentClass;
  List<String>? classes;
  List<String>? teachers;


  AddExistingUser(
    {
      Key? key, required this.currentUserData,
      required this.onNavigationItemSelected,
      required this.selectedClass,
      required this.currentClass,
      required this.classes,
      required this.teachers
    }
  );

  @override
  State<AddExistingUser> createState() => _AddExistingUserState();
}

class _AddExistingUserState extends State<AddExistingUser> {
  String _selectedTeacher = '';
  List<UserData> teacherDataList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTeachers();
  }

  Future<void> _fetchTeachers() async {
    List<UserData> fetchedTeachers = [];
    for (var teacherId in widget.teachers!) {
      try {
        print(teacherId);
        UserData teacherData = await fetchUser(teacherId);
        fetchedTeachers.add(teacherData);

        print(fetchedTeachers);
      } catch (e) {
        print("Error fetching teacher data: $e");
      }
    }

    setState(() {
      teacherDataList = fetchedTeachers;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 900,
        height: 1080,
        padding: EdgeInsets.all(8),
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
                    widget.onNavigationItemSelected(1);
                    widget.selectedClass = null;
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
                      'Pridať učiteľa',
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
              'Vyberte, ktorého učiteľa chcete priradiť k triede}',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: AppColors.getColor('mono').black,
                  ),
            ),
            SizedBox(height: 10,),
            Text(
              'Učiteľ bude môcť následne manažovať vybranú triedu/triedy',
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
              value: widget.selectedClass,
              hint: Text('Select a class'),
              items: widget.classes!.map<DropdownMenuItem<String>>((String classId) {
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
                  widget.selectedClass = newValue ?? '';
                });
              },
            ),
            SizedBox(height: 10,),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: teacherDataList.length,
                      itemBuilder: (BuildContext context, int index) {
                        UserData userData = teacherDataList[index];


                        if (widget.currentClass!.data.teachers.any((element) => element == userData.id)) {
                          return Container();
                        } else {
                          return _buildTeacherCheckbox(userData.name, userData.id);
                        }
                      },
                    ),
            ),
            
            Spacer(),
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
                    onTap: () {
                        setState(() {
                          widget.currentClass!.data.teachers.add(_selectedTeacher);
                        });
                        editClass(widget.selectedClass!, widget.currentClass!.data);
                        updateClasses(_selectedTeacher, widget.selectedClass!);
                      }
                  ),
                ],
              )
              
            ),
            SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }

  Widget _buildTeacherCheckbox(String name, String id) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.getColor('mono').lightGrey), // Grey border
        borderRadius: BorderRadius.circular(10.0), // Rounded corners
      ),
      margin: EdgeInsets.symmetric(vertical: 5.0), // Add margin for spacing
      child: CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          name,
          style: TextStyle(
            color: Colors.black, // Purple when checked
          ),
        ),
        value: _selectedTeacher == id,
        onChanged: (value) {
          setState(() {
            if (value!) {
              _selectedTeacher = id;
            } else {
              _selectedTeacher = '';
            }
          });
        },
        controlAffinity: ListTileControlAffinity.leading, // Place the checkbox to the left
        activeColor: AppColors.getColor('primary').main, // Custom active color
      ),
    );
  }
}