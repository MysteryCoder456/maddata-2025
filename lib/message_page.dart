import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  String? selectedChat;
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userId = Supabase.instance.client.auth.currentUser!.id;
    final stream = Supabase.instance.client
        .from('profiles')
        .stream(primaryKey: ['id']);

    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final List<Map<String, dynamic>> profiles = snapshot.data!;
        for (int i = 0; i < profiles.length; i++) {
          profiles[i]['messages'] = [
            {
              'sender': profiles[i]['display_name'],
              'text': 'Hello from ${profiles[i]['display_name']}.',
            },
            {
              'sender': profiles[i]['display_name'],
              'text': 'Your music taste is GOATED!',
            },
          ];
        }

        // Don't wanna text yourself, right?
        profiles.removeWhere((profile) => profile['id'] == userId);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text('Messages', style: TextStyle(color: Colors.white)),
            actions: [
              IconButton(
                icon: Icon(Icons.search, color: Colors.white),
                onPressed: () {
                  // Search functionality (if needed)
                },
              ),
            ],
          ),
          body:
              selectedChat == null
                  ? _buildChatList(profiles)
                  : _buildChatView(profiles, userId),
          backgroundColor: Colors.black, // Set background to black for the page
        );
      },
    );
  }

  // Build the list of chats
  Widget _buildChatList(List<Map<String, dynamic>> profiles) {
    return ListView.builder(
      itemCount: profiles.length,
      itemBuilder: (context, index) {
        final chat = profiles[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey[700],
              foregroundImage:
                  chat['avatar_url'] != null
                      ? NetworkImage(chat['avatar_url'])
                      : null,
            ),
            title: Text(
              chat['display_name'],
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              chat['messages'].isNotEmpty
                  ? chat['messages'].last['text']
                  : 'No messages yet',
              style: TextStyle(color: Colors.grey),
            ),
            trailing: Icon(Icons.access_time, color: Colors.grey, size: 20),
            onTap: () {
              // Open the specific chat
              setState(() {
                selectedChat = chat['id'];
              });
            },
          ),
        );
      },
    );
  }

  // Build the individual chat view
  Widget _buildChatView(List<Map<String, dynamic>> chats, String currentUser) {
    final chat = chats.firstWhere((chat) => chat['id'] == selectedChat);

    return Column(
      children: [
        // Chat messages
        Expanded(
          child: ListView.builder(
            reverse: true, // Make the most recent message at the bottom
            itemCount: chat['messages'].length,
            itemBuilder: (context, index) {
              final message =
                  chat['messages'][chat['messages'].length - 1 - index];
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
                      chat['messages'].add({
                        'sender': currentUser,
                        'text': messageController.text,
                      });
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
          child: Text(text, style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

