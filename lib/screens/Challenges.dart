
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infomentor/Colors.dart';
import 'package:infomentor/backend/fetchClass.dart';
import 'package:infomentor/backend/fetchCapitols.dart';
import 'package:infomentor/backend/fetchUser.dart';
import 'package:infomentor/Tests/DesktopTest.dart';
import 'package:infomentor/Tests/TeacherDesktopTest.dart';
import 'package:infomentor/Tests/MobileTest.dart';
import 'package:infomentor/Tests/TeacherMobileTest.dart';
import 'package:infomentor/widgets/ReWidgets.dart';
import 'package:infomentor/widgets/TeacherCapitolDragWidget.dart';
import 'package:infomentor/widgets/StudentCapitolDragWidget.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:html' as html;

class Challenges extends StatefulWidget {
  final Future<void> fetch;
  final UserData? currentUserData;

  const Challenges({Key? key, required this.fetch, required this.currentUserData});

  @override
  State<Challenges> createState() => _ChallengesState();
}

class _ChallengesState extends State<Challenges> {
  bool _loading = true;
  bool isOverlayVisible = false;
  late OverlayEntry overlayEntry;
  String? title;
  int _visibleContainerTest = -1;
  int _visibleContainerCapitol = -1;
  List<FetchResult>? results;
  Future<List<FetchResult>>? _dataFuture;
  List<int> capitolsIds = [];
  List<List<double>> percentages = [];
  bool isMobile = false;
  bool isDesktop = false;



  @override
  void initState() {
    super.initState();

    final userAgent = html.window.navigator.userAgent.toLowerCase();
    isMobile = userAgent.contains('mobile');
    isDesktop = userAgent.contains('macintosh') ||
        userAgent.contains('windows') ||
        userAgent.contains('linux');

     _dataFuture = fetchQuestionData();
  }

Future<void> refreshList() async {
  print('refreshList called');
  setState(() {
    _dataFuture = fetchQuestionData();
  });

  await _dataFuture;
}


  Future<void> refreshData() async {
    await _dataFuture;
    await widget.fetch;
  }

  void toggleIndex(int index, int capitolIndex) {
    setState(() {
       _visibleContainerTest = index;
       _visibleContainerCapitol = capitolIndex;
    });
}

