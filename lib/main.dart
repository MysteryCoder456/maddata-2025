import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/animation.dart';
import 'dart:math';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
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
                size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
                painter: TransverseWavePainter(_controller.value),
              );
            },
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Padding()
                Padding(
                  padding: const EdgeInsets.only(bottom: 20), // Moves text upwards
                  child: Text(
                    'Music Matcher',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Text(
                    'Connections through music!',
                    style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 255, 255, 255)),
                  )
                ),
                SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Change button color
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Adjust size
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100), // Rounded corners
                  ),
                ),
                  child: Text('Login with Spotify',
                  style: TextStyle(fontSize: 18, color: Colors.black)),
                  
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
    Paint paint = Paint()
      ..color = const Color.fromARGB(255, 63, 255, 175).withOpacity(0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..maskFilter = MaskFilter.blur(BlurStyle.outer, 5); 
      
    
    Path path = Path();
    double amplitude = 45;
    double frequency = 0.05;
    double yOffset = size.height / 1.9;
    
    for (double x = 0; x < size.width; x += 5) {
      double y = amplitude * 
                 (1 + animationValue) * 
                 (1.5 * animationValue) * 
                 (1 - animationValue) * 
                 (1 + animationValue) * 
                 sin((x * frequency) + (animationValue * 2 * 3.1416)) + yOffset;
      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
