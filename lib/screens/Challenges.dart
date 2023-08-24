
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infomentor/Colors.dart';
import 'package:infomentor/backend/fetchCapitols.dart';
import 'package:infomentor/backend/fetchUser.dart';
import 'package:infomentor/screens/Test.dart';
import 'package:infomentor/widgets/ReWidgets.dart';
import 'package:infomentor/widgets/CapitolDragWidget.dart';
import 'package:percent_indicator/percent_indicator.dart';

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
  String? color;
  int _visibleContainerIndex = -1;

  @override
  void initState() {
    super.initState();
    fetchQuestionData();
  }

  Future<void> refreshData() async {
    await fetchQuestionData();
    await widget.fetch;
  }

  void toggleIndex(int index) {
    setState(() {
       _visibleContainerIndex = index;
    });
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

  double computeOffset(double width) {
    return (0.09 * 500) / width;
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
        color: Theme.of(context).colorScheme.background,
      ),
      child: Column(
        children: <Widget>[
          // Your FractionallySizedBox here (not modified for brevity)
          FractionallySizedBox(
            widthFactor: 1.0,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: !widget.currentUserData!.teacher ? Column(
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
                      value: testsLength != 0
                          ? countTrueTests(
                                  widget.currentUserData!.capitols[
                                      int.parse(widget.capitolsId)].tests) /
                              testsLength
                          : 0,
                      backgroundColor: AppColors.blue.lighter,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.green.main),
                    ),
                  ),
                ],
              ) : Container(),
            ),
          ),
          MediaQuery.of(context).size.width < 1000 && widget.currentUserData!.teacher ?
            Expanded(
              child: PageView(
                children: [
                  // First page - ListView
                  ListView.builder(
                    reverse: true,
                    itemCount: testsLength,
                    itemBuilder: (BuildContext context, int index) {
                      EdgeInsets padding = EdgeInsets.only(
                        left: index % 2 == 0 || index == 0 ? 0.0 : 85.0,
                        right: index % 2 == 0 || index == 0 ? 85.0 : 0.0,
                      );
                      return Column(
                        children: [
                          index == testsLength
                              ? SizedBox(
                                  height: 100,
                                )
                              : Container(),
                          Container(
                            padding: padding,
                            height: 118,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                OverflowBox(
                                  maxHeight: double.infinity,
                                  child: index % 2 == 0 || index == 0
                                      ? !(widget.currentUserData?.capitols?[int
                                                      .parse(widget.capitolsId)]
                                                  ?.tests?[index]
                                                  ?.completed ??
                                              false)
                                          ? SvgPicture.asset(
                                              'assets/roadmap/leftRoad.svg')
                                          : SvgPicture.asset(
                                              'assets/roadmap/leftRoadFilled.svg')
                                      : !(widget.currentUserData?.capitols?[int
                                                      .parse(widget.capitolsId)]
                                                  ?.tests?[index]
                                                  ?.completed ??
                                              false)
                                          ? SvgPicture.asset(
                                              'assets/roadmap/rightRoad.svg')
                                          : SvgPicture.asset(
                                              'assets/roadmap/rightRoadFilled.svg'),
                                ),
                                // <- Adjust this value to position the blue container
                                OverflowBox(
                                  alignment: index % 2 == 0 || index == 0
                                      ? Alignment(-computeOffset(MediaQuery.of(context).size.width), 2.65)
                                      : Alignment(computeOffset(MediaQuery.of(context).size.width), 2.65),
                                  maxHeight: double.infinity,
                                  child: index == _visibleContainerIndex  ? Container(
                                    width: 130.0,
                                    height: 130.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.blue.lighter,
                                    ),
                                  ) : Container(),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    bottom: 30,
                                    right: index % 2 == 0 ? 20 : 0,
                                    left: index % 2 == 0 ? 0 : 20,
                                  ),
                                  child: StarButton(
                                    number: index,
                                    userData: widget.currentUserData,
                                    onPressed: (int number) =>
                                        toggleOverlayVisibility(number),
                                    capitolsId: widget.capitolsId,
                                    visibleContainerIndex: (int number) => toggleIndex(number),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  // Second page - CapitolDragWidget (only if the user is a teacher)
                    Container(
                      height: MediaQuery.of(context).size.height,
                      child: CapitolDragWidget(currentUserData: widget.currentUserData),
                    ),
                ],
              ),
            ) : Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      itemCount: testsLength,
                      itemBuilder: (BuildContext context, int index) {
                        EdgeInsets padding = EdgeInsets.only(
                          left: index % 2 == 0 || index == 0 ? 0.0 : 85.0,
                          right: index % 2 == 0 || index == 0 ? 85.0 : 0.0,
                        );
                        return Column(
                          children: [
                            index == testsLength
                                ? SizedBox(
                                    height: 100,
                                  )
                                : Container(),
                            Container(
                              padding: padding,
                              height: 118,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  OverflowBox(
                                    maxHeight: double.infinity,
                                    child: index % 2 == 0 || index == 0
                                        ? !(widget.currentUserData?.capitols?[int
                                                        .parse(widget.capitolsId)]
                                                    ?.tests?[index]
                                                    ?.completed ??
                                                false)
                                            ? SvgPicture.asset(
                                                'assets/roadmap/leftRoad.svg')
                                            : SvgPicture.asset(
                                                'assets/roadmap/leftRoadFilled.svg')
                                        : !(widget.currentUserData?.capitols?[int
                                                        .parse(widget.capitolsId)]
                                                    ?.tests?[index]
                                                    ?.completed ??
                                                false)
                                            ? SvgPicture.asset(
                                                'assets/roadmap/rightRoad.svg')
                                            : SvgPicture.asset(
                                                'assets/roadmap/rightRoadFilled.svg'),
                                  ),
                                  // <- Adjust this value to position the blue container
                                  OverflowBox(
                                    maxHeight: double.infinity,
                                    child:  Container(
                                      height: 170,
                                      padding: EdgeInsets.only(
                                        bottom: 30,
                                        right: index % 2 == 0 ? 18 : 0,
                                        left: index % 2 == 0 ? 0 : 18,
                                      ),
                                      child: Stack (
                                        alignment: Alignment.center,
                                        children: [
                                        index == _visibleContainerIndex ?   
                                        Container(
                                          width: 170.0,
                                          height: 170.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: !widget.currentUserData!.capitols[int.parse(widget.capitolsId)].tests[index].completed ? AppColors.blue.lighter : AppColors.yellow.lighter,
                                          ),
                                        ) : Container(),
                                        StarButton(
                                          number: index,
                                          userData: widget.currentUserData,
                                          onPressed: (int number) =>
                                              toggleOverlayVisibility(number),
                                          capitolsId: widget.capitolsId,
                                          visibleContainerIndex: (int number) => toggleIndex(number),
                                        ),
                                        ]
                                      )
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  if (widget.currentUserData!.teacher)
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width / 2,
                      child: CapitolDragWidget(currentUserData: widget.currentUserData),
                    ),
                ],
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
  final UserData? userData;
  final void Function(int) onPressed;
  final String capitolsId;
  final void Function(int) visibleContainerIndex;

  StarButton({
    required this.number,
    required this.onPressed,
    required this.capitolsId,
    this.userData,
    required this.visibleContainerIndex
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
        ?  Stack(
          alignment: Alignment.center,
            children: [
              OverflowBox(
                  child:Container(
                width: double.infinity,
                height: 98.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
              ),
              OverflowBox(
                  child:Container(
                width: double.infinity,
                height: 87.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.mono.lightGrey,
                ),
              ),
              ),
              OverflowBox(
                  child: CircularPercentIndicator(
                    radius: 45.0,  // Adjust as needed
                    lineWidth: 8.0,
                    animation: true,
                    percent: countTrueValues(userData!.capitols[int.parse(capitolsId)].tests[number].questions) /
                            userData!.capitols[int.parse(capitolsId)].tests[number].questions.length,
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: AppColors.yellow.light,
                    backgroundColor: Colors.transparent,
                )
               ),
               
              Container(
                width: 76.0,
                height: 76.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.mono.white,
                ),
                child: GestureDetector(
                  onTap: () {
                    showPopupMenu(context, number % 2 == 0 ? 0 : 1);
                    visibleContainerIndex(number);
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
        : Stack(
          alignment: Alignment.center,
          children: [
            OverflowBox(
              child:Container(
                width: double.infinity, 
                  height: 98.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ), 
              Container(
                child: GestureDetector(
                onTap: () {
                  showPopupMenu(context, number % 2 == 0 ? 0 : 1);
                  visibleContainerIndex(number);
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: SvgPicture.asset(
                    'assets/star.svg',
                    width: 90.0,
                    height: 90.0,
                  ),
                ),
              ),
          ),
        ]
      )
  );
}



  void showPopupMenu(BuildContext context, int direction) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;

    final Offset buttonTopLeft = button.localToGlobal(Offset.zero, ancestor: overlay);
    final Offset buttonBottomRight = button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay);
    final double buttonCenterX = (buttonTopLeft.dx + buttonBottomRight.dx) / 2;
    final double buttonCenterY = (buttonTopLeft.dy + buttonBottomRight.dy) / 2;
    final Offset buttonCenter = Offset(buttonCenterX, buttonCenterY);

    // Calculate the width of the menu
    final double menuWidth = MediaQuery.of(context).size.width; // Adjust the width according to your needs
    final double offsetX;
    // Calculate the horizontal offset to center the menu
    if (userData!.teacher) {
      offsetX = (button.size.width - menuWidth ) / 2 + 756;
    } else {
      offsetX = (button.size.width - menuWidth ) / 2 + 276;
    }
    

    final RelativeRect position = RelativeRect.fromLTRB(
      buttonCenter.dx - offsetX,
      buttonCenter.dy + 45,
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
    constraints: BoxConstraints(maxWidth: 500, minWidth: 0),

    color: Colors.blue,
    shape: TooltipShape(context: context, direction: direction % 2 == 0 ? 0 : 1),
    items: <PopupMenuEntry<int>>[
      PopupMenuItem<int>(
            child: Container(
              width: 400,
              padding: EdgeInsets.only(bottom: 12, top: 12, left: 20, right: 20),
              constraints: BoxConstraints(maxWidth: 450), // Using constraints instead of a fixed width
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'týždenná výzva',
                    overflow: TextOverflow.ellipsis, // Add this
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  Text(
                    userData?.capitols[int.parse(capitolsId)].tests[number].name ?? '',
                    overflow: TextOverflow.ellipsis, // Add this
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  if (userData != null &&
                      !userData!.capitols[int.parse(capitolsId)].tests[number].completed)
                    SizedBox(height: 12),
                    Center(
                      child: 
                      ReButton(activeColor: AppColors.mono.white, defaultColor:  AppColors.mono.white, disabledColor: AppColors.mono.lightGrey, focusedColor: AppColors.primary.light, hoverColor: AppColors.mono.lighterGrey, textColor: AppColors.mono.black, iconColor: AppColors.mono.black, text: 'ZAČAŤ', leftIcon: false, rightIcon: false, onTap: () {
                      onPressed(number);
                      Navigator.of(context).pop();
                    }),
                      ),
                    
                  if (userData != null &&
                      userData!.capitols[int.parse(capitolsId)].tests[number].completed && !userData!.capitols[int.parse(capitolsId)].completed)
                  Container(
                    color: Colors.blue,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
        ]
      ).then((_) => visibleContainerIndex(-1));
    }
}




class TooltipShape extends ShapeBorder {
  final int direction;
  final BuildContext context;

  const TooltipShape({required this.direction, required this.context});

  final BorderSide _side = BorderSide.none;
  final double _borderRadius = 8.0;

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

    final double triangleWidth = 20.0;
    final double triangleHeight = 20.0;

    double triangleTopCenterX = rrect.width / 2;

    if (MediaQuery.of(context).size.width < 1000) {
      if (direction == 0) {
        triangleTopCenterX -= 50;  // Shift triangle to the left by 40 pixels
      } else if (direction == 1) {
        triangleTopCenterX += 50;  // Shift triangle to the right by 40 pixels
      }
    }

    final double triangleTopCenterY = rrect.top - triangleHeight;

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
