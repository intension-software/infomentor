import 'package:flutter/material.dart';
import 'package:infomentor/screens/Test.dart';
import 'package:infomentor/widgets/ReWidgets.dart';
import 'package:infomentor/screens/backend/fetchCapitols.dart';
import 'package:infomentor/screens/backend/fetchUser.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Challenges extends StatefulWidget {
  final String capitolsId;

  const Challenges({Key? key, required this.capitolsId});

  @override
  State<Challenges> createState() => _ChallengesState();
}

class _ChallengesState extends State<Challenges> {
  bool isOverlayVisible = false;
  late OverlayEntry overlayEntry;
  int? testsLength;
  String? title;
  UserData? currentUserData;
  int? color;

  @override
  void initState() {
    super.initState();
    fetchQuestionData();
    fetchUserData();
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
          testsLength = result.capitolsData?.tests.length;
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
            child: Test(testIndex: testIndex, overlay: () => overlayEntry.remove(), capitolsId: "0", userData: currentUserData),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Text(
              title ?? '',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ListView.builder(
                  reverse: true,
                  itemCount: testsLength ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    final reversedIndex = (testsLength ?? 0) - index - 1;
                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: StarButton(
                        number: reversedIndex,
                        color: color as int,
                        userData: currentUserData,
                        onPressed: (int number) => toggleOverlayVisibility(number),
                      ),
                    );
                  },
                ),
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

  StarButton({required this.number, required this.onPressed,required this.userData, required this.color});

 @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        PopupMenuItem<int>(

          child: Column(
            children: [
              Text('týždenná výzva'),
              Text(userData!.capitols[0].tests[number].name),
              userData != null && !userData!.capitols[0].tests[number].completed
                  ? reButton(context, "ZAČAŤ", color, 0xffffffff, 0xffffffff, () => onPressed(number))
                  : Column(children: [
                    Text("HOTOVO"),
                    Text("${userData!.capitols[0].tests[number].points} / ${userData!.capitols[0].tests[number].questions.length}")
                  ]),
            ],
          ),
        ),
      ],
      child: Container(
        width: 60.0,
        height: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.yellow,
        ),
        child: Center(
          child: Icon(
            Icons.star,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
