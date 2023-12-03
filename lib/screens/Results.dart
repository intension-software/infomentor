import 'package:flutter/material.dart';
import 'package:infomentor/Colors.dart';
import 'package:infomentor/backend/fetchCapitols.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:infomentor/backend/userController.dart'; // Import the UserData class and fetchUser function
import 'package:infomentor/screens/Login.dart';
import 'package:infomentor/backend/fetchClass.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:async/async.dart';

class Results extends StatefulWidget {
  const Results({super.key});

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  final PageController _pageController = PageController();
 UserData? currentUserData;
  int capitolOne = 0;
  bool _isDisposed = false;
  List<String> badges = [];
  List<UserData>? students;
  CancelableOperation<UserData>? fetchUserDataOperation;
  CancelableOperation<List<UserData>>? fetchStudentsOperation;
  int? studentIndex;
  bool _loading = true;
  String selectedPeriod = 'Všetky';  // Initial selection


  int indexOfElement(List<UserData> list, String id) {
    for (var i = 0; i < list.length; i++) {
      if (list[i].id == id) {
        return i;
      }
    }
    return -1; // return -1 if the id is not found
  }

  @override
  void initState() {
    super.initState();
    _isDisposed = false; // Resetting _isDisposed state

    // Fetch the current user data.
    _fetchCurrentUserData().then((_) {
      // After fetching the current user data, fetch students.
      fetchStudents();
    });
  }

  Widget buildRadioButtons() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Radio<String>(
        value: 'Všetky',
        groupValue: selectedPeriod,
        onChanged: (String? value) {
          setState(() {
            selectedPeriod = value!;
          });
        },
      ),
      Text('Všetky'),
      Radio<String>(
        value: 'Prvý Polrok',
        groupValue: selectedPeriod,
        onChanged: (String? value) {
          setState(() {
            selectedPeriod = value!;
          });
        },
      ),
      Text('Prvý Polrok'),
      Radio<String>(
        value: 'Druhý Polrok',
        groupValue: selectedPeriod,
        onChanged: (String? value) {
          setState(() {
            selectedPeriod = value!;
          });
        },
      ),
      Text('Druhý Polrok'),
    ],
  );
}


  Future<void> _fetchCurrentUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      currentUserData = await fetchUser(user.uid);
    }
  }
  
  Future<void> fetchStudents() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null && currentUserData != null && currentUserData!.schoolClass != null) {
        final classData = await fetchClass(currentUserData!.schoolClass!);
        final studentIds = classData.students;
        List<UserData> fetchedStudents = [];

        for (var id in studentIds) {
          fetchUserDataOperation?.cancel();  // Cancel the previous operation if it exists
          fetchUserDataOperation = CancelableOperation<UserData>.fromFuture(fetchUser(id));

          UserData userData = await fetchUserDataOperation!.value;

          if (mounted) {
            fetchedStudents.add(userData);
          } else {
            return;
          }
        }

        // sort students by score

        if (mounted) {
          setState(() {
            studentIndex = indexOfElement(fetchedStudents, user.uid);
            students = fetchedStudents;
            _loading = false;
          });
        }

      } else {
        print('currentUserData is null');
      }
    } catch (e) {
      print('Error fetching students: $e');
    }
  }

  @override
Widget build(BuildContext context) {
  if (_loading) return Center(child: CircularProgressIndicator());

  return SingleChildScrollView(
    child: Container(
      color: Theme.of(context).colorScheme.background,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildRadioButtons(),  // Include the radio buttons
            if (students != null)
              buildScoreTable(students!)
          ],
        ),
      ),
    ),
  );
}



  List<Map<String, int>> getCapitolScores(UserData userData) {
    List<Map<String, int>> scores = [];

    for (var capitol in userData.capitols) {
      int capitolScore = 0;
      int capitolMaxScore = 0;

      for (var test in capitol.tests) {
        capitolScore += test.points;
        capitolMaxScore += test.questions.length;
      }

      scores.add({
        'score': capitolScore,
        'maxScore': capitolMaxScore,
      });
    }

    return scores;
  }


int getTotalScore(UserData userData) {
  int total = 0;

  for (var scoreMap in getCapitolScores(userData)) {
    total += scoreMap['score'] ?? 0;
  }

  return total;
}

