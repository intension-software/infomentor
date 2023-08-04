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
  const Profile({Key? key}) : super(key: key);

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

  @override
  void initState() {
    super.initState();
    _isDisposed = false; // Resetting _isDisposed state
    fetchUserData();
    fetchCapitolsData();
    
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
      print('fetchStudents started');
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
    return Scaffold(
      body: currentUserData != null
          ? Column(
                  children: <Widget>[
                    Flexible(
              child:PageView(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    children: [ 
                      SingleChildScrollView(
                        child:Center(
                        child: Container(
                          padding: EdgeInsets.all(24),
                          width: 900, 
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset('assets/profilePicture.svg', width: 150),
                            SizedBox(height: 16),
                            Center(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        currentUserData!.name,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 5,),
                                      Text(
                                        currentUserData!.surname,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    className ?? '',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 24),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Moje skóre',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 48,
                                        width: double.infinity, // Set the width to expand to the available space
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Celkovo',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text('${currentUserData!.points} / ${capitolOne}'),
                                                  SizedBox(width: 8),
                                                  Container(
                                                    width: 150,
                                                    height: 15,
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(10),
                                                      child: LinearProgressIndicator(
                                                        value: capitolOne != 0 ? currentUserData!.points / capitolOne : 0,
                                                        backgroundColor: Colors.grey[300],
                                                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.green.main),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Divider(color: Colors.grey),
                                      Container(
                                        height: 48,
                                        width: double.infinity, // Set the width to expand to the available space
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Tento týždeň:',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    '${currentUserData!.points}',
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
                                      Divider(color: Colors.grey),
                                      Container(
                                        height: 48,
                                        width: double.infinity, // Set the width to expand to the available space
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Celý čas:',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    '${currentUserData!.points}',
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
                                      Divider(color: Colors.grey),
                                      Container(
                                        height: 48,
                                        width: double.infinity, // Set the width to expand to the available space
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Diskusné fórum:',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                '${currentUserData!.active ? 'Aktívny prispievateľ' : 'Neaktívny prispievateľ'}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: currentUserData!.active ? Colors.green : Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 24),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              Text(
                                'Ukončené kapitoly',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  children: List.generate(badges.length, (index) {
                                    return SvgPicture.asset(
                                      badges[index],
                                      width: 100,
                                      height: 100,
                                    );
                                  }),
                                ),
                              ),
                                Wrap(
                                  alignment: WrapAlignment.start,
                                  spacing: 10.0,
                                  runSpacing: 10.0,
                                  children: [
                                  
                                  ],
                                ),
                            ]
                            ),
                            SizedBox(height: 24),
                            students == null 
                          ? CircularProgressIndicator() // show loading indicator when data is loading
                          : students!.isEmpty
                              ? Text('No Students') // show message when there are no students
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Rebríček',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    GestureDetector(
                                      onTap: () {
                                        _onNavigationItemSelected(1);
                                      },
                                      child: MouseRegion(
                                        cursor: SystemMouseCursors.click,
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
                                          if (index > 2) return SizedBox.shrink(); // we only want to display top 3
                                          return Column(
                                            children: [
                                              Container(
                                                height: 48,
                                                decoration: BoxDecoration(
                                                  color: studentIndex == index ? AppColors.primary.lighter : null,
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
                            ElevatedButton(
                              onPressed: () {
                                FirebaseAuth.instance.signOut();
                                setState(() {
                                  fetchUserData();
                                });
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => Login()),
                                );
                              },
                              child: Text('SignOut'),
                            ),
                          ],
                        ),
                      ),
                    )
                      )
                      ,if (students != null)Center(
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
                                    color: AppColors.mono.darkGrey,
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
                                      color: studentIndex == index ? AppColors.primary.lighter : null,
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
                  ]
          )
          : Center(
              child: CircularProgressIndicator(),
            ),
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
