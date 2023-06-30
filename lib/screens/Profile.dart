import 'package:flutter/material.dart';
import 'package:infomentor/Colors.dart';
import 'package:infomentor/backend/fetchCapitols.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:infomentor/backend/fetchUser.dart'; // Import the UserData class and fetchUser function
import 'package:infomentor/screens/Login.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  UserData? currentUserData;
  int capitolOne = 0;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchCapitolsData();
  }

  Future<void> fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null && mounted) {
        UserData userData = await fetchUser(user.uid);
        setState(() {
          currentUserData = userData;
        });
      } else {
        setState(() {
          currentUserData = null; // Set currentUserData to null when the user is not logged in
        });
        print('User is not logged in.');
      }
    } catch (e) {
      setState(() {
        currentUserData = null; // Set currentUserData to null on error
      });
      print('Error fetching user data: $e');
    }
  }

  Future<void> fetchCapitolsData() async {
    try {
      FetchResult one = await fetchCapitols("0");

      setState(() {
        capitolOne = one.capitolsData!.points;
      });
    } catch (e) {
      print('Error fetching question data: $e');
    }
  }

  @override
  void dispose() {
    // Cancel any ongoing operations or listeners here
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentUserData != null
          ? SingleChildScrollView(
                child:  Center(
                  child: Container(
                    padding: EdgeInsets.all(24),
                    width: 900, 
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/profilePicture.png'),
                        radius: 80,
                      ),
                      SizedBox(height: 16),
                      Center(
                        child: Column(
                          children: [
                            Text(
                              currentUserData!.name,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              currentUserData!.schoolClass,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Moje skóre',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 48,
                                  width: double.infinity, // Set the width to expand to the available space
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Celkovo',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text('${currentUserData!.points} / ${capitolOne}'),
                                            SizedBox(width: 8),
                                            Container(
                                              width: 150,
                                              height: 15,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: LinearProgressIndicator(
                                                  value: capitolOne != 0 ? currentUserData!.points / capitolOne : 0,
                                                  backgroundColor: Colors.grey[300],
                                                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.green.main),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(color: Colors.grey),
                                Container(
                                  height: 48,
                                  width: double.infinity, // Set the width to expand to the available space
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Tento týždeň:',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              '${currentUserData!.points}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Color(0xfff9BB00),
                                              ),
                                            ),
                                            Icon(
                                              Icons.star,
                                              color: Color(0xfff9BB00),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(color: Colors.grey),
                                Container(
                                  height: 48,
                                  width: double.infinity, // Set the width to expand to the available space
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Celý čas:',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              '${currentUserData!.points}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Color(0xfff9BB00),
                                              ),
                                            ),
                                            Icon(
                                              Icons.star,
                                              color: Color(0xfff9BB00),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(color: Colors.grey),
                                Container(
                                  height: 48,
                                  width: double.infinity, // Set the width to expand to the available space
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Diskusné fórum:',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${currentUserData!.active ? 'Aktívny prispievateľ' : 'Neaktívny prispievateľ'}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: currentUserData!.active ? Colors.green : Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ukončené kapitoly',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: 50,
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rebríček',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            height: 300,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [],
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                          setState(() {
                            fetchUserData();
                          });
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                          );
                        },
                        child: Text('SignOut'),
                      ),
                    ],
                  ),
                ),
              )
          )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}