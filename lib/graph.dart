import 'package:flutter/material.dart';

class GraphPlaceholder extends StatelessWidget {
  const GraphPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Make it take up the full width
      height: 300, // Height of the placeholder
      decoration: BoxDecoration(
        color: Colors.grey[800], // Dark gray background
        borderRadius: BorderRadius.circular(8), // Rounded corners
      ),
      child: Center(
        child: Icon(
          Icons.bar_chart, // Icon for the placeholder
          size: 100, // Set the size of the icon
          color: Colors.white, // Color of the icon
        ),
      ),
    );
  }
}