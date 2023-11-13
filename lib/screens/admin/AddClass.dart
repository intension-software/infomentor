import 'package:flutter/material.dart';
import 'package:infomentor/Colors.dart';
import 'package:infomentor/widgets/ReWidgets.dart';
import 'package:infomentor/backend/fetchClass.dart';
import 'package:infomentor/backend/userController.dart';

class AddClass extends StatefulWidget {
  final UserData? currentUserData;
  void Function(int) onNavigationItemSelected;
  bool teacher;
  TextEditingController classNameController;
  void Function(ClassDataWithId) addSchoolData;
  List<String> classes;
  

  AddClass(
    {
      Key? key, required this.currentUserData,
      required this.onNavigationItemSelected,
      required this.teacher,
      required this.classNameController,
      required this.addSchoolData,
      required this.classes
    }
  );

  @override
  State<AddClass> createState() => _AddClassState();
}

class _AddClassState extends State<AddClass> {
  String _errorText = '';

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
                    widget.onNavigationItemSelected(0);
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
              widget.classNameController,
              AppColors.getColor('mono').lightGrey, // assuming white is the default border color you want
              errorText: _errorText,
            ),
            Spacer(),
            Align(
              alignment: Alignment.center,
              child: Row(
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
                        isDisabled: widget.classNameController.text == '',
                        onTap: () async {
                          bool exists = await doesClassNameExist(widget.classNameController.text, widget.classes);
                          if(widget.classNameController.text != '' && !exists) {
                            setState(() {
                              _errorText = '';
                            });
                          addClass(widget.classNameController.text, widget.currentUserData!.school, widget.addSchoolData, null);
                          widget.classNameController.text = '';
                          widget.onNavigationItemSelected(0);
                          reShowToast('Trieda úspešne pridaná', false, context);
                          } else {
                            setState(() {
                              if(exists) _errorText = 'Meno už existuje';
                              if(widget.classNameController.text == '') _errorText = 'Pole je povinné';
                            });
                          }
                          
                        },
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
}