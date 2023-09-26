import 'dart:io';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:infomentor/Colors.dart';
import 'package:infomentor/screens/Learning.dart';
import 'package:infomentor/screens/Challenges.dart';
import 'package:infomentor/screens/Results.dart';
import 'package:infomentor/screens/Admin.dart';
import 'package:infomentor/screens/Notifications.dart';
import 'package:infomentor/screens/Profile.dart';
import 'package:infomentor/screens/DesktopStudentFeed.dart';
import 'package:infomentor/screens/MobileStudentFeed.dart';
import 'package:infomentor/screens/TeacherFeed.dart';
import 'package:infomentor/screens/Discussions.dart';
import 'package:infomentor/screens/DesktopAdmin.dart';
import 'package:infomentor/screens/MobileAdmin.dart';
import 'package:infomentor/backend/fetchUser.dart'; // Import the UserData class and fetchUser function
import 'package:infomentor/backend/fetchCapitols.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:infomentor/widgets/MobileAppBar.dart';
import 'package:infomentor/widgets/DesktopAppBar.dart';
import 'package:infomentor/widgets/MobileBottomNavigation.dart';
import 'package:infomentor/widgets/TeacherMobileAppBar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class NonSwipeablePageController extends PageController {
  @override
  bool get canScroll => false;
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final NonSwipeablePageController _pageController = NonSwipeablePageController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
  bool _loadingCapitols = true;
  bool _loadingUser = true;
  String? capitolColor;
  bool isMobile = false;
  bool isDesktop = false;

  final userAgent = html.window.navigator.userAgent.toLowerCase();



  @override
  void initState() {
    super.initState();
    final userAgent = html.window.navigator.userAgent.toLowerCase();
    isMobile = userAgent.contains('mobile');
    isDesktop = userAgent.contains('macintosh') ||
        userAgent.contains('windows') ||
        userAgent.contains('linux');
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

  void logOut() {
    FirebaseAuth.instance.signOut();
      setState(() {
        fetchUserData();
      });
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
              countTrueTests(currentUserData!.capitols![1].tests);
          capitolTitle = capitol!.capitolsData!.name;
          _loadingCapitols = false;
          capitolColor = one.capitolsData!.color;
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
          _loadingUser = false;
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
    if (_loadingUser || _loadingCapitols) {
        return Center(child: CircularProgressIndicator()); // Show loading circle when data is being fetched
    }
    return 
      Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        appBar: isMobile
      ? currentUserData!.teacher
          ? PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: TeacherMobileAppBar(
                onItemTapped: _onNavigationItemSelected,
                selectedIndex: _selectedIndex,
                currentUserData: currentUserData,
                onUserDataChanged: _onUserDataChanged,
                logOut: logOut,
              ),
            )
          : PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: MobileAppBar(
                capitol: capitol,
                currentUserData: currentUserData,
                capitolLength: capitolLength,
                logOut: logOut,
                onNavigationItemSelected: _onNavigationItemSelected,
              ),
            )
      : PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: DesktopAppBar(
            capitol: capitol,
            currentUserData: currentUserData,
            capitolLength: capitolLength,
            onNavigationItemSelected: _onNavigationItemSelected,
            onUserDataChanged: _onUserDataChanged,
            selectedIndex: _selectedIndex,
          ),
        ),
      drawer: (currentUserData!.teacher && isMobile) ? Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      child: SvgPicture.asset('assets/icons/xIcon.svg', height: 10,),
                      onTap: () {
                        _scaffoldKey.currentState?.openEndDrawer();
                      },
                    ),
                  ),
                  SizedBox(height: 30,),
                  SvgPicture.asset('assets/logoFilled.svg',)
                ],
              ),
            ),
            SizedBox(height: 30,),
            buildNavItem(0, "assets/icons/homeIcon.svg", "Domov", context),
            buildNavItem(1, "assets/icons/starIcon.svg", "Výzva", context),
            buildNavItem(2, "assets/icons/textBubblesIcon.svg", "Diskusia", context),
            buildNavItem(3, "assets/icons/bookIcon.svg", "Vzdelávanie", context),
            buildNavItem(4, "assets/icons/resultsIcon.svg", "Výsledky", context),
            buildNavItem(6, "assets/icons/adminIcon.svg", "Moja škola", context),
            // Add more ListTile widgets for additional menu items
          ],
        ),
      ) : null,
      bottomNavigationBar:  (isMobile && !currentUserData!.teacher) ? MobileBottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ) : null,
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
          !currentUserData!.teacher ? isMobile ? MobileStudentFeed(
            capitolColor: capitolColor,
            capitolData: currentUserData!.capitols[capitolsId],
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
          ) : DesktopStudentFeed(
            capitolColor: capitolColor,
            capitolData: currentUserData!.capitols[capitolsId],
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
          ) : TeacherFeed(
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
          Challenges(fetch: fetchUserData(), currentUserData: currentUserData),
          Discussions(currentUserData: currentUserData),
          Learning(currentUserData: currentUserData),
          if (currentUserData!.teacher) Results(),
          Notifications(currentUserData: currentUserData, onNavigationItemSelected: _onNavigationItemSelected),
          if(!currentUserData!.teacher) Profile(logOut: () {
            FirebaseAuth.instance.signOut();
              setState(() {
                fetchUserData();
              });
          },),
          if (currentUserData!.teacher) isMobile ? MobileAdmin(currentUserData: currentUserData, logOut: () {
            FirebaseAuth.instance.signOut();
              setState(() {
                fetchUserData();
              });
          },) : DesktopAdmin(currentUserData: currentUserData,logOut: () {
            FirebaseAuth.instance.signOut();
              setState(() {
                fetchUserData();
              });
          }),
        ],
      ),
    );
  }

   void _onNavigationItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 1),
        curve: Curves.ease,
      );
    });
  }
  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 1),
      curve: Curves.ease,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget buildNavItem(int index, String icon, String text, BuildContext context) {
    final bool isSelected = index == _selectedIndex;

    return Container(
      width: 260,
      height: 57,
      margin: EdgeInsets.symmetric(horizontal: 12),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
          _onNavigationItemSelected(index);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(icon, color: isSelected ? AppColors.getColor('primary').main : AppColors.getColor('mono').black),
            SizedBox(width: 8),
            Text(
              text,
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                color: isSelected ? AppColors.getColor('primary').main : AppColors.getColor('mono').black,
              ),
            ),
          ],
        ),
      ),
    );
  }

}


