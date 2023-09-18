import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infomentor/screens/Login.dart';
import 'package:infomentor/screens/Home.dart';
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
        Container(
            padding: EdgeInsets.all(80),
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
            SvgPicture.asset('assets/tutorial/tutorialChallenge.svg', width: 250,),
            SizedBox(height: 20),
            Text(
            'Týždenné výzvy',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
            ),
            SizedBox(height: 20),
            Text(
              textAlign: TextAlign.center,
            'Pripravili sme pre teba krátke testy, ktoré ',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
            ),
            Text(
              textAlign: TextAlign.center,
            'ktoré preskúšajú tvoje kritické myslenie na',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
            ),
            Text(
              textAlign: TextAlign.center,
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
          textAlign: TextAlign.center,
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
              textAlign: TextAlign.center,
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
              textAlign: TextAlign.center,
            'Vyjadri svoj názor na otázky o',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
            ),
            Text(
              textAlign: TextAlign.center,
            'tom, čo sa aktuálne deje vo',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
            ),
            Text(
              textAlign: TextAlign.center,
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
          textAlign: TextAlign.center,
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
              textAlign: TextAlign.center,
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
              textAlign: TextAlign.center,
            'Nájdeš tu tipy na vzdelávacie',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
            ),
            Text(
              textAlign: TextAlign.center,
            'podujatia, projekty a materiály,',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
            ),
            Text(
              textAlign: TextAlign.center,
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
          textAlign: TextAlign.center,
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
            textAlign: TextAlign.center,
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
            textAlign: TextAlign.center,
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
          textAlign: TextAlign.center,
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
            textAlign: TextAlign.center,
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
      return const Home();
    }

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(height: 30),
          Spacer(),
          _isEnterScreen
              ? Container( padding: EdgeInsets.all(16), child: SvgPicture.asset('assets/logo.svg', width: 500)) // Replace with your SVG asset path
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
                    color: _currentStep >= index ? AppColors.getColor('green').main : AppColors.getColor('primary').lighter,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          SizedBox(height: 40),
          Center(
            child: ReButton(activeColor: AppColors.getColor('mono').white, defaultColor:  AppColors.getColor('mono').white, disabledColor: AppColors.getColor('mono').lightGrey, focusedColor: AppColors.getColor('primary').light, hoverColor: AppColors.getColor('mono').lighterGrey, textColor: AppColors.getColor('mono').black, iconColor: AppColors.getColor('mono').black, text: 'VSTÚPIŤ', rightIcon: 'assets/icons/arrowRightIcon.svg', onTap:
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