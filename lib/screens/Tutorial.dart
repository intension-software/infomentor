import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infomentor/screens/Login.dart';
import 'package:infomentor/screens/Home.dart';
import 'package:infomentor/widgets/ReWidgets.dart';
import 'package:infomentor/Colors.dart';
import 'dart:html' as html;
import 'package:infomentor/backend/fetchUser.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Tutorial extends StatefulWidget {
  const Tutorial({Key? key}) : super(key: key);

  @override
  _TutorialState createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  int _currentStep = 0;
  bool _showNavigationIcons = false;
  bool _end = false;
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 360,
          padding: EdgeInsets.all(16),
          child: Text(
            'Ako funguje appka Infomentor?',
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
            Image.asset('assets/tutorial/tutorialChallenge.png', width: 250,),
            SizedBox(height: 20),
            Text(
            'Týždenné výzvy',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
            ),
            SizedBox(height: 20),
            Container(
            width: 280,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child:Text(
                textAlign: TextAlign.center,
              'Pripravili sme pre teba krátke testy, ktoré preskúšajú tvoje kritické myslenie na praktických príkladoch.',
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 360,
          padding: EdgeInsets.all(16),
          child: Text(
            'Ako funguje appka Infomentor?',
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
            Image.asset('assets/tutorial/tutorialDiscussions.png', width: 250,),
            SizedBox(height: 20),
            Text(
              textAlign: TextAlign.center,
            'Diskusné fórum',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
            ),
            SizedBox(height: 20),
            Container(
              width: 360,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child:Text(
                  textAlign: TextAlign.center,
                'Vyjadri svoj názor na otázky o',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                ),
            ),
            Container(
              width: 360,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child:Text(
                  textAlign: TextAlign.center,
                'tom, čo sa aktuálne deje vo',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                ),
            ),
            Container(
              width: 360,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child:Text(
                  textAlign: TextAlign.center,
                'svete.',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                ),
            )
          ]
          )
        )
      ]
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 360,
          padding: EdgeInsets.all(16),
          child: Text(
            'Ako funguje appka Infomentor?',
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
            Image.asset('assets/tutorial/tutorialLearning.png', width: 250,),
            SizedBox(height: 20),
            Text(
              textAlign: TextAlign.center,
            'Vzdelávanie',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
            ),
            SizedBox(height: 8),
             Container(
              width: 280,
              padding: EdgeInsets.all(16),
              child:Text(
                  textAlign: TextAlign.center,
                'Nájdeš tu tipy na vzdelávacie podujatia, projekty a materiály, ktoré ťa posunú ešte ďalej.',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                ),
             )
          ]
          )
        )
      ]
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 360,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Je moja aktivita v appke dôležitá?',
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
            Image.asset('assets/tutorial/tutorialPoints.png', width: 300,),
            SizedBox(height: 20),
            Container(
              width: 310,
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Výsledky tvojich testov a tvoja aktivita v diskusnom fóre je hodnotená bodmi, ktoré vždy vidíš v pravom hornom rohu.',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                ),
            ),
            SizedBox(height: 10),
            Container(
              width: 310,
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Tvoj vyučujúci/a sa môže rozhodnúť brať tieto body do úvahy pri známkovaní.',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                ),
            ),
            SizedBox(height: 20),
          ]
          )
        )
      ]
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
            'Až 56%',
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
            'ľudí na Slovensku je náchylných veriť tvrdeniam, ktoré obsahujú klamstvá či konšpirácie (GLOBSEC).',
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
  ];

  List<Widget> _stepsTeacher = [
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 360,
          padding: EdgeInsets.all(16),
          child: Text(
            'Ako funguje appka Infomentor?',
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
            Image.asset('assets/tutorial/tutorialChallenge.png', width: 250,),
            SizedBox(height: 20),
            Text(
            'Týždenné výzvy',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
            ),
            SizedBox(height: 20),
            Container(
              width: 260,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child:Text(
                  textAlign: TextAlign.center,
                'Pripravili sme pre študentov a študentky krátke testy, ktoré preskúšajú ich kritické myslenie na praktických príkladoch.',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                ),
            )
          ]
          )
        )
      ]
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 360,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Ako funguje appka Infomentor?',
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
            Image.asset('assets/tutorial/tutorialTeacherDiscussions.png', width: 250,),
            SizedBox(height: 20),
            Text(
              textAlign: TextAlign.center,
            'Diskusné fórum',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
            ),
            SizedBox(height: 20),
            Container(
              width: 360,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child:Text(
                  textAlign: TextAlign.center,
                'Študenti a študentky sa naučia vyjadriť svoje názory, dobre diskusné príspevky môžete oceniť hviezdičkou.',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                ),
            ),
            SizedBox(height: 10,),
            Container(
              width: 360,
              padding: EdgeInsets.all(16),
              child:Text(
                  textAlign: TextAlign.center,
                'Diskusiu začnete vybraním diskusnej tézy z našej knižnice alebo napísaním vlastnej tézy.',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                ),
            )
           
          ]
          )
        )
      ]
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 360,
          padding: EdgeInsets.all(16),
          child: Text(
            'Ako funguje appka Infomentor?',
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
            Image.asset('assets/tutorial/tutorialLearning.png', width: 250,),
            SizedBox(height: 20),
            Text(
              textAlign: TextAlign.center,
            'Vzdelávanie',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
            ),
            SizedBox(height: 20),
            Container(
              width: 330,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child:Text(
                  textAlign: TextAlign.center,
                'Nájdete tu tipy na vzdelávacie podujatia, projekty a materiály!',
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
              width: 300,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child:Text(
                  textAlign: TextAlign.center,
                'Taktiež aj vy môžete pridávať takéto tipy pre študentov a študentky.',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                ),
            )
          ]
          )
        )
      ]
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 360,
          padding: EdgeInsets.all(16),
          child: Text(
            'Ako sa hodnotí aktivita štundetov a Študnetiek v aplikácií?',
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
            Image.asset('assets/tutorial/tutorialTeacherPoints.png', width: 300,),
            SizedBox(height: 20),
            Container(
              width: 350,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Testy a ich aktivity sú hodnotená bodmi, ktoré nájdete v sekcii “Výsledky”.',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                ),
            ),
            SizedBox(height: 10),
            Container(
              width: 350,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Môžete sa rozhodnúť brať tieto body do úvahy pri známkovaní.',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                ),
            ),
            SizedBox(height: 20),
          ]
          )
        )
      ]
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
            'Až 56%',
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
            'ľudí na Slovensku je náchylných veriť tvrdeniam, ktoré obsahujú klamstvá či konšpirácie (GLOBSEC).',
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
            'Len 16%',
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
  ];
