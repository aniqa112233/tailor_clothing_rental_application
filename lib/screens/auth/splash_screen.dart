
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
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primary,
                      AppTheme.primary.withOpacity(0.8),
                      AppTheme.accent.withOpacity(0.3),
                    ],
                  ),
                ),
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
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primary,
                      AppTheme.primary.withOpacity(0.8),
                      AppTheme.accent.withOpacity(0.3),
                    ],
                  ),
                ),
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
                  "Tailor Clothing Application",
                  style: TextStyle(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),

          // Top-left: Coral T-shirt on hanger
          Positioned(
            top: 100,
            left: 40,
            child: Transform.rotate(
              angle: -0.2,
              child: CustomPaint(
                size: const Size(55, 55),
                painter: TShirtPainter(color: const Color(0xFFFF8C69)),
              ),
            ),
          ),

          // Top-right: Pink dress with sparkles
          Positioned(
            top: 80,
            right: 50,
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: AppTheme.accent, size: 12),
                    const SizedBox(width: 3),
                    Icon(Icons.star, color: AppTheme.accent, size: 14),
                    const SizedBox(width: 3),
                    Icon(Icons.star, color: AppTheme.accent, size: 12),
                  ],
                ),
                const SizedBox(height: 6),
                Transform.rotate(
                  angle: 0.15,
                  child: CustomPaint(
                    size: const Size(45, 60),
                    painter: DressPainter(color: const Color(0xFFFF6B9D)),
                  ),
                ),
              ],
            ),
          ),

          // Bottom-right: Stack of folded shirts
          Positioned(
            bottom: 150,
            right: 50,
            child: CustomPaint(
              size: const Size(60, 45),
              painter: FoldedShirtsPainter(),
            ),
          ),

          // Bottom-left: Teal shirt with sparkles
          Positioned(
            bottom: 150,
            left: 50,
            child: Column(
              children: [
                Transform.rotate(
                  angle: -0.15,
                  child: CustomPaint(
                    size: const Size(50, 50),
                    painter: LongSleeveShirtPainter(color: AppTheme.accent),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: AppTheme.accent, size: 12),
                    const SizedBox(width: 3),
                    Icon(Icons.star, color: AppTheme.accent, size: 14),
                    const SizedBox(width: 3),
                    Icon(Icons.star, color: AppTheme.accent, size: 12),
                  ],
                ),
              ],
            ),
          ),

          // ❌ BOTTOM ARROW BUTTON REMOVED
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

// Custom Painters for Clothing Items
class TShirtPainter extends CustomPainter {
  final Color color;

  TShirtPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    // Main shirt color with gradient effect
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final hangerPaint = Paint()
      ..color = const Color(0xFF2C2C2C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    // Draw hanger hook (more detailed)
    final hangerPath = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width / 2, 10)
      ..arcToPoint(
        Offset(size.width / 2 - 10, 20),
        radius: const Radius.circular(10),
        clockwise: false,
      )
      ..lineTo(size.width / 2 + 10, 20);

    canvas.drawPath(hangerPath, hangerPaint);

    // Draw T-shirt body (more rounded and natural)
    final shirtPath = Path()
      ..moveTo(size.width / 2, 20)
      ..lineTo(size.width * 0.25, 20)
      ..quadraticBezierTo(size.width * 0.2, size.height * 0.25, size.width * 0.18, size.height * 0.35)
      ..lineTo(size.width * 0.12, size.height * 0.55)
      ..quadraticBezierTo(size.width * 0.15, size.height * 0.7, size.width * 0.25, size.height * 0.85)
      ..lineTo(size.width * 0.35, size.height * 0.95)
      ..lineTo(size.width * 0.65, size.height * 0.95)
      ..lineTo(size.width * 0.75, size.height * 0.85)
      ..quadraticBezierTo(size.width * 0.85, size.height * 0.7, size.width * 0.88, size.height * 0.55)
      ..lineTo(size.width * 0.82, size.height * 0.35)
      ..quadraticBezierTo(size.width * 0.8, size.height * 0.25, size.width * 0.75, 20)
      ..close();

    canvas.drawPath(shirtPath, paint);

