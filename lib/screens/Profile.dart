import 'package:flutter/material.dart';
import 'package:infomentor/fetch.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  UserData? currentUserData;
  int capitolOne = 0;
  // int capitolTwo = 0;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchCapitolsData(); // Fetch the user data when the widget is initialized
  }

  Future<void> fetchUserData() async {
    try {
      // Retrieve the Firebase Auth user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Fetch the user data using the fetchUser function
        UserData userData = await fetchUser(user.uid);
        setState(() {
          currentUserData = userData;
        });
      } else {
        print('User is not logged in.');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> fetchCapitolsData() async {
    try {
      FetchResult one = await fetchCapitols("0");
      //FetchResult two = await fetchCapitols("1");


      setState(() {
        capitolOne = one.capitolsData!.points;
        // capitolTwo = two.capitolsData!.points;
      });
    } catch (e) {
      print('Error fetching question data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentUserData != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/profile_image.png'), // Replace with the path to your asset image
                    radius: 80, // Set the radius of the profile picture
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
                                      value: currentUserData!.points / capitolOne /*+ capitolTwo*/, // Assuming the maximum points is 34
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
                                  Row(children: [
                                    
                                    Text(
                                    '${currentUserData!.points}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xfff9BB00)
                                    ),
                                  ),
                                  Icon(
                                      Icons.star,
                                      color: Color(0xfff9BB00), // Use yellow star icon
                                    ),
                                  ],
                                  )
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
                                  Row(children: [
                                    
                                    Text(
                                    '${currentUserData!.points}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xfff9BB00)
                                    ),
                                  ),
                                  Icon(
                                      Icons.star,
                                      color: Color(0xfff9BB00), // Use yellow star icon
                                    ),
                                  ],
                                  )
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
                                    'Diskusne fórun:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${currentUserData!.active ? 'Aktívny prispievateľ' : 'Neaktívny pripievateľ'}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: currentUserData!.active ? Colors.green : Colors.red
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
                              children: [
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
                              children: [
                              ],
                              
                        ),
                        
                      ),
                    ],
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
