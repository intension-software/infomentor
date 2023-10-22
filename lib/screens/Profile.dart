import 'package:flutter/material.dart';
import 'package:infomentor/Colors.dart';
import 'package:infomentor/backend/fetchCapitols.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:infomentor/backend/fetchUser.dart'; // Import the UserData class and fetchUser function
import 'package:infomentor/screens/Login.dart';
import 'package:infomentor/backend/fetchClass.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:async/async.dart';
import 'package:infomentor/widgets/ReWidgets.dart';
import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';


class Profile extends StatefulWidget {
  final void Function() logOut;

  Profile({
    Key? key,
    required this.logOut,
  }) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final PageController _pageController = PageController();
 UserData? currentUserData;
 int weeklyCapitol = 0;
  int capitolOne = 0;
  int capitolTwo = 0;
  int capitolThree = 0;
  int capitolFour = 0;
  int capitolFive = 0;
  int capitolSix = 0;
  int capitolSeven = 0;
  bool _isDisposed = false;
  List<String> badges = [];
  List<UserData>? students;
  CancelableOperation<UserData>? fetchUserDataOperation;
  CancelableOperation<List<UserData>>? fetchStudentsOperation;
  int? studentIndex;
  String? className;
  int _selectedIndex = 0;
  bool _loading = true;
  int percentage = 0;
  bool hide = true;
  bool isMobile = false;
  String _type = 'Nahlásenie problému';
  TextEditingController _messageController = TextEditingController();

  final userAgent = html.window.navigator.userAgent.toLowerCase();

  final List<String> placeIcons = [
    'assets/icons/firstPlaceIcon.png',
    'assets/icons/secondPlaceIcon.png',
    'assets/icons/thirdPlaceIcon.png',
  ];

  Future<void> sendMessage(String message, String type) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance; // Create an instance of FirebaseFirestore

    await firestore.collection('mail').add(
      {
        'to': ['jozefsvagerkom5@gmail.com'],
        'message': {
          'subject': type,
          'text': message
        },
      },
    ).then(
      (value) {
        print('Queued email for delivery!');
      },
    );
    
