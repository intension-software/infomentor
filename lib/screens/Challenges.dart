import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infomentor/Colors.dart';
import 'package:infomentor/backend/fetchCapitols.dart';
import 'package:infomentor/backend/fetchUser.dart';
import 'package:infomentor/screens/Test.dart';
import 'package:infomentor/widgets/ReWidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Challenges extends StatefulWidget {
  final String capitolsId;
  final Future<void> fetch;
  final UserData? currentUserData;

  const Challenges({Key? key, required this.capitolsId, required this.fetch, required this.currentUserData});

  @override
  State<Challenges> createState() => _ChallengesState();
}

class _ChallengesState extends State<Challenges> {
  bool isOverlayVisible = false;
  late OverlayEntry overlayEntry;
  int testsLength = 0;
  String? title;
  int? color;

  @override
  void initState() {
    super.initState();
    fetchQuestionData();
  }

  Future<void> refreshData() async {
    await fetchQuestionData();
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
            child: Test(testIndex: testIndex, overlay: toggle, capitolsId: widget.capitolsId, userData: widget.currentUserData),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background
      ),
        child: Column(
          children: <Widget>[
            // Your FractionallySizedBox here (not modified for brevity)
            FractionallySizedBox(
              widthFactor: 1.0,
              child: Container(
                decoration: BoxDecoration(color: Theme.of(context).primaryColor),
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    Text(
                      title ?? '',
                      style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      height: 10,
                      child: LinearProgressIndicator(
                        value: testsLength != 0 ? countTrueTests(widget.currentUserData!.capitols[int.parse(widget.capitolsId)].tests) / testsLength : 0,
                        backgroundColor: AppColors.blue.lighter,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.green.main),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 500,
                      height: MediaQuery.of(context).size.height,
                        child: ListView.builder(
                        reverse: true,
                        itemCount: testsLength,
                        itemBuilder: (BuildContext context, int index) {
                          EdgeInsets padding = EdgeInsets.only(
                            left: index % 2 == 0 || index == 0 ? 0.0 : 90.0,
                            right: index % 2 == 0 || index == 0  ? 90.0 : 0.0,
                          );
                          return Column(
                            children: [
                            index == testsLength ? SizedBox(height: 100,) : Container(),
                            Container(
                            padding: padding,
                            height: 116,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Positioned.fill(
                                  child: OverflowBox(
                                    maxHeight: double.infinity,
                                    child: index % 2 == 0 || index == 0
                                        ? !(widget.currentUserData?.capitols?[int.parse(widget.capitolsId)]?.tests?[index]?.completed ?? false) ? SvgPicture.asset('assets/roadmap/leftRoad.svg') : SvgPicture.asset('assets/roadmap/leftRoadFilled.svg')
                                        : !(widget.currentUserData?.capitols?[int.parse(widget.capitolsId)]?.tests?[index]?.completed ?? false) ? SvgPicture.asset('assets/roadmap/rightRoad.svg') : SvgPicture.asset('assets/roadmap/rightRoadFilled.svg'),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(bottom: 30, right: index % 2 == 0 ? 10 : 0, left: index % 2 == 0 ? 0 : 10,),
                                  child: StarButton(
                                    number: index,
                                    color: color as int,
                                    userData: widget.currentUserData,
                                    onPressed: (int number) => toggleOverlayVisibility(number),
                                    capitolsId: widget.capitolsId,
                                  ),
                                )
                              ],
                            ),
                          )
                          ]
                          );
                        },
                      )
                    ),
                    widget.currentUserData!.teacher ? Container(
                      width: 500,
                      height: 500,
                      decoration: BoxDecoration(color: Colors.blue),
                      child: Text('Hey'),
                    ) : Container(),
                  ],
                ),
              )
        )
          ] 
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
  final String capitolsId;

  StarButton({
    required this.number,
    required this.onPressed,
    required this.color,
    required this.capitolsId,
    this.userData,
  });

 int countTrueValues(List<UserQuestionsData>? questionList) {
    int count = 0;
    if (questionList != null) {
      for (UserQuestionsData question in questionList) {
        if (question.completed == true) {
          count++;
        }
      }
    }
    return count;
}

  @override
