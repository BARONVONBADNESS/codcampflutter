import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import '../services/auth_service.dart';
import '../services/discord_oauth.dart';
import '../services/tips_service.dart'; // kTipsBaseUrl
import 'signup_screen.dart';

const _lime    = Color(0xFFA6FF2E);
const _bg      = Color(0xFF050A05);
const _discord = Color(0xFF5865F2); // Discord blurple

// ── Tactical login background ─────────────────────────────────────────────────
//
// Architecture:
//  Layer 1  — Solid near-black base
//  Layer 2  — Radial lime glow (subtle warmth behind card)
//  Layer 3  — CustomPainter: grid + tick marks + corner brackets
//  Layer 4  — LEFT glowing bar
//  Layer 5  — RIGHT glowing bar
//  Layer 6  — Metallic / armored frame border (beveled gunmetal)
//  Layer 7  — Top + bottom vignette

class TacticalLoginBackground extends StatelessWidget {
  const TacticalLoginBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [

        // 1. Solid very-dark olive-black base
        const ColoredBox(color: Color(0xFF030604)),

        // 2. Radial lime glow — very faint warmth behind the login card
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.15),
                  radius: 0.75,
                  colors: [
                    _lime.withValues(alpha: 0.10),
                    _lime.withValues(alpha: 0.04),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.35, 1.0],
                ),
              ),
            ),
          ),
        ),

        // 3. Grid + tick marks + corner brackets
        const Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(painter: _TacticalHudPainter()),
          ),
        ),

        // 4. LEFT glowing bar
        Positioned(
          left: 0, top: 0, bottom: 0,
          child: IgnorePointer(
            child: Container(
              width: 2,
              decoration: BoxDecoration(
                color: _lime.withValues(alpha: 0.88),
                boxShadow: [
                  BoxShadow(
                    color: _lime.withValues(alpha: 0.60),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: _lime.withValues(alpha: 0.28),
                    blurRadius: 26,
                    spreadRadius: 5,
                  ),
                  BoxShadow(
                    color: _lime.withValues(alpha: 0.10),
                    blurRadius: 60,
                    spreadRadius: 12,
                  ),
                ],
              ),
            ),
          ),
        ),

        // 5. RIGHT glowing bar
        Positioned(
          right: 0, top: 0, bottom: 0,
          child: IgnorePointer(
            child: Container(
              width: 2,
              decoration: BoxDecoration(
                color: _lime.withValues(alpha: 0.88),
                boxShadow: [
                  BoxShadow(
                    color: _lime.withValues(alpha: 0.60),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: _lime.withValues(alpha: 0.28),
                    blurRadius: 26,
                    spreadRadius: 5,
                  ),
                  BoxShadow(
                    color: _lime.withValues(alpha: 0.10),
                    blurRadius: 60,
                    spreadRadius: 12,
                  ),
                ],
              ),
            ),
          ),
        ),

        // 6. Metallic / armored frame border — beveled gunmetal look
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(painter: _MetallicFramePainter()),
          ),
        ),

        // 7. Top + bottom vignette
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.80),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.62),
                  ],
                  stops: const [0.0, 0.22, 0.80, 1.0],
                ),
              ),
            ),
          ),
        ),

      ],
    );
  }
}

// ── Metallic frame painter ──────────────────────────────────────────────────

class _MetallicFramePainter extends CustomPainter {
  const _MetallicFramePainter();

  @override
  void paint(Canvas canvas, Size size) {
    const double frameW = 8.0;
    final w = size.width;
    final h = size.height;

    // Outer dark edge
    final outerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = frameW
      ..color = const Color(0xFF1A1E1A);
    canvas.drawRect(
      Rect.fromLTWH(frameW / 2, frameW / 2, w - frameW, h - frameW),
      outerPaint,
    );

    // Inner highlight bevel (top-left lighter, bottom-right darker)
    final highlightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = const Color(0xFF3A3E3A);
    // top edge inner
    canvas.drawLine(
      Offset(frameW, frameW), Offset(w - frameW, frameW), highlightPaint);
    // left edge inner
    canvas.drawLine(
      Offset(frameW, frameW), Offset(frameW, h - frameW), highlightPaint);

    final shadowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = const Color(0xFF0A0E0A);
    // bottom edge inner
    canvas.drawLine(
      Offset(frameW, h - frameW), Offset(w - frameW, h - frameW), shadowPaint);
    // right edge inner
    canvas.drawLine(
      Offset(w - frameW, frameW), Offset(w - frameW, h - frameW), shadowPaint);

    // Subtle inner border line (lime tinted)
    final innerBorder = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..color = _lime.withValues(alpha: 0.08);
    canvas.drawRect(
      Rect.fromLTWH(frameW + 1, frameW + 1, w - frameW * 2 - 2, h - frameW * 2 - 2),
      innerBorder,
    );
  }

