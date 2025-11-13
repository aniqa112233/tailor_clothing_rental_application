import 'dart:async';
import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, Routes.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // Top Wave
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: TopWaveClipper(),
              child: Container(
                height: 250,
                color: AppTheme.primary,
              ),
            ),
          ),

          // Bottom Wave
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: BottomWaveClipper(),
              child: Container(
                height: 250,
                color: AppTheme.primary,
              ),
            ),
          ),

          // Center Content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle_outline,
                    color: AppTheme.accent, size: 80),
                const SizedBox(height: 20),
                Text(
                  "ANGEL SURE",
                  style: TextStyle(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                ),
              ],
            ),
          ),

          // Bottom Arrow Button
          Positioned(
            bottom: 50,
            right: 30,
            child: CircleAvatar(
              radius: 24,
              backgroundColor: AppTheme.accent,
              child: const Icon(Icons.arrow_forward_ios, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 100);
    path.quadraticBezierTo(
        size.width / 4, size.height - 200, size.width / 2, size.height - 100);
    path.quadraticBezierTo(
        3 * size.width / 4, size.height, size.width, size.height - 150);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 150);
    path.quadraticBezierTo(
        size.width / 4, 50, size.width / 2, 150);
    path.quadraticBezierTo(
        3 * size.width / 4, 250, size.width, 150);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
