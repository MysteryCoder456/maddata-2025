import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

import 'user_card.dart';

class BrowserView extends StatefulWidget {
  const BrowserView({super.key});

  @override
  State<BrowserView> createState() => _BrowserViewState();
}

class _BrowserViewState extends State<BrowserView> {
  final client = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    final userId = client.auth.currentSession!.user.id;
    final String host = "https://mad.codeboi.dev/match";

    final matchesFuture = http.post(
      Uri.parse(host),
      headers: {"Content-Type": "application/json"},
      body: JsonEncoder().convert({"user1_id": userId}),
    );

    return FutureBuilder(
      future: matchesFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final jsonBody = JsonDecoder().convert(snapshot.data!.body);

        final List<Widget> list = [];
        for (final item in jsonBody) {
          final matchPercent = (item["match_percentage"] as num);
          final userFuture =
              client
                  .from('profiles')
                  .select()
                  .eq('id', item['id'])
                  .limit(1)
                  .single();

          list.add(
            FutureBuilder(
              future: userFuture,
              builder: (context, snapshot) {
                String username = "Username";
                String topTrack = "Top Track";
                String? avatarUrl;

                if (snapshot.hasData) {
                  final userData = snapshot.data!;
                  username = userData['display_name'];
                  topTrack = userData['match_params']['top_tracks'][0]['name'];
                  avatarUrl = userData['avatar_url'];
                }

                return UserCard(
                  userId: item['id'],
                  username: username,
                  topTrack: topTrack,
                  matchPercent: matchPercent,
                  avatarUrl: avatarUrl,
                );
              },
            ),
          );
        }

        return ListView(children: list);
      },
    );
  }
}
