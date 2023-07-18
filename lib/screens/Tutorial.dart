import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infomentor/screens/Login.dart';
import 'package:infomentor/widgets/ReWidgets.dart';
import 'package:infomentor/Colors.dart';


class Tutorial extends StatefulWidget {
  const Tutorial({Key? key}) : super(key: key);

  @override
  _TutorialState createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  int _currentStep = 0;
  bool _isEnterScreen = true;
  

  @override
  Widget build(BuildContext context) {
  
    List<Widget> _steps = [
    Column(
      children: [
        Text(
          'Ako funguje appka Infomentor?',
          style: Theme.of(context)
              .textTheme
              .displayLarge!
              .copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
        ),
        SizedBox(height: 20),
        Center(
          child: Column(
            children: [
              SizedBox(height: 20),
            SvgPicture.asset('assets/tutorial/tutorialChallenge.svg', width: 250,),
            SizedBox(height: 20),
            Text(
            'Týždenné výzvy',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
            ),
            SizedBox(height: 20),
            Text(
            'Pripravili sme pre teba krátke testy, ktoré ',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
            ),
            Text(
            'ktoré preskúšajú tvoje kritické myslenie na',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
            ),
            Text(
            'praktických príkladoch',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
            ),
          ]
          )
        )
      ]
    ),
    Column(
      children: [
        Text(
          'Ako funguje appka Infomentor?',
          style: Theme.of(context)
              .textTheme
              .displayLarge!
              .copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
        ),
        SizedBox(height: 20),
        Center(
          child: Column(
            children: [
              SizedBox(height: 20),
            SvgPicture.asset('assets/tutorial/tutorialDiscussions.svg', width: 250,),
            SizedBox(height: 20),
            Text(
            'Diskusné fórum',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
            ),
            SizedBox(height: 20),
            Text(
            'Vyjadri svoj názor na otázky o',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
            ),
            Text(
            'tom, čo sa aktuálne deje vo',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
            ),
            Text(
            'svete',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
            ),
          ]
          )
        )
      ]
    ),
    Column(
      children: [
        Text(
          'Ako funguje appka Infomentor?',
          style: Theme.of(context)
              .textTheme
              .displayLarge!
              .copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
        ),
        SizedBox(height: 20),
        Center(
          child: Column(
            children: [
              SizedBox(height: 20),
            SvgPicture.asset('assets/tutorial/tutorialLearning.svg', width: 250,),
            SizedBox(height: 20),
            Text(
            'Vzdelávanie',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
            ),
            SizedBox(height: 20),
            Text(
            'Nájdeš tu tipy na vzdelávacie',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
            ),
            Text(
            'podujatia, projekty a materiály,',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
            ),
            Text(
            'ktoré ťa posunú ešte ďalej',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
            ),
          ]
          )
        )
      ]
    ),
    Column(
      children: [
         SizedBox(height: 20),
            SvgPicture.asset('assets/tutorial/tutorialWoman.svg', width: 250,),
            SizedBox(height: 20),
        Text(
          'Je moja aktivita v appke dôležitá?',
          style: Theme.of(context)
              .textTheme
              .displayLarge!
              .copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
        ),
        SizedBox(height: 20),
        Container(
          width: 350,
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
        SizedBox(height: 5),
        Container(
          width: 350,
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
    ),
    Column(
      children: [
         SizedBox(height: 20),
            SvgPicture.asset('assets/tutorial/tutorialMan.svg', width: 250,),
            SizedBox(height: 20),
        Text(
          'Nauč sa myslieť kriticky',
          style: Theme.of(context)
              .textTheme
              .displayLarge!
              .copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
        ),
        SizedBox(height: 20),
        Container(
          width: 350,
          child: Text(
            'Až 56% ľudí na Slovensku je náchylných veriť tvrdeniam, ktoré obsahujú klamstvá či konšpirácie (GLOBSEC) len 16% mladých ľudí si overuje informácie z médií vždy alebo takmer vždy (RmS)',
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
    ),
  ];

  if (_currentStep >= _steps.length && !_isEnterScreen) {
      return const Login();
    }

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(height: 30),
          Spacer(),
          _isEnterScreen
              ? SvgPicture.asset('assets/logo.svg', width: 500) // Replace with your SVG asset path
              : _steps[_currentStep],
          Spacer(),
          if (!_isEnterScreen)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _steps.length,
                (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  width: _currentStep == index ? 10 : 5,
                  height: _currentStep == index ? 10 : 5,
                  decoration: BoxDecoration(
                    color: _currentStep >= index ? AppColors.green.main : AppColors.primary.lighter,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          SizedBox(height: 40),
          Center(
            child: ReButton(activeColor: AppColors.mono.white, defaultColor:  AppColors.mono.white, disabledColor: AppColors.mono.lightGrey, focusedColor: AppColors.primary.light, hoverColor: AppColors.mono.lighterGrey, textColor: AppColors.mono.black, iconColor: AppColors.mono.black, text: 'VSTÚPIŤ', rightIcon: true, onTap:
              () {
                setState(() {
                  if (_isEnterScreen) {
                    _isEnterScreen = false;
                  } else {
                    _currentStep = (_currentStep + 1);
                  }
                });
              },
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}