Widget build(BuildContext context) {
  return SizedBox(
    child: userData != null &&
            !userData!.capitols[int.parse(capitolsId)].tests[number].completed
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
                width: 85.0,
                height: 85.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.mono.white, width: 2.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(90.0),
                  child: LinearProgressIndicator(
                    value: countTrueValues(userData!.capitols[int.parse(capitolsId)].tests[number].questions) /
                        userData!.capitols[int.parse(capitolsId)].tests[number].questions.length,
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
                  color: AppColors.mono.white,
                ),
                child: GestureDetector(
                  onTap: () {
                    showPopupMenu(context);
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Center(
                      child: countTrueValues(userData!.capitols[int.parse(capitolsId)].tests[number].questions) > 0 ? SvgPicture.asset('assets/icons/starYellowIcon.svg', height: 30,) : SvgPicture.asset('assets/icons/starGreyIcon.svg', height: 30,),
                    ),
                  ),
                ),
              ),
            ],
          )
        : Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                showPopupMenu(context);
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: SvgPicture.asset(
                  'assets/star.svg',
                  width: 85.0,
                  height: 85.0,
                ),
              ),
            ),
          ),
  );
}



  void showPopupMenu(BuildContext context) {
  final RenderBox button = context.findRenderObject() as RenderBox;
  final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;

  final Offset buttonTopLeft = button.localToGlobal(Offset.zero, ancestor: overlay);
  final Offset buttonBottomRight = button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay);
  final double buttonCenterX = (buttonTopLeft.dx + buttonBottomRight.dx) / 2;
  final double buttonCenterY = (buttonTopLeft.dy + buttonBottomRight.dy) / 2;
  final Offset buttonCenter = Offset(buttonCenterX, buttonCenterY);

  // Calculate the width of the menu
  final double menuWidth = MediaQuery.of(context).size.width; // Adjust the width according to your needs

  // Calculate the horizontal offset to center the menu
  final double offsetX = (button.size.width - menuWidth ) / 2 + 900;

  final RelativeRect position = RelativeRect.fromLTRB(
    buttonCenter.dx - offsetX,
    buttonCenter.dy + 40,
    buttonCenter.dx - offsetX,
    buttonCenter.dy,
  );

  int countTrueValues(List<UserQuestionsData>? questionList) {
    int count = 0;
    if (questionList != null) {
      for (UserQuestionsData question in questionList) {
        if (question.completed == true) {
          count++;
        }
      }
    }
    return count;
}

  showMenu<int>(
  context: context,
  position: position,
  shape: const TooltipShape(), // Add the TooltipShape as the shape for the popup menu
  items: <PopupMenuEntry<int>>[
    PopupMenuItem<int>(
      child: Container(
        padding: EdgeInsets.only(top: 16, bottom: 16, right: 10, left: 10),
        decoration: BoxDecoration(
          color: Color(color), // Use the same color as ReButton
          borderRadius: BorderRadius.circular(8), // Set rounded border radius
        ),
        child: Center(
          child: Column(

            children: [
              Text(
                'týždenná výzva',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                 color: Theme.of(context).colorScheme.onPrimary,
                  ),
              ),
              Text(
                userData?.capitols[int.parse(capitolsId)].tests[number].name ?? '',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                    ), // Set text color to white
              ),
              if (userData != null &&
                  !userData!.capitols[int.parse(capitolsId)].tests[number].completed)
                ReButton(activeColor: AppColors.mono.white, defaultColor:  AppColors.mono.white, disabledColor: AppColors.mono.lightGrey, focusedColor: AppColors.primary.light, hoverColor: AppColors.mono.lighterGrey, textColor: AppColors.mono.black, iconColor: AppColors.mono.black, text: 'ZAČAŤ', leftIcon: false, rightIcon: false, onTap: () {
                  onPressed(number);
                  Navigator.of(context).pop();
                }),
              if (userData != null &&
                  userData!.capitols[int.parse(capitolsId)].tests[number].completed && !userData!.capitols[int.parse(capitolsId)].completed)
                Column(
                  children: [
                    Text(
                      "HOTOVO",
                      style: TextStyle(color: Colors.white), // Set text color to white
                    ),
                    Text(
                      "${userData!.capitols[int.parse(capitolsId)].tests[number].points} / ${userData!.capitols[int.parse(capitolsId)].tests[number].questions.length}",
                      style: TextStyle(color: Colors.white), // Set text color to white
                    ),
                    ReButton(activeColor: AppColors.mono.white, defaultColor:  AppColors.mono.white, disabledColor: AppColors.mono.lightGrey, focusedColor: AppColors.primary.light, hoverColor: AppColors.mono.lighterGrey, textColor: AppColors.mono.black, iconColor: AppColors.mono.black, text: 'PREZRIEŤ', leftIcon: false, rightIcon: false, onTap: () {
                  onPressed(number);
                  Navigator.of(context).pop();
                }),
                  ],
                ),
              if (userData != null &&
                  userData!.capitols[int.parse(capitolsId)].tests[number].completed &&  userData!.capitols[int.parse(capitolsId)].completed)
                ReButton(activeColor: AppColors.mono.white, defaultColor:  AppColors.mono.white, disabledColor: AppColors.mono.lightGrey, focusedColor: AppColors.primary.light, hoverColor: AppColors.mono.lighterGrey, textColor: AppColors.mono.black, iconColor: AppColors.mono.black, text:  'PREZRIEŤ', leftIcon: false, rightIcon: false, onTap: () {
                  onPressed(number);
                  Navigator.of(context).pop();
                }),
            ],
          ),
        ),
      ),
    ),
  ],
);
}
}

class TooltipShape extends ShapeBorder {
  const TooltipShape();

  final BorderSide _side = BorderSide.none;
  final double _borderRadius = 8.0; // Adjust the radius as needed

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(_side.width);

  @override
  Path getInnerPath(
    Rect rect, {
    TextDirection? textDirection,
  }) {
    final Path path = Path();

    path.addRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(_borderRadius)),
    );

    return path;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final Path path = Path();
    final RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(_borderRadius));

    final double triangleWidth = 20.0; // Adjust the width of the triangle
    final double triangleHeight = 10.0; // Adjust the height of the triangle

    final double triangleTopCenterX = rrect.width / 2; // Calculate the X coordinate of the top center of the triangle
    final double triangleTopCenterY = rrect.top - triangleHeight; // Calculate the Y coordinate of the top center of the triangle

    path.moveTo(triangleTopCenterX, triangleTopCenterY);
    path.lineTo(triangleTopCenterX - (triangleWidth / 2), triangleTopCenterY + triangleHeight);
    path.lineTo(triangleTopCenterX + (triangleWidth / 2), triangleTopCenterY + triangleHeight);
    path.close();

    path.addRRect(rrect);

    return path;
  }

  

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => RoundedRectangleBorder(
        side: _side.scale(t),
        borderRadius: BorderRadius.circular(_borderRadius * t),
      );
}

