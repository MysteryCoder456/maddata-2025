import 'package:flutter/material.dart';

import 'user_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212), // Background color
      appBar: AppBar(
        title: Text("Welcome, User!", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        children: [
          UserCard(
            username: "Aria Talathi",
            topTrack: "Cry For Me - the Weeknd",
            matchPercent: "95%",
          ),
          UserCard(
            username: "Rehatbir Singh",
            topTrack: "Gaand Mein Danda",
            matchPercent: "100%",
          ),
        ],
      ),
    );
  }
}
