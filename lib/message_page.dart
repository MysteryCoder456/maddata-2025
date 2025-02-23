// message_page.dart

import 'package:flutter/material.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Messages',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Search functionality (if needed)
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Display messages (Placeholder for messages)
          Expanded(
            child: ListView.builder(
              itemCount: 10, // You can increase this count or make it dynamic
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey[700],
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      'User $index',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'This is a message from user $index',
                      style: TextStyle(color: Colors.grey),
                    ),
                    trailing: Icon(
                      Icons.access_time,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                );
              },
            ),
          ),

          // Message input area
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Message input field
                Expanded(
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                // Send button
                IconButton(
                  icon: Icon(Icons.send, color: Colors.white),
                  onPressed: () {
                    // Send message action (if needed)
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black, // Set background to black for the page
    );
  }
}