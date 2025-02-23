import 'package:flutter/material.dart';
import 'graph.dart'; // Import the GraphPlaceholder widget

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set the background color to black
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Stats",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding for some spacing
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align items to the left
          children: [
            Text(
              "Weekly Global Stats", // Text displayed at the top
              style: TextStyle(
                fontSize: 24, // Text size
                color: Colors.white, // Text color white
                fontWeight: FontWeight.bold, // Bold text
              ),
            ),
            SizedBox(height: 30), // Space between title and graph
            // Add the GraphPlaceholder widget here
            Image.asset("figure.png", width: 551, height: 423),
          ],
        ),
      ),
    );
  }
}

