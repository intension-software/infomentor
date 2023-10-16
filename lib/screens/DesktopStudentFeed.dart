import 'package:flutter/material.dart';
import 'package:infomentor/Colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infomentor/backend/fetchUser.dart';
import 'package:infomentor/backend/fetchCapitols.dart';
import 'package:infomentor/widgets/ReWidgets.dart';
import 'dart:html' as html;


class DesktopStudentFeed extends StatefulWidget {
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
  final UserCapitolsData? capitolData;
  final String? capitolColor;

  DesktopStudentFeed({
    Key? key,
    required this.capitolColor,
    required this.onNavigationItemSelected,
    required this.capitolData,
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
  State<DesktopStudentFeed> createState() => _DesktopStudentFeedState();
}

class _DesktopStudentFeedState extends State<DesktopStudentFeed> {
  bool isMobile = false;
  bool isDesktop = false;
  bool _loading = true;

  final userAgent = html.window.navigator.userAgent.toLowerCase();

  @override
  void initState()
    {
      super.initState();
      final userAgent = html.window.navigator.userAgent.toLowerCase();
      isMobile = userAgent.contains('mobile');
      isDesktop = userAgent.contains('macintosh') ||
          userAgent.contains('windows') ||
          userAgent.contains('linux');

      setState(() {
        _loading = false;
      });
    }
   
  @override
  Widget build(BuildContext context) {
    if (_loading) {
        return Center(child: CircularProgressIndicator()); // Show loading circle when data is being fetched
    }
    return  Container(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 50,),
                    Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 836,
                      height: 329,
                      decoration: BoxDecoration(
                        color: isMobile ?  null : Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.all(16),
                      child: Center(
                        child: !widget.weeklyBool ? Column(
                          mainAxisAlignment: MainAxisAlignment.center, // Align items vertically to center
                          crossAxisAlignment: CrossAxisAlignment.center, // Align items horizontally to center
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center, // Align items horizontally to center
                              children: [
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
                            SizedBox(height: 5,),
                            Text(
                                "Kapitola: ${widget.capitolTitle}",
                                style: TextStyle(color: AppColors.getColor('primary').lighter,),
                              ),
                              SizedBox(height: 5,),
                            Text(
                                "Čas na dokončenie: 1 týždeň",
                                style: TextStyle(color: AppColors.getColor('primary').lighter,),
                              ),
                            SizedBox(height: 20,),
                            ReButton(activeColor: AppColors.getColor('mono').white, defaultColor:  AppColors.getColor('mono').white, disabledColor: AppColors.getColor('mono').lightGrey, focusedColor: AppColors.getColor('primary').light, hoverColor: AppColors.getColor('mono').lighterGrey, textColor: AppColors.getColor('mono').black, iconColor: AppColors.getColor('mono').black, text: 'ZAČAŤ', onTap:
                              () {
                                  widget.onNavigationItemSelected(1);
                              },
                            ),
                          ],
                        ) : Column(
                          mainAxisAlignment: MainAxisAlignment.center, // Align items vertically to center
                          crossAxisAlignment: CrossAxisAlignment.center, // Align items horizontally to center
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center, // Align items horizontally to center
                              children: [
                                SvgPicture.asset('assets/icons/greenCheckIcon.svg'),
                                Text(
                                  "Týždenná výzva splnená",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                    color: AppColors.getColor('primary').lighter,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 40),
                            Text(
                              "budúci týždeň ťa čaká",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                color: AppColors.getColor('primary').lighter,
                              ),
                            ),
                              Text(
                                textAlign: TextAlign.center,
                              widget.futureWeeklyTitle ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            Text(
                                "Kapitola: ${widget.capitolTitle}",
                                style: TextStyle(color: AppColors.getColor('primary').lighter,),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 24),
                  !widget.weeklyBool ? Container(
                    height: 320,
                    width: 804,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.getColor('mono').lightGrey,
                        width: 2,
                      ),
                    ),
                    margin: EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center, // Align items vertically to center
                        crossAxisAlignment: CrossAxisAlignment.center, // Align items horizontally to center
                        children: [
                            SvgPicture.asset(
                              'assets/badges/badgeArg.svg',
                              height: 100,
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Center(
                                child: Container(
                                  width: 400, // Set your desired maximum width here
                                  child: Text(
                                    widget.weeklyTitle ?? '',
                                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                      color: AppColors.getColor('mono').grey,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              'Splň týždennú výzvu pre',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                color: AppColors.getColor('mono').black,
                              ),
                            ),
                            Text(
                              'zobrazenie skóre',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                color: AppColors.getColor('mono').black,
                              ),
                            ),
                          ],
                        )
                  ) :  ConstrainedBox(
                        constraints: BoxConstraints(minHeight: 350),
                        child:Container(
                          width: 804,
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
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Doterajšie výsledky',
                                    style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!.copyWith(
                                        color: AppColors.getColor('mono').black,
                                      ),
                                  ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                  Container(
                                    width:  630,
                                    height: 18,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: LinearProgressIndicator(
                                        value: (widget.weeklyCapitolLength != 0) ? widget.completedCount / 10 : 0.0,
                                        backgroundColor: AppColors.getColor('blue').lighter,
                                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.getColor('green').main),
                                      ),
                                    )
                                  ),
                                  SizedBox(width: isMobile ? 5 : 10),
                                  Text(
                                    "${widget.completedCount}/10 výziev hotových",
                                    style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                          color: AppColors.getColor('mono').black,
                                        ),
                                    ),
                                  ]
                                ,) 
                                ],
                              ),
                            SizedBox(height: 20),
                            Container(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: (widget.capitolData?.tests ?? []).where((test) => test.completed == true).map((test) {
                                    return Container(
                                      height: 56,
                                      margin: EdgeInsets.symmetric(vertical: 2),
                                      decoration: BoxDecoration(
                                        color: widget.capitolData?.tests[widget.weeklyChallenge] == test ?  AppColors.getColor(widget.capitolColor!).main : AppColors.getColor('mono').lighterGrey, // Grey background color
                                        borderRadius: BorderRadius.circular(10.0), // Rounded borders
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                      child:  Row(
                                        children: [
                                          Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              test.name,
                                              style: Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .copyWith(
                                                      color: widget.capitolData?.tests[widget.weeklyChallenge] == test ? AppColors.getColor('mono').white : AppColors.getColor('mono').darkGrey ,
                                                  ),
                                              ),
                                              SizedBox(height: 5,),
                                                Text(
                                                  '${test.points}/${test.questions.length} správných odpovedí',
                                                  style: TextStyle(color:  widget.capitolData?.tests[widget.weeklyChallenge] == test ? AppColors.getColor('mono').white : AppColors.getColor('mono').grey , fontSize: 12),
                                                ),
                                              ],
                                            ),
                                            Spacer(),
                                            Row(
                                              children: [
                                                Text('+ ${test.points}',
                                                style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .copyWith(
                                                          color: widget.capitolData?.tests[widget.weeklyChallenge] == test ? AppColors.getColor('mono').white : AppColors.getColor('mono').grey ,
                                                      ),
                                                  ),
                                                  SizedBox(width: 8,),
                                                SvgPicture.asset('assets/icons/starYellowIcon.svg', height: 20,)
                                              ],
                                            )
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  
                                ),
                              ),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              width: 280,
                              height: 40,
                              child: ReButton(
                                activeColor: AppColors.getColor('primary').light, 
                                defaultColor: AppColors.getColor('mono').lighterGrey, 
                                disabledColor: AppColors.getColor('mono').lightGrey, 
                                focusedColor: AppColors.getColor('primary').light, 
                                hoverColor: AppColors.getColor('primary').lighter, 
                                textColor: AppColors.getColor('primary').main, 
                                iconColor: AppColors.getColor('mono').black,
                                text: 'Zobraziť všetky výsledky',
                                rightIcon: 'assets/icons/arrowRightIcon.svg',
                                onTap: () {
                                    widget.onNavigationItemSelected(1);
                                }
                              ),
                            )
                        ],
                      )
                    ),
                  )
                ],
              ),
            ),
          ),
        );
  }
}