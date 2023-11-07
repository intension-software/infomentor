import 'package:flutter/material.dart';
import 'package:infomentor/backend/fetchUser.dart';
import 'package:infomentor/backend/fetchClass.dart';
import 'package:infomentor/backend/fetchCapitols.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infomentor/Colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infomentor/widgets/ReWidgets.dart';

class StudentCapitolDragWidget extends StatefulWidget {
  final UserData? currentUserData;
  List<int> numbers;
  Future<void> Function()  refreshData;

  StudentCapitolDragWidget({
    Key? key,
    required this.numbers,
    required this.currentUserData,
    required this.refreshData
  }) : super(key: key);

  @override
  _StudentCapitolDragWidgetState createState() => _StudentCapitolDragWidgetState();
}

class _StudentCapitolDragWidgetState extends State<StudentCapitolDragWidget> {
  int? expandedTileIndex;
  ClassData? currentClassData;
  CapitolsData? capitolsData;
  List<FetchResult> localResults = [];
  List<FetchResult> localResultsDrag = [];
  bool _loadingCurrentClass = true;
  bool _loadingQuestionData = true;

  int countTrueValues(List<UserQuestionsData> questionList) {
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

  fetchCurrentClass() async {
    try {
      ClassData classData = await fetchClass(widget.currentUserData!.schoolClass!);
      if (classData != null) {
        if (mounted) {
          setState(() {
            currentClassData = classData;
            _loadingCurrentClass = false;
          });
        }
      } else {
        print('User is not logged in.');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  fetchQuestionData() async {
  try {
    for (int order in widget.numbers) {
      localResults.add(await fetchCapitols(order.toString()));
    }

    for (int order = 0; order < widget.numbers.length; order++) {
      localResultsDrag.add(await fetchCapitols(order.toString()));
    }

    setState(() {
      _loadingQuestionData = false;
    });
  } catch (e) {
    print('Error fetching question data: $e');
  }

  return localResults;
}

  @override
  void initState() {
    super.initState();
    fetchCurrentClass();
    fetchQuestionData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingCurrentClass || _loadingQuestionData) {
        return Center(child: CircularProgressIndicator()); // Show loading circle when data is being fetched
    }
    return Container(
      width: 200,
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20,),
          Container(
            width: 600,
            child: 
              Text(
                'Všetky Kapitoly',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
          ),
          SizedBox(height: 20,),
          Container(
            width: 600,
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: localResults.length,
              itemBuilder: (ctx, index) {
                bool isExpanded = index == expandedTileIndex;
                CapitolsData? capitol = localResults[index].capitolsData;

                if (capitol == null) {
                  // If capitol data is null, return an empty Container or another widget indicating no data
                  return Container();
                }

                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(0),
                      margin: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: isExpanded
                            ? Theme.of(context).primaryColor
                            : AppColors.getColor('mono').lighterGrey,
                      ),
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            if (isExpanded) {
                              expandedTileIndex = null;
                            } else {
                              expandedTileIndex = index;
                            }
                          });
                        },
                        hoverColor: Colors.transparent,
                        leading: CircleAvatar(
                          radius: 8,
                          backgroundColor: isExpanded
                              ? AppColors.getColor('mono').white
                              : AppColors.getColor(capitol.color).light,  // Update this to avoid out-of-bounds
                        ),
                        title: Text(
                          capitol.name,
                          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                color: isExpanded
                                    ? Theme.of(context).colorScheme.onPrimary
                                    : Theme.of(context).primaryColor,
                              ),
                        ),
                        trailing: isExpanded
                            ? SvgPicture.asset('assets/icons/upWhiteIcon.svg')
                            : SvgPicture.asset('assets/icons/downPrimaryIcon.svg'),
                      ),
                    ),
                    if (isExpanded)
                      ...List.generate(
                        capitol.tests.length,
                        (subIndex) => Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: AppColors.getColor('mono').lighterGrey,
                                width: 1.0,
                              ),
                            ),
                          ),
                          child: ListTile(
                            title: Text(
                              capitol.tests[subIndex].name,
                              style: TextStyle(fontSize: 14, decoration: subIndex == 0 && index == 0 ? TextDecoration.underline : null, ),
                            ),
                            trailing: ((countTrueValues(widget.currentUserData!.capitols[widget.numbers[index]].tests[subIndex].questions) /
                                widget.currentUserData!.capitols[widget.numbers[index]].tests[subIndex].questions.length)*100) != 0 ? Row(
                              mainAxisSize: MainAxisSize.min,  // To shrink-wrap the Row
                              children: [
                                Text('${((countTrueValues(widget.currentUserData!.capitols[widget.numbers[index]].tests[subIndex].questions) /
                                widget.currentUserData!.capitols[widget.numbers[index]].tests[subIndex].questions.length)*100).toStringAsFixed(0)}%',
                                  style: TextStyle(color: AppColors.getColor('mono').darkGrey)
                                ),  // Showing upto 2 decimal places
                                SizedBox(width: 5),  // Optional: To give some space between the Text and the Icon
                                SvgPicture.asset('assets/icons/correctIcon.svg')  // Replace with the icon you want
                              ],
                            ) : null,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                            dense: true,
                          ),
                        ),
                      )
                  ],
                );
              },
            )
          )
        ],
      ),
    );
  }
 
}

// ReorderListOverlay remains unchanged.




