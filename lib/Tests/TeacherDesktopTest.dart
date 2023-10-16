import 'package:flutter/material.dart';
import 'package:infomentor/backend/fetchCapitols.dart';
import 'package:infomentor/widgets/ReWidgets.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infomentor/backend/fetchUser.dart'; // Import the UserData class and fetchUser function
import 'package:infomentor/backend/fetchClass.dart';
import 'package:infomentor/Colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:html' as html;
import 'package:dropdown_button2/dropdown_button2.dart';


List<String> badgePaths = [
  'assets/badges/badgeArgActive.svg',
  'assets/badges/badgeManActive.svg',
  'assets/badges/badgeCritActive.svg',
  'assets/badges/badgeDataActive.svg',
  'assets/badges/badgeGramActive.svg',
  'assets/badges/badgeMediaActive.svg',
  'assets/badges/badgeSocialActive.svg'
];


class TeacherDesktopTest extends StatefulWidget {
  final int testIndex;
  final Function overlay;
  final String capitolsId;
  final UserData? userData;

  const TeacherDesktopTest(
      {Key? key,
      required this.testIndex,
      required this.overlay,
      required this.capitolsId,
      required this.userData})
      : super(key: key);

  @override
  State<TeacherDesktopTest> createState() => _TeacherDesktopTestState();
}

class _TeacherDesktopTestState extends State<TeacherDesktopTest> {
  List<UserAnswerData> _answer = [];
  bool? isCorrect;
  bool screen = true;
  int questionIndex = 0;
  List<DivisionData> division = [];
  List<String> answers = [];
  List<String> answersImage = [];
  List<String> matchmaking = [];
  List<String> matches = [];
  List<CorrectData>? correct;
  String definition = '';
  List<String> explanation = [];
  List<String> images = [];
  String question = '';
  String subQuestion = '';
  String title = '';
  int? questionsPoint;
  bool _disposed = false;
  bool pressed = false;
  List<dynamic>? percentages;
  double? percentagesAll;
  bool _loading = true; // Add this line
  int? openDropdownIndex;
  String? allCorrects;
  bool usersCompleted = false;
  bool firstScreen = true;
  String? introduction;
  bool checkTitle = false;

  final userAgent = html.window.navigator.userAgent.toLowerCase();


  Future<void> fetchQuestionData(int index) async {
      FetchResult result = await fetchCapitols(widget.capitolsId);

      if (_disposed) return; // Check if the widget has been disposed

      setState(() {
        division = result.capitolsData?.tests[widget.testIndex].questions[questionIndex].division ?? [];
        answers = result.capitolsData?.tests[widget.testIndex].questions[questionIndex].answers ?? [];
        answersImage = result.capitolsData?.tests[widget.testIndex].questions[questionIndex].answersImage ?? [];
        matchmaking = result.capitolsData?.tests[widget.testIndex].questions[questionIndex].matchmaking ?? [];
        matches = result.capitolsData?.tests[widget.testIndex].questions[questionIndex].matches ?? [];
        correct = result.capitolsData?.tests[widget.testIndex].questions[questionIndex].correct;
        definition = result.capitolsData?.tests[widget.testIndex].questions[questionIndex].definition ?? '';
        explanation = result.capitolsData?.tests[widget.testIndex].questions[questionIndex].explanation ?? [];
        images = result.capitolsData?.tests[widget.testIndex].questions[questionIndex].images ?? [];
        question = result.capitolsData?.tests[widget.testIndex].questions[questionIndex].question ?? '';
        subQuestion = result.capitolsData?.tests[widget.testIndex].questions[questionIndex].subQuestion ?? '';
        title = result.capitolsData?.tests[widget.testIndex].questions[questionIndex].title ?? '';
        questionsPoint = result.capitolsData?.tests[widget.testIndex].points;
        introduction =  result.capitolsData?.tests[widget.testIndex].introduction;
        if (widget.userData!.capitols[int.parse(widget.capitolsId)].tests[widget.testIndex].questions[questionIndex].completed == true) {
            _answer = widget.userData!.capitols[int.parse(widget.capitolsId)].tests[widget.testIndex].questions[questionIndex].answer;
            pressed = true;

        }

        if (matchmaking.length > 0) {
            allCorrects = correct!.map((e) {
                String letter = String.fromCharCode(97 + e.correct);
                return 'pri otázke ${e.index + 1}. je odpoveď $letter)';
            }).join(', ');
        } else {
            allCorrects = correct!.map((e) => String.fromCharCode(97 + e.correct) + ')').join(', ');
        }

        if(title != '' && (definition == '' && images.length < 1 && division.length < 1)) checkTitle = true;


        print(definition == '' && images.length < 1);
        _loading = false;

      });

      
  }