    // Draw sleeves (more detailed)
    final sleevePath = Path()
      ..moveTo(size.width * 0.18, size.height * 0.35)
      ..quadraticBezierTo(size.width * 0.08, size.height * 0.28, size.width * 0.05, size.height * 0.2)
      ..quadraticBezierTo(size.width * 0.08, size.height * 0.35, size.width * 0.12, size.height * 0.45)
      ..close();

    canvas.drawPath(sleevePath, paint);

    final sleevePath2 = Path()
      ..moveTo(size.width * 0.82, size.height * 0.35)
      ..quadraticBezierTo(size.width * 0.92, size.height * 0.28, size.width * 0.95, size.height * 0.2)
      ..quadraticBezierTo(size.width * 0.92, size.height * 0.35, size.width * 0.88, size.height * 0.45)
      ..close();

    canvas.drawPath(sleevePath2, paint);

    // Add neckline detail
    final neckPaint = Paint()
      ..color = color.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final neckPath = Path()
      ..moveTo(size.width * 0.35, 20)
      ..quadraticBezierTo(size.width * 0.4, 25, size.width * 0.5, 25)
      ..quadraticBezierTo(size.width * 0.6, 25, size.width * 0.65, 20);

    canvas.drawPath(neckPath, neckPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DressPainter extends CustomPainter {
  final Color color;

  DressPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw dress body (sleeveless, flared with more curves)
    final dressPath = Path()
      ..moveTo(size.width / 2, 0)
      ..quadraticBezierTo(size.width * 0.35, size.height * 0.15, size.width * 0.32, size.height * 0.25)
      ..quadraticBezierTo(size.width * 0.28, size.height * 0.4, size.width * 0.22, size.height * 0.55)
      ..quadraticBezierTo(size.width * 0.18, size.height * 0.7, size.width * 0.12, size.height * 0.85)
      ..quadraticBezierTo(size.width * 0.08, size.height * 0.95, size.width * 0.05, size.height)
      ..lineTo(size.width * 0.95, size.height)
      ..quadraticBezierTo(size.width * 0.92, size.height * 0.95, size.width * 0.88, size.height * 0.85)
      ..quadraticBezierTo(size.width * 0.82, size.height * 0.7, size.width * 0.78, size.height * 0.55)
      ..quadraticBezierTo(size.width * 0.72, size.height * 0.4, size.width * 0.68, size.height * 0.25)
      ..quadraticBezierTo(size.width * 0.65, size.height * 0.15, size.width / 2, 0)
      ..close();

    canvas.drawPath(dressPath, paint);

    // Add waist detail
    final waistPaint = Paint()
      ..color = color.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final waistPath = Path()
      ..moveTo(size.width * 0.32, size.height * 0.25)
      ..quadraticBezierTo(size.width * 0.35, size.height * 0.3, size.width * 0.4, size.height * 0.32)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.35, size.width * 0.6, size.height * 0.32)
      ..quadraticBezierTo(size.width * 0.65, size.height * 0.3, size.width * 0.68, size.height * 0.25);

    canvas.drawPath(waistPath, waistPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class FoldedShirtsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Bottom shirt (coral/pink matching theme)
    final bottomPaint = Paint()
      ..color = const Color(0xFFFFB3BA)
      ..style = PaintingStyle.fill;

    final bottomPath = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..quadraticBezierTo(size.width * 0.95, size.height * 0.75, size.width * 0.9, size.height * 0.7)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.65, size.width * 0.1, size.height * 0.7)
      ..quadraticBezierTo(size.width * 0.05, size.height * 0.75, 0, size.height)
      ..close();

    canvas.drawPath(bottomPath, bottomPaint);

    // Top shirt (teal/cyan matching accent)
    final topPaint = Paint()
      ..color = const Color(0xFF7FD8D2)
      ..style = PaintingStyle.fill;

    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final buttonPaint = Paint()
      ..color = const Color(0xFF2C2C2C)
      ..style = PaintingStyle.fill;

    final topPath = Path()
      ..moveTo(size.width * 0.1, size.height * 0.7)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.65, size.width * 0.9, size.height * 0.7)
      ..quadraticBezierTo(size.width * 0.88, size.height * 0.35, size.width * 0.85, size.height * 0.3)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.25, size.width * 0.15, size.height * 0.3)
      ..quadraticBezierTo(size.width * 0.12, size.height * 0.35, size.width * 0.1, size.height * 0.7)
      ..close();

    canvas.drawPath(topPath, topPaint);

    // Draw collar (more detailed)
    final collarPath = Path()
      ..moveTo(size.width * 0.32, size.height * 0.3)
      ..quadraticBezierTo(size.width * 0.38, size.height * 0.18, size.width * 0.42, size.height * 0.15)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.12, size.width * 0.58, size.height * 0.15)
      ..quadraticBezierTo(size.width * 0.62, size.height * 0.18, size.width * 0.68, size.height * 0.3)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.32, size.width * 0.32, size.height * 0.3)
      ..close();

    canvas.drawPath(collarPath, whitePaint);

    // Draw collar outline
    final collarOutlinePaint = Paint()
      ..color = const Color(0xFF2C2C2C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawPath(collarPath, collarOutlinePaint);

    // Draw buttons (more visible)
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.42), 2.5, buttonPaint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.52), 2.5, buttonPaint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.62), 2.5, buttonPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class LongSleeveShirtPainter extends CustomPainter {
  final Color color;

  LongSleeveShirtPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final buttonPaint = Paint()
      ..color = const Color(0xFF2C2C2C)
      ..style = PaintingStyle.fill;

    // Draw shirt body (more rounded and natural)
    final shirtPath = Path()
      ..moveTo(size.width / 2, 0)
      ..quadraticBezierTo(size.width * 0.3, size.height * 0.12, size.width * 0.28, size.height * 0.18)
      ..quadraticBezierTo(size.width * 0.22, size.height * 0.35, size.width * 0.18, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.15, size.height * 0.65, size.width * 0.18, size.height * 0.8)
      ..quadraticBezierTo(size.width * 0.2, size.height * 0.9, size.width * 0.25, size.height * 0.95)
      ..lineTo(size.width * 0.75, size.height * 0.95)
      ..quadraticBezierTo(size.width * 0.8, size.height * 0.9, size.width * 0.82, size.height * 0.8)
      ..quadraticBezierTo(size.width * 0.85, size.height * 0.65, size.width * 0.82, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.78, size.height * 0.35, size.width * 0.72, size.height * 0.18)
      ..quadraticBezierTo(size.width * 0.7, size.height * 0.12, size.width / 2, 0)
      ..close();

    canvas.drawPath(shirtPath, paint);

    // Draw long sleeves (more detailed and curved)
    final sleevePath = Path()
      ..moveTo(size.width * 0.28, size.height * 0.18)
      ..quadraticBezierTo(size.width * 0.15, size.height * 0.12, size.width * 0.08, size.height * 0.08)
      ..quadraticBezierTo(size.width * 0.05, size.height * 0.2, size.width * 0.08, size.height * 0.32)
      ..quadraticBezierTo(size.width * 0.12, size.height * 0.45, size.width * 0.18, size.height * 0.5)
      ..close();

    canvas.drawPath(sleevePath, paint);

    final sleevePath2 = Path()
      ..moveTo(size.width * 0.72, size.height * 0.18)
      ..quadraticBezierTo(size.width * 0.85, size.height * 0.12, size.width * 0.92, size.height * 0.08)
      ..quadraticBezierTo(size.width * 0.95, size.height * 0.2, size.width * 0.92, size.height * 0.32)
      ..quadraticBezierTo(size.width * 0.88, size.height * 0.45, size.width * 0.82, size.height * 0.5)
      ..close();

    canvas.drawPath(sleevePath2, paint);

    // Draw collar (more detailed)
    final collarPath = Path()
      ..moveTo(size.width * 0.38, size.height * 0.18)
      ..quadraticBezierTo(size.width * 0.42, size.height * 0.08, size.width * 0.45, size.height * 0.05)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.02, size.width * 0.55, size.height * 0.05)
      ..quadraticBezierTo(size.width * 0.58, size.height * 0.08, size.width * 0.62, size.height * 0.18)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.2, size.width * 0.38, size.height * 0.18)
      ..close();

    final collarPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawPath(collarPath, collarPaint);

    // Draw collar outline
    final collarOutlinePaint = Paint()
      ..color = const Color(0xFF2C2C2C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawPath(collarPath, collarOutlinePaint);

    // Draw buttons (more visible)
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.45), 2.5, buttonPaint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.58), 2.5, buttonPaint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.71), 2.5, buttonPaint);

    // Draw center line
    final centerLinePaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.2),
      Offset(size.width * 0.5, size.height * 0.85),
      centerLinePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