int getMaxScore(UserData userData) {
  int total = 0;

  for (var capitol in userData.capitols) {
    for (var test in capitol.tests) {
      total += test.questions.length;
    }
  }

  return total;
}

Widget buildScoreTable(List<UserData> students) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,  // Enable horizontal scrolling
    child: Container(
      width: 1400,  // Set the table width to 1200 pixels
      margin: EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Table(
            border: TableBorder(
              right: BorderSide(color: Colors.grey),
            ),
            children: _buildRows(students),
          ),
        ),
      ),
    ),
  );
}



List<TableRow> _buildRows(List<UserData> students) {
  List<TableRow> rows = [];

  // Add header
  rows.add(
    TableRow(
      children: [
        Container(
          height: 50,
          width: 120,
          decoration: BoxDecoration(
          color: AppColors.getColor('primary').light,

            border: Border(
            right:  BorderSide(color: Colors.white),
          )
          ),
          padding: EdgeInsets.all(8),
          child: Text('Meno', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        ),
        ...students.first.capitols.map((e) => Container(
           decoration: BoxDecoration(
              color: AppColors.getColor('primary').light,

                border: Border(
                right:  BorderSide(color: Colors.white),
              )
              ),
              height: 50,
              padding: EdgeInsets.all(8),
              child: Text(e.name, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        )),
        Container(
          height: 50,
          width: 80,
          decoration: BoxDecoration(
          color: AppColors.getColor('primary').light,

            border: Border(
            right:  BorderSide(color: Colors.white),
          )
          ),
          padding: EdgeInsets.all(8),
          child: Text('Diskusia', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        ),
        Container(
          height: 50,
          width: 80,
          decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,

            border: Border(
            right:  BorderSide(color: Colors.white),
          )
          ),
          padding: EdgeInsets.all(8),
          child: Text('Preimerná Úspešnosť', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        ),
        Container(
          height: 50,
          width: 80,
          decoration: BoxDecoration(
            border: Border(
            right:  BorderSide(color: Colors.white),

          ),
          color: AppColors.getColor('green').light,

          ),
          padding: EdgeInsets.all(8),
          child: Text('Známka', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        ),
      ],
    ),
  );

  // Add data rows
  for (var student in students) {
    List<Map<String, int>> scores = getCapitolScores(student);
    int totalScore = getTotalScore(student);
    int maxScore = getMaxScore(student);
    double percentage = (totalScore / maxScore) * 100;
    String grade = getGrade(percentage);

    // Modify this part to filter capitols based on selectedPeriod
    if (selectedPeriod == 'Prvý Polrok') {
      scores = scores.take(4).toList();  // Take first 4 capitols for Prvý Polrok
    } else if (selectedPeriod == 'Druhý Polrok') {
      scores = scores.skip(4).toList();  // Skip first 4 capitols for Druhý Polrok
    }
    

    rows.add(
      TableRow(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 0.5,
                color: AppColors.getColor('mono').lighterGrey
              ),
            ),
            padding: EdgeInsets.all(8),
            child: Text('${student.name} ${student.surname}'),
          ),
          ...scores.map((score) => Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 0.5,
                color: AppColors.getColor('mono').lighterGrey
              ),
            ),
                padding: EdgeInsets.all(8),
                child: Text('${score['score']} / ${score['maxScore']}'),
          )),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 0.5,
                color: AppColors.getColor('mono').lighterGrey
              ),
            ),
            padding: EdgeInsets.all(8),
            child: Text(student.discussionPoints.toString()),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 0.5,
                color: AppColors.getColor('primary').main
              ),
              color: AppColors.getColor('primary').lighter
            ),
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${totalScore} / ${maxScore} = ${percentage.toStringAsFixed(2)}%"),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 0.5,
                color: AppColors.getColor('mono').lighterGrey
              ),
            ),
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(grade),
              ],
            ),
          ),
        ],
      ),
    );
  }

  return rows;
}

String getGrade(double percentage) {
  if (percentage >= 90 && percentage <= 100) return '1';
  if (percentage >= 75 && percentage < 90) return '2';
  if (percentage >= 50 && percentage < 75) return '3';
  if (percentage >= 30 && percentage < 50) return '4';
  return '5';
}


}