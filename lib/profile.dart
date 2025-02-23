import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final client = Supabase.instance.client;

  String location = "Madison, WI";

  void _editProfile(String name, String bio) {
    // Create controllers for the bio and location TextFields
    TextEditingController nameController = TextEditingController(text: name);
    TextEditingController locationController = TextEditingController(
      text: location,
    );
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
                controller: locationController,
                decoration: InputDecoration(labelText: "Location"),
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
              onPressed: () async {
                setState(() {
                  // Save the changes to bio and location
                  name = nameController.text;
                  bio = bioController.text;
                  location = locationController.text;
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
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog without saving
              },
              child: Text("Cancel"),
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
            actions: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.white),
                onPressed: () => _editProfile(displayName, bio),
              ),
            ],
          ),
          body: Center(
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
                SizedBox(height: 8),
                Text(
                  "📍 $location",
                  style: TextStyle(color: Colors.white, fontSize: 16),
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
                Text(bio, style: TextStyle(color: Colors.white, fontSize: 16)),
              ],
            ),
          ),
        );
      },
    );
  }
}
