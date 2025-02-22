import 'dart:math';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'home.dart';

final goRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, _) => const LoginPage()),
    GoRoute(path: '/login-success', redirect: (_, _) => '/home'),
    GoRoute(path: '/home', builder: (_, _) => const HomePage()),
  ],
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  await Supabase.initialize(
    url: dotenv.get('SUPABASE_URL'),
    anonKey: dotenv.get('SUPABASE_KEY'),
  );
  Supabase.instance.client.auth.onAuthStateChange.listen(onAuthStateChanged);

  runApp(const MyApp());
}

Future<void> onAuthStateChanged(AuthState state) async {
  print("Received auth event: ${state.event}");
  SupabaseClient client = Supabase.instance.client;

  switch (state.event) {
    case AuthChangeEvent.initialSession:
    case AuthChangeEvent.signedIn:
      Session session = state.session!;
      Map<String, dynamic> userMetadata = session.user.userMetadata!;

      // Upload profile data to Supabase
      String displayName = userMetadata['full_name'];
      String avatarUrl = userMetadata['avatar_url'];
      String spotifyId = userMetadata['provider_id'];
      await client.from('profiles').upsert({
        'id': session.user.id,
        'display_name': displayName,
        'avatar_url': avatarUrl,
        'spotify_id': spotifyId,
      });

      // TODO: fetch user's top tracks and artists from Spotify API

      print("Spotify login was successful!");
      break;

    default:
  }
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
    await Supabase.instance.client.auth.signInWithOAuth(
      OAuthProvider.spotify,
      redirectTo: 'music-matcher://codeboi.dev/login-success',
      authScreenLaunchMode: LaunchMode.externalApplication,
    );
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
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: const Color.fromARGB(255, 85, 222, 156),
                          blurRadius: 20,
                        ),
                        Shadow(color: Colors.cyan, blurRadius: 10),
                      ],
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
                      shadows: [
                        Shadow(
                          color: const Color.fromARGB(255, 85, 222, 156),
                          blurRadius: 20,
                        ),
                        Shadow(color: Colors.cyan, blurRadius: 10),
                      ],
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
          ..color = const Color.fromARGB(255, 28, 255, 62).withOpacity(0.9)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 7
          ..maskFilter = MaskFilter.blur(BlurStyle.outer, 10);

    // White path paint (for the center line of the wave)
    Paint centerLinePaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5;

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
