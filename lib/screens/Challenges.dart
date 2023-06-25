import 'package:flutter/material.dart';
import 'package:infomentor/screens/Test.dart';
import 'package:infomentor/widgets/ReWidgets.dart';
import 'package:infomentor/fetch.dart';

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

  @override
  void initState() {
    super.initState();
    fetchQuestionData(); // Call fetchQuestionData in initState
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

  Future<void> fetchQuestionData() async {
    try {
      FetchResult result = await fetchCapitols(widget.capitolsId);

      setState(() {
        testsLength = result.capitolsData?.tests.length;
      });
    } catch (e) {
      print('Error fetching question data: $e');
    }
  }

  OverlayEntry createOverlayEntry(BuildContext context, int testIndex) {
    return OverlayEntry(
      builder: (context) => Positioned.fill(
        child: GestureDetector(
          onTap: () {
            toggleOverlayVisibility(testIndex);
            Navigator.of(context).pop();
          },
          child: Container(
            color: Colors.black.withOpacity(0.5),
            alignment: Alignment.center,
            child: Test(testIndex: testIndex, overlay: () => overlayEntry.remove(),capitolsId:  "0")
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
  final void Function(int) onPressed;

  StarButton({required this.number, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed(number),
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
