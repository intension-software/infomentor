import 'package:flutter/material.dart';
import 'package:infomentor/Colors.dart';
import 'package:infomentor/backend/fetchCapitols.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:infomentor/backend/fetchUser.dart'; // Import the UserData class and fetchUser function
import 'package:infomentor/screens/Login.dart';
import 'package:infomentor/backend/fetchClass.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:async/async.dart';


class Profile extends StatefulWidget {
  final void Function() logOut;

  const Profile({
    Key? key,
    required this.logOut,
  }) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final PageController _pageController = PageController();
 UserData? currentUserData;
  int capitolOne = 0;
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

  @override
  void initState() {
    super.initState();
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

      if (mounted && !_isDisposed) {
        setState(() {
          capitolOne = one.capitolsData!.points;
          percentage = (currentUserData!.points / capitolOne).round();
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
                            SvgPicture.asset('assets/profilePicture.svg', width: 90),
                            SizedBox(height: 16),
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
                                  SizedBox(height: 8),
                                  Text(
                                    className ?? '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .copyWith(
                                      color: AppColors.getColor('mono').darkGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 24),
                            Wrap(
                              spacing: 20,
                              runSpacing: 20,
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
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(10),
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
                                                      '${currentUserData!.points}/${capitolOne}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge!
                                                          .copyWith(
                                                        color: AppColors.getColor('yellow').light,
                                                      ),
                                                    ),
                                                    SvgPicture.asset('assets/icons/starYellowIcon.svg'),
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
                                                    Text('0',
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
                                          Divider(color: AppColors.getColor('mono').lightGrey),
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
                                                  'Týždenná výzva',
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
                                                      '${currentUserData!.points}/${capitolOne}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge!
                                                          .copyWith(
                                                        color: AppColors.getColor('yellow').light,
                                                      ),
                                                    ),
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
                                                    Text('0',
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
                                          Divider(color: Colors.grey),
                                          Container(
                                            padding: EdgeInsets.all(12),
                                            child: Text(
                                              'Skóre za kapitoly',
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
                                                  'Kritické myslenie',
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
                                                      '${currentUserData!.points}/${capitolOne}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge!
                                                          .copyWith(
                                                        color: AppColors.getColor('yellow').light,
                                                      ),
                                                    ),
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
                                                  'Argumentácia',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(
                                                    color: AppColors.getColor('mono').darkGrey,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text('0',
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
                                    GestureDetector(
                                      onTap: () {
                                        _onNavigationItemSelected(1);
                                      },
                                      child: MouseRegion(
                                        cursor: MediaQuery.of(context).size.width < 1000 ? SystemMouseCursors.click : SystemMouseCursors.basic,
                                        child: Center(
                                          child:
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: List.generate(students!.length, (index) {
                                          if (index > 2 && MediaQuery.of(context).size.width < 1000) return SizedBox.shrink(); // we only want to display top 3
                                          return Column(
                                            children: [
                                              Container(
                                                height: 48,
                                                decoration: BoxDecoration(
                                                  color: studentIndex == index ? AppColors.getColor('primary').lighter : null,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                width: double.infinity, // Set the width to expand to the available space
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      
                                                      Row(
                                                        children: [
                                                          Text(
                                                        '${index + 1}.',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(width: 5,),
                                                          Text(
                                                        '${students![index].name}',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(width: 5,),
                                                            Text(
                                                          '${students![index].surname}',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            '${students![index].points}',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color: Color(0xfff9BB00),
                                                            ),
                                                          ),
                                                          Icon(
                                                            Icons.star,
                                                            color: Color(0xfff9BB00),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              if (index < students!.length - 1) Divider(color: Colors.grey), // avoid divider for last element
                                            ],
                                          );
                                        }),
                                      ),
                                    ),
                                        )
                                      )
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
                      ,if (students != null)Container(
                        width: 392,
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 50,),
                            Container(
                              width: 900,
                              alignment: Alignment.topLeft,
                              child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: AppColors.getColor('mono').darkGrey,
                                  ),
                                  onPressed: () => 
                                    _onNavigationItemSelected(0),
                                ),
                            ),
                            Text(
                              'Rebríček',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 30,),
                            SingleChildScrollView(
                            child:Container(
                            width: 900,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(students!.length, (index) {
                              return Column(
                                children: [
                                  Container(
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: studentIndex == index ? AppColors.getColor('primary').lighter : null,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    width: double.infinity, // Set the width to expand to the available space
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          
                                          Row(
                                            children: [
                                              Text(
                                            '${index + 1}.',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(width: 5,),
                                              Text(
                                            '${students![index].name}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(width: 5,),
                                                Text(
                                              '${students![index].surname}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                '${students![index].points}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xfff9BB00),
                                                ),
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: Color(0xfff9BB00),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                if (index < students!.length - 1) Divider(color: Colors.grey), // avoid divider for last element
                              ],
                            );
                          }),
                        ),
                      ),
                  )
                          ]
                        )
                  )
              ]
            )
          )
          : Center(
              child: CircularProgressIndicator(),
            );
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
