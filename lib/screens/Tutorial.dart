import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infomentor/screens/Login.dart';
import 'package:infomentor/screens/Home.dart';
import 'package:infomentor/widgets/ReWidgets.dart';
import 'package:infomentor/Colors.dart';
import 'dart:html' as html;
import 'package:infomentor/backend/userController.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Tutorial extends StatefulWidget {
  final void Function() check;

  Tutorial({Key? key, required this.check});

  @override
  _TutorialState createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  int _currentStep = 0;
  bool _showNavigationIcons = false;
  bool isMobile = false;
  bool isDesktop = false;
  UserData? currentUserData;
  bool _loading = true;

  final userAgent = html.window.navigator.userAgent.toLowerCase();

   Future<void> fetchUserData() async {
    try {
      // Retrieve the Firebase Auth user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Fetch the user data using the fetchUser function
        UserData userData = await fetchUser(user.uid);
        setState(() {
          currentUserData = userData;
          _loading = false;
        });
      } else {
        print('User is not logged in.');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final userAgent = html.window.navigator.userAgent.toLowerCase();
    isMobile = userAgent.contains('mobile');
    isDesktop = userAgent.contains('macintosh') ||
        userAgent.contains('windows') ||
        userAgent.contains('linux');

    fetchUserData();
  }
  

  @override
  Widget build(BuildContext context) {
    final PageController _pageController = PageController();
    List<Widget> _steps = [
      Column(
      mainAxisAlignment: MediaQuery.of(context).size.width < 1000 ? MainAxisAlignment.start : MainAxisAlignment.center,
      children: [
         SizedBox(height: 20),
            Image.asset('assets/tutorial/tutorialMan.png', width: 250,),
            SizedBox(height: 20),
          Container(
          width: 360,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
                      'Nauč sa myslieť kriticky',

            style: Theme.of(context)
                .textTheme
                .displayLarge!
                .copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
          ),
        ),
        SizedBox(height: 20),
        Container(
           padding: EdgeInsets.symmetric(horizontal: 16),
          width: 350,
          child: Text(
            'S appkou Infomat si študenti a študentky každý týždeň cez krátke testy posilňujú kritické myslenie a v diskusnom fóre sa učia formulovať svoje názory.',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
            ),
        ),
        SizedBox(height: 20),
        Container(
           padding: EdgeInsets.symmetric(horizontal: 16),
          width: 350,
          child: Text(
            'len 16% ',
            style: Theme.of(context)
                .textTheme
                .displayMedium!
                .copyWith(
                  color: AppColors.getColor('yellow').main,
                ),
            ),
        ),
        Container(
           padding: EdgeInsets.symmetric(horizontal: 16),
          width: 350,
          child: Text(
            'mladých ľudí si overuje informácie z médií vždy alebo takmer vždy (RmS).',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
            ),
        ),
      ]
    ),
      Column(
        mainAxisAlignment: MediaQuery.of(context).size.width < 1000 ? MainAxisAlignment.start : MainAxisAlignment.center,
        children: [
          Container(
            width: 360,
            padding: EdgeInsets.all(16),
            child: Text(
              'Ako budujeme kritické myslenie?',
              style: Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                width: 350,
                child:Image.asset('assets/tutorial/tutorialTest.png', width: 250,),
               ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                width: 350,
                child: Text(
                  textAlign: TextAlign.start,
                  'Na začiatku každého týždňa dostaneš krátky test s priemerne 5 otázkami zameraných na odhalenie dezinformácií - napr. nájdi v článku argumentačnú chybu, nepravdivo odprezentované dáta alebo odhaľ falošný zdroj. Každý týždeň je možné vyplniť iba jeden test do deadline, následne test evidujeme ako nesplnený.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        
                      ),
                  ),
                  
              ),
            ]
            )
          )
        ]
      ),
      Column(
        mainAxisAlignment: MediaQuery.of(context).size.width < 1000 ? MainAxisAlignment.start : MainAxisAlignment.center,
        children: [
          Container(
            width: 370,
            padding: EdgeInsets.all(16),
            child: Text(
              'Čo nájdeš v aplikácii?',
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                width: 350,
                child: Text(
                textAlign: TextAlign.start,
                'Domov',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                width: 350,
                child: Text(
                  textAlign: TextAlign.start,
                  'Tu nájdeš aktuálne prebiehajúcu týždennú výzvu a tvoj doterajší progres a výsledky.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                  ),
              ),
              SizedBox(height: 20),
               Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                width: 350,
                child:Image.asset('assets/tutorial/tutorialFeed.png', width: 250,),
               )
            ]
            )
          )
        ]
      ),
       Column(
        mainAxisAlignment: MediaQuery.of(context).size.width < 1000 ? MainAxisAlignment.start : MainAxisAlignment.center,
        children: [
          Container(
            width: 370,
            padding: EdgeInsets.all(16),
            child: Text(
              'Čo nájdeš v aplikácii?',
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                width: 350,
                child: Text(
                textAlign: TextAlign.start,
                'Výzva',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                width: 350,
                child: Text(
                  textAlign: TextAlign.start,
                  'Tu nájdeš plán všetkých testov, ktoré spájame podľa obsahu do väčších tematických celkov - kapitol. ',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                  ),
              ),
              SizedBox(height: 20),
               Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                width: 350,
                child:Image.asset('assets/tutorial/tutorialChallenges.png', width: 250,),
               )
            ]
            )
          )
        ]
      ),
      Column(
        mainAxisAlignment: MediaQuery.of(context).size.width < 1000 ? MainAxisAlignment.start : MainAxisAlignment.center,
        children: [
          Container(
            width: 370,
            padding: EdgeInsets.all(16),
            child: Text(
              'Čo nájdeš v aplikácii?',
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                width: 350,
                child: Text(
                textAlign: TextAlign.start,
                'Diskusia',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                width: 350,
                child: Text(
                  textAlign: TextAlign.start,
                  'Do diskusného fóra môže iba učiteľ/ka pridať tézu (napr. o aktuálnom spoločenskom dianí) a ty na ňu môžeš reagovať v komentároch. Kvalitné komentáre môžete učiteľ/ka oceniť hviezdičkou za aktivitu.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                  ),
              ),
              SizedBox(height: 20),
               Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                width: 350,
                child:Image.asset('assets/tutorial/tutorialAward.png', width: 250,),
               )
            ]
            )
          )
        ]
      ),
      Column(
        mainAxisAlignment: MediaQuery.of(context).size.width < 1000 ? MainAxisAlignment.start : MainAxisAlignment.center,
        children: [
          Container(
            width: 370,
            padding: EdgeInsets.all(16),
            child: Text(
              'Čo nájdeš v aplikácii?',
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                width: 350,
                child: Text(
                textAlign: TextAlign.start,
                'Vzdelávanie',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                width: 350,
                child: Text(
                  textAlign: TextAlign.start,
                  'Tu nájdeš vzdelávacie tipy na podujatia, videá, články a programy.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                  ),
              ),
              SizedBox(height: 20),
               Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                width: 350,
                child:Image.asset('assets/tutorial/tutorialLearning.png', width: 250,),
               )
            ]
            )
          )
        ]
      ),
      Column(
        mainAxisAlignment: MediaQuery.of(context).size.width < 1000 ? MainAxisAlignment.start : MainAxisAlignment.center,
        children: [
          Container(
            width: 370,
            padding: EdgeInsets.all(16),
            child: Text(
              'Čo nájdeš v aplikácii?',
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                width: 350,
                child: Text(
                textAlign: TextAlign.start,
                'Profil',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                width: 350,
                child: Text(
                  textAlign: TextAlign.start,
                  'Tu nájdeš tvoje zhrnuté výsledky. Jednu hviezdu dostaneš za každú správnu odpoveď v teste a za každý ocenený komentár. Tvoju aktivitu v appke môže učiteľ/ka započítať do tvojho hodnotenia na vysvedčení.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                  ),
              ),
              SizedBox(height: 20),
               Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                width: 350,
                child:Image.asset('assets/tutorial/tutorialProfile.png', width: 250,),
               )
            ]
            )
          )
        ]
      ),
  ];

