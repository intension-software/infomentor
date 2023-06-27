import 'package:flutter/material.dart';
import 'package:infomentor/backend/fetchCapitols.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:infomentor/backend/fetchUser.dart';
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
          currentUserData = null;
        });
        print('User is not logged in.');
      }
    } catch (e) {
      setState(() {
        currentUserData = null;
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
    super.dispose();
  }

  Future<void> signOutAndReload() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Login()),
      (route) => false, // Remove all previous routes from the stack
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentUserData != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/profile_image.png'),
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
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Celkovo',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: LinearProgressIndicator(
                                            value: capitolOne != 0 ? currentUserData!.points / capitolOne : 0,
                                            backgroundColor: Colors.grey[300],
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Divider(color: Colors.grey),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  SizedBox(height: 8),
                                  Divider(color: Colors.grey),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  Divider(color: Colors.grey),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Diskusne fórum:',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${currentUserData!.active ? 'Aktívny prispievateľ' : 'Neaktívny pripievateľ'}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: currentUserData!.active ? Colors.green : Colors.red,
                                          ),
                                        ),
                                      ],
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
                      ],
                    ),
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
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