  Future <void> fetchPercentages() async{
    Map<String, dynamic> questionStats = await getQuestionStats(
      widget.userData!.schoolClass,
      int.parse(widget.capitolsId),
      widget.testIndex,
      questionIndex,
    );

    // Extracting the results from the map
    usersCompleted = await questionStats['userCompleted'];
    percentagesAll = await questionStats['correctPercentage'];
    percentages = await questionStats['answerPercentages'];
  }

  @override
  void initState() {
    super.initState();

    fetchQuestionData(questionIndex);
    fetchPercentages();
    
    
    
    if (countTrueValues(widget.userData!.capitols[int.parse(widget.capitolsId)].tests[widget.testIndex].questions) == widget.userData!.capitols[int.parse(widget.capitolsId)].tests[widget.testIndex].questions.length) {
      questionIndex = 0;
    } else {
      questionIndex = countTrueValues(widget.userData!.capitols[int.parse(widget.capitolsId)].tests[widget.testIndex].questions);
    } 
    
  }

  @override
  void didUpdateWidget(TeacherDesktopTest oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.testIndex != oldWidget.testIndex) {
      // Test ID has changed, reset the state and fetch new data
      setState(() {
        questionIndex = 0;
        _answer = [];
      });
      fetchQuestionData(questionIndex);

    }
        _loading = false;

  }
  
