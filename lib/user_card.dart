import 'package:flutter/material.dart';
import 'profile.dart'; // Import the ProfilePage

class UserCard extends StatelessWidget {
  final String username;
  final String topTrack;
  final num matchPercent;
  //final String avatar_url;

  const UserCard({
    super.key,
    required this.username,
    required this.topTrack,
    required this.matchPercent,
    //this.avatar_url,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Profile Widget with extended height
          GestureDetector(
            onTap: () {
              // Navigate to ProfilePage when card is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => ProfilePage(), // Navigate to ProfilePage
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 4),
                    blurRadius: 10,
                  ),
                ],
              ),
              width: double.infinity,
              height: 250, // Increased height of the profile widget
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      //ClipOval(child: Image.network(avatar_url)),
                       //: Icon(Icons.person, size: 90, color: Colors.white),
                      SizedBox(
                        width: 16,
                      ), // Space between profile picture and text
                      Padding(
                        padding: const EdgeInsets.only(left: 150, bottom: 30),
                        child: Text(
                          "${matchPercent.round()}%",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    username,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Top Track for this week: " + topTrack,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

