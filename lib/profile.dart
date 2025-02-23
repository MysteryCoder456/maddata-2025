import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final client = Supabase.instance.client;

  void _editProfile(String name, String bio) {
    TextEditingController nameController = TextEditingController(text: name);
    TextEditingController bioController = TextEditingController(text: bio);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Profile", style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Name", hintText: "Your full name"),
              ),
              TextField(
                controller: bioController,
                maxLines: 8,
                minLines: 2,
                decoration: InputDecoration(labelText: "Bio", hintText: "Tell us about yourself"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                setState(() {
                  name = nameController.text;
                  bio = bioController.text;
                });

                final userId = client.auth.currentUser!.id;
                await client.auth.updateUser(UserAttributes(data: {"full_name": name}));
                await client
                    .from('profiles')
                    .update({'id': userId, 'display_name': name, "bio": bio})
                    .eq('id', userId);

                Navigator.pop(context);
              },
              child: Text("Save", style: TextStyle(color: Colors.blue)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = client.auth.currentSession!.user.id;
    final stream = client
        .from('profiles')
        .stream(primaryKey: ['id'])
        .eq('id', userId);

    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(backgroundColor: Colors.black);
        }

        final userData = snapshot.data![0];
        final String displayName = userData['display_name'];
        final String? avatarUrl = userData['avatar_url'];
        final String bio = userData['bio'];
        final String recentSong = "Song Title - Artist"; // Placeholder for the most recent song

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              "Profile",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.black),
                onPressed: () => _editProfile(displayName, bio),
              ),
              IconButton(
                icon: Icon(Icons.exit_to_app, color: Colors.red),
                onPressed: client.auth.signOut,
              ),
            ],
          ),
          body: Stack(
            children: [
              // Gradient Background
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF001F3F), // Dark Blue
                      Color(0xFF005F99), // Aesthetic Blue
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),

              // Music Notes in Background
              Positioned(top: 50, left: 30, child: Icon(Icons.music_note, color: Colors.white, size: 40)),
              Positioned(top: 60, right: 100, child: Icon(Icons.music_note, color: Colors.white, size: 35)),
              Positioned(bottom: 100, left: 70, child: Icon(Icons.music_note, color: Colors.white, size: 38)),
              Positioned(bottom: 100, right: 150, child: Icon(Icons.music_note, color: Colors.white, size: 45)),
              Positioned(top: 210, left: 140, child: Icon(Icons.music_note, color: Colors.white, size: 32)),
              Positioned(bottom: 200, right: 10, child: Icon(Icons.music_note, color: Colors.white, size: 37)),
              Positioned(top: 200, right: 20, child: Icon(Icons.music_note, color: Colors.white, size: 34)),
              Positioned(bottom: 50, left: 120, child: Icon(Icons.music_note, color: Colors.white, size: 42)),

              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 26), // Keeps elements closer to AppBar
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[800],
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: avatarUrl == null
                          ? Icon(Icons.person, size: 90, color: Colors.white)
                          : ClipOval(child: Image.network(avatarUrl)),
                    ),
                    SizedBox(height: 26), // Reduced space
                    Text(
                      displayName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34, // Bigger font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 34), // Less spacing between elements
                    Text(
                      "🎶 Most Recent Song:",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      recentSong,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 40), // Less spacing
                    Text(
                      "📝 Bio:",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        bio,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}