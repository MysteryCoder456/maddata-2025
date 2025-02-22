import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final String username;
  
  final String topTrack;
  
  final String matchPercent;

  const UserCard({super.key, required this.username, required this.topTrack, required this.matchPercent});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Widget with extended height
            Container(
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
                      CircleAvatar(
                        radius: 50
                      ),
                      SizedBox(width: 16), // Space between profile picture and text
                      Padding(
                        padding: const EdgeInsets.only(left: 150, bottom: 30),
                        child: Text(
                          matchPercent,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ))
                      
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    username,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left, // Center the username text
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Top Track for this week: " + topTrack,
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.left, // Center the bio text
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }
}