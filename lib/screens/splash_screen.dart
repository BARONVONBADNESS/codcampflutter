import 'package:flutter/material.dart';
import '../main.dart';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _radarController;
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _scanController;

  late Animation<double> _radarScale;
  late Animation<double> _radarOpacity;
  late Animation<double> _logoOpacity;
  late Animation<double> _logoScale;
  late Animation<double> _trainOpacity;
  late Animation<Offset> _trainSlide;
  late Animation<double> _taglineOpacity;
  late Animation<double> _scanPosition;

  static const _green = Color(0xFFA8FF00);
  static const _bg = Color(0xFF090A07);

  @override
  void initState() {
    super.initState();

    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _radarScale = Tween<double>(begin: 0.2, end: 2.2).animate(
      CurvedAnimation(parent: _radarController, curve: Curves.easeOut),
    );
    _radarOpacity = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.9), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 0.0), weight: 80),
    ]).animate(_radarController);

    _logoScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeIn),
    );

    _trainSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic));
    _trainOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );
    _taglineOpacity = Tween<double>(begin: 0.0, end: 0.7).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    _scanPosition = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.easeInOut),
    );

    // Sequence the animations
    _radarController.forward().then((_) {
      _logoController.forward().then((_) {
        _textController.forward().then((_) {
          _scanController.forward().then((_) {
            Future.delayed(const Duration(milliseconds: 400), () {
              if (mounted) {
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const MainShell(),
                    transitionDuration: const Duration(milliseconds: 600),
                    transitionsBuilder: (_, animation, __, child) =>
                        FadeTransition(opacity: animation, child: child),
                  ),
                );
              }
            });
          });
        });
      });
    });
  }

  @override
  void dispose() {
    _radarController.dispose();
    _logoController.dispose();
    _textController.dispose();
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          // Grid overlay
          CustomPaint(
            size: Size(size.width, size.height),
            painter: _GridPainter(),
          ),

          // Radar pulse
          Center(
            child: AnimatedBuilder(
              animation: _radarController,
              builder: (_, __) => Transform.scale(
                scale: _radarScale.value,
                child: Opacity(
                  opacity: _radarOpacity.value,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: _green, width: 1.5),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Center content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo
                AnimatedBuilder(
                  animation: _logoController,
                  builder: (_, __) => Transform.scale(
                    scale: _logoScale.value,
                    child: Opacity(
                      opacity: _logoOpacity.value,
                      child: _SkullEmblem(),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // TRAIN SMARTER
                AnimatedBuilder(
                  animation: _textController,
                  builder: (_, __) => SlideTransition(
                    position: _trainSlide,
                    child: FadeTransition(
                      opacity: _trainOpacity,
                      child: const Text(
                        'TRAIN SMARTER',
                        style: TextStyle(
                          color: _green,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 6.0,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // codcamp.com
                AnimatedBuilder(
                  animation: _textController,
                  builder: (_, __) => FadeTransition(
                    opacity: _taglineOpacity,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: _green.withValues(alpha: 0.5)),
                      ),
                      child: const Text(
                        'codcamp.com',
                        style: TextStyle(
                          color: _green,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 3.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Scan line sweep
          AnimatedBuilder(
            animation: _scanController,
            builder: (_, __) => Positioned(
              top: size.height * (_scanPosition.value * 0.5 + 0.5),
              left: 0,
              right: 0,
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      _green.withValues(alpha: 0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Skull emblem drawn with CustomPaint
class _SkullEmblem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 140,
      child: CustomPaint(painter: _SkullPainter()),
    );
  }
}

class _SkullPainter extends CustomPainter {
  static const _green = Color(0xFFA8FF00);
  static const _white = Color(0xFFECF0E6);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;

    final circlePaint = Paint()
      ..color = _green.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..color = _green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final skullPaint = Paint()
      ..color = _white
      ..style = PaintingStyle.fill;

    // Outer ring
    canvas.drawCircle(Offset(cx, cy), r - 4, circlePaint);
    canvas.drawCircle(Offset(cx, cy), r - 4, borderPaint);

    // Inner tick marks
    for (int i = 0; i < 12; i++) {
      final angle = (i * 30) * math.pi / 180;
      final tickLen = i % 3 == 0 ? 8.0 : 4.0;
      final outer = Offset(cx + (r - 6) * math.cos(angle), cy + (r - 6) * math.sin(angle));
      final inner = Offset(cx + (r - 6 - tickLen) * math.cos(angle), cy + (r - 6 - tickLen) * math.sin(angle));
      canvas.drawLine(outer, inner, borderPaint..strokeWidth = i % 3 == 0 ? 1.5 : 0.8);
    }

    // Skull head
    final skullPath = Path()
      ..addOval(Rect.fromCenter(center: Offset(cx, cy - 8), width: 52, height: 48));
    canvas.drawPath(skullPath, skullPaint);

    // Jaw
    final jawPath = Path()
      ..moveTo(cx - 18, cy + 16)
      ..lineTo(cx - 14, cy + 34)
      ..lineTo(cx + 14, cy + 34)
      ..lineTo(cx + 18, cy + 16)
      ..close();
    canvas.drawPath(jawPath, skullPaint);

    // Eye sockets
    final eyePaint = Paint()..color = const Color(0xFF090A07);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx - 11, cy - 10), width: 14, height: 12), eyePaint);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + 11, cy - 10), width: 14, height: 12), eyePaint);

    // Nose
    final nosePath = Path()
      ..moveTo(cx, cy + 4)
      ..lineTo(cx - 5, cy + 14)
      ..lineTo(cx + 5, cy + 14)
      ..close();
    canvas.drawPath(nosePath, eyePaint);

    // Teeth lines
    final teethPaint = Paint()
      ..color = const Color(0xFF090A07)
      ..strokeWidth = 1.5;
    for (int i = -1; i <= 1; i++) {
      canvas.drawLine(
        Offset(cx + i * 9.0, cy + 20),
        Offset(cx + i * 9.0, cy + 30),
        teethPaint,
      );
    }

    // COD CAMP text arc label
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'GHOST PROTOCOL',
        style: TextStyle(
          color: _green,
          fontSize: 7,
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    canvas.save();
    canvas.translate(cx - textPainter.width / 2, cy - r + 14);
    textPainter.paint(canvas, Offset.zero);
    canvas.restore();

    final textPainter2 = TextPainter(
      text: const TextSpan(
        text: 'COD CAMP',
        style: TextStyle(
          color: _green,
          fontSize: 7,
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    canvas.save();
    canvas.translate(cx - textPainter2.width / 2, cy + r - 22);
    textPainter2.paint(canvas, Offset.zero);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_) => false;
}

// Subtle military grid background
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFA8FF00).withValues(alpha: 0.04)
      ..strokeWidth = 0.5;
    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}