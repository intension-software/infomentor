import 'package:flutter/material.dart';
import 'package:infomentor/Colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infomentor/backend/fetchUser.dart';
import 'package:infomentor/backend/fetchCapitols.dart';
import 'package:infomentor/widgets/ReWidgets.dart';
import 'dart:html' as html;


class TeacherFeed extends StatefulWidget {
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

  TeacherFeed({
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
  State<TeacherFeed> createState() => _TeacherFeedState();
}

class _TeacherFeedState extends State<TeacherFeed> {
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
                  children: [
                    Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 700,
                      height: 250,
                      decoration: BoxDecoration(
                        color: isMobile ?  null : AppColors.getColor('primary').main,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      margin: EdgeInsets.all(16),
                      padding: EdgeInsets.all(16),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child:  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,

                          children: [ 
                            Column(
                            mainAxisAlignment: MainAxisAlignment.center, // Align items vertically to center
                            crossAxisAlignment: CrossAxisAlignment.start, // Align items horizontally to center
                            children: [
                            Text(
                                "Týždenná výzva",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(
                                  color: AppColors.getColor('primary').lighter,
                                ),
                              ),
                              SizedBox(height: 16), // Add some spacing between the items
                              Text(
                                widget.weeklyTitle ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                              SizedBox(height: 16), // Add some spacing between the items
                              ReButton(activeColor: AppColors.getColor('mono').white, defaultColor:  AppColors.getColor('mono').white, disabledColor: AppColors.getColor('mono').lightGrey, focusedColor: AppColors.getColor('primary').light, hoverColor: AppColors.getColor('mono').lighterGrey, textColor: AppColors.getColor('mono').black, iconColor: AppColors.getColor('mono').black, text: 'ZOBRAZIŤ TEST', onTap:
                                () {
                                    widget.onNavigationItemSelected(1);
                                },
                              ),
                            ],
                          ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center, // Align items vertically to center
                            crossAxisAlignment: CrossAxisAlignment.start, 
                              children: [
                                Container(
                                  width: 60,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                  color: AppColors.getColor('primary').light,
                                  ),
                                ),
                                  Text('priemerné skóre',
                                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)
                                  ),
                                  Container(
                                  width: 60,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                  color: AppColors.getColor('primary').light,

                                  ),
                                ),
                                  Text('študentov dokončilo',
                                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)
                                  )


                              ],
                            )
                          ]
                        )
                      ),
                    ),
                  ),

                  SizedBox(height: 24),
                  Text(
                    'Výsledky',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                  Container(
                        height: 150,
                        width: 700,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.getColor('mono').lightGrey,
                            width: 2,
                          ),
                        ),
                        margin: EdgeInsets.all(16),
                        padding: EdgeInsets.all(16),
                        child: Column(children: [
                           Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(12),
                              height: 110,
                              color: AppColors.getColor('mono').lightGrey,
                              child: Text('Tu uvidíte výsledky vašich študentov. Celý prehľad je k dispozícií v sekcii Výsledky.'),
                           )
                      ],
                    )
                  ),
                  Text(
                    'Diskusia',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                  SizedBox(height: 24),
                  Container(
                        height: 150,
                        width: 700,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.getColor('mono').lightGrey,
                            width: 2,
                          ),
                        ),
                        margin: EdgeInsets.all(16),
                        padding: EdgeInsets.all(16),
                        child: Column(children: [
                           Container(
                              height: 110,
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(12),
                              color: AppColors.getColor('mono').lightGrey,
                              child: Text('Ešte nebol pridaný žiaden príspevok. Nové príspevky môžete pridávať prostredníctvom sekcie Diskusia.'),
                           )
                      ],
                    )
                  ),
                ],
              ),
            ),
          ),
        );
  }
}