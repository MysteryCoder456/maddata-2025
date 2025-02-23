import 'package:flutter/material.dart';
import 'package:maddata2025/message_page.dart';
import 'package:maddata2025/profile.dart';
import 'package:maddata2025/stats.dart';

import 'browser.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Color(0xFF121212), // Background color
        appBar: AppBar(
          title: Text("Welcome, User!", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        bottomNavigationBar: PreferredSize(
          preferredSize: Size.fromHeight(10),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: const TabBar(
              dividerColor: Colors.transparent,
              tabs: [
                Tab(
                      icon: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5), // Adjust the bottom padding to move the icon higher
                        child: Icon(Icons.home, size: 36), // Set your desired icon size here
                      ),
                    ),
                Tab(icon: Padding(
                        padding: EdgeInsets.symmetric(vertical: 3), // Adjust the bottom padding to move the icon higher
                        child: Icon(Icons.message, size: 36), )),
                Tab(icon: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5), // Adjust the bottom padding to move the icon higher
                        child: Icon(Icons.language_outlined, size: 36), )),
                Tab(icon: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5), // Adjust the bottom padding to move the icon higher
                        child: Icon(Icons.perm_identity, size: 36),)),
              ],
            ),
          ),
        ),
        body: const TabBarView(
          children: [BrowserView(), MessagePage(), StatsPage(), ProfilePage()],
        ),
      ),
    );
  }
}
