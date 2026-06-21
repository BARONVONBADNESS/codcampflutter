import 'dart:math' as math;
import 'package:flutter/material.dart';

// ── Static map data (all positions as fractions of canvas w/h) ───────────────

class _Patch {
  final List<Offset> pts;
  final Color color;
  const _Patch(this.pts, this.color);
}

const _patches = [
  _Patch([Offset(0.05,0.35),Offset(0.22,0.32),Offset(0.30,0.50),Offset(0.18,0.60),Offset(0.05,0.55)], Color(0xFF0C1A0A)),
  _Patch([Offset(0.55,0.28),Offset(0.75,0.26),Offset(0.82,0.44),Offset(0.70,0.56),Offset(0.50,0.48)], Color(0xFF0D1C0B)),
  _Patch([Offset(0.10,0.65),Offset(0.30,0.60),Offset(0.38,0.78),Offset(0.22,0.88),Offset(0.08,0.80)], Color(0xFF0F1E0D)),
  _Patch([Offset(0.60,0.62),Offset(0.80,0.58),Offset(0.92,0.74),Offset(0.80,0.88),Offset(0.62,0.84)], Color(0xFF0C1B0A)),
  _Patch([Offset(0.30,0.40),Offset(0.50,0.36),Offset(0.56,0.54),Offset(0.44,0.62),Offset(0.28,0.56)], Color(0xFF111F0F)),
  _Patch([Offset(0.72,0.36),Offset(0.90,0.34),Offset(0.95,0.50),Offset(0.84,0.58),Offset(0.70,0.50)], Color(0xFF0E1C0C)),
  _Patch([Offset(0.18,0.42),Offset(0.36,0.40),Offset(0.40,0.56),Offset(0.28,0.64),Offset(0.14,0.58)], Color(0xFF101E0E)),
  _Patch([Offset(0.38,0.68),Offset(0.55,0.64),Offset(0.60,0.80),Offset(0.45,0.90),Offset(0.32,0.82)], Color(0xFF0D1B0B)),
];

const _roads = <List<Offset>>[
  [Offset(0.00,0.50),Offset(0.50,0.42),Offset(1.00,0.48)],
  [Offset(0.50,0.22),Offset(0.48,1.00)],
  [Offset(0.00,0.72),Offset(0.50,0.60),Offset(1.00,0.65)],
  [Offset(0.15,0.30),Offset(0.50,0.50),Offset(0.88,0.34)],
  [Offset(0.25,0.95),Offset(0.50,0.65),Offset(0.78,0.90)],
  [Offset(0.02,0.88),Offset(0.35,0.70),Offset(0.65,0.80),Offset(0.98,0.76)],
];

const _blips = [
  Offset(0.22,0.55), Offset(0.48,0.45), Offset(0.68,0.60), Offset(0.35,0.70),
  Offset(0.78,0.48), Offset(0.15,0.78), Offset(0.60,0.82), Offset(0.85,0.72),
  Offset(0.42,0.90), Offset(0.72,0.92), Offset(0.28,0.88), Offset(0.55,0.65),
  Offset(0.10,0.60), Offset(0.90,0.85), Offset(0.50,0.96),
];

const _lime  = Color(0xFFA6FF2E);
const _amber = Color(0xFFD7A430);
const _mapBg = Color(0xFF060B06);

// ── Widget ────────────────────────────────────────────────────────────────────

/// Perspective-tilted tactical map background with animated scan sweep.
/// Drop content into [child] — it sits on top of the map layer.
class RadarBackground extends StatefulWidget {
  final Widget child;
  const RadarBackground({super.key, required this.child});

  @override
  State<RadarBackground> createState() => _RadarBackgroundState();
}

class _RadarBackgroundState extends State<RadarBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.hardEdge,
      children: [
        // ── Perspective map layer ───────────────────────────────────────────
        Positioned.fill(
          child: Transform(
            alignment: Alignment.bottomCenter,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0014) // perspective depth
              ..rotateX(0.50)          // ~29° forward tilt
              ..scale(1.06),
            child: AnimatedBuilder(
              animation: _ctrl,
              builder: (_, __) => CustomPaint(
                painter: _TacticalMapPainter(scan: _ctrl.value),
              ),
            ),
          ),
        ),

        // ── Edge fades — top heavy so cards are readable ────────────────────
        IgnorePointer(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF050A05),
                  Color(0x00050A05),
                  Color(0x00050A05),
                  Color(0xFF050A05),
                ],
                stops: [0.0, 0.25, 0.72, 1.0],
              ),
            ),
          ),
        ),

        // ── Content ─────────────────────────────────────────────────────────
        widget.child,
      ],
    );
  }
}

// ── Painter ───────────────────────────────────────────────────────────────────

class _TacticalMapPainter extends CustomPainter {
  final double scan; // 0..1

  const _TacticalMapPainter({required this.scan});

  // Scale fractional offset to canvas pixels
  Offset _p(Offset f, Size s) => Offset(f.dx * s.width, f.dy * s.height);

  @override
  void paint(Canvas canvas, Size size) {
    // Background
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = _mapBg,
    );

