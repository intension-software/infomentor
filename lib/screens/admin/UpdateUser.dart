import 'package:flutter/material.dart';
import 'package:infomentor/Colors.dart';
import 'package:infomentor/widgets/ReWidgets.dart';
import 'package:infomentor/backend/fetchClass.dart';
import 'package:infomentor/backend/userController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:infomentor/backend/auth.dart';

class UpdateUser extends StatefulWidget {
  void Function(int) onNavigationItemSelected;
  bool teacher;
  bool admin;
  void Function() setAdmin;
  TextEditingController editUserNameController;
  TextEditingController editUserEmailController;
  TextEditingController editUserPasswordController;
  ClassDataWithId? currentClass;
  UserDataWithId? currentUser;
  void Function(String) changeName;
  void Function(String) changeEmail;

  UpdateUser(
    {
      required this.onNavigationItemSelected,
      required this.teacher,
      required this.admin,
      required this.setAdmin,
      required this.editUserEmailController, 
      required this.editUserNameController, 
      required this.editUserPasswordController,
      required this.currentClass,
      required this.currentUser,
      required this.changeEmail,
      required this.changeName
    }
  );

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  String _emailErrorText = '';
  String _passwordErrorText = '';

  bool isValidPassword(String password) {
  final regex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d{4,}).*$');
  return regex.hasMatch(password);

  
}

// Existing isValidEmail function
bool isValidEmail(String email) {
  final emailRegex = RegExp(
    r'^[^@]+@[^@]+\.[^@]+',
  );
  return emailRegex.hasMatch(email);
}
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: EdgeInsets.all(8),
        width: 900,
        height: 1080,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: AppColors.getColor('mono').darkGrey,
                  ),
                  onPressed: () {
                    if(widget.admin) {
                      widget.onNavigationItemSelected(0);
                      widget.editUserNameController.text = '';
                      widget.editUserEmailController.text = '';
                      widget.editUserPasswordController.text = '';
                      widget.setAdmin();
                    } else {
                      widget.onNavigationItemSelected(1);
                      widget.editUserNameController.text = '';
                      widget.editUserEmailController.text = '';
                      widget.editUserPasswordController.text = '';
                    }
                  },
                ),
                Text(
                  'Späť',
                  style: TextStyle(color: AppColors.getColor('mono').darkGrey),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      widget.admin ? 'Upraviť správcu' : widget.teacher ? '${widget.currentClass!.data.name} / Upraviť učiteľa' : '${widget.currentClass!.data.name} / Upraviť žiaka',
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                  ),
                ),
                SizedBox(width: 100,)
              ],
            ),
            SizedBox(height: 40,),
            Text(
              'Napíšte triedu, meno a email ${widget.teacher ? 'učiteľa' : 'žiaka'}',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: AppColors.getColor('mono').black,
                  ),
            ),
            SizedBox(height: 10,),
            Text(
              'Po kliknutí na “ULOŽIŤ” sa učiteľovi odošle email s prihlasovacími údajmi',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: AppColors.getColor('mono').grey,
                ),
            ),
            SizedBox(height: 30,),
            Text(
              'Meno a priezvisko ${widget.teacher ? 'učiteľa' : 'žiaka'}',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: AppColors.getColor('mono').grey,
                  ),
            ),
            SizedBox(height: 10,),
            reTextField(
              'Jožko Mrkvička',
              false,
              widget.editUserNameController,
              AppColors.getColor('mono').lightGrey, // assuming white is the default border color you want
            ),
            SizedBox(height: 10,),
            Text(
              'Email ${widget.teacher ? 'učiteľa' : 'žiaka'}',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: AppColors.getColor('mono').grey,
                  ),
            ),
            reTextField(
              'jozko.mrkvicka@gmail.com',
              false,
              widget.editUserEmailController,
              AppColors.getColor('mono').lightGrey, // assuming white is the default border color you want
              errorText: _emailErrorText
            ),
            SizedBox(height: 10,),
            Text(
              'Heslo ${widget.teacher ? 'učiteľa' : 'žiaka'}',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: AppColors.getColor('mono').grey,
                  ),
            ),
            reTextField(
              'Heslo',
              false,
              widget.editUserPasswordController,
              AppColors.getColor('mono').lightGrey, // assuming white is the default border color you want
            ),
            Spacer(),
            Align(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      if(!widget.admin)ReButton(
                        activeColor: AppColors.getColor('mono').white, 
                        defaultColor: AppColors.getColor('mono').white, 
                        disabledColor: AppColors.getColor('mono').lightGrey, 
                        focusedColor: AppColors.getColor('mono').white, 
                        hoverColor: AppColors.getColor('mono').white, 
                        textColor: Theme.of(context).colorScheme.error, 
                        iconColor: Theme.of(context).colorScheme.error,
                        leftIcon: 'assets/icons/binIcon.svg',
                        text: widget.teacher ? 'Vymazať učiteľa' : 'Vymazať žiaka', 
                        onTap: () {
                            widget.onNavigationItemSelected(1);
                            deleteUserFunction([widget.currentUser!.id],widget.currentUser!.data, context, widget.currentClass);
                            widget.editUserNameController.text = '';
                            widget.editUserEmailController.text = '';
                            widget.editUserPasswordController.text = '';
                          }
                      ),
                      ReButton(
                        activeColor: AppColors.getColor('mono').white, 
                        defaultColor: AppColors.getColor('green').main, 
                        disabledColor: AppColors.getColor('mono').lightGrey, 
                        focusedColor: AppColors.getColor('green').light, 
                        hoverColor: AppColors.getColor('green').light, 
                        textColor: Theme.of(context).colorScheme.onPrimary, 
                        iconColor: AppColors.getColor('mono').black, 
                        text: 'ULOŽIŤ', 
                        onTap: () async {
                          bool isUsed = await isEmailAlreadyUsed(widget.editUserEmailController.text);
                          bool validPassword = isValidPassword(widget.editUserPasswordController.text);
                          bool validEmail = isValidEmail(widget.editUserEmailController.text);
                          setState(() {
                            if(!isUsed) _emailErrorText = '';
                            if(validPassword) _passwordErrorText = '';
                            if(validEmail) _emailErrorText = '';
                          });
                          if(widget.editUserNameController.text != '' && widget.editUserEmailController.text != '') {
                            widget.changeEmail(widget.editUserEmailController.text);
                            widget.changeName(widget.editUserNameController.text);

                            saveUserDataToFirestore(widget.currentUser!.data, widget.currentUser!.id, widget.editUserEmailController.text, widget.editUserPasswordController.text, context );

                            widget.editUserNameController.text = '';
                            widget.editUserEmailController.text = '';
                            widget.editUserPasswordController.text = '';

                            widget.onNavigationItemSelected(1);

                            widget.setAdmin();
                            
                            reShowToast(widget.teacher ? 'Učiteľ úspešne upravený' : 'Žiak úspešne upravený', false, context);
                          }
                          setState(() {
                            if(isUsed) _emailErrorText = 'Účet s daným E-mailom už existuje';
                            if(!validPassword) _passwordErrorText = 'Heslo musí mať aspoň jeden charakter a 4 čísla';
                            if(!validEmail) _emailErrorText = 'Nesprávny formát E-mailu';
                          });
                          }
                      ),
                    ],
                  ),
                  if (widget.teacher)Text(
                    'Ak učiteľ, ktorého chcete pridať, už má účet v aplikácií, pridáte ho tu.',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.getColor('mono').grey,
                      ),
                  ),
                ],
              )
            ),
            SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }
}