if (_loading) {
    return Container(color: Theme.of(context).primaryColor,); // Show loading circle when data is being fetched
}
if (_end) {
  return const Home();
}

return Scaffold(
  backgroundColor: Theme.of(context).primaryColor,
  body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height <= 700
          ? 700
          : MediaQuery.of(context).size.height >= 900
              ? 900
              : MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 50),
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
                        height: 600,
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (int page) {
                            setState(() {
                              _currentStep = page;
                            });
                          },
                          children: currentUserData!.teacher ? _stepsTeacher : _steps,
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
                                  setState(() {
                                    _end = true;
                                  });
                                }
                              });
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
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
                SizedBox(height: 60),
                Center(
                  child: ReButton(
                    activeColor: AppColors.getColor('mono').white,
                    defaultColor: AppColors.getColor('mono').white,
                    disabledColor: AppColors.getColor('mono').lightGrey,
                    focusedColor: AppColors.getColor('primary').light,
                    hoverColor: AppColors.getColor('mono').lighterGrey,
                    textColor: AppColors.getColor('mono').black,
                    iconColor: AppColors.getColor('mono').black,
                    text: 'VSTÚPIŤ',
                    rightIcon: 'assets/icons/arrowRightIcon.svg',
                    onTap: () {
                      setState(() {
                        _end = true;
                      });
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