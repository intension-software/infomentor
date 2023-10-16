import 'package:flutter/material.dart';
import 'package:infomentor/Colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infomentor/backend/fetchUser.dart';
import 'package:infomentor/backend/fetchCapitols.dart';
import 'package:infomentor/widgets/ReWidgets.dart';
import 'package:flutter/gestures.dart'; // Import this line

import 'dart:html' as html;


class MobileTeacherFeed extends StatefulWidget {
  final Function(int) onNavigationItemSelected;
  final int? capitolLength;
  final int capitolsId;
  final FetchResult? capitol;
  final int weeklyChallenge;
  final String? weeklyTitle;
  final String? futureWeeklyTitle;
  final bool weeklyBool;
  final int weeklyCapitolLength ;
  final int completedCount;
  final String? capitolTitle;

  MobileTeacherFeed({
    Key? key,
    required this.onNavigationItemSelected,
    required this.capitol,
    required this.capitolLength,
    required this.capitolTitle,
    required this.capitolsId,
    required this.completedCount,
    required this.futureWeeklyTitle,
    required this.weeklyBool,
    required this.weeklyCapitolLength,
    required this.weeklyChallenge,
    required this.weeklyTitle
  }) : super(key: key);

  @override
  State<MobileTeacherFeed> createState() => _MobileTeacherFeedState();
}

class _MobileTeacherFeedState extends State<MobileTeacherFeed> {
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
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
            width: 900,
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Align(
                        alignment: Alignment.center,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center, // Align items vertically to center
                              crossAxisAlignment: CrossAxisAlignment.center, // Align items horizontally to center
                              children: [
                                SizedBox(height: 30,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center, // Align items horizontally to center
                                  children: [
                                    SvgPicture.asset('assets/icons/smallStarIcon.svg', color: AppColors.getColor('primary').lighter),
                                    SizedBox(width: 8,),
                                    Text(
                                      "Týždenná výzva #${widget.weeklyChallenge + 1}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                        color: AppColors.getColor('primary').lighter,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Center(
                                    child: Container(
                                      width: 400, // Set your desired maximum width here
                                      child: Text(
                                        widget.weeklyTitle ?? '',
                                        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                          color: Theme.of(context).colorScheme.onPrimary,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                    "Čas na dokončenie: 1 týždeň",
                                    style: TextStyle(color: AppColors.getColor('primary').lighter,),
                                  ),
                                SizedBox(height: 16,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center, // Align items vertically to center
                                crossAxisAlignment: CrossAxisAlignment.start, 
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          width: 60,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                          color: AppColors.getColor('primary').light,
                                          ),
                                          child: Row(
                                          children: [
                                            Text('/', style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                              color: Theme.of(context).colorScheme.onPrimary,
                                            ),),
                                            SizedBox(width: 4,),
                                            SvgPicture.asset('assets/icons/starYellowIcon.svg')
                                          ],
                                        )
                                        ),
                                          Text('priemerné skóre',
                                            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)
                                          ),
                                      ],
                                    ),
                                    SizedBox(width: 16,),
                                    Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(6),
                                          width: 60,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                          color: AppColors.getColor('primary').light,
                                          ),
                                          child: Text('/',style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                          color: Theme.of(context).colorScheme.onPrimary,
                                        ),),
                                        ),
                                        Text('študentov dokončilo',
                                          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)
                                        )
                                      ],
                                    )
                                      
                                  ],
                                ),
                                SizedBox(height: 16,),
                                Container(
                                  height: 40,
                                  width:  170,
                                  child:  ReButton(
                                    activeColor: AppColors.getColor('primary').light, 
                                    defaultColor: AppColors.getColor('primary').light, 
                                    disabledColor: AppColors.getColor('mono').lightGrey, 
                                    focusedColor: AppColors.getColor('primary').light, 
                                    hoverColor: AppColors.getColor('primary').light, 
                                    textColor: AppColors.getColor('mono').white, 
                                    iconColor: AppColors.getColor('mono').black, 
                                    text: 'Zobraziť test',
                                    rightIcon: 'assets/icons/arrowRightIcon.svg',
                                    onTap: () {
                                      widget.onNavigationItemSelected(1);
                                    },
                                  ),
                                ),
                              ],
                            )
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(top: BorderSide(color: Theme.of(context).primaryColor))
                        ),
                        child: SvgPicture.asset('assets/bottomBackground.svg', fit: BoxFit.cover, width:  MediaQuery.of(context).size.width,),
                      ),
                  Container(
                    padding: EdgeInsets.all(16),
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Výsledky',
                        textAlign: TextAlign.start,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                              ),
                        ),
                        Container(
                              height: 142,
                              width: 804,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: AppColors.getColor('mono').lightGrey,
                                  width: 2,
                                ),
                              ),
                              margin: EdgeInsets.all(8),
                              padding: EdgeInsets.all(16),
                              child: Column(
                                children: [
                                Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(12),
                                    height: 100,
                                    color: AppColors.getColor('mono').lighterGrey,
                                    child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,

                                      children: [
                                        Text('Tu uvidíte výsledky vašich študentov. Celý prehľad je k dispozícií v sekcii ', style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                      ),),
                                        Text.rich(
                                          TextSpan(
                                            text: 'Výsledky.',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                decoration: TextDecoration.underline,
                                            ),
                                            // You can also add onTap to make it clickable
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                // Handle the tap event here, e.g., open a URL
                                                // You can use packages like url_launcher to launch URLs.
                                                widget.onNavigationItemSelected(4);
                                              },
                                          ),
                                        ),
                                      ],
                                    )
                                    
                                )
                            ],
                          )
                        ),
                        ],
                      ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Diskusia',
                        textAlign: TextAlign.start,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                              ),
                        ),
                        Container(
                              height: 142,
                              width: 804,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: AppColors.getColor('mono').lightGrey,
                                  width: 2,
                                ),
                              ),
                              margin: EdgeInsets.all(8),
                              padding: EdgeInsets.all(16),
                              child: Column(
                                children: [
                                Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(12),
                                    height: 100,
                                    color: AppColors.getColor('mono').lighterGrey,
                                    child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,

                                      children: [
                                        Text('Ešte nebol pridaný žiaden príspevok. Nové príspevky môžete pridávať prostredníctvom sekcie ', style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                      ),),
                                        Text.rich(
                                          TextSpan(
                                            text: 'Diskusia.',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                decoration: TextDecoration.underline,
                                            ),
                                            // You can also add onTap to make it clickable
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                // Handle the tap event here, e.g., open a URL
                                                // You can use packages like url_launcher to launch URLs.
                                                widget.onNavigationItemSelected(2);
                                              },
                                          ),
                                        ),
                                      ],
                                    )
                                    
                                )
                            ],
                          )
                        ),
                        ],
                      ),
                  ),
                ],
              ),
            ),
          ),
        );
  }
}