import 'dart:io';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'dart:convert';
import 'package:infomentor/backend/fetchClass.dart';
import 'package:infomentor/backend/auth.dart';
import 'dart:typed_data';


class ConvertTable {
  String name;
  String email;
  String classValue;
  String classId;

  ConvertTable({required this.name, required this.email, required this.classValue, required this.classId});
}

class IncorrectRow {
  int index;
  String error;

  IncorrectRow({required this.index,  required this.error});
}

class FileProcessingResult {
  List<IncorrectRow> incorrectRows;
  List<ConvertTable> data;
  int errNum;

  FileProcessingResult({required this.incorrectRows, required this.data, required this.errNum});
}



Future<FileProcessingResult?> processFile(Uint8List fileBytes, String extension, List<String> classIds) async {
  FileProcessingResult? result;

  switch (extension) {
    case 'csv':
      result = await processCSV(fileBytes, classIds);
      break;
    case 'xlsx':
      result = await processXLSX(fileBytes, classIds);
      break;
    default:
      print('Unsupported file type');
      return null;
  }

  return result;
}

// Existing isValidEmail function
bool isValidEmail(String email) {
  final emailRegex = RegExp(
    r'^[^@]+@[^@]+\.[^@]+',
  );
  return emailRegex.hasMatch(email);
}

// Modified check that combines both validations
Future<bool> isValidAndUnusedEmail(String email) async {
  return isValidEmail(email) && !(await isEmailAlreadyUsed(email));
}

Future<FileProcessingResult> processCSV(Uint8List fileBytes, List<String> classIds) async {
  final classes = await fetchClasses(classIds);
  Stream<List<dynamic>> csvStream = Stream.value(utf8.decode(fileBytes))
                                           .transform(LineSplitter())
                                           .transform(CsvToListConverter());

  final fields = await csvStream.toList();
  List<IncorrectRow> incorrectRows = [];
  List<ConvertTable> processedData = [];
  Set<String> seenEmails = Set<String>(); // Set to track seen emails
  int errNum = 0;

  for (int i = 0; i < fields.length; i++) {
    var row = fields[i];
    String name = row[0];
    String email = row[1];
    String classValue = row[2];

    bool classExists = false;
    String classId = '';

    for (int j = 0; j < classes.length; j++) {
      if (classes[j].name == classValue) {
        classExists = true;
        classId = classIds[j];
      }
    }
    bool emailIsValid = isValidEmail(email);
    bool emailAlreadySeen = !seenEmails.add(email); // Returns false if email is new

    List<String> errors = [];
    if (!classExists) {
        errors.add('Trieda neexistuje');
    }
    if (!emailIsValid || !await isEmailAlreadyUsed(email) || emailAlreadySeen) {
        errors.add(emailAlreadySeen ? 'Email sa už vyskytol v zozname' : 'Email je používaný alebo v zlom formáte');
    }

    if (errors.isNotEmpty) {
        incorrectRows.add(IncorrectRow(index: i, error: errors.join(' a ')));
        processedData.add(ConvertTable(name: name, email: email, classValue: classValue, classId: classId));
        errNum++;
    } else {
        incorrectRows.add(IncorrectRow(index: -1, error: errors.join(' a ')));
        processedData.add(ConvertTable(name: name, email: email, classValue: classValue, classId: classId));
    }
  }

  return FileProcessingResult(incorrectRows: incorrectRows, data: processedData, errNum: errNum);
}




Future<FileProcessingResult> processXLSX(Uint8List fileBytes, List<String> classIds) async {
  var excel = Excel.decodeBytes(fileBytes);
  final classes = await fetchClasses(classIds);
  List<IncorrectRow> incorrectRows = [];
  List<ConvertTable> processedData = [];
  Set<String> seenEmails = Set<String>(); // Set to track seen emails
  int errNum = 0;

  for (var table in excel.tables.keys) {
    for (int i = 1; i < excel.tables[table]!.rows.length; i++) {
      var row = excel.tables[table]!.rows[i];

      String getCellValue(dynamic cell) => cell?.value?.toString() ?? "";

      String name = getCellValue(row[0]);
      String email = getCellValue(row[1]);
      String classValue = getCellValue(row[2]);

      bool classExists = false;
      String classId = '';

      for (int j = 0; j < classes.length; j++) {
        if (classes[j].name == classValue) {
          classExists = true;
          classId = classIds[j];
        }
      }

      
      bool emailIsValid = isValidEmail(email);
      bool emailAlreadySeen = !seenEmails.add(email); // returns false if email is new

      List<String> errors = [];
      if (!classExists) {
        errors.add('Trieda neexistuje');
      }
      if (!emailIsValid || await isEmailAlreadyUsed(email) || emailAlreadySeen) {
        errors.add(emailAlreadySeen ? 'Email sa už vyskytol v zozname' : 'Email je používaný alebo v zlom formáte');
      }

      if (errors.isNotEmpty) {
        incorrectRows.add(IncorrectRow(index: i - 1, error: errors.join(' a ')));
        processedData.add(ConvertTable(name: name, email: email, classValue: classValue, classId: classId));
        errNum++;
      } else {
        incorrectRows.add(IncorrectRow(index: -1, error: errors.join(' a ')));
        processedData.add(ConvertTable(name: name, email: email, classValue: classValue, classId: classId));
      }
    }
  }

  return FileProcessingResult(incorrectRows: incorrectRows, data: processedData, errNum: errNum);
}











