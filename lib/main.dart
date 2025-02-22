import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import 'dart:math';
import 'home.dart';

final goRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/login-success', redirect: (context, state) => '/home'),
    GoRoute(path: '/home', builder: (context, state) => const HomePage()),
  ],
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: put these into .env file
  await Supabase.initialize(
    url: 'https://nxnrgycurrpxzkskcecz.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im54bnJneWN1cnJweHprc2tjZWN6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDAyNTMxODQsImV4cCI6MjA1NTgyOTE4NH0.hpK_TYKhLKMNn9ha_cdXFVaXhGaAeHGX6SMevXcdjSw',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: goRouter);
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> signInWithSpotify() async {
    // Login with Spotify
    // FIX: deep link redirect not working
    bool success = await Supabase.instance.client.auth.signInWithOAuth(
      OAuthProvider.spotify,
      //redirectTo: "music-matcher://codeboi.dev/login-success",
      authScreenLaunchMode: LaunchMode.externalApplication,
    );

    print("Logged in with Spotify: $success");
    if (success && context.mounted) {
      context.go('/login-success');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                size: Size(
                  MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height,
                ),
                painter: TransverseWavePainter(_controller.value),
              );
            },
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    'Music Matcher',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Text(
                    'Connections through music!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Fixed color
                    ),
                  ),
                ),
                SizedBox(height: 50),
                ElevatedButton(
                  onPressed: signInWithSpotify,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: Text(
                    'Login with Spotify',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TransverseWavePainter extends CustomPainter {
  final double animationValue;

  TransverseWavePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    // Green path paint (for the outer wave)
    Paint paint =
        Paint()
          ..color = const Color.fromARGB(255, 94, 148, 255).withOpacity(0.9)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 7
          ..maskFilter = MaskFilter.blur(BlurStyle.outer, 10);

    // White path paint (for the center line of the wave)
    Paint centerLinePaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4;

    Path path = Path();
    double amplitude = 45;
    double frequency = 0.05;
    double yOffset = size.height / 1.9;

    for (double x = 0; x < size.width; x += 5) {
      // Adjust sine wave offset using animationValue
      double y =
          amplitude *
              (1 + animationValue) *
              (1.5 * animationValue) *
              (1 - animationValue) *
              (1 + animationValue) *
              sin((x * frequency) - (animationValue * 2 * 3.1416)) +
          yOffset;

      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Draw the green wave first
    canvas.drawPath(path, paint);

    // Draw the center line with white color
    Path centerPath = Path();
    for (double x = 0; x < size.width; x += 5) {
      double y =
          amplitude *
              (1 + animationValue) *
              (1.5 * animationValue) *
              (1 - animationValue) *
              (1 + animationValue) *
              sin((x * frequency) - (animationValue * 2 * 3.1416)) +
          yOffset;

      if (x == 0) {
        centerPath.moveTo(x, y);
      } else {
        centerPath.lineTo(x, y);
      }
    }

    // Draw the center line in white
    canvas.drawPath(centerPath, centerLinePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
