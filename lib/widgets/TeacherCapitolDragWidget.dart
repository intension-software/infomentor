import 'package:flutter/material.dart';
import 'package:infomentor/backend/fetchUser.dart';
import 'package:infomentor/backend/fetchClass.dart';
import 'package:infomentor/backend/fetchCapitols.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infomentor/Colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infomentor/widgets/ReWidgets.dart';

class TeacherCapitolDragWidget extends StatefulWidget {
  final List<List<double>> percentages;
  final UserData? currentUserData;
  List<int> numbers;
  Future<void> Function()  refreshData;

  TeacherCapitolDragWidget({
    Key? key,
    required this.percentages,
    required this.numbers,
    required this.currentUserData,
    required this.refreshData
  }) : super(key: key);

  @override
  _TeacherCapitolDragWidgetState createState() => _TeacherCapitolDragWidgetState();
}

class _TeacherCapitolDragWidgetState extends State<TeacherCapitolDragWidget> {
  int? expandedTileIndex;
  ClassData? currentClassData;
  CapitolsData? capitolsData;
  List<FetchResult> localResults = [];
  List<FetchResult> localResultsDrag = [];

  fetchCurrentClass() async {
    try {
      ClassData classData = await fetchClass(widget.currentUserData!.schoolClass!);
      if (classData != null) {
        if (mounted) {
          setState(() {
            currentClassData = classData;
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
    return SingleChildScrollView(
      child: Container(
      width: 200,
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20,),
          Container(
            width: 600,
            child: Row(
              children: [
                Text(
                  'Všetky Kapitoly',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                 ReButton(
                  activeColor: AppColors.getColor('primary').light, 
                  defaultColor: AppColors.getColor('mono').lighterGrey, 
                  disabledColor: AppColors.getColor('mono').lightGrey, 
                  focusedColor: AppColors.getColor('primary').light, 
                  hoverColor: AppColors.getColor('primary').lighter, 
                  textColor: AppColors.getColor('primary').main, 
                  iconColor: AppColors.getColor('primary').main,
                  rightIcon: 'assets/icons/editIcon.svg',
                  text: 'Upraviť poradie', 
                  onTap: () async {
                    final result = await reorderListOverlay(context, currentClassData!);
                      if (result != null) {
                        setState(() {
                          widget.numbers = result;
                        });
                      }
                  },
                ),
              ],
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
                              style: TextStyle(fontSize: 14, decoration: subIndex == 0 ? TextDecoration.underline : null,),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,  // To shrink-wrap the Row
                              children: [
                                Text('Úspešnosť: ${(widget.percentages[widget.numbers[index]][subIndex]*100).toStringAsFixed(0)}%',
                                  style: TextStyle(color: AppColors.getColor('mono').darkGrey)
                                ),  // Showing upto 2 decimal places
                                SizedBox(width: 5),
                                
                                SizedBox(width: 5),  // Optional: To give some space between the Text and the Icon
                                SvgPicture.asset('assets/icons/correctIcon.svg')  // Replace with the icon you want
                              ],
                            ),
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
      )
    );
  }

    
 Future<List<int>?> reorderListOverlay(BuildContext context, ClassData currentClass) async {
  List<int> reorderedNumbers = List.from(widget.numbers); // Create a deep copy
  List<int> normalOrder = [0,1,2,3,4,5,6];

  return await showDialog<List<int>>(
    context: context,
    builder: (ctx) => StatefulBuilder( // Using StatefulBuilder for local state management
      builder: (context, setState) => Dialog(
        shape: RoundedRectangleBorder(  // Add this line
        borderRadius: BorderRadius.circular(20),
      ),
        child: Container(
          width: 1300,
          height: 900,
          padding: EdgeInsets.all(30),

          child: Container(
            width: 600,
            child:Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Zmena poradia kapitol',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              SizedBox(height: 20,),
              Text(
                'Presuňte poradie nezačatých kapitol. Túto zmenu uvidia študenti okamžite.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 16
                ),
              ),
              SizedBox(height: 50,),
             Expanded(
              child: Container(
                width: 600,
                child: ReorderableListView(
                  onReorder: (oldIndex, newIndex) {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    final item = reorderedNumbers.removeAt(oldIndex);
                    reorderedNumbers.insert(newIndex, item);
                    setState(() {});
                  },
                  buildDefaultDragHandles: false, // Remove default drag handles
                  children: normalOrder.map((number) {
                    CapitolsData? capitol = localResultsDrag[reorderedNumbers[number]].capitolsData;
                    if (capitol == null) {
                      return Container();
                    }
                    return Row(
                      key: ValueKey(number),
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(0),
                            margin: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.getColor('mono').lighterGrey,
                            ),
                            child: ListTile(
                              enabled: false,
                              leading: CircleAvatar(
                                radius: 8,
                                backgroundColor: AppColors.getColor(capitol.color).light,
                              ),
                              title: Text(
                                capitol.name,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        ReorderableDragStartListener(
                          index: number,
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: SvgPicture.asset('assets/icons/dragIcon.svg'),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
              MediaQuery.of(context).size.width < 1000 ? 
                Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ReButton(
                    activeColor: AppColors.getColor('mono').white, 
                    defaultColor: AppColors.getColor('green').main, 
                    disabledColor: AppColors.getColor('mono').lightGrey, 
                    focusedColor: AppColors.getColor('green').light, 
                    hoverColor: AppColors.getColor('green').light, 
                    textColor: Theme.of(context).colorScheme.onPrimary, 
                    iconColor: AppColors.getColor('mono').black, 
                    text: 'ULOŽIŤ ZMENY', 
                    onTap: () async {
                      Navigator.pop(context, reorderedNumbers);
                      await updateClassToFirestore(reorderedNumbers);
                      fetchCurrentClass(); 
                    },
                  ),
                  SizedBox(width: 20,),
                  ReButton(
                    activeColor: AppColors.getColor('mono').white, 
                    defaultColor: AppColors.getColor('mono').white, 
                    disabledColor: AppColors.getColor('mono').lightGrey, 
                    focusedColor: AppColors.getColor('mono').lightGrey, 
                    hoverColor: AppColors.getColor('mono').lighterGrey, 
                    textColor: Theme.of(context).colorScheme.onBackground, 
                    iconColor: AppColors.getColor('mono').black, 
                    text: 'ZRUŠIŤ ZMENY', 
                    onTap: () async {
                      Navigator.pop(context, reorderedNumbers);
                    },
                  ),
                ],
              )
              : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ReButton(
                    activeColor: AppColors.getColor('mono').white, 
                    defaultColor: AppColors.getColor('mono').white, 
                    disabledColor: AppColors.getColor('mono').lightGrey, 
                    focusedColor: AppColors.getColor('mono').lightGrey, 
                    hoverColor: AppColors.getColor('mono').lighterGrey, 
                    textColor: Theme.of(context).colorScheme.onBackground, 
                    iconColor: AppColors.getColor('mono').black, 
                    text: 'ZRUŠIŤ ZMENY', 
                    onTap: () async {
                      Navigator.pop(context, reorderedNumbers);
                    },
                  ),
                  SizedBox(width: 20,),
                  ReButton(
                    activeColor: AppColors.getColor('mono').white, 
                    defaultColor: AppColors.getColor('green').main, 
                    disabledColor: AppColors.getColor('mono').lightGrey, 
                    focusedColor: AppColors.getColor('green').light, 
                    hoverColor: AppColors.getColor('green').light, 
                    textColor: Theme.of(context).colorScheme.onPrimary, 
                    iconColor: AppColors.getColor('mono').black, 
                    text: 'ULOŽIŤ ZMENY', 
                    onTap: () async {
                      Navigator.pop(context, reorderedNumbers);
                      await updateClassToFirestore(reorderedNumbers);
                      fetchCurrentClass(); 
                    },
                  ),
                ],
              )
            ],
          ),
          ),
        ),
      ),
    ),
  );
}


  Future<void> updateClassToFirestore(List<int> capitolOrder) async {
  try {
    DocumentReference classRef =
        FirebaseFirestore.instance.collection('classes').doc(widget.currentUserData!.schoolClass);

    // Add the material data to Firestore and get the DocumentReference of the new document
    await classRef.update({
      'capitolOrder': capitolOrder
    });

    widget.refreshData();

    } catch (e) {
      print('Error adding material to class: $e');
      throw Exception('Failed to add capitolOrder');
    }
  }
}

// ReorderListOverlay remains unchanged.




