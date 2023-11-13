import 'package:flutter/material.dart';
import 'package:infomentor/Colors.dart';
import 'package:infomentor/widgets/ReWidgets.dart';
import 'package:infomentor/backend/fetchClass.dart';
import 'package:infomentor/backend/convert.dart';
import 'package:infomentor/backend/userController.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;

class Csv extends StatefulWidget {
  final UserData? currentUserData;
  void Function(int) onNavigationItemSelected;
  String? selectedClass;
  ClassDataWithId? currentClass;
  List<String> classes;

  Csv(
    {
      Key? key, 
      required this.currentUserData,
      required this.onNavigationItemSelected,
      required this.selectedClass,
      required this.currentClass,
      required this.classes,
    }
  );

  @override
  State<Csv> createState() => _CsvState();
}

class _CsvState extends State<Csv> {
  FileProcessingResult? table;
  bool showTable = true;

  Future<FileProcessingResult?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(withData: true);

    if (result != null) {
      PlatformFile pickedFile = result.files.single;
      Uint8List fileBytes = pickedFile.bytes!;
      String fileName = pickedFile.name;
      String extension = fileName.split('.').last;

      return processFile(fileBytes, extension, widget.classes);
    } else {
      // User canceled the picker
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: EdgeInsets.all(8),
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
                    widget.onNavigationItemSelected(0);
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
                      'Pridať žiakov',
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
              'Importovať údaje žiakov',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: AppColors.getColor('mono').black,
                  ),
            ),
            SizedBox(height: 10,),
            Text(
              'Údaje nahrajte prostredníctvom .csv súboru. Aplikácia každému žiakovi vygeneruje a pošle prihlasovacie údaje.',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: AppColors.getColor('mono').grey,
                ),
            ),
            SizedBox(height: 30,),
            Text(
              'Súbor musí byť formátovaný nasledovne: ',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: AppColors.getColor('mono').grey,
                  ),
            ),
            Text(
              '3 stĺplce pomenované ako:',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: AppColors.getColor('mono').grey,
                  ),
            ),
            Text(
              '“Meno Priezvisko”',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: AppColors.getColor('mono').grey,
                  ),
            ),
            Text(
              '“Email”',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: AppColors.getColor('mono').grey,
                  ),
            ),
            Text(
              '“Trieda”',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: AppColors.getColor('mono').grey,
                  ),
            ),
            SizedBox(height: 30,),
              Text(
              'Názvy tried v súbore sa musia zhodovať s názvami, ktoré ste zadali v aplikácii.',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: AppColors.getColor('mono').grey,
                  ),
            ),
            SizedBox(height: 50,),
            showTable && table != null
          ? Expanded( 
            child: ListView.separated(
                itemCount: table!.data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(table!.data[index].name),
                    subtitle: table!.incorrectRows[index].index == index ? Text('${table!.data[index].email}, ${table!.data[index].classValue} - ${table!.incorrectRows[index].error}') : Text('${table!.data[index].email}, ${table!.data[index].classValue}'),
                    textColor: table!.incorrectRows[index].index == index ? Colors.red : Colors.black,
                  );
                },
                separatorBuilder: (context, index) => Divider(),
              )
            ) : Center(
              child: Image.asset('assets/import.png', width: 700, height: 300,),
            ),
            Spacer(),
            Align(
              alignment: Alignment.center,
              child: showTable && table != null ? 
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ReButton(
                        activeColor: AppColors.getColor('primary').light, 
                        defaultColor: AppColors.getColor('mono').lighterGrey, 
                        disabledColor: AppColors.getColor('mono').lightGrey, 
                        focusedColor: AppColors.getColor('primary').light, 
                        hoverColor: AppColors.getColor('primary').lighter, 
                        textColor: AppColors.getColor('primary').main, 
                        iconColor: AppColors.getColor('mono').black, 
                        text: 'SKÚSIŤ ZNOVA',
                        onTap: () async {
                          FileProcessingResult? result = await pickFile();
                          if (result != null) {
                            setState(() {
                              table = result;
                              showTable = true;
                            });
                          }
                        }
                      ),
                      SizedBox(width: 5,),
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
                          if (table!.errNum == 0) {
                            registerMultipleUsers(table!.data, widget.currentUserData!.school, false, context);
                          }
                        }
                    ),
                  ],
                )
              : Container(
                width: 277,
                child: 
                    ReButton(
                    activeColor: AppColors.getColor('mono').white, 
                    defaultColor: AppColors.getColor('green').main, 
                    disabledColor: AppColors.getColor('mono').lightGrey, 
                    focusedColor: AppColors.getColor('green').light, 
                    hoverColor: AppColors.getColor('green').light, 
                    textColor: Theme.of(context).colorScheme.onPrimary, 
                    iconColor: AppColors.getColor('mono').black, 
                    text: 'NAHRAŤ .CSV / .XLSX SÚBOR', 
                    onTap: () async {
                      FileProcessingResult? result = await pickFile();
                      if (result != null) {
                        setState(() {
                          table = result;
                          showTable = true;
                        });
                      }
                    },
                  ),
              )
              
            ),
            SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }
}