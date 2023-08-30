import 'package:flutter/material.dart';
import 'package:infomentor/Colors.dart';
import 'package:infomentor/backend/fetchCapitols.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:infomentor/backend/fetchUser.dart'; // Import the UserData class and fetchUser function
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
    /* _fetchCurrentUserData().then((_) {
      // After fetching the current user data, fetch students.
      fetchStudents();
    });*/
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
  return SingleChildScrollView(
    child: Container(
      child: Column(
        children: [
          if (students != null)
            /* buildScoreTable(students!) */
            Container()
        ],
      ),
    ),
  );
}


  List<int> getCapitolScores(UserData userData) {
  List<int> scores = [];

  for (var capitol in userData.capitols) {
    int capitolScore = 0;
    for (var test in capitol.tests) {
      capitolScore += test.points;
    }
    scores.add(capitolScore);
  }
  return scores;
}

int getTotalScore(UserData userData) {
  int total = 0;
  for (var score in getCapitolScores(userData)) {
    total += score;
  }
  return total;
}

int getMaxScore(UserData userData) {
  int total = 0;
  for (var capitols in userData.capitols) {
    for(var score in capitols.tests) {
      total += score.questions.length;
    }
  }
  return total;
}

  Widget buildScoreTable(List<UserData> students) {
  return DataTable(
    columns: _buildColumns(students.first.capitols),
    rows: _buildRows(students),
  );
}

List<DataColumn> _buildColumns(List<UserCapitolsData> capitols) {
  List<DataColumn> columns = [];
  columns.add(DataColumn(label: Text('Name')));

  for (var capitol in capitols) {
    columns.add(DataColumn(label: Text(capitol.name)));
  }
  columns.add(DataColumn(label: Text('Total')));
  columns.add(DataColumn(label: Text('%')));

  return columns;
}

List<DataRow> _buildRows(List<UserData> students) {
  List<DataRow> rows = [];

  for (var student in students) {
    List<DataCell> cells = [];
    cells.add(DataCell(Text(student.name)));

    List<int> scores = getCapitolScores(student);
    for (var score in scores) {
      cells.add(DataCell(Text(score.toString())));
    }

    int totalScore = getTotalScore(student);
    int maxScore = getMaxScore(student);
    double percentage = (totalScore / maxScore) * 100;

    cells.add(DataCell(Text(totalScore.toString())));
    cells.add(DataCell(Text("${percentage.toStringAsFixed(2)}%")));

    rows.add(DataRow(cells: cells));
  }

  return rows;
}

}