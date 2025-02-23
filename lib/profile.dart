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
    // Create controllers for the bio and location TextFields
    TextEditingController nameController = TextEditingController(text: name);
    TextEditingController bioController = TextEditingController(text: bio);

    // Show the dialog to edit bio and location
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Profile"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: bioController,
                maxLines: 8, // Allow bio text to be longer
                minLines: 2, // Set a minimum height for the bio TextField
                decoration: InputDecoration(labelText: "Bio"),
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
                  // Save the changes to bio and location
                  name = nameController.text;
                  bio = bioController.text;
                });

                // Push changes to Supabase
                final userId = client.auth.currentUser!.id;
                await client.auth.updateUser(
                  UserAttributes(data: {"full_name": name}),
                );
                await client
                    .from('profiles')
                    .update({'id': userId, 'display_name': name, "bio": bio})
                    .eq('id', userId);

                Navigator.pop(context); // Close the dialog after saving
              },
              child: Text("Save"),
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

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text(
              "Profile",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            actions:
                currentUserId == viewingUserId
                    ? [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.white),
                        onPressed: () => _editProfile(displayName, bio),
                      ),
                      IconButton(
                        icon: Icon(Icons.exit_to_app, color: Colors.red),
                        onPressed: client.auth.signOut,
                      ),
                    ]
                    : [],
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[700],
                    ),
                    child:
                        avatarUrl == null
                            ? Icon(Icons.person, size: 50, color: Colors.white)
                            : ClipOval(child: Image.network(avatarUrl)),
                  ),
                  SizedBox(height: 15),
                  Text(
                    displayName,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  //SizedBox(height: 15),
                  //Text(
                  //  "🎵 Recent Song: $recentSong",
                  //  style: TextStyle(color: Colors.white, fontSize: 16),
                  //),
                  SizedBox(height: 40),
                  Text(
                    "📝Bio:",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    bio,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
