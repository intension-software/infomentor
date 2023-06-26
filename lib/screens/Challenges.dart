import 'package:flutter/material.dart';
import 'package:infomentor/screens/Test.dart';
import 'package:infomentor/widgets/ReWidgets.dart';
import 'package:infomentor/backend/fetchCapitols.dart';
import 'package:infomentor/backend/fetchUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:infomentor/Colors.dart';

class Challenges extends StatefulWidget {
  final String capitolsId;
  final Future<void> fetch;

  const Challenges({Key? key, required this.capitolsId, required this.fetch});

  @override
  State<Challenges> createState() => _ChallengesState();
}

class _ChallengesState extends State<Challenges> {
  bool isOverlayVisible = false;
  late OverlayEntry overlayEntry;
  int testsLength = 0;
  String? title;
  UserData? currentUserData;
  int? color;

  @override
  void initState() {
    super.initState();
    fetchQuestionData();
    fetchUserData();
  }

  Future<void> refreshData() async {
    await fetchQuestionData();
    await fetchUserData();
    await widget.fetch;
  }

  void toggleOverlayVisibility(int index) {
    setState(() {
      isOverlayVisible = !isOverlayVisible;
    });

    if (isOverlayVisible) {
      overlayEntry = createOverlayEntry(context, index);
      Overlay.of(context)!.insert(overlayEntry);
    } else {
      overlayEntry.remove();
    }
  }

   int countTrueTests(List<UserCapitolsTestData>? boolList) {
    int count = 0;
    if (boolList != null) {
      for (UserCapitolsTestData testData in boolList) {
        if (testData.completed) {
          count++;
        }
      }
    }
    return count;
  }

  void toggle() {
    refreshData();
    overlayEntry.remove();
    isOverlayVisible = false;
    
  }

  Future<void> fetchUserData() async {
    try {
      // Retrieve the Firebase Auth user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Fetch the user data using the fetchUser function
        UserData userData = await fetchUser(user.uid);
        if (mounted) {
          setState(() {
            currentUserData = userData;
          });
        }
      } else {
        print('User is not logged in.');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> fetchQuestionData() async {
    try {
      FetchResult result = await fetchCapitols(widget.capitolsId);

      if (mounted) {
        setState(() {
          testsLength = result.capitolsData!.tests.length;
          title = result.capitolsData?.name;
          color = result.capitolsData?.color;
        });
      }
    } catch (e) {
      print('Error fetching question data: $e');
    }
  }

  OverlayEntry createOverlayEntry(BuildContext context, int testIndex) {
    return OverlayEntry(
      builder: (context) => Positioned.fill(
        child: GestureDetector(
          child: Container(
            color: Colors.black.withOpacity(0.5),
            alignment: Alignment.center,
            child: Test(testIndex: testIndex, overlay: toggle, capitolsId: "0", userData: currentUserData),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
        Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.background),
          child: Column(
          children: [
            FractionallySizedBox(
              widthFactor: 1.0,
              child: Container(
                decoration: BoxDecoration(color: Theme.of(context).primaryColor),
                child: Column(
                  children: [
                   
                    Text(
                      title ?? '',
                      style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: testsLength != 0 ? countTrueTests(currentUserData!.capitols[0].tests)  / testsLength : 0, /*+ capitolTwo*/ // Assuming the maximum points is 34
                      backgroundColor: AppColors.blue.lighter,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.green.main),
                      
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  child: ListView.builder(
                  reverse: true,
                  itemCount: testsLength ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: StarButton(
                        number: index,
                        color: color as int,
                        userData: currentUserData,
                        onPressed: (int number) => toggleOverlayVisibility(number),
                      ),
                    );
                  },
                ),
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}



 
class StarButton extends StatelessWidget {
  final int number;
  final int color;
  final UserData? userData;
  final void Function(int) onPressed;

  StarButton({
    required this.number,
    required this.onPressed,
    required this.color,
    this.userData,
  });

 

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showPopupMenu(context);
      },
      child: SizedBox(
        child: userData != null &&
                !userData!.capitols[0].tests[number].completed
            ? Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 60.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                    ),
                  ),
                  Container(
                    width: 80.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.mono.white, width: 2.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(90.0),
                      child: LinearProgressIndicator(
                        value: countTrueValues(userData!.capitols[0].tests[number].questions) /
                            userData!.capitols[0].tests[number].questions.length,
                        backgroundColor: AppColors.mono.lighterGrey,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.yellow.light),
                      ),
                    ),
                  ),
                  Container(
                    width: 70.0,
                    height: 70.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.mono.white
                    ),
                    child: Center(
                      child: Icon(
                        Icons.star,
                        color: AppColors.yellow.light,
                        size: 40,
                      ),
                    ),
                  ),
                ],
              )
            : Image.asset(
                'star.png',
                width: 100.0,
                height: 100.0,
              ),
      ),
    );
  }

  void showPopupMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

     int countTrueValues(List<bool>? boolList) {
        int count = 0;
        if (boolList != null) {
          for (bool value in boolList) {
            if (value == true) {
              count++;
            }
          }
        }
        return count;
      }

    showMenu<int>(
      context: context,
      position: position,
      items: <PopupMenuEntry<int>>[
        PopupMenuItem<int>(
          child: Column(
            children: [
              Text('týždenná výzva'),
              Text(userData?.capitols[0].tests[number].name ?? ''),
              if (userData != null &&
                  !userData!.capitols[0].tests[number].completed)
                reButton(context, "ZAČAŤ", color, 0xffffffff, 0xffffffff, () {
                  onPressed(number);
                  Navigator.of(context).pop();
                }),
              if (userData != null &&
                  userData!.capitols[0].tests[number].completed)
                Column(
                  children: [
                    Text("HOTOVO"),
                    Text(
                      "${userData!.capitols[0].tests[number].points} / ${userData!.capitols[0].tests[number].questions.length}",
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}