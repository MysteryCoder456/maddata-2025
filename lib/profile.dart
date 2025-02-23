import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name= "nkksxkks";
  String location = "Madison, WI";
  String recentSong = "Blinding Lights - The Weeknd";
  String bio = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

  void _editProfile() {
    // Create controllers for the bio and location TextFields
    TextEditingController nameController = TextEditingController(text: name);
    TextEditingController locationController = TextEditingController(text: location);
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
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  // Save the changes to bio and location
                  name = nameController.text;
                  location = locationController.text;
                });
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Profile", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: _editProfile,
          )
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[700],
              ),
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            SizedBox(height: 15),
            Text(name, style: TextStyle(color: Colors.white, fontSize: 18)),
            SizedBox(height: 8),
            Text("📍 $location", style: TextStyle(color: Colors.white, fontSize: 16)),
            SizedBox(height: 15),
            Text("🎵 Recent Song: $recentSong", style: TextStyle(color: Colors.white, fontSize: 16)),
            SizedBox(height: 40),
            Text("📝Bio: \n$bio", style: TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
