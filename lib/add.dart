import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MoodView extends StatefulWidget {
  const MoodView({super.key});

  @override
  State<MoodView> createState() => _MoodViewState();
}

class _MoodViewState extends State<MoodView> {
  double _moodValue = 0;
  final List<String> _moods = ['Sad', 'Calm', 'Happy', 'Excited'];

  // Map moods to corresponding Spotify playlist URLs
  final Map<String, String> moodPlaylists = {
    'Sad': 'https://open.spotify.com/playlist/37i9dQZF1EIg6gLNLe52Bd',
    'Calm': 'https://open.spotify.com/playlist/37i9dQZF1EIgZ4krjKXewt',
    'Happy': 'https://open.spotify.com/playlist/37i9dQZF1EIgG2NEOhqsD7',
    'Excited': 'https://open.spotify.com/playlist/37i9dQZF1EIg65X9FWVODX',
  };

  // Function to open Spotify playlist
  Future<void> _openPlaylist() async {
    String selectedMood = _moods[_moodValue.toInt()];
    String playlistUrl = moodPlaylists[selectedMood]!;
    
    final Uri url = Uri.parse(playlistUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $playlistUrl';
    }
  }

  // Get the corresponding emoji based on the selected mood
  Widget _getMoodFace() {
    String mood = _moods[_moodValue.toInt()];
    IconData icon;
    switch (mood) {
      case 'Sad':
        icon = Icons.sentiment_dissatisfied;
        break;
      case 'Calm':
        icon = Icons.sentiment_neutral;
        break;
      case 'Happy':
        icon = Icons.sentiment_satisfied;
        break;
      case 'Excited':
        icon = Icons.sentiment_very_satisfied;
        break;
      default:
        icon = Icons.sentiment_neutral;
    }
    return Icon(
      icon,
      size: 100,
      color: Colors.blue[_moodValue.toInt() * 100 + 200],
    );
  }

  @override
  Widget build(BuildContext context) {
    String selectedMood = _moods[_moodValue.toInt()];

    return Scaffold(
      appBar: AppBar(
        title: Text('Mood Playlist'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _getMoodFace(),
          Slider(
            value: _moodValue,
            min: 0,
            max: 3,
            divisions: 3,
            label: selectedMood,
            onChanged: (value) {
              setState(() => _moodValue = value);
            },
          ),
          Text(
            "Now Playing: $selectedMood Mix",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _openPlaylist,
            child: Text('Open Playlist in Spotify'),
          ),
        ],
      ),
    );
  }
}