import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String bio = "nkksxkks";
  String location = "Madison, WI";
  String recentSong = "Blinding Lights - The Weeknd";

  void _editProfile() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController bioController = TextEditingController(text: bio);
        TextEditingController locationController = TextEditingController(text: location);
        return AlertDialog(
          title: Text("Edit Profile"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: bioController, decoration: InputDecoration(labelText: "Bio")),
              TextField(controller: locationController, decoration: InputDecoration(labelText: "Location")),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  bio = bioController.text;
                  location = locationController.text;
                });
                Navigator.pop(context);
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
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Profile", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: _editProfile,
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            Text(bio, style: TextStyle(color: Colors.white, fontSize: 18)),
            SizedBox(height: 8),
            Text("📍 $location", style: TextStyle(color: Colors.grey, fontSize: 16)),
            SizedBox(height: 15),
            Text("🎵 Recent Song: $recentSong", style: TextStyle(color: Colors.greenAccent, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
