import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../data/models/intel_item.dart';
import '../data/models/coaching_request.dart';
import '../shared/widgets/empty_state_card.dart';
import '../services/auth_service.dart';
import '../services/loadout_service.dart';
import 'home_screen.dart';
import 'login_screen.dart' show LoginScreen, showDeliveryPreferenceSheet;
import 'my_stats_screen.dart';
import 'chat_screen.dart';

const _lime = Color(0xFFA6FF2E);
const _amber = Color(0xFFD7A430);
const _bg = Color(0xFF050A05);
const _surf = Color(0xFF0C130C);

// ── Circular gauge painter ────────────────────────────────────────────────────

class _GaugePainter extends CustomPainter {
  final double value; // 0.0–1.0
  final Color color;

  const _GaugePainter({required this.value, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 6;
    const startAngle = math.pi * 0.75;
    const sweepAll = math.pi * 1.5;

    // Track
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAll,
      false,
      Paint()
        ..color = color.withValues(alpha: 0.10)
        ..strokeWidth = 5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Value arc
    if (value > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAll * value.clamp(0.0, 1.0),
        false,
        Paint()
          ..color = color
          ..strokeWidth = 5
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
    }

    // Outer ring
    canvas.drawCircle(
      center,
      radius + 8,
      Paint()
        ..color = color.withValues(alpha: 0.08)
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(_GaugePainter old) =>
      old.value != value || old.color != color;
}

// ── Stat gauge widget ─────────────────────────────────────────────────────────

class _StatGauge extends StatelessWidget {
  final String label;
  final int value; // 0–100
  final String grade;
  final Color color;

  const _StatGauge({
    required this.label,
    required this.value,
    required this.grade,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96,
      child: Column(
        children: [
          SizedBox(
            width: 90,
            height: 90,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(90, 90),
                  painter: _GaugePainter(value: value / 100, color: color),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$value',
                      style: TextStyle(
                        color: color,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        height: 1.0,
                      ),
                    ),
                    Text(
                      '/100',
                      style: TextStyle(
                        color: color.withValues(alpha: 0.40),
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            grade,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.35),
              fontSize: 9,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tactical progress bar ─────────────────────────────────────────────────────

class _TacBar extends StatelessWidget {
  final String label;
  final double value; // 0.0–1.0
  final String? rightLabel;
  final Color color = _lime;

  const _TacBar({required this.label, required this.value, this.rightLabel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                color: color.withValues(alpha: 0.45),
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
            const Spacer(),
            if (rightLabel != null)
              Text(
                rightLabel!,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
          ],
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(1),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 4,
            backgroundColor: color.withValues(alpha: 0.10),
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}

// ── Tab button ────────────────────────────────────────────────────────────────

class _TabBtn extends StatelessWidget {
  final String label;
  final int index;
  final int selected;
  final void Function(int) onTap;

  const _TabBtn({
    required this.label,
    required this.index,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final active = index == selected;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: active ? _lime.withValues(alpha: 0.10) : Colors.transparent,
            borderRadius: BorderRadius.circular(2),
            border: active
                ? Border.all(color: _lime.withValues(alpha: 0.30))
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: active ? _lime : Colors.white.withValues(alpha: 0.30),
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Action button ─────────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final bool primary;

  const _ActionButton({
    required this.label,
    required this.icon,
    this.onTap,
    this.primary = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: primary ? _lime.withValues(alpha: 0.08) : Colors.transparent,
          border: Border.all(
            color: primary
                ? _lime.withValues(alpha: 0.45)
                : Colors.white.withValues(alpha: 0.10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: primary ? _lime : Colors.white.withValues(alpha: 0.30),
              size: 16,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: primary ? _lime : Colors.white.withValues(alpha: 0.30),
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 2.0,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right_rounded,
              color: primary
                  ? _lime.withValues(alpha: 0.50)
                  : Colors.white.withValues(alpha: 0.15),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Screen ────────────────────────────────────────────────────────────────────

class ProfileScreen extends StatefulWidget {
  final Set<String> savedTipIds;
  final Set<String> savedLoadoutIds;
  final List<IntelItem> allTips;
  final List<Loadout> allLoadouts;
  final List<CoachingRequest> coachingHistory;
  final void Function(String id) onToggleSavedTip;
  final void Function(String id) onToggleSavedLoadout;
  final void Function(IntelItem item) onOpenTip;
  final void Function(String requestId) onDeleteCoachingRequest;

  const ProfileScreen({
    super.key,
    required this.savedTipIds,
    required this.savedLoadoutIds,
    required this.allTips,
    required this.allLoadouts,
    required this.coachingHistory,
    required this.onToggleSavedTip,
    required this.onToggleSavedLoadout,
    required this.onOpenTip,
    required this.onDeleteCoachingRequest,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _tab = 0; // 0=OVERVIEW 1=SKILLS 2=LOADOUT

  // Mirrors AuthService so the UI rebuilds when preference changes.
  DeliveryPreference? _deliveryPref;

  @override
  void initState() {
    super.initState();
    _deliveryPref = AuthService.deliveryPreference;
  }

  @override
  Widget build(BuildContext context) {
    final savedTips = widget.allTips
        .where((t) => widget.savedTipIds.contains(t.id))
        .toList();
    final savedLoadouts = widget.allLoadouts
        .where((l) => widget.savedLoadoutIds.contains(l.id))
        .toList();

    final user = AuthService.currentUser;
    final displayName = user?.displayName ?? 'GHOSTCAMPER';
    final avatarUrl = user?.discordAvatarUrl;
    final isDiscord = user?.discordId != null;

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────────────────
              AppTopBar(
                title: 'Operative Profile',
                subtitle: isDiscord
                    ? '${user!.discordUsername} · Active'
                    : 'Ghost_Protocol · Active',
                icon: Icons.person_rounded,
              ),

              const SizedBox(height: 18),

              // ── Hero card ───────────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _surf,
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: _lime.withValues(alpha: 0.18)),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Avatar — Discord profile picture or fallback icon
                        Stack(
                          children: [
                            Container(
                              width: 68,
                              height: 68,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _lime.withValues(alpha: 0.08),
                                border: Border.all(
                                  color: _lime.withValues(alpha: 0.45),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: _lime.withValues(alpha: 0.15),
                                    blurRadius: 12,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: avatarUrl != null
                                  ? ClipOval(
                                      child: Image.network(
                                        avatarUrl,
                                        width: 64,
                                        height: 64,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, _, _) => const Icon(
                                          Icons.person_outline_rounded,
                                          color: _lime,
                                          size: 34,
                                        ),
                                      ),
                                    )
                                  : const Icon(
                                      Icons.person_outline_rounded,
                                      color: _lime,
                                      size: 34,
                                    ),
                            ),
                            Positioned(
                              bottom: 2,
                              right: 2,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _lime,
                                  border: Border.all(color: _surf, width: 2),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      displayName.toUpperCase(),
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 7,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _lime.withValues(alpha: 0.10),
                                      borderRadius: BorderRadius.circular(2),
                                      border: Border.all(
                                        color: _lime.withValues(alpha: 0.30),
                                      ),
                                    ),
                                    child: Text(
                                      'ACTIVE',
                                      style: TextStyle(
                                        color: _lime,
                                        fontSize: 8,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                isDiscord
                                    ? 'Discord Linked · Tier 3 Recruit'
                                    : 'Tier 3 Recruit',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.40),
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // K/D + WIN RATE + HRS
                              Row(
                                children: [
                                  _MiniStat(label: 'K/D', value: '1.48'),
                                  _MiniStatDiv(),
                                  _MiniStat(label: 'WIN RATE', value: '58%'),
                                  _MiniStatDiv(),
                                  _MiniStat(label: 'HRS PLAYED', value: '72h'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    Container(height: 1, color: _lime.withValues(alpha: 0.08)),
                    const SizedBox(height: 10),

                    // Coordinates
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: _lime.withValues(alpha: 0.30),
                          size: 11,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'GPC-752-BRAVO  ·  SECTOR DELTA  ·  ZONE 04',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.25),
                            fontSize: 9,
                            letterSpacing: 0.8,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Tab bar ─────────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: const Color(0xFF080E08),
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: _lime.withValues(alpha: 0.10)),
                ),
                child: Row(
                  children: [
                    _TabBtn(
                      label: 'OVERVIEW',
                      index: 0,
                      selected: _tab,
                      onTap: (i) => setState(() => _tab = i),
                    ),
                    _TabBtn(
                      label: 'SKILLS',
                      index: 1,
                      selected: _tab,
                      onTap: (i) => setState(() => _tab = i),
                    ),
                    _TabBtn(
                      label: 'LOADOUT',
                      index: 2,
                      selected: _tab,
                      onTap: (i) => setState(() => _tab = i),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // ── Tab content ─────────────────────────────────────────────
              if (_tab == 0) _buildOverview(context),
              if (_tab == 1) _buildSkills(savedTips),
              if (_tab == 2) _buildLoadout(savedLoadouts),
            ],
          ),
        ),
      ),
    );
  }

  // ── OVERVIEW tab ───────────────────────────────────────────────────────────

  Widget _buildOverview(BuildContext context) {
    return Column(
      children: [
        // Stat gauges row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            _StatGauge(label: 'AIM', value: 72, grade: 'GOOD', color: _lime),
            _StatGauge(
              label: 'MOVEMENT',
              value: 68,
              grade: 'SOLID',
              color: Color(0xFF6E9BFF),
            ),
            _StatGauge(label: 'IQ', value: 74, grade: 'GOOD', color: _amber),
          ],
        ),

        const SizedBox(height: 22),

        // SEASON XP bar
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _surf,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: _lime.withValues(alpha: 0.10)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: _lime.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: const Icon(
                      Icons.workspace_premium_rounded,
                      color: _lime,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'SEASON XP',
                    style: TextStyle(
                      color: _lime.withValues(alpha: 0.50),
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'LVL 18',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _TacBar(
                label: '',
                value: 18450 / 25000,
                rightLabel: '18,450 / 25,000 XP',
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // COD CAMP COMPLETION bar
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _surf,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: _lime.withValues(alpha: 0.10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TacBar(
                label: 'COD CAMP COMPLETION',
                value: 0.87,
                rightLabel: '87%',
              ),
              const SizedBox(height: 10),
              // Tier progression
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ['RECRUIT', 'REGULAR', 'VETERAN', 'ELITE', 'MASTER']
                    .map(
                      (t) => Text(
                        t,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.22),
                          fontSize: 7,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // My Stats entry
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MyStatsScreen()),
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF080E08),
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: _lime.withValues(alpha: 0.15)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.bar_chart_rounded,
                  color: _lime.withValues(alpha: 0.55),
                  size: 16,
                ),
                const SizedBox(width: 10),
                Text(
                  'MY STATS  ·  Track performance by mode',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.40),
                    fontSize: 11,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.chevron_right_rounded,
                  color: _lime.withValues(alpha: 0.30),
                  size: 16,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 14),

        // VIEW COACHING HISTORY
        _ActionButton(
          label: 'VIEW COACHING HISTORY',
          icon: Icons.history_rounded,
          onTap: () => setState(() => _tab = 1),
          primary: true,
        ),

        const SizedBox(height: 10),

        // ADJUST TRAINING PLAN
        _ActionButton(
          label: 'ADJUST TRAINING PLAN',
          icon: Icons.edit_calendar_rounded,
          primary: false,
        ),

        const SizedBox(height: 18),

        // ── SETTINGS ────────────────────────────────────────────────────────
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF080E08),
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: _lime.withValues(alpha: 0.10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SETTINGS',
                style: TextStyle(
                  color: _lime.withValues(alpha: 0.40),
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.5,
                ),
              ),
              const SizedBox(height: 14),

              // Coaching delivery preference row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: _lime.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      Icons.send_rounded,
                      color: _lime.withValues(alpha: 0.55),
                      size: 14,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'COACHING DELIVERY',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _deliveryPref == null
                              ? 'Not configured'
                              : _deliveryPref == DeliveryPreference.app
                              ? 'In-app chat'
                              : 'Discord DM (via Lt. Reaper)',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.35),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () async {
                      await showDeliveryPreferenceSheet(
                        context,
                        dismissible: true,
                      );
                      if (mounted) {
                        setState(() {
                          _deliveryPref = AuthService.deliveryPreference;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _lime.withValues(alpha: 0.07),
                        borderRadius: BorderRadius.circular(2),
                        border: Border.all(
                          color: _lime.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Text(
                        'CHANGE',
                        style: TextStyle(
                          color: _lime.withValues(alpha: 0.70),
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              Container(height: 1, color: Colors.white.withValues(alpha: 0.06)),
              const SizedBox(height: 16),

              // Sign out row
              GestureDetector(
                onTap: () async {
                  final navigator = Navigator.of(context);
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: const Color(0xFF0C130C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(
                          color: Colors.red.withValues(alpha: 0.30),
                        ),
                      ),
                      title: const Text(
                        'SIGN OUT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),
                      content: const Text(
                        'You\'ll need to log in again to access coaching and saved data.',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: Text(
                            'CANCEL',
                            style: TextStyle(
                              color: _lime.withValues(alpha: 0.70),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text(
                            'SIGN OUT',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                  if (confirmed == true && mounted) {
                    await AuthService.logout();
                    if (mounted) {
                      navigator.pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    }
                  }
                },
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.07),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        Icons.logout_rounded,
                        color: Colors.redAccent.withValues(alpha: 0.55),
                        size: 14,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'SIGN OUT',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.redAccent.withValues(alpha: 0.30),
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // Footer
        Text(
          'FORGED IN TRAINING. BUILT FOR WAR.',
          style: TextStyle(
            color: _lime.withValues(alpha: 0.15),
            fontSize: 9,
            letterSpacing: 3.0,
          ),
        ),
      ],
    );
  }

  // ── SKILLS tab (saved tips + coaching history) ─────────────────────────────

  Widget _buildSkills(List<IntelItem> savedTips) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'SAVED TIPS',
              style: TextStyle(
                color: _lime.withValues(alpha: 0.45),
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.0,
              ),
            ),
            const Spacer(),
            Text(
              '${savedTips.length} ITEMS',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.20),
                fontSize: 9,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (savedTips.isEmpty)
          const EmptyStateCard(
            title: 'No saved tips',
            subtitle: 'Bookmark tips from the feed to see them here.',
          )
        else
          ...savedTips.map(
            (tip) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SavedTipCard(
                item: tip,
                onToggleSaved: () => widget.onToggleSavedTip(tip.id),
                onTap: () => widget.onOpenTip(tip),
              ),
            ),
          ),
        if (widget.coachingHistory.isNotEmpty) ...[
          const SizedBox(height: 18),
          Text(
            'COACHING HISTORY',
            style: TextStyle(
              color: _lime.withValues(alpha: 0.45),
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 10),
          ...widget.coachingHistory.reversed.map(
            (req) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _HistoryCard(
                request: req,
                onDelete: req.requestId != null
                    ? () => widget.onDeleteCoachingRequest(req.requestId!)
                    : null,
              ),
            ),
          ),
        ],
      ],
    );
  }

  // ── LOADOUT tab (saved loadouts) ────────────────────────────────────────────

  Widget _buildLoadout(List<Loadout> savedLoadouts) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'SAVED LOADOUTS',
              style: TextStyle(
                color: _lime.withValues(alpha: 0.45),
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.0,
              ),
            ),
            const Spacer(),
            Text(
              '${savedLoadouts.length} BUILDS',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.20),
                fontSize: 9,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (savedLoadouts.isEmpty)
          const EmptyStateCard(
            title: 'No saved loadouts',
            subtitle:
                'Bookmark builds from the Loadouts tab to save them here.',
          )
        else
          ...savedLoadouts.map(
            (lo) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _SavedLoadoutCard(
                loadout: lo,
                onRemove: () => widget.onToggleSavedLoadout(lo.id),
              ),
            ),
          ),
      ],
    );
  }
}

// ── Mini stat cell ────────────────────────────────────────────────────────────

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.30),
            fontSize: 8,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }
}

class _MiniStatDiv extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    width: 1,
    height: 28,
    margin: const EdgeInsets.symmetric(horizontal: 10),
    color: Colors.white.withValues(alpha: 0.08),
  );
}

// ── MiniProfileStat (legacy — kept for compatibility) ─────────────────────────

class MiniProfileStat extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;

  const MiniProfileStat({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _surf,
        borderRadius: const BorderRadius.all(Radius.circular(3)),
        border: Border.all(color: _lime.withValues(alpha: 0.12)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.35),
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Saved tip card ────────────────────────────────────────────────────────────

class SavedTipCard extends StatelessWidget {
  final IntelItem item;
  final VoidCallback onToggleSaved;
  final VoidCallback onTap;

  const SavedTipCard({
    super.key,
    required this.item,
    required this.onToggleSaved,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: _surf,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: item.accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Icon(item.icon, color: item.accent, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.category,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.30),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onToggleSaved,
              child: const Icon(
                Icons.bookmark_rounded,
                color: _amber,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Saved loadout card ───────────────────────────────────────────────────────

class _SavedLoadoutCard extends StatelessWidget {
  final Loadout loadout;
  final VoidCallback onRemove;

  const _SavedLoadoutCard({required this.loadout, required this.onRemove});

  Color _tierColor(String tier) {
    switch (tier) {
      case 'S':
        return const Color(0xFFFFD700);
      case 'A':
        return const Color(0xFFA6FF2E);
      case 'B':
        return const Color(0xFF6E9BFF);
      default:
        return const Color(0xFF888888);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tierColor = _tierColor(loadout.tier);
    final attPreview = loadout.attachments.entries
        .take(3)
        .map((e) => e.value)
        .join(' · ');

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _surf,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          // Tier badge
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: tierColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: tierColor.withValues(alpha: 0.4)),
            ),
            child: Center(
              child: Text(
                loadout.tier,
                style: TextStyle(
                  color: tierColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loadout.weapon,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${loadout.weaponClass}  ·  $attPreview',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.30),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.bookmark_rounded, color: _amber, size: 20),
          ),
        ],
      ),
    );
  }
}

// ── History card ──────────────────────────────────────────────────────────────

class _HistoryCard extends StatelessWidget {
  final CoachingRequest request;
  final VoidCallback? onDelete;
  const _HistoryCard({required this.request, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final hasThread = request.requestId != null;
    return GestureDetector(
      onTap: hasThread
          ? () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ChatScreen(request: request)),
            )
          : null,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _surf,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(
            color: hasThread
                ? _lime.withValues(alpha: 0.18)
                : Colors.white.withValues(alpha: 0.06),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: _amber.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(3),
              ),
              child: const Icon(
                Icons.sports_esports_rounded,
                color: _amber,
                size: 17,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.mode,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (request.goal.isNotEmpty)
                    Text(
                      request.goal,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.30),
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
            ),
            if (hasThread)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: _lime.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(color: _lime.withValues(alpha: 0.25)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.chat_bubble_rounded,
                      color: _lime,
                      size: 10,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'CHAT',
                      style: const TextStyle(
                        color: _lime,
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              )
            else
              Text(
                request.urgency.isNotEmpty ? request.urgency : 'ACTIVE',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.25),
                  fontSize: 11,
                ),
              ),
            if (onDelete != null) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: const Color(0xFF111111),
                      title: const Text(
                        'Delete request?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      content: const Text(
                        'This will permanently remove this coaching request and its chat history.',
                        style: TextStyle(
                          color: Color(0xFFAAAAAA),
                          fontSize: 13,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text(
                            'CANCEL',
                            style: TextStyle(color: Color(0xFF555555)),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            onDelete!();
                          },
                          child: const Text(
                            'DELETE',
                            style: TextStyle(
                              color: Color(0xFFFF4444),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: Color(0xFF555555),
                  size: 18,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
