import 'package:flutter/material.dart';
import 'package:infomentor/backend/fetchCapitols.dart';
import 'package:infomentor/widgets/ReWidgets.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infomentor/backend/fetchUser.dart'; // Import the UserData class and fetchUser function
import 'package:infomentor/Colors.dart';



class Test extends StatefulWidget {
  final int testIndex;
  final Function overlay;
  final String capitolsId;
  final UserData? userData;

  const Test(
      {Key? key,
      required this.testIndex,
      required this.overlay,
      required this.capitolsId,
      required this.userData})
      : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

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

class _TestState extends State<Test> {
  int? _answer;
  bool? isCorrect;
  bool lastScreen = false;
  int questionIndex = 0;
  List<String>? answers;
  List<String>? answersImage;
  int? correct;
  String? definition;
  String? explanation;
  String? image;
  String? question;
  String? subQuestion;
  String? title;
  int? questionsCount;
  bool _disposed = false;
  bool pressed = false;

  Future<void> fetchQuestionData(int index) async {
    try {
      FetchResult result = await fetchCapitols(widget.capitolsId);

      if (_disposed) return; // Check if the widget has been disposed

      setState(() {
        answers = result.capitolsData?.tests[widget.testIndex].questions[questionIndex].answers;
        answersImage = result.capitolsData?.tests[widget.testIndex].questions[questionIndex].answersImage;
        correct = result.capitolsData?.tests[widget.testIndex].questions[questionIndex].correct;
        definition = result.capitolsData?.tests[widget.testIndex].questions[questionIndex].definition;
        explanation = result.capitolsData?.tests[widget.testIndex].questions[questionIndex].explanation;
        image = result.capitolsData?.tests[widget.testIndex].questions[questionIndex].image;
        question = result.capitolsData?.tests[widget.testIndex].questions[questionIndex].question;
        subQuestion = result.capitolsData?.tests[widget.testIndex].questions[questionIndex].subQuestion;
        title = result.capitolsData?.tests[widget.testIndex].questions[questionIndex].title;
        questionsCount = result.capitolsData?.tests[widget.testIndex].points;
      });
    } catch (e) {
      print('Error fetching question data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    questionIndex = countTrueValues(widget.userData!.capitols[int.parse(widget.capitolsId)].tests[widget.testIndex].questions);
    fetchQuestionData(questionIndex);
  }

  @override
  void didUpdateWidget(Test oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.testIndex != oldWidget.testIndex) {
      // Test ID has changed, reset the state and fetch new data
      setState(() {
        questionIndex = 0;
        _answer = null;
      });
      fetchQuestionData(questionIndex);
    }
  }

  @override
  void dispose() {
    _disposed = true; // Set the disposed flag to true
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: MediaQuery.of(context).size.width < 1000 ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.background,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: MediaQuery.of(context).size.width < 1000 ? AppColors.mono.white : AppColors.mono.black,
            ),
            onPressed: () => widget.overlay()
          ),
        ),
      backgroundColor: lastScreen ? Theme.of(context).primaryColor : AppColors.mono.white,
      body: !lastScreen ? Container(
        
        child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Added this line
            children: [
            Container(
              decoration: BoxDecoration(
                color: MediaQuery.of(context).size.width < 1000 ?  Theme.of(context).primaryColor : null,
        ),
              child: Column(
                children: [
                  Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  title ?? '',
                   style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(
                            color: MediaQuery.of(context).size.width < 1000 ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onBackground,
                          ),
                ),
              ),
                    if (image != null && image!.isNotEmpty && image != "")
                  image!.isEmpty
                      ? Container() // Placeholder for empty image field
                      :  Padding(
                          padding: EdgeInsets.all(8),
                          child: Image.asset(
                            width: 500,
                            height: 400,
                            image!,
                          ),
                        ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    definition ?? '',
                     style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .copyWith(
                            color: MediaQuery.of(context).size.width < 1000 ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onBackground,
                          ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    question ?? '',
                    style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(
                            color: MediaQuery.of(context).size.width < 1000 ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onBackground,
                          ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    subQuestion ?? '',
                     style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(
                            color: MediaQuery.of(context).size.width < 1000 ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onBackground,
                          ),
                  ),
                ),
                ],
              ),
            ),
            MediaQuery.of(context).size.width < 1000 ? Container(
              height: 100,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(1000.0),
                  bottomRight: Radius.circular(1000.0),
                )
              ),
            ) : Container(),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: (answersImage?.length ?? 0) + (answers?.length ?? 0),
              itemBuilder: (BuildContext context, index) {
                if (pressed) {
                  if (index == correct) {
                    // Show the tile in green if index matches correct
                    if (answersImage != null && index < answersImage!.length) {
                      String? item = answersImage?[index];
                      return Container(
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: _answer == index ? Border.all(color: Theme.of(context).colorScheme.error) : Border.all(color: AppColors.mono.lightGrey),
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.green.main,
                        ),
                        child: Column(
                          children: [
                            if (item != null && item.isNotEmpty) Image.asset(item, fit: BoxFit.cover),
                            ListTile(
                              title: Text('Obrázok ${index + 1}'),
                              leading: Radio(
                                value: index,
                                groupValue: _answer,
                                fillColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
                                onChanged: null,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (answers != null && index - (answersImage?.length ?? 0) < answers!.length) {
                      String? item = answers?[(index - (answersImage?.length ?? 0))];
                      return Container(
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: _answer == index ? Border.all(color: Theme.of(context).colorScheme.error) : Border.all(color: AppColors.mono.lightGrey),
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.green.main,
                        ),
                        child: ListTile(
                          title: Text(item ?? ''),
                          leading: Radio(
                            value: index,
                            groupValue: _answer,
                            fillColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
                            onChanged: null,
                          ),
                        ),
                      );
                    }
                  } else if (index == _answer && _answer != correct) {
                    // Show the tile in red if index matches _answer but is different from correct
                    if (answersImage != null && index < answersImage!.length) {
                      String? item = answersImage?[index];
                      return Container(
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.mono.lightGrey),
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).colorScheme.error,
                        ),
                        child: Column(
                          children: [
                            if (item != null && item.isNotEmpty) Image.asset(item, fit: BoxFit.cover),
                            ListTile(
                              title: Text('Obrázok ${index + 1}'),
                              leading: Radio(
                                value: index,
                                groupValue: _answer,
                                fillColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
                                onChanged: null,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (answers != null && index - (answersImage?.length ?? 0) < answers!.length) {
                      String? item = answers?[(index - (answersImage?.length ?? 0))];
                      return Container(
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.mono.lightGrey),
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).colorScheme.error,
                        ),
                        child: ListTile(
                          title: Text(item ?? ''),
                          leading: Radio(
                            value: index,
                            groupValue: _answer,
                            fillColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
                            onChanged: (int? value) {
                              setState(() {
                                _answer = value;
                              });
                            },
                          ),
                        ),
                      );
                    }
                  }
                } else {
                  // Show all items when boolPressed is false
                  if (answersImage != null && index < answersImage!.length) {
                    String? item = answersImage?[index];
                    return Container(
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: _answer == index ? Border.all(color: Theme.of(context).primaryColor) : Border.all(color: AppColors.mono.lightGrey),
                        borderRadius: BorderRadius.circular(10),
                        color: _answer == index ? AppColors.primary.lighter: AppColors.mono.white,
                      ),
                      child: Column(
                        children: [
                          if (item != null && item.isNotEmpty) Image.asset(item, fit: BoxFit.cover),
                          ListTile(
                            title: Text('Obrázok ${index + 1}'),
                            leading: Radio(
                              value: index,
                              groupValue: _answer,
                              fillColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
                              onChanged: (int? value) {
                                setState(() {
                                  _answer = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (answers != null && index - (answersImage?.length ?? 0) < answers!.length) {
                    String? item = answers?[(index - (answersImage?.length ?? 0))];
                    return Container(
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: _answer == index ? Border.all(color: Theme.of(context).primaryColor) : Border.all(color: AppColors.mono.lightGrey),
                        borderRadius: BorderRadius.circular(10),
                        color: _answer == index ? AppColors.primary.lighter: AppColors.mono.white,
                      ),
                      child: ListTile(
                        title: Text(item ?? ''),
                        leading: Radio(
                          value: index,
                          groupValue: _answer,
                          fillColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
                          onChanged: (int? value) {
                            setState(() {
                              _answer = value;
                            });
                          },
                        ),
                      ),
                    );
                  }
                }

                return Container(); // Placeholder for empty answer fields or non-matching tiles
              },
            ),
            SizedBox(height: 20),

            if (pressed) Text(explanation ?? ""),
            SizedBox(height: 20),

            pressed ? reButton(
              context,
              'ĎALEJ',
              0xff3cad9a,
              0xffffffff,
              0xffffffff,
              onNextButtonPressed,
            ) : reButton(
              context,
              'HOTOVO',
              0xff3cad9a,
              0xffffffff,
              0xffffffff,
              onAnswerPressed,
            ),
          ],
        ),
      )
      ) : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.userData!.capitols[int.parse(widget.capitolsId)].tests[widget.testIndex].name,
              style: TextStyle(
                color: AppColors.mono.white,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 20),
            Icon(
              Icons.star,
              size: 50,
              color: AppColors.yellow.light,
            ),
            SizedBox(height: 10),
            Text(
              "Super!",
              style: TextStyle(
                color: AppColors.mono.white,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "${widget.userData!.capitols[int.parse(widget.capitolsId)].tests[widget.testIndex].points}/${questionsCount} správnych odpovedí",
              style: TextStyle(
                color: AppColors.mono.white,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.star,
                  size: 20,
                  color: AppColors.yellow.light,
                ),
                SizedBox(width: 5),
                Text(
                  "+${widget.userData!.capitols[int.parse(widget.capitolsId)].tests[widget.testIndex].points}",
                  style: TextStyle(
                    color: AppColors.mono.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            reButton(
              context,
              'ZAVRIEŤ',
              0xff3cad9a,
              0xffffffff,
              0xffffffff,
              () => widget.overlay(),
            ),
          ],
        )
      );
  }

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


  void onAnswerPressed() {
    if (_answer != null) {
      setState(() {
      if (_answer == correct) {
            widget.userData!.capitols[int.parse(widget.capitolsId)].tests[widget.testIndex].points++;
            widget.userData!.points++;
        }
        if (widget.userData!.capitols[int.parse(widget.capitolsId)].tests[widget.testIndex].questions.length - 1 == countTrueValues(widget.userData!.capitols[int.parse(widget.capitolsId)].tests[widget.testIndex].questions)) {
          widget.userData!.capitols[int.parse(widget.capitolsId)].tests[widget.testIndex].completed = true;
          switch (int.parse(widget.capitolsId)) {
            case 0:
              widget.userData!.badges[int.parse(widget.capitolsId)] = 'assets/badges/badgeArgActive.svg';
              break;
            case 1:
              widget.userData!.badges[int.parse(widget.capitolsId)] = 'assets/badges/badgeManActive.svg';
              break;
            case 2:
              widget.userData!.badges[int.parse(widget.capitolsId)] = 'assets/badges/badgeCritActive.svg';
              break;
            case 3:
              widget.userData!.badges[int.parse(widget.capitolsId)] = 'assets/badges/badgeDataActive.svg';
              break;
            case 4:
              widget.userData!.badges[int.parse(widget.capitolsId)] = 'assets/badges/badgeGramActive.svg';
              break;
            case 5:
              widget.userData!.badges[int.parse(widget.capitolsId)] = 'assets/badges/badgeMediaActive.svg';
              break;
            case 6:
              widget.userData!.badges[int.parse(widget.capitolsId)] = 'assets/badges/badgeSocialActive.svg';
              break;
          }
      }
        widget.userData!.capitols[int.parse(widget.capitolsId)].tests[widget.testIndex].questions[questionIndex] = true;
        
        _answer = _answer;
        pressed = true;

      });
      saveUserDataToFirestore(widget.userData!);
    }
  }

  void onNextButtonPressed() {
    if (questionIndex + 1 < (questionsCount ?? 0)) {
      setState(() {
        questionIndex++;
        pressed = false;
        _answer = null;
      });
      fetchQuestionData(questionIndex);
    } else {


      setState(() {
        widget.userData!.capitols[int.parse(widget.capitolsId)].tests[widget.testIndex].completed = true;
        questionIndex = 0;
        _answer = null;
        pressed = false;
      });
      if (areAllCompleted(widget.userData!)) {
        widget.userData!.capitols[int.parse(widget.capitolsId)].completed = true;
      }
      saveUserDataToFirestore(widget.userData!);
      _showLastScreen();
    }
  }

  void _showLastScreen() {
    setState(() {
      // Update the state to show the last screen
      lastScreen = true;
      question = null;
      subQuestion = null;
      title = null;
      image = null;
      definition = null;
      answers = null;
      answersImage = null;
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
        'email': userData.email,
        'name': userData.name,
        'active': userData.active,
        'schoolClass': userData.schoolClass,
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
                'questions': userCapitolsTestData.questions,
              };
            }).toList(),
          };
        }).toList(),
        'materials': userData.materials,
      };

      // Update the user document in Firestore with the new userDataMap
      await userRef.update(userDataMap);
    } catch (e) {
      print('Error saving user data to Firestore: $e');
      rethrow;
    }
  }
}
