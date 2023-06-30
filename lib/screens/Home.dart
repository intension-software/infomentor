import 'package:flutter/material.dart';
import 'package:infomentor/widgets/ReWidgets.dart';
import 'package:infomentor/screens/Learning.dart';
import 'package:infomentor/screens/Challenges.dart';
import 'package:infomentor/screens/Discussions.dart';
import 'package:infomentor/backend/fetchUser.dart'; // Import the UserData class and fetchUser function
import 'package:infomentor/backend/fetchCapitols.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:infomentor/Colors.dart';
import 'package:infomentor/widgets/MobileAppBar.dart';
import 'package:infomentor/widgets/DesktopAppBar.dart';
import 'package:infomentor/widgets/MobileBottomNavigation.dart';


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
  int capitolsId = 0;
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
    
    return Scaffold(
      appBar: MediaQuery.of(context).size.width < 1000 ? MobileAppBar(capitol: capitol, currentUserData: currentUserData, capitolLength: capitolLength) : DesktopAppBar(capitol: capitol, currentUserData: currentUserData, capitolLength: capitolLength, onNavigationItemSelected: _onNavigationItemSelected,),
      bottomNavigationBar:  MediaQuery.of(context).size.width < 1000 ? MobileBottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ) : null,
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
          Container(
            decoration: MediaQuery.of(context).size.width < 1000 ?BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'), // Replace with your own image path
                fit: BoxFit.cover,
              ),
            ) : null,
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 700,
                      height: 250,
                      decoration: BoxDecoration(
                        color: MediaQuery.of(context).size.width < 1000 ?  null : Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      margin: EdgeInsets.all(16),
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: !weeklyBool ? Column(
                          mainAxisAlignment: MainAxisAlignment.center, // Align items vertically to center
                          crossAxisAlignment: CrossAxisAlignment.center, // Align items horizontally to center
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center, // Align items horizontally to center
                              children: [
                                Icon(
                                  Icons.star_border_outlined,
                                  color: AppColors.primary.lighter,
                                ),
                                Text(
                                  "Týždenná výzva",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(
                                    color: AppColors.primary.lighter,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16), // Add some spacing between the items
                            Text(
                              weeklyTitle ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            SizedBox(height: 16), // Add some spacing between the items
                            reButton(
                              context,
                              "ZAČAŤ",
                              0xff3cad9a,
                              0xffffffff,
                              0xffffffff,
                              () {},
                            ),
                          ],
                        ) : Column(
                          mainAxisAlignment: MainAxisAlignment.center, // Align items vertically to center
                          crossAxisAlignment: CrossAxisAlignment.center, // Align items horizontally to center
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center, // Align items horizontally to center
                              children: [
                                Icon(
                                  Icons.task_alt_rounded,
                                  color: AppColors.green.main,
                                ),
                                Text(
                                  "Týždenná výzva dokončená",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(
                                    color: AppColors.primary.lighter,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16), // Add some spacing between the items
                            Text(
                              "budúci týždeň ťa čaká",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(
                                color: AppColors.primary.lighter,
                              ),
                            ),
                            SizedBox(height: 16), // Add some spacing between the items
                            Text(
                              futureWeeklyTitle ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),


                    !weeklyBool ? Container(
                      height: 350,
                      width: 700,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.mono.lightGrey,
                          width: 2,
                        ),
                      ),
                      margin: EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center, // Align items vertically to center
                          crossAxisAlignment: CrossAxisAlignment.center, // Align items horizontally to center
                          children: [
                              Image.asset(
                                'assets/badges/badgeArg.png',
                              ),
                              Text(
                                capitolTitle ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                  color: AppColors.mono.grey
                                ),
                              ),
                              Text(
                                'Splň týždennú výzvu pre',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                  color: AppColors.mono.black,
                                ),
                              ),
                              Text(
                                'zobrazenie skóre',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                  color: AppColors.mono.black,
                                ),
                              ),
                            ],
                          )
                    ) :  Container(
                          height: 350,
                          width: 700,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.mono.lightGrey,
                              width: 2,
                            ),
                          ),
                          margin: EdgeInsets.all(16),
                          child: Column(children: [
                            Text(
                                  capitolTitle ?? '',
                                  style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                      ,
                                ),
                              Row(
                            children: [
                              
                              Image.asset(
                                'assets/badges/badgeArg.png',
                                width: 200,
                                fit: BoxFit.contain,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child:  Container(
                                  height: 20,
                                  child: LinearProgressIndicator(
                                    value: (weeklyCapitolLength != 0) ? completedCount / weeklyCapitolLength : 0.0,
                                    backgroundColor: AppColors.blue.lighter,
                                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.green.main),
                                  ),
                              ),
                              
                              ),
                              Text(
                                  "${completedCount} / ${ weeklyCapitolLength} Hotových",
                                  style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                      ,
                                ),
                            ],
                          ),
                        ],
                      )
                    ),
                    ListTile(
                            title: Text('Argumentácia'),
                            leading: Radio(
                              value: 0,
                              groupValue: capitolsId,
                              onChanged: (value) {
                                setState(() {
                                  capitolsId = value as int;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: Text('Manipulácia'),
                            leading: Radio(
                              value: 1,
                              groupValue: capitolsId,
                              onChanged: (value) {
                                setState(() {
                                  capitolsId = value as int;
                                });
                              },
                            ),
                          ),
                     
                  ],
                ),
              ),
            ),
          ),
          Challenges(capitolsId: capitolsId.toString(), fetch: fetchUserData()),
          Discussions(),
          Learning(),
        ],
      ),
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