  @override
  bool shouldRepaint(_MetallicFramePainter old) => false;
}

// ── Tactical HUD painter ────────────────────────────────────────────────────

class _TacticalHudPainter extends CustomPainter {
  const _TacticalHudPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // ── Faint grid
    final grid = Paint()
      ..color = _lime.withValues(alpha: 0.022)
      ..strokeWidth = 0.4;
    const cols = 22;
    const rows = 38;
    for (int i = 0; i <= cols; i++) {
      final x = size.width * i / cols;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (int j = 0; j <= rows; j++) {
      final y = size.height * j / rows;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    // ── Tick marks
    _ticks(canvas, size, 2.0, isLeft: true);
    _ticks(canvas, size, size.width - 2.0, isLeft: false);

    // ── Corner brackets
    _cornerFrame(canvas, Offset.zero, 1, 1);
    _cornerFrame(canvas, Offset(size.width, 0), -1, 1);
    _cornerFrame(canvas, Offset(0, size.height), 1, -1);
    _cornerFrame(canvas, Offset(size.width, size.height), -1, -1);
  }

  void _ticks(Canvas canvas, Size size, double x, {required bool isLeft}) {
    const int count = 16;
    final tp = Paint()
      ..color = _lime.withValues(alpha: 0.45)
      ..strokeWidth = 0.9;
    final dir = isLeft ? 1.0 : -1.0;
    for (int i = 1; i < count; i++) {
      final y   = size.height * i / count;
      final len = (i % 4 == 0) ? 12.0 : (i % 2 == 0 ? 7.0 : 4.0);
      canvas.drawLine(Offset(x, y), Offset(x + dir * len, y), tp);
    }
  }

  void _cornerFrame(Canvas canvas, Offset o, double sx, double sy) {
    _bracket(canvas, o, 50, sx, sy, 0.22, 1.2);
    _bracket(
      canvas,
      Offset(o.dx + sx * 6, o.dy + sy * 6),
      34, sx, sy, 0.65, 1.6,
    );
  }

  void _bracket(Canvas canvas, Offset o, double len,
      double sx, double sy, double alpha, double strokeW) {
    canvas.drawPath(
      Path()
        ..moveTo(o.dx + sx * len, o.dy)
        ..lineTo(o.dx, o.dy)
        ..lineTo(o.dx, o.dy + sy * len),
      Paint()
        ..color = _lime.withValues(alpha: alpha)
        ..strokeWidth = strokeW
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(_TacticalHudPainter old) => false;
}

// ── Boot sequence widget ────────────────────────────────────────────────────

class _BootSequence extends StatelessWidget {
  final AnimationController ctrl;

  static const _lines = [
    '> INITIALIZING SECURE NODE................. ',
    '> ENCRYPTING DATA.......................... ',
    '> ESTABLISHING ENCRYPTED TUNNEL............ ',
    '> GHOST PROTOCOL ONLINE.................... ',
  ];

  const _BootSequence({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ctrl,
      builder: (_, __) {
        final t    = ctrl.value;
        final done = (t * _lines.length).floor();
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.40),
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: _lime.withValues(alpha: 0.15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text('BOOT SEQUENCE',
                    style: TextStyle(
                        color: _lime.withValues(alpha: 0.55),
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.0)),
                const SizedBox(width: 10),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(1),
                    child: LinearProgressIndicator(
                      value: t,
                      minHeight: 3,
                      backgroundColor: const Color(0xFF151F15),
                      valueColor: const AlwaysStoppedAnimation(_lime),
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              ...List.generate(_lines.length, (i) {
                final isDone   = i < done;
                final isActive = i == done && t < 1.0;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Row(children: [
                    Expanded(
                      child: Text(_lines[i],
                          style: TextStyle(
                              color: _lime.withValues(
                                  alpha: isDone ? 0.65 : (isActive ? 0.35 : 0.12)),
                              fontSize: 9,
                              fontFamily: 'monospace',
                              letterSpacing: 0.3)),
                    ),
                    if (isDone)
                      Text('[ OK ]',
                          style: TextStyle(
                              color: _lime.withValues(alpha: 0.55),
                              fontSize: 9,
                              fontFamily: 'monospace')),
                  ]),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

// ── Tactical text field ─────────────────────────────────────────────────────

class _TacField extends StatelessWidget {
  final TextEditingController ctrl;
  final String label;
  final IconData icon;
  final TextInputType? keyboard;
  final bool obscure;

  const _TacField({
    super.key,
    required this.ctrl,
    required this.label,
    required this.icon,
    this.keyboard,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                color: _lime.withValues(alpha: 0.45),
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.0)),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF070E07),
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: _lime.withValues(alpha: 0.20)),
          ),
          child: TextField(
            controller: ctrl,
            keyboardType: keyboard,
            obscureText: obscure,
            style: const TextStyle(
                color: Color(0xFFCCCCCC), fontSize: 14, letterSpacing: 0.5),
            cursorColor: _lime,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border: InputBorder.none,
              suffixIcon:
                  Icon(icon, color: _lime.withValues(alpha: 0.35), size: 18),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Delivery preference bottom sheet ─────────────────────────────────────────
//
// Shown when a user has now used BOTH login methods and hasn't chosen where
// coaching responses should be delivered.

/// Shows the coaching delivery preference sheet.
///
/// [dismissible] — false (default) during login first-overlap flow (user must
/// choose).  Pass true when opened from settings so the user can cancel.
Future<void> showDeliveryPreferenceSheet(
  BuildContext context, {
  bool dismissible = false,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: const Color(0xFF0C130C),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      side: BorderSide(color: Color(0xFF1E3E1E)),
    ),
    isDismissible: dismissible,
    enableDrag: dismissible,
    builder: (_) => _DeliveryPreferenceSheet(showCancel: dismissible),
  );
}

class _DeliveryPreferenceSheet extends StatelessWidget {
  final bool showCancel;
  const _DeliveryPreferenceSheet({this.showCancel = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 24, 20, MediaQuery.of(context).padding.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _lime.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: _lime.withValues(alpha: 0.20)),
              ),
              child: const Icon(Icons.swap_horiz_rounded, color: _lime, size: 18),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text('COACHING DELIVERY',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5)),
            ),
          ]),
          const SizedBox(height: 8),
          Text(
            "You've used both app login and Discord. Where should Lt. Reaper send coaching responses?",
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.50),
                fontSize: 12,
                height: 1.55),
          ),
          const SizedBox(height: 20),

          // In-app option
          _PrefOption(
            icon: Icons.chat_bubble_outline_rounded,
            label: 'IN-APP CHAT',
            subtitle: 'Responses appear in the chat thread inside the app',
            color: _lime,
            onTap: () async {
              await AuthService.setDeliveryPreference(DeliveryPreference.app);
              if (context.mounted) Navigator.pop(context);
            },
          ),
          const SizedBox(height: 10),

          // Discord option
          _PrefOption(
            icon: Icons.send_rounded,
            label: 'DISCORD DM',
            subtitle: 'Lt. Reaper sends a DM via the OpenClaw bot',
            color: _discord,
            onTap: () async {
              await AuthService.setDeliveryPreference(DeliveryPreference.discord);
              if (context.mounted) Navigator.pop(context);
            },
          ),

          const SizedBox(height: 14),
          Text('You can change this any time in your profile settings.',
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.28),
                  fontSize: 10)),
          if (showCancel) ...[
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: double.infinity,
                height: 40,
                alignment: Alignment.center,
                child: Text('Keep current setting',
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.30),
                        fontSize: 12)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PrefOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _PrefOption({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: color.withValues(alpha: 0.35)),
        ),
        child: Row(children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.38),
                        fontSize: 10,
                        height: 1.4)),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded,
              color: color.withValues(alpha: 0.40), size: 18),
        ]),
      ),
    );
  }
}