  void toggleOverlayVisibility(int index, int capitolId) {
    setState(() {
      isOverlayVisible = !isOverlayVisible;
    });

    if (isOverlayVisible) {
      overlayEntry = createOverlayEntry(context, index, capitolId);
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

List<List<double>> computeCompletionPercentages(ClassData? classData, List<UserData>? userDataList) {
  // Initialize a 2D list (matrix) for storing percentages.

  try {
    // Get the list of student ids in the class
    List<String> studentIds = classData!.students;

    // Loop through each student
    for (UserData userData in userDataList!) {
      // Loop through each capitol
      for (int i = 0; i < userData.capitols.length; i++) {
        // Ensure the list is big enough to hold this capitol.
        while (percentages.length <= i) {
          percentages.add([]);
        }

        UserCapitolsData capitol = userData.capitols[i];

        // Loop through each test in the current capitol
        for (int j = 0; j < capitol.tests.length; j++) {
          // Ensure the list is big enough to hold this test.
          while (percentages[i].length <= j) {
            percentages[i].add(0.0);
          }

          int completedCount = 0;

          // Loop through each student
          for (UserData studentData in userDataList) {
            // Check if the student has completed the test
            if (i < studentData.capitols.length &&
                j < studentData.capitols[i].tests.length &&
                studentData.capitols[i].tests[j].completed) {
              completedCount++;
            }
          }

          // Compute and store the percentage.
          percentages[i][j] = (completedCount / studentIds.length);
        }
      }
    }
  } catch (e) {
    print('Error computing completion percentage: $e');
    throw Exception('Failed to compute completion percentage');
  }

  return percentages;
}


Future<ClassData> fetchCurrentUserClass() async {
  // Assuming you know how to retrieve the currentUser's classId
  String currentUserClassId = widget.currentUserData!.schoolClass;
  return await fetchClass(currentUserClassId);
  
}

Future<List<FetchResult>> fetchQuestionData() async {
  List<FetchResult> localResults = [];
  List<UserData> userDataList = [];

  try {
    ClassData currentUserClass = await fetchCurrentUserClass();
    
    for (String userId in currentUserClass.students) {
      UserData userData = await fetchUser(userId);
      userDataList.add(userData);
    }

    computeCompletionPercentages(currentUserClass,userDataList);

      capitolsIds = currentUserClass.capitolOrder;
    

    for (int order in [0,1,2,3,4,5,6]) {
      localResults.add(await fetchCapitols(order.toString()));
    }

    setState(() {
      _loading = false;
    });

  } catch (e) {
    print('Error fetching question data: $e');
  }

  return localResults;
}

  double computeOffset(double width) {
    return (0.09 * 500) / width;
  }

  OverlayEntry createOverlayEntry(BuildContext context, int testIndex, int capitolId) {
    return OverlayEntry(
      builder: (context) => Positioned.fill(
        child: GestureDetector(
          child: Container(
            color: Colors.black.withOpacity(0.5),
            alignment: Alignment.center,
            child: isMobile ? widget.currentUserData!.teacher ?  TeacherMobileTest(testIndex: testIndex, overlay: toggle, capitolsId: capitolId.toString(), userData: widget.currentUserData) :  MobileTest(testIndex: testIndex, overlay: toggle, capitolsId: capitolId.toString(), userData: widget.currentUserData) : widget.currentUserData!.teacher ?  TeacherDesktopTest(testIndex: testIndex, overlay: toggle, capitolsId: capitolId.toString(), userData: widget.currentUserData) : DesktopTest(testIndex: testIndex, overlay: toggle, capitolsId: capitolId.toString(), userData: widget.currentUserData),
          ),
        ),
      ),
    );
  }

  int totalTests() {
  int total = 0;
  for (var result in results!) {
    total += result.capitolsData!.tests.length;
  }
  return total;
}

  @override
Widget build(BuildContext context) {
  if (_loading) {
      return Center(child: CircularProgressIndicator()); // Show loading circle when data is being fetched
  }
  return Scaffold(
    backgroundColor: Theme.of(context).colorScheme.background,
    body: FutureBuilder<List<FetchResult>>(
    future: _dataFuture,
      builder: (BuildContext context, AsyncSnapshot<List<FetchResult>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return  Center(child: CircularProgressIndicator());  // Show loading spinner until the Future is complete
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          results = snapshot.data!;
        return  Column(
            children: <Widget>[
              // Your FractionallySizedBox here (not modified for brevity)
              MediaQuery.of(context).size.width < 1000 ?
                Expanded(
                  child: PageView(
                    children: [
                      // First page - ListView
                     ListView.builder(
                            reverse: true,
                            itemCount: totalTests() + 1, // Add 1 for the dummy item
                            itemBuilder: (BuildContext context, int globalIndex) {
                              if (globalIndex == 0) {
                                // This is the dummy item, you can control its height
                                return SizedBox(height: 300.0); // Adjust the height as needed
                              }
                            int? capitolIndex;
                            int? testIndex;

                            int prevTestsSum = 0;
                            for (int i = 0; i < capitolsIds.length; i++) {
                              int currentCapitolId = capitolsIds[i]; // make sure to get the id correctly
                              int currentCapitolTestCount = results![currentCapitolId].capitolsData!.tests.length;

                              if (globalIndex - 1 < (prevTestsSum + currentCapitolTestCount)) {
                                capitolIndex = currentCapitolId;
                                testIndex = globalIndex - 1 - prevTestsSum;
                                break;
                              } else {
                                prevTestsSum += currentCapitolTestCount;
                              }
                            }

                            if (capitolIndex == null || testIndex == null) return Container();  // Handle error

                            EdgeInsets padding = EdgeInsets.only(
                              left: testIndex % 2 == 0 || testIndex == 0 ? 0.0 : 85.0,
                              right: testIndex % 2 == 0 || testIndex == 0 ? 85.0 : 0.0,
                            );
                            return Column(
                              children: [
                                Container(
                                  padding: padding,
                                  height: 118,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      OverflowBox(
                                        maxHeight: double.infinity,
                                        child: testIndex % 2 == 0 || testIndex == 0
                                            ? (!widget.currentUserData!.teacher ? !(widget.currentUserData?.capitols?[capitolIndex].tests[testIndex]?.completed ?? false) : !(percentages[capitolIndex][testIndex] == 1.0))
                                                ? SvgPicture.asset('assets/roadmap/leftRoad.svg')
                                                : SvgPicture.asset('assets/roadmap/leftRoadFilled.svg')
                                            : (!widget.currentUserData!.teacher ? !(widget.currentUserData?.capitols?[capitolIndex].tests[testIndex]?.completed ?? false) : !(percentages[capitolIndex][testIndex] == 1.0))
                                                ? SvgPicture.asset('assets/roadmap/rightRoad.svg')
                                                : SvgPicture.asset('assets/roadmap/rightRoadFilled.svg'),
                                      ),
                                      OverflowBox(
                                        alignment: Alignment.center,
                                        maxHeight: double.infinity,
                                        child: Container(
                                          height: 170,
                                          padding: EdgeInsets.only(
                                            bottom: 30,
                                            right: testIndex % 2 == 0 ? 18 : 0,
                                            left: testIndex % 2 == 0 ? 0 : 18,
                                          ),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              testIndex == _visibleContainerTest && capitolIndex == _visibleContainerCapitol
                                                  ? Container(
                                                      width: 170.0,
                                                      height: 170.0,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: (!widget.currentUserData!.teacher ? !(widget.currentUserData?.capitols?[capitolIndex].tests[testIndex]?.completed ?? false) : !(percentages[capitolIndex][testIndex] == 1.0))
                                                            ? AppColors.getColor(results?[capitolIndex].capitolsData!.color ?? '').lighter
                                                            : AppColors.getColor('yellow').lighter,
                                                      ),
                                                    )
                                                  : Container(),
                                              StarButton(
                                                color: results?[capitolIndex].capitolsData!.color,
                                                number: testIndex,
                                                userData: widget.currentUserData,
                                                onPressed: (int number) => toggleOverlayVisibility(number, capitolIndex ?? 0),
                                                capitolsId: capitolIndex.toString(),
                                                visibleContainerIndex: (int number) => toggleIndex(number, capitolIndex ?? 0),
                                                percentages: percentages
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height,
                          child: widget.currentUserData!.teacher ? TeacherCapitolDragWidget(currentUserData: widget.currentUserData, numbers: capitolsIds, refreshData: refreshList, percentages: percentages) : StudentCapitolDragWidget(currentUserData: widget.currentUserData, numbers: capitolsIds, refreshData: refreshList),
                        ),
                    ],
                  ),
                ) : Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: ListView.builder(
                            reverse: true,
                            itemCount: totalTests() + 1, // Add 1 for the dummy item
                            itemBuilder: (BuildContext context, int globalIndex) {
                              if (globalIndex == 0) {
                                // This is the dummy item, you can control its height
                                return SizedBox(height: 300.0); // Adjust the height as needed
                              }
                            int? capitolIndex;
                            int? testIndex;

                            int prevTestsSum = 0;
                            for (int i = 0; i < capitolsIds.length; i++) {
                              int currentCapitolId = capitolsIds[i]; // make sure to get the id correctly
                              int currentCapitolTestCount = results![currentCapitolId].capitolsData!.tests.length;

                              if (globalIndex - 1 < (prevTestsSum + currentCapitolTestCount)) {
                                capitolIndex = currentCapitolId;
                                testIndex = globalIndex - 1 - prevTestsSum;
                                break;
                              } else {
                                prevTestsSum += currentCapitolTestCount;
                              }
                            }

                            if (capitolIndex == null || testIndex == null) return Container();  // Handle error

                            EdgeInsets padding = EdgeInsets.only(
                              left: testIndex % 2 == 0 || testIndex == 0 ? 0.0 : 85.0,
                              right: testIndex % 2 == 0 || testIndex == 0 ? 85.0 : 0.0,
                            );
                            return Column(
                              children: [
                                Container(
                                  padding: padding,
                                  height: 118,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      OverflowBox(
                                        maxHeight: double.infinity,
                                        child: testIndex % 2 == 0 || testIndex == 0
                                            ? (!widget.currentUserData!.teacher ? !(widget.currentUserData?.capitols?[capitolIndex].tests[testIndex]?.completed ?? false) : !(percentages[capitolIndex][testIndex] == 1.0))
                                                ? SvgPicture.asset('assets/roadmap/leftRoad.svg')
                                                : SvgPicture.asset('assets/roadmap/leftRoadFilled.svg')
                                            : (!widget.currentUserData!.teacher ? !(widget.currentUserData?.capitols?[capitolIndex].tests[testIndex]?.completed ?? false) : !(percentages[capitolIndex][testIndex] == 1.0))
                                                ? SvgPicture.asset('assets/roadmap/rightRoad.svg')
                                                : SvgPicture.asset('assets/roadmap/rightRoadFilled.svg'),
                                      ),
                                      OverflowBox(
                                        alignment: Alignment.center,
                                        maxHeight: double.infinity,
                                        child: Container(
                                          height: 170,
                                          padding: EdgeInsets.only(
                                            bottom: 30,
                                            right: testIndex % 2 == 0 ? 18 : 0,
                                            left: testIndex % 2 == 0 ? 0 : 18,
                                          ),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              testIndex == _visibleContainerTest && capitolIndex == _visibleContainerCapitol
                                                  ? Container(
                                                      width: 170.0,
                                                      height: 170.0,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: (!widget.currentUserData!.teacher ? !(widget.currentUserData?.capitols?[capitolIndex].tests[testIndex]?.completed ?? false) : !(percentages[capitolIndex][testIndex] == 1.0))
                                                            ? AppColors.getColor(results?[capitolIndex].capitolsData!.color ?? '').lighter
                                                            : AppColors.getColor('yellow').lighter,
                                                      ),
                                                    )
                                                  : Container(),
                                              StarButton(
                                                color: results?[capitolIndex].capitolsData!.color,
                                                number: testIndex,
                                                userData: widget.currentUserData,
                                                onPressed: (int number) => toggleOverlayVisibility(number, capitolIndex ?? 0),
                                                capitolsId: capitolIndex.toString(),
                                                visibleContainerIndex: (int number) => toggleIndex(number, capitolIndex ?? 0),
                                                percentages: percentages
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      
                      if(MediaQuery.of(context).size.width > 1000) Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width / 2,
                        child: widget.currentUserData!.teacher ? TeacherCapitolDragWidget(currentUserData: widget.currentUserData, numbers: capitolsIds, refreshData: refreshList, percentages: percentages) : StudentCapitolDragWidget(currentUserData: widget.currentUserData, numbers: capitolsIds, refreshData: refreshList),
                      ),
                    ],
                  ),
                ),
            ],
          );
      }
      }
    )
  );
}


}

class StarButton extends StatelessWidget {
  final List<List<double>> percentages;
  final int number;
  final UserData? userData;
  final String? color;
  final void Function(int) onPressed;
  final String capitolsId;
  final void Function(int) visibleContainerIndex;

  StarButton({
    required this.percentages,
    required this.number,
    required this.onPressed,
    required this.color,
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
            (userData!.teacher ? percentages[int.parse(capitolsId)][number] != 1.0 : !userData!.capitols[int.parse(capitolsId)].tests[number].completed)
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
                  color: AppColors.getColor('mono').lightGrey,
                ),
              ),
              ),
              OverflowBox(
                  child: CircularPercentIndicator(
                    radius: 45.0,  // Adjust as needed
                    lineWidth: 8.0,
                    animation: true,
                    percent: userData!.teacher ? percentages[int.parse(capitolsId)][number] : countTrueValues(userData!.capitols[int.parse(capitolsId)].tests[number].questions) /
                            userData!.capitols[int.parse(capitolsId)].tests[number].questions.length,
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: AppColors.getColor('yellow').light,
                    backgroundColor: Colors.transparent,
                )
               ),
               
              Container(
                width: 76.0,
                height: 76.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.getColor('mono').white,
                ),
                child: GestureDetector(
                 onTap: () {
                    final RenderBox button = context.findRenderObject() as RenderBox;
                    showPopupMenu(context, number % 2 == 0 ? 0 : 1, button);
                    visibleContainerIndex(number);
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Center(
                      child: (userData!.teacher ? (percentages[int.parse(capitolsId)][number] > 0.0) : (countTrueValues(userData!.capitols[int.parse(capitolsId)].tests[number].questions) > 0)) ? SvgPicture.asset('assets/icons/starYellowIcon.svg', height: 30,) : SvgPicture.asset('assets/icons/starGreyIcon.svg', height: 30,),
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
                  final RenderBox button = context.findRenderObject() as RenderBox;
                  showPopupMenu(context, number % 2 == 0 ? 0 : 1, button);
                  visibleContainerIndex(number);
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Image.asset(
                    'assets/star.png',
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



void showPopupMenu(BuildContext context, int direction, RenderBox button) {
   final double menuWidth = 400.0; // Set your desired menu width
  final double menuHeight = 200.0; // Set your desired menu height

  // Calculate the position of the button on the screen
  final Offset buttonPosition = button.localToGlobal(Offset.zero);

  double offsetX = buttonPosition.dx + button.size.width / 2 - menuWidth / 2;
  double offsetY = buttonPosition.dy + button.size.height + 10; // Adjust vertical position as needed

  final RelativeRect position = RelativeRect.fromLTRB(
    offsetX,
    offsetY,
    offsetX + menuWidth,
    offsetY + menuHeight,
  );

  showMenu<int>(
    context: context,
    position: position,
    constraints: BoxConstraints(maxWidth: 400, minWidth: 0),

    color: AppColors.getColor(color!).light,
    shape: TooltipShape(context: context, direction: direction % 2 == 0 ? 0 : 1),
    items: <PopupMenuEntry<int>>[
      PopupMenuItem<int>(
            child: Container(
              width: 400,
              padding: EdgeInsets.only(bottom: 12, top: 12,),
              constraints: BoxConstraints(maxWidth: 450), // Using constraints instead of a fixed width
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Týždenná výzva',
                        overflow: TextOverflow.ellipsis, // Add this
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      Spacer(),
                      if(userData!.teacher)SvgPicture.asset('assets/icons/correctIcon.svg', color: Colors.white,)
                    ],
                  ),
                  
                  SizedBox(height: 5),
                  Text(
                    userData?.capitols[int.parse(capitolsId)].tests[number].name ?? '',
                    overflow: TextOverflow.ellipsis, // Add this
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.onPrimary),
                  ),
                    if (userData!.teacher) Container(
                    padding: EdgeInsets.only(top: 12, bottom: 12),
                    child: Text(
                      'Priemerná úspešnosť ${percentages[int.parse(capitolsId)][number]*100}%',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    ),
                  ),
                  if (userData != null && !userData!.capitols[int.parse(capitolsId)].tests[number].completed && !userData!.capitols[int.parse(capitolsId)].completed)Center(
                      child: 
                      ReButton(activeColor: AppColors.getColor('mono').white, defaultColor:  AppColors.getColor('mono').white, disabledColor: AppColors.getColor('mono').lightGrey, focusedColor: AppColors.getColor('primary').light, hoverColor: AppColors.getColor('mono').lighterGrey, textColor: AppColors.getColor('mono').black, iconColor: AppColors.getColor('mono').black, text: 'ZOBRAZIŤ' , onTap: () {
                      onPressed(number);
                      Navigator.of(context).pop();
                    }),
                  ),
                  if (userData != null && userData!.capitols[int.parse(capitolsId)].tests[number].completed && !userData!.capitols[int.parse(capitolsId)].completed)
                  Container(
                    width: 400,
                    height: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.getColor(color ?? '').main,
                      ),
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Hotovo!",
                          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ), // Set text color to white
                        ),
                        Text(
                          "${userData!.capitols[int.parse(capitolsId)].tests[number].points}/${userData!.capitols[int.parse(capitolsId)].tests[number].questions.length} správnych odpovedí",
                          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ), // Set text color to white
                        ),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "+ ${userData!.capitols[int.parse(capitolsId)].tests[number].points}",
                              style:  Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            ),
                            SizedBox(width: 5),
                            SvgPicture.asset('assets/icons/starYellowIcon.svg'),
                          ],
                        ),
                      ],
                    ),
                  ),
                   if (userData != null && userData!.capitols[int.parse(capitolsId)].tests[number].completed && !userData!.capitols[int.parse(capitolsId)].completed) Text(
                              "Test si môžeš znovu otvoriť po skončení kapitoly",
                              style:  Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                   ),
                  if (userData != null && userData!.capitols[int.parse(capitolsId)].tests[number].completed &&  userData!.capitols[int.parse(capitolsId)].completed)
                    Center(
                      child: ReButton(activeColor: AppColors.getColor('mono').white, defaultColor:  AppColors.getColor('mono').white, disabledColor: AppColors.getColor('mono').lightGrey, focusedColor: AppColors.getColor('primary').light, hoverColor: AppColors.getColor('mono').lighterGrey, textColor: AppColors.getColor('mono').black, iconColor: AppColors.getColor('mono').black, text:  'ZOBRAZIŤ', onTap: () {
                        onPressed(number);
                        Navigator.of(context).pop();
                      }),
                    ),
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
