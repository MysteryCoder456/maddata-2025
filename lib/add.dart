import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MoodView extends StatefulWidget {
  const MoodView({super.key});

  @override
  State<MoodView> createState() => _MoodViewState();
}

class _MoodViewState extends State<MoodView> {
  double _moodValue = 0;
  final List<String> _moods = ['Sad', 'Calm', 'Happy', 'Excited'];
  List<dynamic> _playlist = [];

  // Fetch data from Spotify based on user mood
  Future<void> fetchPlaylist() async {
    final session = Supabase.instance.client.auth.currentSession!;
    final token = session.providerToken;
    if (token == null) {
      print("No token found");
      return;
    }

    print("Token: $token");

    final genreUrl = Uri.parse('https://api.spotify.com/v1/recommendations/available-genre-seeds');
    final genreResponse = await http.get(genreUrl, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if (genreResponse.statusCode == 200) {
      final genres = json.decode(genreResponse.body)['genres'] as List<dynamic>;
      if (genres.isEmpty) {
        print("No genres available");
        return;
      }

      // Map mood to genre (adjust as needed)
      final moodToGenre = {
        'Sad': 'blues',
        'Calm': 'chill',
        'Happy': 'pop',
        'Excited': 'rock'
      };
      final selectedMood = _moods[_moodValue.toInt()];
      final selectedGenre = moodToGenre[selectedMood] ?? genres.first;

      print("Selected Genre: $selectedGenre");

      // Fetch playlist based on selected genre
      final playlistUrl = Uri.parse(
          'https://api.spotify.com/v1/recommendations?limit=10&seed_genres=$selectedGenre');
      final playlistResponse = await http.get(playlistUrl, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      if (playlistResponse.statusCode == 200) {
        final data = json.decode(playlistResponse.body);
        setState(() {
          _playlist = data['tracks'];
        });
      } else {
        print("Failed to fetch playlists: ${playlistResponse.statusCode}");
        print("Response Body: ${playlistResponse.body}");
      }
    } else {
      print("Failed to fetch genres: ${genreResponse.statusCode}");
      print("Response Body: ${genreResponse.body}");
    }
  }

  // Get the corresponding emoji based on the selected mood
  Widget _getMoodFace() {
    String mood = _moods[_moodValue.toInt()];
    IconData icon;
    switch (mood) {
      case 'Sad':
        icon = Icons.sentiment_dissatisfied; // Upside down smile
        break;
      case 'Calm':
        icon = Icons.sentiment_neutral; // Straight face
        break;
      case 'Happy':
        icon = Icons.sentiment_satisfied; // Normal smile
        break;
      case 'Excited':
        icon = Icons.sentiment_very_satisfied; // Wide smile
        break;
      default:
        icon = Icons.sentiment_neutral; // Default
    }
    return Icon(
      icon,
      size: 100,
      color: Colors.blue[_moodValue.toInt() * 100 + 200],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mood Playlist'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display the mood emoji based on slider value
          _getMoodFace(),

          // Mood slider
          Slider(
            value: _moodValue,
            min: 0,
            max: 3,
            divisions: 3,
            label: _moods[_moodValue.toInt()],
            onChanged: (value) {
              setState(() => _moodValue = value);
            },
          ),

          // Submit button to fetch playlist
          ElevatedButton(
            onPressed: fetchPlaylist,
            child: Text('Generate Playlist'),
          ),

          // Display the playlist with tracks
          Expanded(
            child: ListView.builder(
              itemCount: _playlist.length,
              itemBuilder: (context, index) {
                final track = _playlist[index];
                return ListTile(
                  leading: Image.network(track['album']['images'][0]['url']),
                  title: Text(track['name']),
                  subtitle: Text(track['artists'][0]['name']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}