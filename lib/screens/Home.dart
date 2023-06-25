import 'package:flutter/material.dart';
import 'package:infomentor/widgets/ReWidgets.dart';
import 'package:infomentor/screens/Learning.dart';
import 'package:infomentor/screens/Challenges.dart';
import 'package:infomentor/screens/Discussions.dart';
import 'package:infomentor/fetch.dart'; // Import the UserData class and fetchUser function
import 'package:firebase_auth/firebase_auth.dart';
import 'package:infomentor/screens/Profile.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;
  UserData? currentUserData;

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Fetch the user data when the app starts
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff4b4fb3), // Set the appbar background color
        elevation: 0, // Remove the appbar elevation
        actions: [
          if (currentUserData != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10), // Add horizontal padding between the actions
              child: Row(
                children: [
                  Text(
                    '${currentUserData!.points} / 50',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xfff9BB00),
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.star,
                    color: Color(0xfff9BB00), // Use yellow star icon
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                      Icons.notifications_outlined,
                      color: Colors.white, // Use white bell icon
                    ),
                    onPressed: () {
                      // Handle notification icon press
                    },
                  ),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      // Open profile overlay
                      showProfileOverlay();
                    },
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(currentUserData!.image), // Use user's image
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      bottomNavigationBar: reBottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
          Container(
            child: Text('home'),
          ), // Replace with your actual widget for the Home page
          Challenges(capitolsId: "0"),
          Discussions(),
          Learning(),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

void showProfileOverlay() {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(30), // Set the preferred height of the app bar
          child: AppBar(
            backgroundColor: Colors.transparent, // Make the app bar transparent
            elevation: 0, // Remove the app bar elevation
            leading: SizedBox(
              height: 30, // Set the height of the button
              width: 60, // Set the width of the button
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                color: Colors.grey, // Set the color of the back button to black
                onPressed: () {
                  Navigator.of(context).pop(); // Navigate back when the back button is pressed
                },
              ),
            ),
          ),
        ),
        body: Profile(), // Display the Profile widget
      ),
    ),
  );
}


}