Future<Map<String, dynamic>> getQuestionStats(String classId, int capitolIndex, int testIndex, int questionIndex) async {
  try {
    ClassData classData = await fetchClass(classId);

    CollectionReference usersRef = FirebaseFirestore.instance.collection('users');
    QuerySnapshot usersSnapshot = await usersRef.where(FieldPath.documentId, whereIn: classData.students).get();
    FetchResult capitolsData = await fetchCapitols(capitolIndex.toString());

    int totalStudents = usersSnapshot.docs.length;
    int completedStudents = 0; // new variable to keep track of students who have completed the test
    int correctResponses = 0;

    List<int> answerCounts = List.filled(
      capitolsData.capitolsData!.tests[testIndex].questions[questionIndex].answersImage!.length +
      capitolsData.capitolsData!.tests[testIndex].questions[questionIndex].answers!.length +
      capitolsData.capitolsData!.tests[testIndex].questions[questionIndex].matchmaking!.length,
      0
    );

    for (var userDoc in usersSnapshot.docs) {
      var userData = userDoc.data();
      if (userData == null) continue;

      Map<String, dynamic> userMap = userData as Map<String, dynamic>;
      var userTest = userMap['capitols'][capitolIndex]['tests'][testIndex];
      var userQuestion = userTest?['questions'][questionIndex];

      if (userTest != null && userTest['completed'] == true) {
        completedStudents++;  // increment if the student has completed the test

        if (userQuestion != null) {
          List<dynamic> correctList = userQuestion['correct'];
          if (correctList.every((e) => e == true)) {
            correctResponses++;
          }

          var userAnswers = userQuestion['answer'] as List?;
          if (userAnswers != null) {
            for (var userAnswer in userAnswers) {
              int? index = userAnswer['index'];
              if (index != null && index >= 0 && index < answerCounts.length) {
                answerCounts[index]++;
              }
            }
          }
        }
      }
    }

    // Use 'completedStudents' instead of 'totalStudents' for percentage calculation
    List<double> percentages = answerCounts.map((count) => (count / (completedStudents != 0 ? completedStudents : 1)) * 100).toList();

      percentages.asMap().forEach((index, value) {
        percentages[index] = double.parse(value.toStringAsFixed(2));
      });


      return {
        'userCompleted': completedStudents > 0,
        'completedStudents': completedStudents,
        'correctPercentage': double.parse(((correctResponses / (completedStudents != 0 ? completedStudents : 1)) * 100).toStringAsFixed(2)),
        'answerPercentages': percentages
      };
    } catch (e) {
      print('Error getting question statistics: $e');
      rethrow;
    }
  }

  @override
  void dispose() {
    _disposed = true; // Set the disposed flag to true
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
        return Center(child: CircularProgressIndicator()); // Show loading circle when data is being fetched
    }
    return Stack(
      children: [
        screen ? Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor
            ),
          ),) : Container(),

        screen ? Positioned.fill(
          child:  SvgPicture.asset(
            'assets/lastScreenBackground.svg',
            fit: BoxFit.cover,
          ),
         ) : Container(),
        
      Scaffold(
      appBar: AppBar(
        backgroundColor: 
            screen
            ? Theme.of(context).primaryColor
            : Theme.of(context).colorScheme.background,
        elevation: 0,
        flexibleSpace: Container(
          padding: EdgeInsets.symmetric(horizontal: 50),
          height: 120, // adjust this to make the AppBar taller
          child: !screen
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        questionsPoint ?? 0,
                        (index) {
                          final maxCellWidth = 50.0; // Specify the maximum cell width
                          final minWidth = 40.0; // Specify the minimum cell width
                          final totalWidth =
                              maxCellWidth * (questionsPoint ?? 1);
                          final availableWidth =
                              MediaQuery.of(context).size.width -
                                  (questionsPoint ?? 0 - 1) * 2.0 * 2.0;

                          final width = (availableWidth / totalWidth * maxCellWidth)
                              .clamp(minWidth, maxCellWidth);

                          return Flexible(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 2.0),
                              width: width,
                              height: 10,
                              decoration: BoxDecoration(
                                color: questionIndex >= index
                                    ? AppColors.getColor('green').main
                                    : AppColors.getColor('primary').lighter,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
              : null,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: 
              screen
                ? AppColors.getColor('mono').white
                : AppColors.getColor('mono').black,
          ),
          onPressed: () =>
              questionIndex > 0
                  ? setState(() {
                      questionIndex--;
                      fetchQuestionData(questionIndex);
                    })
                  : widget.overlay(),
        ),
      ),

      backgroundColor: screen ?  Colors.transparent : Theme.of(context).colorScheme.background,
      body: !screen ? SingleChildScrollView(
         child:
         Container(
          child: Column(
          children: [
          Container(
            width: double.infinity,
            child:
          Align( 
            alignment:  Alignment.topCenter,
            child: Wrap(
            direction: Axis.horizontal,
            crossAxisAlignment: WrapCrossAlignment.start,
            alignment: WrapAlignment.spaceEvenly,

            children: [
            if (!checkTitle && (title != '' || definition != '' || images.length > 0)) Container(
              width: 670,
              margin:  EdgeInsets.only(bottom: 12, left: 12, right: 30, top: 50),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius:  BorderRadius.circular(10),
                    border: Border.all(color: AppColors.getColor('mono').grey),
                ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                        margin: EdgeInsets.all(8),
                        padding: EdgeInsets.all(4),
                        child: Text(
                          title ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onBackground,
                              ),
                        ),
                      ),
                  Column(
                    children: [
                      if (division != null && division!.isNotEmpty)
                              ...division!.map((dvs) => Container(
                                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: AppColors.getColor('mono').grey),
                                      color: Theme.of(context).colorScheme.background,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          width: 200,
                                          height: 200,
                                          padding: EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            border: Border(right: BorderSide(color: AppColors.getColor('mono').grey) ,),
                                          ),
                                          child: Text(
                                            dvs.title,
                                            style: Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium!
                                                  .copyWith(
                                                    color: Theme.of(context).colorScheme.onBackground,
                                                  ),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          width: 400,
                                          height: 200,
                                          padding: EdgeInsets.all(16),
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            dvs.text,
                                            style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                    color: Theme.of(context).colorScheme.onBackground,
                                                  ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )).toList()
                            else 
                              Container(), // Pl
                      if (images != null && images!.isNotEmpty)
                        ...images!.map((img) => Container(
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.getColor('mono').grey),
                                color: Theme.of(context).colorScheme.background,
                              ),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.asset(img!,
                                ),
                              ),
                            )).toList()
                      else 
                        Container(), // Placeholder for empty image field
                        
                      definition != '' ? Container(
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.getColor('mono').grey),
                          color: Theme.of(context).colorScheme.background
                          ),
                        padding: EdgeInsets.all(12),
                        child: Text(
                          definition ?? '',
                          style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.onBackground,
                                ),
                        ),
                      ) : Container(),
                    ],
                  ),
                ],
              ),
            ),
            Container(
               width: ((title != '' || definition != '' || images.length > 0) && !checkTitle) ? 600 : 800,
                margin: EdgeInsets.all(12),
                padding: EdgeInsets.all(12),
              child: 
                Container(
                  constraints: BoxConstraints(minHeight: 576,),
                    child:
                     Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (usersCompleted) Container(
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          height: 60,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.getColor('primary').main,
                              width: 2
                            ),
                          ),
                            child: Row(
                              children: [
                                Text('Otázka ${questionIndex + 1}: ',
                                  style: Theme.of(context)
                                          .textTheme
                                          .displayMedium!
                                          .copyWith(
                                            color: AppColors.getColor('primary').main,
                                          ),
                                ),
                                SizedBox(width: 8,),
                                FutureBuilder<Map<String, dynamic>>(
                                    future:  getQuestionStats(
                                    widget.userData!.schoolClass,
                                    int.parse(widget.capitolsId),
                                    widget.testIndex,
                                    questionIndex,
                                  ),
                                builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    int? correctPercentage = snapshot.data?['correctPercentage'].round();
                                    return Text('Úspešnosť: ${correctPercentage?.toString() ?? "N/A"}%',
                                        style: Theme.of(context)
                                          .textTheme
                                          .displayMedium!
                                          .copyWith(
                                            color: Theme.of(context).colorScheme.onBackground,
                                          ),
                                      );
                                  }
                                },
                              )
                              ],
                            )
                        ),
                        if(checkTitle)SizedBox(height: 30,),
                           if(checkTitle)Container(
                            padding: EdgeInsets.all(4),
                            child: Text(
                              title ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .copyWith(
                                    color: Theme.of(context).colorScheme.onBackground,
                                  ),
                            ),
                          ),
                          if(question != '')SizedBox(height: 30,),
                          question != '' ? Container(
                              padding: EdgeInsets.all(4),
                              child: Text(
                                question,
                                style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .copyWith(
                                        color: Theme.of(context).colorScheme.onBackground,
                                      ),
                              ),
                            ) : Container(),
                            if (!(title != '' || definition != '' || images.length > 0)) SizedBox(height: 20,),
                            subQuestion != '' ? Container(
                              child: Text(
                                subQuestion,
                                style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(
                                        color: Theme.of(context).colorScheme.onBackground,
                                      ),
                              ),
                            ) : Container(),
                            if (!(title != '' || definition != '' || images.length > 0)) SizedBox(height: 20,),
                         SizedBox(height: 30,),
                         FutureBuilder<Map<String, dynamic>>(
                              future:  getQuestionStats(
                              widget.userData!.schoolClass,
                              int.parse(widget.capitolsId),
                              widget.testIndex,
                              questionIndex,
                            ),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return CircularProgressIndicator();
                            final data = snapshot.data;
                            return ListView.builder(
                          
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: (answersImage!.length ?? 0) + (answers!.length ?? 0) + (matchmaking!.length ?? 0),
                            itemBuilder: (BuildContext context, index) {
                              String? itemText;
                              Color bgColor;
                              Color borderColor;
                              Color percentageColor;
                              bool isCorrect = correct!.any((cItem) => cItem.index == index);

                              Widget mainWidget;

                              // Handle answersImage
                              if (index < answersImage.length &&  answersImage.isNotEmpty) {
                                String item = answersImage[index];
                                itemText = explanation!.length > 1 && explanation![index].isNotEmpty  ? explanation![index] : null;
                                bgColor = isCorrect ? AppColors.getColor('green').lighter : AppColors.getColor('mono').white;
                                borderColor = isCorrect ? AppColors.getColor('green').main : AppColors.getColor('mono').lightGrey;
                                percentageColor = isCorrect ? AppColors.getColor('green').main : AppColors.getColor('red').main;
                                if (usersCompleted) {
                                  mainWidget = reTileImage(bgColor, borderColor, index, item, context, percentage: data!['answerPercentages'], correct: isCorrect, percentageColor: percentageColor);
                                } else {
                                  mainWidget = reTileImage(bgColor, borderColor, index, item, context, correct: isCorrect);
                                }
                              }
                              // Handle answers
                              else if ((index - answersImage.length) < answers.length &&  answers.isNotEmpty && answers[index - answersImage.length].isNotEmpty) {
                                String? item = answers[index - answersImage.length].isNotEmpty ? answers[index - answersImage.length] : null;
                                itemText = explanation!.length > 1 && explanation![index - answersImage.length].isNotEmpty  ? explanation![index - answersImage.length] : null;
                                bgColor = isCorrect ? AppColors.getColor('green').lighter : AppColors.getColor('mono').white;
                                borderColor = isCorrect ? AppColors.getColor('green').main : AppColors.getColor('mono').lightGrey;
                                percentageColor = isCorrect ? AppColors.getColor('green').main : AppColors.getColor('red').main;
                                if (usersCompleted) {
                                  mainWidget = reTile(bgColor, borderColor, index, item, context, percentage: data!['answerPercentages'], correct: isCorrect, percentageColor: percentageColor);
                                } else {
                                  mainWidget = reTile(bgColor, borderColor, index, item, context, correct: isCorrect);
                                }
                              }
                              // Handle matchmaking
                              else  {
                                itemText = explanation!.length > 1 && explanation![index - answersImage.length - answers.length].isNotEmpty  ? explanation![index - answersImage.length - answers.length ] : null;
                                String? item = matchmaking[index  - answersImage.length  - answers.length];
                                List<String> item2 = matches;
                                itemText = explanation!.length > 1 && explanation![index - answersImage.length  - answers.length].isNotEmpty  ? explanation![index - answersImage.length - answers.length ] : null;
                                bgColor = isCorrect ? AppColors.getColor('green').lighter : AppColors.getColor('mono').white;
                                borderColor = isCorrect ? AppColors.getColor('green').main : AppColors.getColor('mono').lightGrey;
                                percentageColor = isCorrect ? AppColors.getColor('green').main : AppColors.getColor('red').main;
                                mainWidget = reTileMatchmaking(bgColor, borderColor, correct!.firstWhere((cItem) => cItem.index == index).correct, index, item, context, item2, true);
                              }

                              // Return the main widget alongside the item text
                              return Column(
                                children: [
                                  mainWidget,
                                  if(itemText != null)Container(
                                    margin: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColors.getColor('primary').lighter,
                                    ),
                                    padding: EdgeInsets.all(12),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,  // aligns items to the top
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/lightbulbIcon.svg',  // Make sure to replace this with your SVG asset path
                                          width: 30,  // Optional: You can adjust width & height as per your requirement
                                          height: 30,
                                        ),
                                        SizedBox(width: 12),  // Give some spacing between the SVG and the text
                                        Expanded(  // To make sure the text takes the remaining available space and wraps if needed
                                          child: Text(
                                            itemText,
                                            style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                    color: Theme.of(context).colorScheme.onBackground,
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  
                                ],
                              );
                            },
                            );
                          }
                         ),
                      if(explanation!.length < 2 && explanation.length > 0)Container(
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.getColor('primary').lighter,
                        ),
                        padding: EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,  // aligns items to the top
                          children: [
                            SvgPicture.asset(
                              'assets/icons/lightbulbIcon.svg',  // Make sure to replace this with your SVG asset path
                              width: 30,  // Optional: You can adjust width & height as per your requirement
                              height: 30,
                            ),
                            SizedBox(width: 12),  // Give some spacing between the SVG and the text
                            Expanded(  // To make sure the text takes the remaining available space and wraps if needed
                              child: Text(
                                'Správna je odpoveď ${allCorrects ?? ''}: ${explanation?[0] ?? ''}',
                                style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        color: Theme.of(context).colorScheme.onBackground,
                                      ),
                              ),
                            ),
                            
                          ],
                        ),
                      ),
                      
                      ]
                      )
                ),
              )
          ],
        ),
          )
          ),
          SizedBox(height: 50,),
          ReButton(activeColor: AppColors.getColor('green').main, defaultColor:  AppColors.getColor('green').light, disabledColor: AppColors.getColor('mono').lightGrey, focusedColor: AppColors.getColor('primary').lighter, hoverColor: AppColors.getColor('green').main, text: 'ĎALEJ',onTap:
            onNextButtonPressed,
          ),
          SizedBox(height: 50,),
         ]
      ),
          )
       ) : firstScreen ?
      Container(
        decoration: BoxDecoration(
                  color: AppColors.getColor('mono').white
                ),
      child: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * (1/2),
              decoration: BoxDecoration(
                  color: AppColors.getColor('primary').light
                ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.userData!.capitols[int.parse(widget.capitolsId)].tests[widget.testIndex].name,
                    style:  Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                  ),
                  SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                    CircularPercentIndicator(
                          radius: 45.0,  // Adjust as needed
                          lineWidth: 8.0,
                          animation: true,
                          percent: 0.05,
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: AppColors.getColor('yellow').light,
                          backgroundColor: AppColors.getColor('mono').lighterGrey,
                      ),
                    SvgPicture.asset('assets/icons/starYellowIcon.svg', height: 30,),
                  ],),
                  SizedBox(height: 10),
                  Text(introduction ?? '',
                    style:  Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Theme.of(context).primaryColor))
              ),
              child: SvgPicture.asset('assets/bottomBackground.svg', fit: BoxFit.cover, width:  MediaQuery.of(context).size.width,),
            ),
            Spacer(),
            ReButton(activeColor: AppColors.getColor('green').main, defaultColor:  AppColors.getColor('green').light, disabledColor: AppColors.getColor('mono').lightGrey, focusedColor: AppColors.getColor('primary').lighter, hoverColor: AppColors.getColor('green').main, text: 'POKRAČOVAŤ', onTap:
              () {
                setState(() {
                  screen = false;
                  firstScreen = false;
                });
              }
            ),
            SizedBox(height: 60),
          ],
        ))) :  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.userData!.capitols[int.parse(widget.capitolsId)].tests[widget.testIndex].name,
              style:  Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
            ),
            SizedBox(height: 30),
            Image.asset('assets/star.png', height: 100,),
            SizedBox(height: 10),
            Text(
              getResultBasedOnPercentage(widget.userData!.capitols[int.parse(widget.capitolsId)].tests[widget.testIndex].points, questionsPoint ?? 0),
              style:  Theme.of(context)
                .textTheme
                .headlineLarge!
                .copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
            ),
            
            SizedBox(height: 10),
            Text(
              "${widget.userData!.capitols[int.parse(widget.capitolsId)].tests[widget.testIndex].points}/${questionsPoint} správnych odpovedí | ${((widget.userData!.capitols[int.parse(widget.capitolsId)].tests[widget.testIndex].points / questionsPoint!) * 100).round()}%",
              style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "+${widget.userData!.capitols[int.parse(widget.capitolsId)].tests[widget.testIndex].points}",
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
            SizedBox(height: 20),
            ReButton(activeColor: AppColors.getColor('mono').white, defaultColor:  AppColors.getColor('mono').white, disabledColor: AppColors.getColor('mono').lightGrey, focusedColor: AppColors.getColor('primary').light, hoverColor: AppColors.getColor('mono').lighterGrey, textColor: AppColors.getColor('mono').black, iconColor: AppColors.getColor('mono').black, text: 'ZAVRIEŤ', onTap:
              () => widget.overlay(),
            ),
          ],
        )
      ),
      ]
    );
  }

  String getResultBasedOnPercentage(int value, int total) {
  if (total == 0) {
    throw ArgumentError('Total cannot be zero');
  }

  double percentage = (value / total) * 100;

  if (percentage >= 90 && percentage <= 100) {
    return 'Výborný výsledok!';
  } else if (percentage >= 75 && percentage < 90) {
    return 'Chválitebný výsledok!';
  } else if (percentage >= 50 && percentage < 75) {
    return 'Dobrý výsledok!';
  } else if (percentage >= 30 && percentage < 50) {
    return 'Dostatočný výsledok!';
  } else if (percentage >= 0 && percentage < 30) {
    return 'Nedostatočný výsledok!';
  } else {
    throw ArgumentError('Invalid values provided');
  }
}



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


// Define a utility function for firstWhereOrNull behavior
CorrectData? firstWhereOrNull(List<CorrectData> list, bool Function(CorrectData) test) {
    for (CorrectData element in list) {
        if (test(element)) return element;
    }
    return null;
}

  void onNextButtonPressed() {
    if (questionIndex + 1 < (questionsPoint ?? 0)) {
      setState(() {
        questionIndex++;
        pressed = false;
        _answer = [];
        _loading = true;
        checkTitle = false;
      });
      fetchQuestionData(questionIndex);
    } else {

 
      setState(() {
        questionIndex = 0;
        _answer = [];
        pressed = false;
        checkTitle = false;
      });
     
      _showscreen();
    }
  }


  void _showscreen() {
    setState(() {
      // Update the state to show the last screen
      screen = true;
      question = '';
      subQuestion = '';
      title = '';
      images = [];
      definition = '';
      answers = [];
      answersImage = [];
      matches = [];
      matchmaking = [];
    });
  }

  bool areAllCompleted(UserData userData) {
    for (var capitol in userData.capitols) {
      for (var test in capitol.tests) {
        if (!test.completed) {
          return false;
        }
      }
    }
    return true;
  }

}
