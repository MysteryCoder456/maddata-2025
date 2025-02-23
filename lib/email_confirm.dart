import 'package:flutter/material.dart';

class EmailConfirmPage extends StatelessWidget {
  const EmailConfirmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Email Confirmation')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Please check your email to confirm your email address'),
          ],
        ),
      ),
    );
  }
}
