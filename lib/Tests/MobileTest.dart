import 'package:flutter/material.dart';
import 'package:infomentor/backend/fetchCapitols.dart';
import 'package:infomentor/widgets/ReWidgets.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infomentor/backend/userController.dart'; // Import the UserData class and fetchUser function
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


class MobileTest extends StatefulWidget {
  final int testIndex;
  final Function overlay;
  final String capitolsId;
  final UserData? userData;

  const MobileTest(
      {Key? key,
      required this.testIndex,
      required this.overlay,
      required this.capitolsId,
      required this.userData})
      : super(key: key);

  @override
  State<MobileTest> createState() => _MobileTestState();
}

class _MobileTestState extends State<MobileTest> {
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
  List<String>? explanation;
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
  bool isMobile = false;

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
        explanation = result.capitolsData?.tests[widget.testIndex].questions[questionIndex].explanation;
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




        _loading = false;

      });

      
  }


  @override
  void initState() {
    super.initState();

    fetchQuestionData(questionIndex);
    
    
    if (countTrueValues(widget.userData!.capitols[int.parse(widget.capitolsId)].tests[widget.testIndex].questions) == widget.userData!.capitols[int.parse(widget.capitolsId)].tests[widget.testIndex].questions.length) {
      questionIndex = 0;
    } else {
      questionIndex = countTrueValues(widget.userData!.capitols[int.parse(widget.capitolsId)].tests[widget.testIndex].questions);
    } 
    
  }

  @override
  void didUpdateWidget(MobileTest oldWidget) {
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

  double calculateHeight(String? title, String? definition, List<String?>? images) {
    double baseHeight = 0.0;
    double heightIncrement = 150.0; // This is the value added for each condition that's true
    
    if (title != '' ) {
      baseHeight += heightIncrement;
    }
    
    if (definition != '' || images!.isNotEmpty) {
      baseHeight += heightIncrement;
    }
    
    return baseHeight;
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
        !screen  ? Positioned.fill(
          child: SvgPicture.asset(
            'assets/background.svg',
            fit: BoxFit.cover,
          ),
        ) : Container(),
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
                (definition != '' || images.length > 0) ||
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
            color: (
              (definition != '' || images.length > 0)) || screen
                ? AppColors.getColor('mono').white
                : AppColors.getColor('mono').black,
          ),
          onPressed: () =>
              /*questionIndex > 0
                  ? setState(() {
                      questionIndex--;
                      fetchQuestionData(questionIndex);
                    })
                  : widget.overlay(), */
              widget.overlay()
        ),
      ),


      backgroundColor: (definition != '' || images.length > 0) || screen ? Colors.transparent : Theme.of(context).colorScheme.background,
      body: !screen ? 
        SingleChildScrollView(
         child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(bottom: 50),
          child:
          Align( 
            alignment: Alignment.topCenter, 
            child: Wrap(
            direction: Axis.horizontal,
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.spaceEvenly,

            children: [
            if (title != '' || definition != '' || images.length > 0) Container(
              width: 600,
              padding: EdgeInsets.all(12),
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
                            color: (definition != '' || images.length > 0)
                                ? Theme.of(context).colorScheme.onPrimary 
                                : Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                  ),
                  Column(
                    children: [
                      if (division != null && division!.isNotEmpty)
                              ...division!.map((dvs) => Container(
                                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: AppColors.getColor('mono').grey),
                                      color: Theme.of(context).colorScheme.background,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          constraints: BoxConstraints(maxWidth: 100, minHeight: 50),
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
                                          constraints: BoxConstraints( minHeight: 50, maxWidth: MediaQuery.of(context).size.width - 150),
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
                              Container(), 
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
              margin: EdgeInsets.all(12),
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                question != '' ? Container(
                    child: Text(
                      question,
                      style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                    ),
                  ) : Container(),
                  SizedBox(height: 8,),
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
                  ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: (answersImage?.length ?? 0) + (answers?.length ?? 0) + (matchmaking?.length ?? 0),
                  itemBuilder: (BuildContext context, index) {
                    Widget? tile;
                    String? itemText;

                    if (pressed) {
                      if (correct!.any((item) => item.index == index)) {
                        // Show the tile in green if index matches correct
                        if (answersImage.isNotEmpty && index < answersImage!.length) {
                          String? item = answersImage?[index];
                          tile = reTileImage(AppColors.getColor('green').lighter, AppColors.getColor('green').main, index, item, context, correct: true);
                          itemText = explanation!.length > 1 && explanation![index - answersImage.length].isNotEmpty  ? explanation![index] : null;;
                        } else if ((answers?.length ?? 0) > 1 && index - (answersImage?.length ?? 0) < (answers?.length ?? 0)) {
                          String? item = answers?[(index - (answersImage?.length ?? 0))];
                          tile = reTile(AppColors.getColor('green').lighter, AppColors.getColor('green').main, index, item, context, correct: true);
                          itemText = explanation!.length > 1 && explanation![index - answersImage.length].isNotEmpty  ? explanation![index - answersImage.length] : null;
                        } else if ((matchmaking?.length ?? 0) > 1 && (matches?.length ?? 0) > 0 && index - (answersImage?.length ?? 0) + ((answers?.length ?? 0)) < (matchmaking?.length ?? 0)) {
                          String? item = matchmaking?[(index - (answersImage?.length ?? 0) + (answers?.length ?? 0))];
                          List<String> item2 = matches ?? [];

                          if (_answer.any((answerItem) => answerItem.index == index) && correct!.any((correctItem) => _answer.any((answerItem) => answerItem.answer == correctItem.correct && answerItem.index == correctItem.index && answerItem.index == index))) {
                            tile = reTileMatchmaking(AppColors.getColor('green').lighter, AppColors.getColor('green').main, correct!.firstWhere((item) => item.index == index).correct, index, item, context, item2, true);
                            itemText = explanation!.length > 1 && explanation![index - answersImage.length - answers.length].isNotEmpty  ? explanation![index - answersImage.length - answers.length] : null;
                          } else {
                            tile = reTileMatchmaking(AppColors.getColor('red').lighter, AppColors.getColor('red').main, correct!.firstWhere((item) => item.index == index).correct, index, item, context, item2, false);
                            itemText = explanation!.length > 1 && explanation![index - answersImage.length - answers.length].isNotEmpty  ? explanation![index - answersImage.length - answers.length] : null;;
                          }
                        } 
                        if (tile != null) {
                          return Column(
                            children: [
                              tile,
                              if(itemText != null) Container(
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
                                          itemText ?? '',
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
                        }
                      } else if (correct!.any((item) => item.index != index) && _answer!.any((item) => item.index == index)) {
                          if (answersImage.isNotEmpty && index < answersImage!.length) {
                            String? item = answersImage?[index];
                            tile = reTileImage(AppColors.getColor('mono').white, AppColors.getColor('red').main, index, item, context, correct: false);
                            itemText = explanation!.length > 1 && explanation![index - answersImage.length].isNotEmpty  ? explanation![index] : null;;
                          } else if ((answers?.length ?? 0) > 1 && index - (answersImage?.length ?? 0) < (answers?.length ?? 0)) {
                            String? item = answers?[(index - (answersImage?.length ?? 0))];
                            tile =  reTile(AppColors.getColor('red').lighter, AppColors.getColor('red').main, index, item, context,correct: false);
                            itemText = explanation!.length > 1 && explanation![index - answersImage.length].isNotEmpty  ? explanation![index - answersImage.length] : null;
                          }
                            if (tile != null) {
                          return Column(
                            children: [
                              tile,
                              if(itemText != null) Container(
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
                                          itemText ?? '',
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
                        }
                        } else {
                            if (answersImage.isNotEmpty && index < answersImage!.length) {
                            String? item = answersImage?[index];
                            tile = reTileImage(AppColors.getColor('mono').white, AppColors.getColor('mono').lightGrey, index, item, context);
                            itemText = explanation!.length > 1 && explanation![index - answersImage.length].isNotEmpty  ? explanation![index] : null;;
                          } else if ((answers?.length ?? 0) > 1 && index - (answersImage?.length ?? 0) < (answers?.length ?? 0)) {
                            String? item = answers?[(index - (answersImage?.length ?? 0))];
                            tile =   reTile(AppColors.getColor('mono').white, AppColors.getColor('mono').lightGrey, index, item, context); 
                            itemText = explanation!.length > 1 && explanation![index - answersImage.length].isNotEmpty  ? explanation![index - answersImage.length] : null;
                          }
                            if (tile != null) {
                          return Column(
                            children: [
                              tile,
                              if(itemText != null) Container(
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
                                          itemText ?? '',
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
                        }
                        }
                    } else {
                // Show all items when boolPressed is false
                if (answersImage.isNotEmpty && index < answersImage!.length) {
                  String? item = answersImage?[index];
                  return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        bool isSelected = _answer.any((e) => e.answer == index);
                        if (!isSelected) {
                          // If selected items are less than the limit, allow adding
                          if ((answers.length + answersImage.length) <= 3) {
                            if (_answer.length < 1) {
                              _answer.add(UserAnswerData(answer: index, index: index));
                            }
                          } else {
                            _answer.add(UserAnswerData(answer: index, index: index));
                          }
                        } else {
                          // Always allow unchecking
                          _answer.removeWhere((element) => element.answer == index);
                        }
                      });
                    },
                    child: Material(
                      type: MaterialType.transparency,
                      child: Container(
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: _answer.any((e) => e.answer == index)
                              ? Border.all(color: Theme.of(context).primaryColor)
                              : Border.all(color: AppColors.getColor('mono').lightGrey),
                          color: _answer.any((e) => e.answer == index)
                              ? AppColors.getColor('primary').lighter
                              : AppColors.getColor('mono').white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            if (item != null && item.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.asset(item, fit: BoxFit.cover),
                              ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                              child: Row(
                                children: [
                                  Text('${String.fromCharCode('a'.codeUnitAt(0) + index)})',
                                    style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: _answer.any((e) => e.index == index)
                                            ? Theme.of(context).primaryColor
                                            : Theme.of(context).colorScheme.onBackground,
                                      ),
                                  ),
                                  SizedBox(width: 32),
                                  Expanded(child: Text('Obrázok ${index + 1},',
                                    style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: _answer.any((e) => e.index == index) == true ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onBackground,
                                  ),
                                  )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )

                  );
                } else if (answers.isNotEmpty && (index - answersImage.length) < answers!.length) {
                  String? item = answers[(index - answersImage.length)];
                  return  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          bool isSelected = _answer.any((e) => e.answer == index);
                          if (!isSelected) {
                            // If selected items are less than the limit, allow adding
                            if ((answers.length + answersImage.length) <= 3) {
                              if (_answer.length < 1) {
                                _answer.add(UserAnswerData(answer: index, index: index));
                              }
                            } else {
                              _answer.add(UserAnswerData(answer: index, index: index));
                            }
                          } else {
                            // Allow toggling off
                            _answer.removeWhere((element) => element.answer == index);
                          }
                        });
                      },
                      child: Material(
                        type: MaterialType.transparency,
                        child: Container(
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: _answer.any((e) => e.index == index)
                                ? Border.all(color: Theme.of(context).primaryColor)
                                : Border.all(color: AppColors.getColor('mono').lightGrey),
                            color: _answer.any((e) => e.index == index)
                                ? AppColors.getColor('primary').lighter
                                : AppColors.getColor('mono').white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                            child: Row(
                              children: [
                                Text('${String.fromCharCode('a'.codeUnitAt(0) + index)})',
                                  style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: _answer.any((e) => e.index == index)
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context).colorScheme.onBackground,
                                    ),
                                ),
                                SizedBox(width: 32),
                                Expanded(
                                  child: Text(
                                    item,
                                    style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: _answer.any((e) => e.index == index)
                                            ? Theme.of(context).colorScheme.primary
                                            : Theme.of(context).colorScheme.onBackground,
                                      ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );

                } else if (matchmaking.isNotEmpty && matches.isNotEmpty && index - (answersImage.length) + ((answers.length)) < matchmaking.length) {
                  String? item = matchmaking[(index - (answersImage.length) - (answers.length))];
                  return Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.getColor('mono').lightGrey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(item,
                        style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                            InkWell(
                            onTap: () {
                              setState(() {
                                if (openDropdownIndex == index) {
                                  openDropdownIndex = null;
                                } else {
                                  openDropdownIndex = index;
                                }
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.all(8),
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: openDropdownIndex == index ? AppColors.getColor('primary').main : Colors.grey),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    _answer.any((e) => e.index == index)
                                        ? matches[_answer.firstWhere((e) => e.index == index).answer!]
                                        : 'Vybrať definíciu',
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: _answer.any((e) => e.index == index) == true
                                          ? AppColors.getColor('primary').main
                                          : Theme.of(context).colorScheme.onBackground,
                                    ),
                                  ),
                                  openDropdownIndex == index ? SvgPicture.asset(
                                      'assets/icons/upIcon.svg',  // Make sure to replace this with your SVG asset path
                                    ) :  SvgPicture.asset(
                                      'assets/icons/downIcon.svg',  // Make sure to replace this with your SVG asset path
                                    ),
                                ],
                              ),
                            ),
                          ),
                          if (openDropdownIndex == index) _buildDropdown(index, matches),
                      ],
                    ),
                  );
              }
              }
              return Container(); // Placeholder for empty answer fields or non-matching tiles
            }
          ),
              if(explanation!.length < 2 && pressed && explanation!.length > 0 )Container(
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

            pressed ? ReButton(activeColor: AppColors.getColor('green').main, defaultColor:  AppColors.getColor('green').light, disabledColor: AppColors.getColor('mono').lightGrey, focusedColor: AppColors.getColor('primary').lighter, hoverColor: AppColors.getColor('green').main, text: 'ĎALEJ',onTap:
              onNextButtonPressed,
            ) : ReButton(activeColor: AppColors.getColor('green').main, defaultColor:  AppColors.getColor('green').light, disabledColor: AppColors.getColor('mono').lightGrey, focusedColor: AppColors.getColor('primary').lighter, hoverColor: AppColors.getColor('green').main,isDisabled: _answer.length < 1  + (matchmaking.length > 0 ? matchmaking.length - 1 : 0),  text: 'HOTOVO', onTap:
              onAnswerPressed,
            ),
          ],
        ),
          )
        )
      )
         : firstScreen ?
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
              height: MediaQuery.of(context).size.height * (8/12),
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


  Widget _buildDropdown(int index, List<String> matches) {
    return Material(
      elevation: 5,
        borderRadius: BorderRadius.circular(10),
      child: Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: ListView.builder(
        itemCount: matches.length,
        shrinkWrap: true,
        itemBuilder: (context, idx) {
          return ListTile(
            title: Text(matches[idx],
            style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(
                color: _answer.any((e) => e.index == index) == true ? AppColors.getColor('primary').main : Theme.of(context).colorScheme.onBackground,
              ),
            ),
            onTap: () {
              // Handle selection here
              setState(() {
                openDropdownIndex = null;
                if (_answer.length > 0) {
                  bool exists = _answer.any((element) => element.index == index);
                  if (!exists) {
                    _answer.add(UserAnswerData(answer: idx, index: index));
                  } else {
                    _answer.removeWhere((element) => element.index == index);
                    _answer.add(UserAnswerData(answer: idx, index: index));
                  }
                } else {
                  _answer.add(UserAnswerData(answer: idx, index: index));
                }
              });
            },
          );
        },
      ),
    )
    );
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

  void onAnswerPressed() {
    if (_answer.length > 0) {
      setState(() {
       double partialPoints = 1.00 / widget.userData!.capitols[int.parse(widget.capitolsId)].tests[widget.testIndex].questions[questionIndex].correct.length;

    // Initialize points to 0 for this specific run
    double points = 0.0;

   List<bool> correctnessList = List<bool>.filled(correct!.length, false);

      for (var userAnswer in _answer) {
        // Try to find a matching correct answer based on index
        CorrectData? matchingCorrectItem;

          try {
              matchingCorrectItem = correct!.firstWhere((c) => c.index == userAnswer.index);
          } catch (e) {
              matchingCorrectItem = null;
          }


        // If found and answers match, update points and correctnessList
        if (matchingCorrectItem != null && userAnswer.answer == matchingCorrectItem.correct) {
          int correctListIndex = correct!.indexOf(matchingCorrectItem);
          if (correctListIndex != -1 && correctListIndex < correctnessList.length) {
            correctnessList[correctListIndex] = true;
          }
          points += partialPoints;
        } else {
          points -= partialPoints;
        }
      }


    for (int i = 0; i < correct!.length; i++) {
        if (!_answer.any((item) => item.index == correct![i].index)) {
            points -= partialPoints; // Decrement points by partialPoints for every missing answer
        }
    }

    // Update the user's data
    widget.userData!.capitols[int.parse(widget.capitolsId)].tests[widget.testIndex].questions[questionIndex].correct = correctnessList;

    // Check if points are negative and if so, reset them to 0
    if (points < 0) {
        points = 0.0;
    }

    // Update points, round it as per your instructions
    widget.userData!.capitols[int.parse(widget.capitolsId)].tests[widget.testIndex].points += points.round();
    widget.userData!.points += points.round();





        if (widget.userData!.capitols[int.parse(widget.capitolsId)].tests[widget.testIndex].questions.length - 1 == countTrueValues(widget.userData!.capitols[int.parse(widget.capitolsId)].tests[widget.testIndex].questions)) widget.userData!.capitols[int.parse(widget.capitolsId)].tests[widget.testIndex].completed = true;

        widget.userData!.capitols[int.parse(widget.capitolsId)].tests[widget.testIndex].questions[questionIndex].completed = true;
        widget.userData!.capitols[int.parse(widget.capitolsId)].tests[widget.testIndex].questions[questionIndex].answer = _answer ?? [];

        if (areAllCompleted(widget.userData!)) {
          widget.userData!.capitols[int.parse(widget.capitolsId)].completed = true;

          // Ensure that badges list is long enough
          while (widget.userData!.badges.length <= int.parse(widget.capitolsId)) {
            widget.userData!.badges.add('');
          }

          widget.userData!.badges[int.parse(widget.capitolsId)] = badgePaths[int.parse(widget.capitolsId)];
        }
        
        _answer = _answer;
        pressed = true;

      });
      saveUserDataToFirestore(widget.userData!);
    }
  }

  void onNextButtonPressed() {
    if (questionIndex + 1 < (questionsPoint ?? 0)) {
      setState(() {
        questionIndex++;
        pressed = false;
        _answer = [];
        _loading = true;
      });
      fetchQuestionData(questionIndex);
    } else {

 
      setState(() {
        widget.userData!.capitols[int.parse(widget.capitolsId)].tests[widget.testIndex].completed = true;
        questionIndex = 0;
        _answer = [];
        pressed = false;
      });
     
      saveUserDataToFirestore(widget.userData!);
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

  Future<void> saveUserDataToFirestore(UserData userData) async {
    try {
      // Reference to the user document in Firestore
      DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);

      // Convert userData object to a Map
      Map<String, dynamic> userDataMap = {
        'badges': userData.badges,
        'discussionPoints': userData.discussionPoints,
        'weeklyDiscussionPoints': userData.weeklyDiscussionPoints,
        'admin': userData.admin,
        'teacher': userData.teacher,
        'email': userData.email,
        'name': userData.name,
        'active': userData.active,
        'schoolClass': userData.schoolClass,
        'notifications': userData.notifications,
        'image': userData.image,
        'surname': userData.surname,
        'points': userData.points,
        'capitols': userData.capitols.map((userCapitolsData) {
          return {
            'id': userCapitolsData.id,
            'name': userCapitolsData.name,
            'image': userCapitolsData.image,
            'completed': userCapitolsData.completed,
            'tests': userCapitolsData.tests.map((userCapitolsTestData) {
              return {
                'name': userCapitolsTestData.name,
                'completed': userCapitolsTestData.completed,
                'points': userCapitolsTestData.points,
                'questions': userCapitolsTestData.questions.map((userQuestionsData) {
                  return {
                    'answer': userQuestionsData.answer.map((userAnswerData) {
                      return {
                        'answer': userAnswerData.answer,
                        'index': userAnswerData.index
                        };
                    }).toList(),
                    'completed': userQuestionsData.completed,
                    'correct': userQuestionsData.correct,
                  };
                }).toList(),
              };
            }).toList(),
          };
        }).toList(),
      };

      // Update the user document in Firestore with the new userDataMap
      await userRef.update(userDataMap);
    } catch (e) {
      print('Error saving user data to Firestore: $e');
      rethrow;
    }
  }
}
