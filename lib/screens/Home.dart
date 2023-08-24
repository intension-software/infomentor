import 'package:flutter/material.dart';
import 'package:infomentor/screens/Learning.dart';
import 'package:infomentor/screens/Challenges.dart';
import 'package:infomentor/screens/Results.dart';
import 'package:infomentor/screens/Admin.dart';
import 'package:infomentor/screens/Notifications.dart';
import 'package:infomentor/screens/Profile.dart';
import 'package:infomentor/screens/StudentFeed.dart';
import 'package:infomentor/screens/Discussions.dart';
import 'package:infomentor/backend/fetchUser.dart'; // Import the UserData class and fetchUser function
import 'package:infomentor/backend/fetchCapitols.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:infomentor/widgets/MobileAppBar.dart';
import 'package:infomentor/widgets/DesktopAppBar.dart';
import 'package:infomentor/widgets/MobileBottomNavigation.dart';
import 'package:flutter_svg/flutter_svg.dart';



class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;
  UserData? currentUserData;
  int? capitolLength;
  int capitolsId = 1;
  FetchResult? capitol;
  int weeklyChallenge = 0;
  String? weeklyTitle;
  String? futureWeeklyTitle;
  bool weeklyBool = false;
  int weeklyCapitolLength = 0;
  int completedCount = 0;
  String? capitolTitle;



  @override
  void initState() {
    super.initState();
    fetchUserData(); // Fetch the user data when the app starts
    fetchCapitolsData();
  }

   void _onUserDataChanged() {
    fetchUserData();
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


  Future<void> fetchCapitolsData() async {
    try {
      FetchResult one = await fetchCapitols("0");
      FetchResult two = await fetchCapitols("1");
      capitol = await fetchCapitols(capitolsId.toString());


      //FetchResult two = await fetchCapitols("1");


      setState(() {
        if (mounted) {
          capitolLength = one.capitolsData!.points + two.capitolsData!.points;
          weeklyChallenge = capitol!.capitolsData!.weeklyChallenge;
          weeklyTitle = capitol!.capitolsData!.tests[weeklyChallenge].name;
          futureWeeklyTitle =
              capitol!.capitolsData!.tests[weeklyChallenge + 1].name;
          weeklyBool =
              currentUserData!.capitols![capitolsId].tests[weeklyChallenge]
                  .completed;
          weeklyCapitolLength = capitol!.capitolsData!.tests.length;
          completedCount =
              countTrueTests(currentUserData!.capitols![weeklyChallenge].tests);
          capitolTitle = capitol!.capitolsData!.name;
        }
      });
    } catch (e) {
      print('Error fetching question data: $e');
    }
  }

  Future<void> fetchUserData() async {
    try {
      // Retrieve the Firebase Auth user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Fetch the user data using the fetchUser function
        UserData userData = await fetchUser(user.uid);
        setState(() {
          currentUserData = userData;
          
        });
      } else {
        print('User is not logged in.');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  void dispose() {
    _pageController.dispose(); // Cancel the page controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Stack(
      children: [
        MediaQuery.of(context).size.width < 1000 ? Positioned.fill(
          child: SvgPicture.asset(
            'assets/background.svg',
            fit: BoxFit.cover,
          ),
        ) : Container(),
      Scaffold(
        backgroundColor: Colors.transparent,
      appBar: MediaQuery.of(context).size.width < 1000 ? MobileAppBar(capitol: capitol, currentUserData: currentUserData, capitolLength: capitolLength) : DesktopAppBar(capitol: capitol, currentUserData: currentUserData, capitolLength: capitolLength, onNavigationItemSelected: _onNavigationItemSelected, onUserDataChanged: _onUserDataChanged, selectedIndex: _selectedIndex),
      bottomNavigationBar:  MediaQuery.of(context).size.width < 1000 ? MobileBottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ) : null,
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
          StudentFeed(
            onNavigationItemSelected: _onNavigationItemSelected,
            capitol: capitol,
            capitolLength: capitolLength,
            capitolTitle: capitolTitle,
            capitolsId: capitolsId,
            completedCount: completedCount,
            futureWeeklyTitle: futureWeeklyTitle,
            weeklyBool: weeklyBool,
            weeklyCapitolLength: weeklyCapitolLength,
            weeklyChallenge: weeklyChallenge,
            weeklyTitle: weeklyTitle,
          ),
          Challenges(capitolsId: capitolsId.toString(), fetch: fetchUserData(), currentUserData: currentUserData),
          Discussions(currentUserData: currentUserData),
          Learning(currentUserData: currentUserData),
          Notifications(currentUserData: currentUserData,),
          SingleChildScrollView(
                child:Column(
            children: [
              Profile(),
              ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  setState(() {
                    fetchUserData();
                  });
                  },
                  child: Text('SignOut'),
                ),
              ],
            )
          ),
          Results(),
          Admin(currentUserData: currentUserData,),
        ],
      ),
    )
    ]
    );
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
  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

}