    reShowToast( 'Správa odoslaná', false, context);
  }

  @override
  void initState() {
    super.initState();
    final userAgent = html.window.navigator.userAgent.toLowerCase();
    isMobile = userAgent.contains('mobile');
    
    _isDisposed = false; // Resetting _isDisposed state
    fetchUserData();
    fetchCapitolsData();
    _loading = false;
  }

  int indexOfElement(List<UserData> list, String id) {
    for (var i = 0; i < list.length; i++) {
      if (list[i].id == id) {
        return i;
      }
    }
    return -1; // return -1 if the id is not found
  }

  int calculateTotalPointsForCapitol(int capitolIndex) {
    if (currentUserData == null ||
        capitolIndex < 0 ||
        capitolIndex >= currentUserData!.capitols.length) {
      throw ArgumentError('Invalid capitol index');
    }

    int totalPoints = 0;

    // Iterate through each test in the selected capitol and sum the points
    for (final test in currentUserData!.capitols[capitolIndex].tests) {
      totalPoints += test.points;
    }

    return totalPoints;
  }

  Future<void> fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        fetchUserDataOperation?.cancel();  // Cancel the previous operation if it exists
        fetchUserDataOperation = CancelableOperation<UserData>.fromFuture(fetchUser(user.uid));
        
        UserData userData = await fetchUserDataOperation!.value;
        
        if (mounted) {
          setState(() {
            currentUserData = userData;
            badges = currentUserData!.badges;
          });
          
          fetchStudents();
        }
      } else {
        if (mounted) {
          setState(() {
            currentUserData = null; // Set currentUserData to null when the user is not logged in
          });
        }
        print('User is not logged in.');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          currentUserData = null; // Set currentUserData to null on error
        });
      }
      print('Error fetching user data: $e');
    }
  }

  Future<void> fetchStudents() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null && currentUserData != null && currentUserData!.schoolClass != null) {
        final classData = await fetchClass(currentUserData!.schoolClass!);
        final studentIds = classData.students;
        List<UserData> fetchedStudents = [];

        for (var id in studentIds) {
          fetchUserDataOperation?.cancel();  // Cancel the previous operation if it exists
          fetchUserDataOperation = CancelableOperation<UserData>.fromFuture(fetchUser(id));

          UserData userData = await fetchUserDataOperation!.value;

          if (mounted) {
            fetchedStudents.add(userData);
          } else {
            return;
          }
        }

        // sort students by score
        fetchedStudents.sort((a, b) => b.points.compareTo(a.points));

        if (mounted) {
          setState(() {
            studentIndex = indexOfElement(fetchedStudents, user.uid);
            students = fetchedStudents;
            className = classData.name;
          });
        }
      } else {
        print('currentUserData is null');
      }
    } catch (e) {
      print('Error fetching students: $e');
    }
  }


  Future<void> fetchCapitolsData() async {
    try {
      FetchResult one = await fetchCapitols("0");
      FetchResult two = await fetchCapitols("1");
      FetchResult three = await fetchCapitols("2");
      FetchResult four = await fetchCapitols("3");
      FetchResult five = await fetchCapitols("4");
      FetchResult six = await fetchCapitols("5");
      FetchResult seven = await fetchCapitols("6");

      if (mounted && !_isDisposed) {
        setState(() {
          weeklyCapitol = one.capitolsData!.tests[one.capitolsData!.weeklyChallenge].points;
          capitolOne = one.capitolsData!.points;
          capitolTwo = two.capitolsData!.points;
          capitolThree = three.capitolsData!.points;
          capitolFour = four.capitolsData!.points;
          capitolFive = five.capitolsData!.points;
          capitolSix = six.capitolsData!.points;
          capitolSeven = seven.capitolsData!.points;
          percentage = ((currentUserData!.points / (capitolOne + capitolTwo + capitolThree + capitolFour + capitolFive + capitolSix + capitolSeven)) * 100).round();
        });
      }
    } catch (e) {
      print('Error fetching question data: $e');
    }
  }

  @override
  void dispose() {
  fetchUserDataOperation?.cancel();
  fetchStudentsOperation?.cancel();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    if (_loading) {
        return Center(child: CircularProgressIndicator()); // Show loading circle when data is being fetched
    }
    return currentUserData != null
          ? Container(
            color: Theme.of(context).colorScheme.background,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
              child: PageView(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    children: [ 
                      SingleChildScrollView(
                        child:Center(
                        child: Container(
                          padding: EdgeInsets.all(24),
                        child: Column(
                          children: [
                            SizedBox(height: 16),
                            CircularAvatar(name: currentUserData!.name, width: 90, fontSize: 80,),
                             SizedBox(height: 20),
                            Container(
                              width: double.infinity,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        currentUserData!.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium!
                                            .copyWith(
                                          color: AppColors.getColor('mono').black,
                                        ),
                                      ),
                                      SizedBox(width: 5,),
                                      Text(
                                        currentUserData!.surname,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium!
                                            .copyWith(
                                          color: AppColors.getColor('mono').black,
                                        ),
                                      ),
                                    ],
                                  ),
                                   SizedBox(height: 20),
                                  Text(
                                    className ?? '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                      color: AppColors.getColor('mono').black,
                                    ),
                                  ),
                                  SizedBox(height: 28),
                                  Wrap(
                                    alignment: WrapAlignment.center,
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    runSpacing: 5,
                                    children: [
                                      Container(
                                        width: 190,
                                        height: 40,
                                        child: ReButton(
                                          activeColor: AppColors.getColor('primary').light, 
                                          defaultColor: AppColors.getColor('mono').lighterGrey, 
                                          disabledColor: AppColors.getColor('mono').lightGrey, 
                                          focusedColor: AppColors.getColor('primary').light, 
                                          hoverColor: AppColors.getColor('primary').lighter, 
                                          textColor: AppColors.getColor('primary').main, 
                                          iconColor: AppColors.getColor('mono').black, 
                                          text: 'Kontaktuje nás',
                                          rightIcon: 'assets/icons/messageIcon.svg',
                                          onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return StatefulBuilder(
                                                    builder: (BuildContext context, StateSetter setState) {
                                                      return AlertDialog(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(20.0),
                                                    ),
                                                    content: Container(
                                                      width: 500,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisSize: MainAxisSize.min, // Ensure the dialog takes up minimum height
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Spacer(),
                                                              MouseRegion(
                                                                cursor: SystemMouseCursors.click,
                                                                child: GestureDetector(
                                                                  child: SvgPicture.asset('assets/icons/xIcon.svg', height: 10,),
                                                                  onTap: () {
                                                                    Navigator.of(context).pop();
                                                                  },
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          SizedBox(height: 30,),
                                                           Text(
                                                              'Moja správa je',
                                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                                                              textAlign: TextAlign.center,
                                                            ),
                                                            SizedBox(height: 10,),
                                                            Container(
                                                              padding: EdgeInsets.only(right: 8),
                                                              height: 30,
                                                              width: 200,
                                                              alignment: Alignment.center,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(8),
                                                                color: _type == 'Nahlásenie problému' ? AppColors.getColor('primary').lighter : AppColors.getColor('mono').lighterGrey,
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  Radio(
                                                                    value: 'Nahlásenie problému',
                                                                      groupValue: _type,
                                                                      onChanged: (newValue) {
                                                                        setState(() {
                                                                          if (newValue != null) _type = newValue;
                                                                        });
                                                                      },
                                                                      activeColor: AppColors.getColor('primary').main,
                                                                    ),
                                                                  Text(
                                                                    'Nahlásenie problému',
                                                                    style: TextStyle(
                                                                      color:  _type == 'Nahlásenie problému' ? AppColors.getColor('primary').main : AppColors.getColor('mono').darkGrey,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(height: 10,),
                                                            Container(
                                                              padding: EdgeInsets.only(right: 8),
                                                              height: 30,
                                                              width: 100,
                                                              alignment: Alignment.center,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(8),
                                                                color: _type == 'Otázka' ? AppColors.getColor('primary').lighter : AppColors.getColor('mono').lighterGrey,
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                    Radio(
                                                                    value: 'Otázka',
                                                                      groupValue: _type,
                                                                      onChanged: (newValue) {
                                                                        setState(() {
                                                                          if (newValue != null) _type = newValue;
                                                                        });
                                                                      },
                                                                      activeColor: AppColors.getColor('primary').main,
                                                                    ),
                                                                  Text(
                                                                    'Otázka',
                                                                    style: TextStyle(
                                                                      color: _type == 'Otázka' ? AppColors.getColor('primary').main : AppColors.getColor('mono').darkGrey,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(height: 10,),
                                                            Text(
                                                              'Správa',
                                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                                                              textAlign: TextAlign.center,
                                                            ),
                                                            SizedBox(height: 10,),
                                                            reTextField(
                                                              'Popíš svoj problém s aplikáciou alebo nám napíš otázku.',
                                                              false,
                                                              _messageController,
                                                              AppColors.getColor('mono').white, // assuming white is the default border color you want
                                                            ),
                                                          SizedBox(height: 30,),
                                                            Center(
                                                              child: ReButton(
                                                              activeColor: AppColors.getColor('mono').white, 
                                                              defaultColor: AppColors.getColor('green').main, 
                                                              disabledColor: AppColors.getColor('mono').lightGrey, 
                                                              focusedColor: AppColors.getColor('green').light, 
                                                              hoverColor: AppColors.getColor('green').light, 
                                                              textColor: Theme.of(context).colorScheme.onPrimary, 
                                                              iconColor: AppColors.getColor('mono').black, 
                                                              text: 'ODOSLAŤ',
                                                              onTap: () {
                                                                if(_messageController.text != '') {
                                                                  sendMessage(_messageController.text, _type);
                                                                  Navigator.of(context).pop();
                                                                  setState() {
                                                                    _messageController.text != '';
                                                                  }
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                          
                                                          SizedBox(height: 30,),
                                                        ],
                                                      ),
                                                    )
                                                  );
                                                    }
                                                  );
                                                },
                                              );
                                          }
                                        )
                                      ),
                                      
                                      SizedBox(width: 5,),
                                      Container(
                                    width: 160,
                                    height: 40,
                                    child: ReButton(
                                      activeColor: AppColors.getColor('red').light, 
                                      defaultColor: AppColors.getColor('red').main, 
                                      disabledColor: AppColors.getColor('mono').lightGrey, 
                                      focusedColor: AppColors.getColor('red').light, 
                                      hoverColor: AppColors.getColor('red').lighter, 
                                      textColor: AppColors.getColor('mono').white, 
                                      iconColor: AppColors.getColor('mono').white, 
                                      text: 'Odhlásiť sa',
                                      rightIcon: 'assets/icons/logoutIcon.svg',
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20.0),
                                              ),
                                              content: Container(
                                                width: 328,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisSize: MainAxisSize.min, // Ensure the dialog takes up minimum height
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Spacer(),
                                                        MouseRegion(
                                                          cursor: SystemMouseCursors.click,
                                                          child: GestureDetector(
                                                            child: SvgPicture.asset('assets/icons/xIcon.svg', height: 10,),
                                                            onTap: () {
                                                              Navigator.of(context).pop();
                                                            },
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Align(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        'Odhlásiť sa',
                                                        textAlign: TextAlign.center,
                                                        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                                              color: AppColors.getColor('mono').black,
                                                            ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 30,),
                                                    Align(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        'Po odhlásení sa z aplikácie budeš musieť znovu zadať svoje používeteľské meno a heslo.',
                                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                    SizedBox(height: 30,),
                                                     ReButton(
                                                      activeColor: AppColors.getColor('mono').white, 
                                                      defaultColor: AppColors.getColor('red').main, 
                                                      disabledColor: AppColors.getColor('mono').lightGrey, 
                                                      focusedColor: AppColors.getColor('red').light, 
                                                      hoverColor: AppColors.getColor('red').light, 
                                                      textColor: Theme.of(context).colorScheme.onPrimary, 
                                                      iconColor: AppColors.getColor('mono').black, 
                                                      text: 'ODHLÁSIŤ SA',
                                                      onTap: () {
                                                        widget.logOut();
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                    SizedBox(height: 30,),
                                                  ],
                                                ),
                                              )
                                            );
                                          },
                                        );
                                      }
                                    ),
                                  )
                                ],
                              ),
                                    ],
                                  ),
                            ),
                            SizedBox(height: 24),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Moja aktivita',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium!
                                          .copyWith(
                                        color: AppColors.getColor('mono').black,
                                      ),
                                    ),
                                    SizedBox(height:8,),
                                    Container(
                                      width: 376,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: AppColors.getColor('mono').lightGrey, width: 2.5),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(12),
                                            child: Text(
                                              'Celkovo',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall!
                                                  .copyWith(
                                                color: AppColors.getColor('mono').black,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(12),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Skóre:',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(
                                                    color: AppColors.getColor('mono').darkGrey,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      '${currentUserData!.points}/${capitolOne + capitolTwo + capitolThree + capitolFour + capitolFive + capitolSix + capitolSeven}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge!
                                                          .copyWith(
                                                        color: AppColors.getColor('yellow').light,
                                                      ),
                                                    ),
                                                    SizedBox(width: 5,),
                                                    SvgPicture.asset('assets/icons/starYellowIcon.svg'),
                                                    SizedBox(width: 5,),
                                                    Text(
                                                        '= ${percentage}%',
                                                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                                          color: AppColors.getColor('mono').darkGrey,
                                                        ),
                                                      ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(12),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Diskusné fórum:',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(
                                                    color: AppColors.getColor('mono').darkGrey,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(currentUserData!.discussionPoints.toString(),
                                                      style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge!
                                                      .copyWith(
                                                        color: AppColors.getColor('yellow').light,
                                                      )
                                                    ),
                                                    SizedBox(width: 5,),
                                                    SvgPicture.asset('assets/icons/starYellowIcon.svg'),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          Divider(color: AppColors.getColor('mono').lightGrey, thickness: 2.5),
                                          Container(
                                            padding: EdgeInsets.all(12),
                                            child: Text(
                                              'Tento týždeň',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall!
                                                  .copyWith(
                                                color: AppColors.getColor('mono').black,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(12),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Týždenná výzva:',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(
                                                    color: AppColors.getColor('mono').darkGrey,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      '${currentUserData!.capitols[0].tests[0].points}/${weeklyCapitol}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge!
                                                          .copyWith(
                                                        color: AppColors.getColor('yellow').light,
                                                      ),
                                                    ),
                                                    SizedBox(width: 5,),
                                                    SvgPicture.asset('assets/icons/starYellowIcon.svg'),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(12),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Diskusné fórum:',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(
                                                    color: AppColors.getColor('mono').darkGrey,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(currentUserData!.weeklyDiscussionPoints.toString(),
                                                      style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge!
                                                      .copyWith(
                                                        color: AppColors.getColor('yellow').light,
                                                      )
                                                    ),
                                                    SizedBox(width: 5,),
                                                    SvgPicture.asset('assets/icons/starYellowIcon.svg'),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          if(!hide || !isMobile)Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Divider(color: AppColors.getColor('mono').lightGrey, thickness: 2.5),
                                               Container(
                                                padding: EdgeInsets.all(12),
                                                child: Text(
                                                  'Skóre za kapitoly:',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineSmall!
                                                      .copyWith(
                                                    color: AppColors.getColor('mono').black,
                                                  ),
                                                ),
                                              ),
                                            Container(
                                              padding: EdgeInsets.all(12),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Kritické myslenie:',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .copyWith(
                                                      color: AppColors.getColor('mono').darkGrey,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '${calculateTotalPointsForCapitol(0)}/${capitolOne}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleLarge!
                                                            .copyWith(
                                                          color: AppColors.getColor('yellow').light,
                                                        ),
                                                      ),
                                                      SizedBox(width: 5,),
                                                      SvgPicture.asset('assets/icons/starYellowIcon.svg'),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(12),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Argumentácia:',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .copyWith(
                                                      color: AppColors.getColor('mono').darkGrey,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text('${calculateTotalPointsForCapitol(1)}/${capitolTwo}',
                                                        style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge!
                                                        .copyWith(
                                                          color: AppColors.getColor('yellow').light,
                                                        )
                                                      ),
                                                      SizedBox(width: 5,),
                                                      SvgPicture.asset('assets/icons/starYellowIcon.svg')
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(12),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Manipulácia',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .copyWith(
                                                      color: AppColors.getColor('mono').darkGrey,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '${calculateTotalPointsForCapitol(2)}/${capitolThree}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleLarge!
                                                            .copyWith(
                                                          color: AppColors.getColor('yellow').light,
                                                        ),
                                                      ),
                                                      SizedBox(width: 5,),
                                                      SvgPicture.asset('assets/icons/starYellowIcon.svg'),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(12),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Práca s dátami:',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .copyWith(
                                                      color: AppColors.getColor('mono').darkGrey,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '${calculateTotalPointsForCapitol(3)}/${capitolFour}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleLarge!
                                                            .copyWith(
                                                          color: AppColors.getColor('yellow').light,
                                                        ),
                                                      ),
                                                      SizedBox(width: 5,),
                                                      SvgPicture.asset('assets/icons/starYellowIcon.svg'),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(12),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Dôveryhodnosť Médií:',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .copyWith(
                                                      color: AppColors.getColor('mono').darkGrey,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '${calculateTotalPointsForCapitol(4)}/${capitolFive}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleLarge!
                                                            .copyWith(
                                                          color: AppColors.getColor('yellow').light,
                                                        ),
                                                      ),
                                                      SizedBox(width: 5,),
                                                      SvgPicture.asset('assets/icons/starYellowIcon.svg'),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(12),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Mediálna Gramotnosť:',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .copyWith(
                                                      color: AppColors.getColor('mono').darkGrey,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '${calculateTotalPointsForCapitol(5)}/${capitolSix}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleLarge!
                                                            .copyWith(
                                                          color: AppColors.getColor('yellow').light,
                                                        ),
                                                      ),
                                                      SizedBox(width: 5,),
                                                      SvgPicture.asset('assets/icons/starYellowIcon.svg'),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(12),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Sociálne Siete:',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .copyWith(
                                                      color: AppColors.getColor('mono').darkGrey,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '${calculateTotalPointsForCapitol(6)}/${capitolSeven}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleLarge!
                                                            .copyWith(
                                                          color: AppColors.getColor('yellow').light,
                                                        ),
                                                      ),
                                                      SizedBox(width: 5,),
                                                      SvgPicture.asset('assets/icons/starYellowIcon.svg'),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            ],
                                          ),
                                          if(isMobile)Center(
                                            child: Container(
                                            margin: EdgeInsets.all(12),
                                            width: 181,
                                            height: 40,
                                            child: ReButton(
                                              activeColor: AppColors.getColor('primary').light, 
                                              defaultColor: AppColors.getColor('mono').lighterGrey, 
                                              disabledColor: AppColors.getColor('mono').lightGrey, 
                                              focusedColor: AppColors.getColor('primary').light, 
                                              hoverColor: AppColors.getColor('primary').lighter, 
                                              textColor: AppColors.getColor('primary').main, 
                                              iconColor: AppColors.getColor('mono').black, 
                                              text: hide ? 'Zobraziť viac' : 'Zobraziť menej',
                                              rightIcon: hide ? 'assets/icons/downIcon.svg' : 'assets/icons/upIcon.svg',
                                              onTap: () {
                                                  setState(() {
                                                    hide = !hide;
                                                  });
                                              }
                                            ),
                                          ),
                                          ),
                                          
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                            SizedBox(height: 24),
                            students == null 
                          ?  Container( child: CircularProgressIndicator(), width: 376, height: 200, alignment: Alignment.center,) // show loading indicator when data is loading
                          : students!.isEmpty
                              ? Text('No Students') // show message when there are no students
                              : Container(
                                width: 376,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Rebríček',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium!
                                          .copyWith(
                                        color: AppColors.getColor('mono').black,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                     Center(
                                          child:
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: AppColors.getColor('mono').lightGrey, width: 2.5),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      width: double.infinity,
                                      child: Column(
                                        children: [ 
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: List.generate(students!.length, (index) {
                                              if (index > 2 && isMobile) return SizedBox.shrink(); // we only want to display top 3
                                              final bool isFirstItem = index == 0;
                                              final bool isLastItem = index == students!.length - 1;

                                              // Define the desired radii for each corner
                                              final BorderRadius borderRadius = BorderRadius.only(
                                                topLeft: isFirstItem ? Radius.circular(18.0) : Radius.zero,
                                                topRight: isFirstItem ? Radius.circular(18.0) : Radius.zero,
                                                bottomLeft: isLastItem ? Radius.circular(18.0) : Radius.zero,
                                                bottomRight: isLastItem ? Radius.circular(18.0) : Radius.zero,
                                              );
                                              return Column(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: studentIndex == index ? AppColors.getColor('primary').lighter : null,
                                                      borderRadius: borderRadius
                                                    ),
                                                    width: double.infinity, // Set the width to expand to the available space
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(16),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              if(index > 2)SizedBox(width: 5,),
                                                              index > 2 ? Text(
                                                              '${index + 1}',
                                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.onBackground),
                                                            ) : Image.asset(
                                                                placeIcons[index], // Use the corresponding SVG asset
                                                                width: 24,
                                                                height: 24,
                                                              ),
                                                              SizedBox(width: 20,),
                                                              Text(
                                                                '${students![index].name}',
                                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.onBackground),
                                                              ),
                                                              SizedBox(width: 5,),
                                                              Text(
                                                                '${students![index].surname}',
                                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.onBackground),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                '${students![index].points}',
                                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.getColor('yellow').light),
                                                              ),
                                                              SizedBox(width: 5,),
                                                              SvgPicture.asset('assets/icons/starYellowIcon.svg'),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }),
                                          ),
                                          if(isMobile)Center(
                                            child: Container(
                                              margin: EdgeInsets.all(12),
                                              width: 200,
                                              height: 40,
                                              child: ReButton(
                                                activeColor: AppColors.getColor('primary').light, 
                                                defaultColor: AppColors.getColor('mono').lighterGrey, 
                                                disabledColor: AppColors.getColor('mono').lightGrey, 
                                                focusedColor: AppColors.getColor('primary').light, 
                                                hoverColor: AppColors.getColor('primary').lighter, 
                                                textColor: AppColors.getColor('primary').main, 
                                                iconColor: AppColors.getColor('mono').black, 
                                                text: 'Zobraziť rebríček',
                                                rightIcon: 'assets/icons/arrowRightIcon.svg',
                                                onTap: () {
                                                  _onNavigationItemSelected(1);
                                                }
                                              ),
                                            ),
                                          ),
                                        ]
                                      )
                                    ),
                                        )
                                  ],
                                ),
                              )
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                      )
                      ,if (students != null && isMobile) SingleChildScrollView(
                        child:Container(
                          padding: EdgeInsets.all(20),
                          width: 392,
                          alignment: Alignment.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 900,
                                alignment: Alignment.topLeft,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: AppColors.getColor('mono').darkGrey,
                                  ),
                                  onPressed: () => _onNavigationItemSelected(0),
                                ),
                              ),
                              Text(
                                'Rebríček',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                  color: AppColors.getColor('mono').black,
                                ),
                              ),
                              SizedBox(height: 20,),
                              Container(
                                  width: 900, // Adjust the width as needed
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.getColor('mono').lightGrey, width: 2.5),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: List.generate(students!.length, (index) {
                                      final bool isFirstItem = index == 0;
                                      final bool isLastItem = index == students!.length - 1;

                                      // Define the desired radii for each corner
                                      final BorderRadius borderRadius = BorderRadius.only(
                                        topLeft: isFirstItem ? Radius.circular(18.0) : Radius.zero,
                                        topRight: isFirstItem ? Radius.circular(18.0) : Radius.zero,
                                        bottomLeft: isLastItem ? Radius.circular(18.0) : Radius.zero,
                                        bottomRight: isLastItem ? Radius.circular(18.0) : Radius.zero,
                                      );
                                      return Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: studentIndex == index ? AppColors.getColor('primary').lighter : null,
                                              borderRadius: borderRadius
                                            ),
                                            width: 900, // Set the width to a fixed value
                                            child: Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    children: [
                                                      if(index > 2)SizedBox(width: 5,),
                                                      index > 2 ? Text(
                                                        '${index + 1}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headlineSmall!
                                                            .copyWith(
                                                          color: studentIndex == index ? AppColors.getColor('primary').main : AppColors.getColor('mono').black,
                                                        ),
                                                      ) : Image.asset(
                                                          placeIcons[index], // Use the corresponding SVG asset
                                                          width: 24,
                                                          height: 24,
                                                        ),
                                                      SizedBox(width: 20,),
                                                      Text(
                                                        '${students![index].name}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headlineSmall!
                                                            .copyWith(
                                                          color: studentIndex == index ? AppColors.getColor('primary').main : AppColors.getColor('mono').black,
                                                        ),
                                                      ),
                                                      SizedBox(width: 5,),
                                                      Text(
                                                        '${students![index].surname}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headlineSmall!
                                                            .copyWith(
                                                          color: studentIndex == index ? AppColors.getColor('primary').main : AppColors.getColor('mono').black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '${students![index].points}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headlineSmall!
                                                            .copyWith(
                                                          color: AppColors.getColor('yellow').light,
                                                        ),
                                                      ),
                                                      SizedBox(width: 5,),
                                                      SvgPicture.asset('assets/icons/starYellowIcon.svg'),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                  ),
                              ),
                            ],
                          ),
                        ) 
                      )
        ]
      )
    ) : Center(child: CircularProgressIndicator());
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onNavigationItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }
}