if (_loading) {
    return Container(color: Theme.of(context).primaryColor,); // Show loading circle when data is being fetched
}
return Scaffold(
  backgroundColor: Theme.of(context).primaryColor,
  body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height <= 840
          ? 840
          : MediaQuery.of(context).size.height >= 900
              ? 900
              : MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MediaQuery.of(context).size.height > 800 ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: <Widget>[
                isMobile ? SizedBox(height: 20,) : SizedBox(height: 50) ,
                MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      if ( isDesktop) {
                        _showNavigationIcons = true;
                      }
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      _showNavigationIcons = false;
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        alignment: Alignment.bottomCenter,
                        height: 566,
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (int page) {
                            setState(() {
                              _currentStep = page;
                            });
                          },
                          children: _steps,
                        ),
                      ),
                      if (_showNavigationIcons)
                        if(_currentStep != 0)Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: SvgPicture.asset(
                              'assets/icons/leftIcon.svg',
                              width: 24,
                              height: 24,
                              color: AppColors.getColor('mono').lighterGrey,
                            ),
                            onPressed: () {
                              setState(() {
                                if (_currentStep > 0) {
                                  _pageController.previousPage(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              });
                            },
                          ),
                        ),
                      if (_showNavigationIcons)
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: SvgPicture.asset(
                              'assets/icons/rightIcon.svg',
                              width: 24,
                              height: 24,
                              color: AppColors.getColor('mono').lighterGrey,
                            ),
                            onPressed: () {
                              setState(() {
                                if (_currentStep < _steps.length - 1) {
                                  _pageController.nextPage(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                  );
                                } else if (_currentStep == _steps.length - 1) {
                                  widget.check();
                                }
                              });
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                 MediaQuery.of(context).size.width < 1000 ? SizedBox(height: 20) : SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _steps.length,
                    (index) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      width: _currentStep == index ? 10 : 5,
                      height: _currentStep == index ? 10 : 5,
                      decoration: BoxDecoration(
                        color: _currentStep == index
                            ? AppColors.getColor('green').main
                            : AppColors.getColor('primary').lighter,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                MediaQuery.of(context).size.width < 1000 ? SizedBox(height: 30) : SizedBox(height: 60),
                Center(
                  child: ReButton(
                    activeColor: AppColors.getColor('mono').white,
                    defaultColor: AppColors.getColor('mono').white,
                    disabledColor: AppColors.getColor('mono').lightGrey,
                    focusedColor: AppColors.getColor('primary').light,
                    hoverColor: AppColors.getColor('mono').lighterGrey,
                    textColor: AppColors.getColor('mono').black,
                    iconColor: AppColors.getColor('mono').black,
                    text: 'DOMOV',
                    rightIcon: 'assets/icons/arrowRightIcon.svg',
                    onTap: () {
                      widget.check();
                    },
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          )
      )
    );


  }
}