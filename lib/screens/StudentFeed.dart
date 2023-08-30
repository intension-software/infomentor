import 'package:flutter/material.dart';
import 'package:infomentor/Colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infomentor/backend/fetchUser.dart';
import 'package:infomentor/backend/fetchCapitols.dart';
import 'package:infomentor/widgets/ReWidgets.dart';


class StudentFeed extends StatefulWidget {
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

  StudentFeed({
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
  State<StudentFeed> createState() => _StudentFeedState();
}

class _StudentFeedState extends State<StudentFeed> {
  @override
  Widget build(BuildContext context) {
    return  Container(
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
                        child: !widget.weeklyBool ? Column(
                          mainAxisAlignment: MainAxisAlignment.center, // Align items vertically to center
                          crossAxisAlignment: CrossAxisAlignment.center, // Align items horizontally to center
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center, // Align items horizontally to center
                              children: [
                                Icon(
                                  Icons.star_border_outlined,
                                  color: AppColors.getColor('primary').lighter,
                                ),
                                Text(
                                  "Týždenná výzva",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(
                                    color: AppColors.getColor('primary').lighter,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16), // Add some spacing between the items
                            Text(
                              widget.weeklyTitle ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            SizedBox(height: 16), // Add some spacing between the items
                            ReButton(activeColor: AppColors.getColor('mono').white, defaultColor:  AppColors.getColor('mono').white, disabledColor: AppColors.getColor('mono').lightGrey, focusedColor: AppColors.getColor('primary').light, hoverColor: AppColors.getColor('mono').lighterGrey, textColor: AppColors.getColor('mono').black, iconColor: AppColors.getColor('mono').black, text: 'ZAČAŤ', leftIcon: false, rightIcon: false, onTap:
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
                                Icon(
                                  Icons.task_alt_rounded,
                                  color: AppColors.getColor('green').main,
                                ),
                                Text(
                                  "Týždenná výzva dokončená",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(
                                    color: AppColors.getColor('primary').lighter,
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
                                color: AppColors.getColor('primary').lighter,
                              ),
                            ),
                            SizedBox(height: 16), // Add some spacing between the items
                            Text(
                              widget.futureWeeklyTitle ?? '',
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

                  SizedBox(height: 24),
                  !widget.weeklyBool ? Container(
                    height: 350,
                    width: 700,
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
                            ),
                            Text(
                              widget.capitolTitle ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                color: AppColors.getColor('mono').grey
                              ),
                            ),
                            Text(
                              'Splň týždennú výzvu pre',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                color: AppColors.getColor('mono').black,
                              ),
                            ),
                            Text(
                              'zobrazenie skóre',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                color: AppColors.getColor('mono').black,
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
                            color: AppColors.getColor('mono').lightGrey,
                            width: 2,
                          ),
                        ),
                        margin: EdgeInsets.all(16),
                        padding: EdgeInsets.all(16),
                        child: Column(children: [
                          
                            Row(
                          children: [
                            SvgPicture.asset(
                              'assets/badges/badgeArg.svg',
                              width: 80,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                widget.capitolTitle ?? '',
                                style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!.copyWith(
                                        color: AppColors.getColor('mono').darkGrey,
                                      ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                Container(
                                  width:  MediaQuery.of(context).size.width < 630 ? 80 : 300,
                                  height: 20,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: LinearProgressIndicator(
                                      value: (widget.weeklyCapitolLength != 0) ? widget.completedCount / widget.weeklyCapitolLength : 0.0,
                                      backgroundColor: AppColors.getColor('blue').lighter,
                                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.getColor('green').main),
                                    ),
                                  )
                                ),
                                SizedBox(width: MediaQuery.of(context).size.width < 630 ? 5 : 10),
                                Text(
                                  "${widget.completedCount}/${widget.weeklyCapitolLength} výziev hotových",
                                  style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(
                                                color: AppColors.getColor('mono').grey,
                                            ),
                                ),
                                ]
                              ,)
                              ],
                            ),
                          ],
                        ),
                        
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