// ── Screen ──────────────────────────────────────────────────────────────────

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late final AnimationController _boot;
  late final AnimationController _flash;
  late final AnimationController _pulse;

  final _callsignCtrl = TextEditingController();
  final _codeCtrl     = TextEditingController();
  bool _engaged       = false;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _boot  = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2600));
    _flash = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _pulse = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1700))
      ..repeat(reverse: true);

    Future.delayed(
        const Duration(milliseconds: 700), () { if (mounted) _boot.forward(); });

    // If AuthService.init() already restored a session (called in main()),
    // skip the login screen entirely on next frame.
    if (AuthService.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _navigateToShell();
      });
    }
  }

  @override
  void dispose() {
    _boot.dispose();
    _flash.dispose();
    _pulse.dispose();
    _callsignCtrl.dispose();
    _codeCtrl.dispose();
    super.dispose();
  }

  // ── App login ─────────────────────────────────────────────────────────────

  Future<void> _engage() async {
    if (_engaged) return;

    final callsign = _callsignCtrl.text.trim();
    final accessCode = _codeCtrl.text.trim();

    if (callsign.isEmpty) {
      setState(() => _errorMsg = 'Enter your callsign or email.');
      return;
    }
    if (accessCode.isEmpty) {
      setState(() => _errorMsg = 'Enter your access code.');
      return;
    }

    setState(() { _engaged = true; _errorMsg = null; });
    HapticFeedback.mediumImpact();

    // Validate access code against the server
    try {
      final response = await http
          .post(
            Uri.parse('$kTipsBaseUrl/api/auth/verify'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'callsign': callsign,
              'accessCode': accessCode,
            }),
          )
          .timeout(const Duration(seconds: 6));

      if (!mounted) return;

      if (response.statusCode != 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        setState(() {
          _engaged = false;
          _errorMsg = body['error'] as String? ?? 'Invalid credentials.';
        });
        return;
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _engaged = false;
        _errorMsg = 'Could not reach server. Is the engine running?';
      });
      return;
    }

    await AuthService.loginWithApp(
      callsign: callsign,
      email: callsign.contains('@') ? callsign : null,
    );

    if (!mounted) return;

    if (AuthService.needsDeliveryPreferencePrompt) {
      await showDeliveryPreferenceSheet(context);
    }

    if (!mounted) return;
    await _navigateToShell();
  }

  // ── Discord OAuth login ───────────────────────────────────────────────────
  //
  // Production flow:
  //   1. DiscordOAuthService.authenticate() opens Discord OAuth in the browser.
  //   2. User authorizes → Discord redirects to our backend with ?code=...
  //   3. Backend exchanges code for token, fetches user, redirects to
  //      codcamp://auth?discord_id=<id>&username=<name> (mobile) or
  //      back to the web app URL with query params (web).
  //   4. app_links picks up the deep link → DiscordOAuthService resolves
  //      the Future with a DiscordUser.
  //   5. We call AuthService.loginWithDiscord() with the real user info.

  Future<void> _engageDiscord() async {
    if (_engaged) return;

    setState(() { _engaged = true; _errorMsg = null; });
    HapticFeedback.mediumImpact();

    try {
      final discordUser = await DiscordOAuthService.authenticate();

      if (!mounted) return;

      if (discordUser == null) {
        // User cancelled or auth failed
        setState(() {
          _engaged = false;
          _errorMsg = 'Discord login cancelled or failed.';
        });
        return;
      }

      await AuthService.loginWithDiscord(
        discordId:       discordUser.id,
        discordUsername: discordUser.displayName,
        discordAvatar:   discordUser.avatar,
      );

      if (!mounted) return;

      if (AuthService.needsDeliveryPreferencePrompt) {
        await showDeliveryPreferenceSheet(context);
      }

      if (!mounted) return;
      await _navigateToShell();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _engaged = false;
        _errorMsg = 'Discord login error. Try again.';
      });
    }
  }

  Future<void> _navigateToShell() async {
    await _flash.forward();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (_, __, ___) => const MainShell(),
      transitionsBuilder: (_, a, __, child) =>
          FadeTransition(opacity: a, child: child),
      transitionDuration: const Duration(milliseconds: 600),
    ));
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final logoSize = screenWidth * 0.40;

    return Scaffold(
      backgroundColor: _bg,
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: [

          // ── Tactical background
          const TacticalLoginBackground(),

          // ── Scrollable content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 28),

                  // ── Skull logo — ~40% screen width
                  AnimatedBuilder(
                    animation: _pulse,
                    builder: (_, __) => Container(
                      width: logoSize,
                      height: logoSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: _lime.withValues(
                                alpha: 0.28 + _pulse.value * 0.18),
                            width: 1.5),
                        boxShadow: [
                          BoxShadow(
                              color: _lime.withValues(
                                  alpha: 0.07 + _pulse.value * 0.11),
                              blurRadius: 24,
                              spreadRadius: 2),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset('assets/images/app_logo.png',
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Eyebrow — "GHOST PROTOCOL"
                  Text('GHOST PROTOCOL',
                      style: TextStyle(
                          color: _lime.withValues(alpha: 0.50),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 4.0)),

                  const SizedBox(height: 4),

                  // Title — "COD CAMP"
                  const Text('COD CAMP',
                      style: TextStyle(
                          color: _lime,
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 6.0,
                          height: 1.0)),

                  const SizedBox(height: 24),

                  // Boot sequence
                  _BootSequence(ctrl: _boot),

                  const SizedBox(height: 22),

                  // Callsign
                  _TacField(
                    ctrl: _callsignCtrl,
                    label: 'CALLSIGN / EMAIL',
                    icon: Icons.person_outline_rounded,
                    keyboard: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),

                  // Access code
                  _TacField(
                    ctrl: _codeCtrl,
                    label: 'ACCESS CODE',
                    icon: Icons.lock_outline_rounded,
                    obscure: true,
                  ),

                  // Error message
                  if (_errorMsg != null) ...[
                    const SizedBox(height: 10),
                    Text(_errorMsg!,
                        style: const TextStyle(
                            color: Color(0xFFFF6B6B), fontSize: 11)),
                  ],

                  const SizedBox(height: 26),

                  // ── ENGAGE button with pulsing glow
                  AnimatedBuilder(
                    animation: _pulse,
                    builder: (_, __) => GestureDetector(
                      onTap: _engage,
                      child: Container(
                        width: double.infinity,
                        height: 58,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: const Color(0xFF0A1805),
                          border: Border.all(
                              color: _lime.withValues(
                                  alpha: 0.55 + _pulse.value * 0.40),
                              width: 1.5),
                          boxShadow: [
                            BoxShadow(
                                color: _lime.withValues(
                                    alpha: 0.07 + _pulse.value * 0.14),
                                blurRadius: 18 + _pulse.value * 10,
                                spreadRadius: 1),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('ENGAGE',
                                style: TextStyle(
                                    color: _lime,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 6.0)),
                            const SizedBox(width: 10),
                            Icon(Icons.chevron_right_rounded,
                                color: _lime.withValues(
                                    alpha: 0.65 + _pulse.value * 0.35),
                                size: 24),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Divider
                  Row(children: [
                    Expanded(
                        child: Container(
                            height: 1,
                            color: _lime.withValues(alpha: 0.10))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('OR',
                          style: TextStyle(
                              color: _lime.withValues(alpha: 0.25),
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2.0)),
                    ),
                    Expanded(
                        child: Container(
                            height: 1,
                            color: _lime.withValues(alpha: 0.10))),
                  ]),

                  const SizedBox(height: 16),

                  // ── Sign in with Discord
                  GestureDetector(
                    onTap: _engaged ? null : _engageDiscord,
                    child: Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: _discord.withValues(alpha: 0.08),
                        border: Border.all(
                            color: _discord.withValues(alpha: 0.45),
                            width: 1.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.discord, color: _discord, size: 20),
                          const SizedBox(width: 10),
                          const Text('SIGN IN WITH DISCORD',
                              style: TextStyle(
                                  color: _discord,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2.5)),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Forgot access code
                  Text('Forgot access code?',
                      style: TextStyle(
                          color: _lime.withValues(alpha: 0.38),
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                          decorationColor: _lime.withValues(alpha: 0.22))),

                  const SizedBox(height: 34),

                  // Sign-up link
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const SignUpScreen())),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                            color: _lime.withValues(alpha: 0.25),
                            fontSize: 10,
                            letterSpacing: 1.0),
                        children: [
                          const TextSpan(text: 'NEW RECRUIT?  '),
                          TextSpan(
                            text: 'ENLIST HERE',
                            style: TextStyle(
                                color: _lime.withValues(alpha: 0.55),
                                fontWeight: FontWeight.w900,
                                decoration: TextDecoration.underline,
                                decorationColor: _lime.withValues(alpha: 0.30)),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // ── Fade-to-black transition
          AnimatedBuilder(
            animation: _flash,
            builder: (_, __) => _flash.value > 0
                ? Container(color: _bg.withValues(alpha: _flash.value))
                : const SizedBox.shrink(),
          ),

        ],
      ),
    );
  }
}