    _drawGrid(canvas, size);
    _drawPatches(canvas, size);
    _drawRoads(canvas, size);
    _drawHotZone(canvas, size);
    _drawScan(canvas, size);
    _drawBlips(canvas, size);
  }

  // ── Grid ──────────────────────────────────────────────────────────────────

  void _drawGrid(Canvas canvas, Size size) {
    final vp = Paint()
      ..color = _lime.withValues(alpha: 0.04)
      ..strokeWidth = 0.5;
    final hp = Paint()
      ..strokeWidth = 0.4;

    // Vertical lines
    const cols = 16;
    for (int i = 0; i <= cols; i++) {
      final x = size.width * i / cols;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), vp);
    }

    // Horizontal lines — denser toward top (perspective illusion)
    const rows = 20;
    for (int j = 1; j < rows; j++) {
      final t = math.pow(j / rows, 0.5).toDouble();
      final y = size.height * t;
      hp.color = _lime.withValues(alpha: 0.03 + t * 0.04);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), hp);
    }
  }

  // ── Terrain patches ───────────────────────────────────────────────────────

  void _drawPatches(Canvas canvas, Size size) {
    final fill = Paint()..style = PaintingStyle.fill;
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..color = _lime.withValues(alpha: 0.05)
      ..strokeWidth = 0.5;

    for (final patch in _patches) {
      final path = Path();
      for (int i = 0; i < patch.pts.length; i++) {
        final pt = _p(patch.pts[i], size);
        i == 0 ? path.moveTo(pt.dx, pt.dy) : path.lineTo(pt.dx, pt.dy);
      }
      path.close();
      fill.color = patch.color;
      canvas.drawPath(path, fill);
      canvas.drawPath(path, stroke);
    }
  }

  // ── Roads ─────────────────────────────────────────────────────────────────

  void _drawRoads(Canvas canvas, Size size) {
    final p = Paint()
      ..color = _lime.withValues(alpha: 0.09)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    for (final road in _roads) {
      final path = Path();
      for (int i = 0; i < road.length; i++) {
        final pt = _p(road[i], size);
        i == 0 ? path.moveTo(pt.dx, pt.dy) : path.lineTo(pt.dx, pt.dy);
      }
      canvas.drawPath(path, p);
    }
  }

  // ── Hot zone (amber glow) ─────────────────────────────────────────────────

  void _drawHotZone(Canvas canvas, Size size) {
    final center = _p(const Offset(0.48, 0.60), size);
    final radius = size.width * 0.14;
    final grad = RadialGradient(colors: [
      _amber.withValues(alpha: 0.20),
      _amber.withValues(alpha: 0.07),
      _amber.withValues(alpha: 0.00),
    ]).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawRect(
      Offset.zero & size,
      Paint()..shader = grad,
    );
  }

  // ── Scan sweep ────────────────────────────────────────────────────────────

  void _drawScan(Canvas canvas, Size size) {
    final scanY = size.height * scan;
    const glowH = 50.0;

    // Gradient glow above the line
    final glowRect = Rect.fromLTWH(0, scanY - glowH, size.width, glowH + 6);
    final glowGrad = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0x00A6FF2E), Color(0x0DA6FF2E), Color(0x28A6FF2E)],
      stops: [0.0, 0.6, 1.0],
    ).createShader(glowRect);
    canvas.drawRect(glowRect, Paint()..shader = glowGrad);

    // Dashed line
    _drawDashed(
      canvas,
      Offset(0, scanY),
      Offset(size.width, scanY),
      Paint()
        ..color = _lime.withValues(alpha: 0.45)
        ..strokeWidth = 0.8,
      8,
      5,
    );
  }

  // ── Blips ─────────────────────────────────────────────────────────────────

  void _drawBlips(Canvas canvas, Size size) {
    for (final frac in _blips) {
      final pos    = _p(frac, size);
      final scanFrac = frac.dy;
      var behind = scan - scanFrac;
      if (behind < 0) behind += 1;
      final alpha = math.pow(1 - behind, 2.8).toDouble();
      if (alpha < 0.02) continue;

      // Size grows as blips are further "south" (closer in perspective)
      final sz = 1.8 + frac.dy * 2.8;
      final cs = sz + 4;

      // Crosshair arms
      final cp = Paint()
        ..color = _lime.withValues(alpha: alpha * 0.75)
        ..strokeWidth = 0.8;
      canvas.drawLine(Offset(pos.dx - cs, pos.dy), Offset(pos.dx + cs, pos.dy), cp);
      canvas.drawLine(Offset(pos.dx, pos.dy - cs), Offset(pos.dx, pos.dy + cs), cp);

      // Glow
      canvas.drawCircle(
        pos,
        sz + 4,
        Paint()
          ..color = _lime.withValues(alpha: alpha * 0.18)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
      );

      // Core dot
      canvas.drawCircle(pos, sz, Paint()..color = _lime.withValues(alpha: alpha * 0.95));

      // Outer ring
      canvas.drawCircle(
        pos,
        sz + 3,
        Paint()
          ..color = _lime.withValues(alpha: alpha * 0.30)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.6,
      );
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  void _drawDashed(Canvas canvas, Offset a, Offset b, Paint p, double dash, double gap) {
    final d   = b - a;
    final len = d.distance;
    if (len == 0) return;
    final dir = d / len;
    double t  = 0;
    bool on   = true;
    while (t < len) {
      final seg = on ? dash : gap;
      final end = math.min(t + seg, len);
      if (on) canvas.drawLine(a + dir * t, a + dir * end, p);
      t = end;
      on = !on;
    }
  }

  @override
  bool shouldRepaint(_TacticalMapPainter old) => old.scan != scan;
}
