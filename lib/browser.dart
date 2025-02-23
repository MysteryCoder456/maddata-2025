import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'user_card.dart';

class BrowserView extends StatelessWidget {
  const BrowserView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        UserCard(
          username: "Aria Talathi",
          topTrack: "Cry For Me - the Weeknd",
          matchPercent: "95%",
        ),
        UserCard(
          username: "Rehatbir Singh",
          topTrack: "Gaand Mein Danda",
          matchPercent: "100%",
        ),
        UserCard(
          username: "namboo the Bumboo",
          topTrack: "lowkey gay",
          matchPercent: "69%",
        ),
      ],
    );
  }
}
