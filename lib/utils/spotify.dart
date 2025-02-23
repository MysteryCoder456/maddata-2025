import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List<dynamic>> getTopTracks(String providerToken) async {
  final url = Uri.https('api.spotify.com', '/v1/me/top/tracks', {
    'limit': '50',
    'offset': '0',
    'time_range': 'short_term',
  });
  final response = await http.get(
    url,
    headers: {"Authorization": "Bearer $providerToken"},
  );
  final jsonBody = JsonDecoder().convert(response.body);

  if (response.statusCode != 200) {
    throw Exception(jsonBody['error']['message']);
  }
  return jsonBody['items'];
}

Future<List<dynamic>> getTopArtists(String providerToken) async {
  final url = Uri.https('api.spotify.com', '/v1/me/top/artists', {
    'limit': '50',
    'offset': '0',
    'time_range': 'short_term',
  });
  final response = await http.get(
    url,
    headers: {"Authorization": "Bearer $providerToken"},
  );
  final jsonBody = JsonDecoder().convert(response.body);

  if (response.statusCode != 200) {
    throw Exception(jsonBody['error']['message']);
  }
  return jsonBody['items'];
}

Future<List<String>> getTopGenres(String providerToken) async {
  List<dynamic> topArtists = await getTopArtists(providerToken);
  Set<String> genres = {};

  for (var artist in topArtists) {
    for (var genre in artist['genres']) {
      genres.add(genre);
    }
  }

  return genres.toList();
}
