import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MessagePage(),
    );
  }
}

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  // Sample data for chats
  final List<Map<String, dynamic>> chats = List.generate(10, (index) {
    return {
      'username': 'User $index',
      'messages': [
        {'sender': 'User $index', 'text': 'Hello from User $index!'},
        {'sender': 'User $index', 'text': 'How are you doing?'},
      ],
    };
  });

  String? selectedChat;
  TextEditingController messageController = TextEditingController();
  String currentUser = 'User 0'; // Change this to the actual user

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
      body: selectedChat == null ? _buildChatList() : _buildChatView(),
      backgroundColor: Colors.black, // Set background to black for the page
    );
  }

  // Build the list of chats
  Widget _buildChatList() {
    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
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
              chat['username'],
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              chat['messages'].isNotEmpty ? chat['messages'].last['text'] : 'No messages yet',
              style: TextStyle(color: Colors.grey),
            ),
            trailing: Icon(
              Icons.access_time,
              color: Colors.grey,
              size: 20,
            ),
            onTap: () {
              // Open the specific chat
              setState(() {
                selectedChat = chat['username'];
              });
            },
          ),
        );
      },
    );
  }

  // Build the individual chat view
  Widget _buildChatView() {
    final chat = chats.firstWhere((chat) => chat['username'] == selectedChat);
    return Column(
      children: [
        // Chat messages
        Expanded(
          child: ListView.builder(
            reverse: true, // Make the most recent message at the bottom
            itemCount: chat['messages'].length,
            itemBuilder: (context, index) {
              final message = chat['messages'][chat['messages'].length - 1 - index];
              bool isCurrentUser = message['sender'] == currentUser;
              return _buildMessageBubble(message['text'], isCurrentUser);
            },
          ),
        ),

        // Message input area (only visible when in a chat)
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              // Message input field
              Expanded(
                child: TextField(
                  controller: messageController,
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
                  if (messageController.text.isNotEmpty) {
                    setState(() {
                      chat['messages'].add({'sender': currentUser, 'text': messageController.text});
                    });
                    messageController.clear();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Build a message bubble with proper alignment
  Widget _buildMessageBubble(String text, bool isCurrentUser) {
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: BoxDecoration(
            color: isCurrentUser ? Colors.purple : Colors.grey[700],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}