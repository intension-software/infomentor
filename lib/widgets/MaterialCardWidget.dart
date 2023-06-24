import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:infomentor/fetch.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MaterialCardWidget extends StatefulWidget {
  final String materialId;
  final String image;
  final String title;
  final String subject;
  final String type;
  final String description;
  final String association;
  final String link;
  final String video;

  MaterialCardWidget({
    required this.materialId,
    required this.image,
    required this.title,
    required this.subject,
    required this.type,
    required this.description,
    required this.association,
    required this.link,
    required this.video,
  });

  @override
  _MaterialCardWidgetState createState() => _MaterialCardWidgetState();
}

class _MaterialCardWidgetState extends State<MaterialCardWidget> {
  bool isHeartFilled = false;
  UserData? userData;
  String? userId;
  late YoutubePlayerController youtubeController;

  @override
  void initState() {
    super.initState();
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      userId = currentUser.uid;
      fetchUser(userId!).then((user) {
        setState(() {
          userData = user;
          isHeartFilled = userData!.materials.contains(widget.materialId);
        });
      });
    }

    youtubeController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.video) ?? '',
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String imageAsset = widget.image.isEmpty ? 'placeholder.png' : widget.image;

    return GestureDetector(
      onTap: () {
        _showOverlay(context);
      },
      child: Container(
        margin: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage(imageAsset),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.all(8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20), // Adjust spacing from the top for the text
                      Text(
                        widget.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        widget.subject,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        widget.type,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Text(
                  widget.type,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      isHeartFilled ? Icons.favorite : Icons.favorite_outline,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      toggleFavorite();
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.link,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _launchURL(widget.link);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOverlay(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: SizedBox(
              height: 30,
              width: 60,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                color: Colors.grey,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.subject,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.type,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.description,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.association,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      InkWell(
                        onTap: () {
                          _launchURL(widget.link);
                        },
                        child: Row(
                          children: [
                            Icon(Icons.link),
                            SizedBox(width: 8),
                            Text(
                              'Go to Link',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      if (widget.video.isNotEmpty && _isValidYouTubeLink(widget.video))
                        YoutubePlayerBuilder(
                          player: YoutubePlayer(
                            controller: youtubeController,
                            showVideoProgressIndicator: true,
                          ),
                          builder: (context, player) {
                            return player;
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isValidYouTubeLink(String link) {
    final Uri? uri = Uri.tryParse(link);
    if (uri != null && uri.host == 'www.youtube.com') {
      return true;
    }
    return false;
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void toggleFavorite() {
    final String materialId = widget.materialId;

    setState(() {
      if (isHeartFilled) {
        userData!.materials.remove(materialId);
      } else {
        userData!.materials.add(materialId);
      }

      isHeartFilled = !isHeartFilled;
    });

    saveUserDataToFirestore(userData!);
  }

  Future<void> saveUserDataToFirestore(UserData userData) async {
    try {
      // Reference to the user document in Firestore
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(userId);

      // Convert userData object to a Map
      Map<String, dynamic> userDataMap = {
        'email': userData.email,
        'name': userData.name,
        'active': userData.active,
        'schoolClass': userData.schoolClass,
        'image': userData.image,
        'surname': userData.surname,
        'points': userData.points,
        'capitols': userData.capitols,
        'materials': userData.materials,
      };

      // Update the user document in Firestore with the new userDataMap
      await userRef.update(userDataMap);
    } catch (e) {
      print('Error saving user data to Firestore: $e');
      rethrow;
    }
  }
}
