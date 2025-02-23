import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  final String? userId;

  const ProfilePage({super.key, this.userId});

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
          title: Text(
            "Edit Profile",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  hintText: "Your full name",
                ),
              ),
              TextField(
                controller: bioController,
                maxLines: 8,
                minLines: 2,
                decoration: InputDecoration(
                  labelText: "Bio",
                  hintText: "Tell us about yourself",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog without saving
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  name = nameController.text;
                  bio = bioController.text;
                });

                final userId = client.auth.currentUser!.id;
                await client.auth.updateUser(
                  UserAttributes(data: {"full_name": name}),
                );
                await client
                    .from('profiles')
                    .update({'id': userId, 'display_name': name, "bio": bio})
                    .eq('id', userId);

                Navigator.pop(context);
              },
              child: Text("Save", style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String currentUserId = client.auth.currentSession!.user.id;
    final String viewingUserId = widget.userId ?? currentUserId;

    final stream = client
        .from('profiles')
        .stream(primaryKey: ['id'])
        .eq('id', viewingUserId);

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
        final String recentSong =
            userData['match_params']['top_tracks'][0]['name'];

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
            actions:
                currentUserId == viewingUserId
                    ? [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.black),
                        onPressed: () => _editProfile(displayName, bio),
                      ),
                      IconButton(
                        icon: Icon(Icons.exit_to_app, color: Colors.red),
                        onPressed: client.auth.signOut,
                      ),
                    ]
                    : [],
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
                      child:
                          avatarUrl == null
                              ? Icon(
                                Icons.person,
                                size: 90,
                                color: Colors.white,
                              )
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
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        "🎶 Top Song:",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      recentSong,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      textAlign: TextAlign.center,
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
                        style: TextStyle(color: Colors.white, fontSize: 18),
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