Future<void> saveUserDataToFirestore(
  UserData userData,
  String userId,
  String newEmail,
  String newPassword,
  BuildContext context
) async {
  try {
    // Reference to the user document in Firestore
    DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(userId);

    // Call the Firebase Function to update email and password
    final functions = FirebaseFunctions.instance;
    final result = await functions.httpsCallable('updateUserEmailAndPassword').call({
      'userId': userId,
      'newEmail': newEmail,
      'newPassword': newPassword,
    });

    // Convert userData object to a Map
    Map<String, dynamic> userDataMap = {
      'badges': userData.badges,
      'admin': userData.admin,
      'discussionPoints': userData.discussionPoints,
      'weeklyDiscussionPoints': userData.weeklyDiscussionPoints,
      'teacher': userData.teacher,
      'email': newEmail, // Update the email in Firestore to the new email
      'name': userData.name,
      'active': userData.active,
      'school': userData.school,
      'schoolClass': userData.schoolClass,
      'image': userData.image,
      'notifications': userData.notifications,
      'surname': userData.surname,
      'materials': userData.materials,
      'points': userData.points,
      'capitols': userData.capitols.map((userCapitolsData) {
        return {
          'id': userCapitolsData.id,
          'name': userCapitolsData.name,
          'image': userCapitolsData.image,
          'completed': userCapitolsData.completed,
          'tests': userCapitolsData.tests.map((userCapitolsTestData) {
            return {
              'name': userCapitolsTestData.name,
              'completed': userCapitolsTestData.completed,
              'points': userCapitolsTestData.points,
              'questions': userCapitolsTestData.questions.map((userQuestionsData) {
                return {
                  'answer': userQuestionsData.answer.map((userAnswerData) {
                    return {
                      'answer': userAnswerData.answer,
                      'index': userAnswerData.index,
                    };
                  }).toList(),
                  'completed': userQuestionsData.completed,
                  'correct': userQuestionsData.correct,
                };
              }).toList(),
            };
          }).toList(),
        };
      }).toList(),
    };



    // Update the user document in Firestore with the new userDataMap
    await userRef.update(userDataMap);
    reShowToast(userData!.teacher ? 'Učiteľ úspešne upravený' : 'Žiak úspešne upravený', false, context);
  } catch (e) {
    reShowToast(userData!.teacher ? 'Učiteľ sa nepodarilo upraviť' : 'Žiaka sa nepodarilo upraviť', true, context);
    rethrow;
  }
}