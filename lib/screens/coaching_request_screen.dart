import 'package:flutter/material.dart';
import '../data/models/coaching_request.dart';
import '../shared/widgets/radar_background.dart';
import '../shared/widgets/request_line.dart';
import 'home_screen.dart'; // AppTopBar
import 'chat_screen.dart';

const _lime = Color(0xFFA6FF2E);
const _bg   = Color(0xFF050A05);
const _surf = Color(0xFF0C130C);

// ── Game-mode definitions ─────────────────────────────────────────────────────

class _GameMode {
  final String id;
  final String label;
  final IconData icon;
  final Color accent;

  const _GameMode({
    required this.id,
    required this.label,
    required this.icon,
    required this.accent,
  });
}

class _ModeCategory {
  final String title;
  final Color accent;
  final List<_GameMode> modes;

  const _ModeCategory({
    required this.title,
    required this.accent,
    required this.modes,
  });
}

const _bo7Accent = Color(0xFFFF9F2E);
const _wzAccent  = Color(0xFF6E9BFF);
const _foAccent  = Color(0xFFB07EFF);

const _categories = <_ModeCategory>[
  // ── BO7 MULTIPLAYER ─────────────────────────────────────────────
  _ModeCategory(
    title: 'BLACK OPS 7 — MULTIPLAYER',
    accent: _bo7Accent,
    modes: [
      _GameMode(id: 'bo7_tdm',        label: 'TEAM DEATHMATCH',   icon: Icons.groups_rounded,           accent: _bo7Accent),
      _GameMode(id: 'bo7_domination',  label: 'DOMINATION',        icon: Icons.flag_rounded,             accent: _bo7Accent),
      _GameMode(id: 'bo7_hardpoint',   label: 'HARDPOINT',         icon: Icons.my_location_rounded,      accent: _bo7Accent),
      _GameMode(id: 'bo7_snd',         label: 'SEARCH & DESTROY',  icon: Icons.gps_fixed_rounded,        accent: _bo7Accent),
      _GameMode(id: 'bo7_control',     label: 'CONTROL',           icon: Icons.shield_rounded,           accent: _bo7Accent),
      _GameMode(id: 'bo7_kill_order',  label: 'KILL ORDER',        icon: Icons.track_changes_rounded,    accent: _bo7Accent),
      _GameMode(id: 'bo7_confirmed',   label: 'KILL CONFIRMED',    icon: Icons.verified_rounded,         accent: _bo7Accent),
      _GameMode(id: 'bo7_ffa',         label: 'FREE-FOR-ALL',      icon: Icons.person_rounded,           accent: _bo7Accent),
      _GameMode(id: 'bo7_overload',    label: 'OVERLOAD',          icon: Icons.bolt_rounded,             accent: _bo7Accent),
      _GameMode(id: 'bo7_gunfight',    label: 'GUNFIGHT',          icon: Icons.flash_on_rounded,         accent: _bo7Accent),
      _GameMode(id: 'bo7_skirmish',    label: 'SKIRMISH (20v20)',  icon: Icons.military_tech_rounded,    accent: _bo7Accent),
    ],
  ),

  // ── BO7 FACE OFF ────────────────────────────────────────────────
  _ModeCategory(
    title: 'BLACK OPS 7 — FACE OFF',
    accent: _foAccent,
    modes: [
      _GameMode(id: 'fo_tdm',         label: 'FACE OFF: TDM',         icon: Icons.groups_rounded,        accent: _foAccent),
      _GameMode(id: 'fo_domination',   label: 'FACE OFF: DOMINATION',  icon: Icons.flag_rounded,          accent: _foAccent),
      _GameMode(id: 'fo_kill_order',   label: 'FACE OFF: KILL ORDER',  icon: Icons.track_changes_rounded, accent: _foAccent),
      _GameMode(id: 'fo_confirmed',    label: 'FACE OFF: CONFIRMED',   icon: Icons.verified_rounded,      accent: _foAccent),
    ],
  ),

  // ── WARZONE ─────────────────────────────────────────────────────
  _ModeCategory(
    title: 'WARZONE',
    accent: _wzAccent,
    modes: [
      _GameMode(id: 'wz_br',          label: 'BATTLE ROYALE',        icon: Icons.public_rounded,        accent: _wzAccent),
      _GameMode(id: 'wz_resurgence',   label: 'RESURGENCE',          icon: Icons.refresh_rounded,       accent: _wzAccent),
      _GameMode(id: 'wz_bo_royale',    label: 'BLACK OPS ROYALE',    icon: Icons.star_rounded,          accent: _wzAccent),
      _GameMode(id: 'wz_ranked_resurg',label: 'RANKED RESURGENCE',   icon: Icons.emoji_events_rounded,  accent: _wzAccent),
      _GameMode(id: 'wz_clash',        label: 'CLASH',               icon: Icons.whatshot_rounded,       accent: _wzAccent),
      _GameMode(id: 'wz_plunder',      label: 'PLUNDER',             icon: Icons.attach_money_rounded,  accent: _wzAccent),
    ],
  ),
];

// ── Screen ────────────────────────────────────────────────────────────────────

class CoachingRequestScreen extends StatefulWidget {
  final CoachingRequest? latestRequest;
  final void Function(CoachingRequest) onSubmitRequest;

  const CoachingRequestScreen({
    super.key,
    required this.latestRequest,
    required this.onSubmitRequest,
  });

  @override
  State<CoachingRequestScreen> createState() => _CoachingRequestScreenState();
}

class _CoachingRequestScreenState extends State<CoachingRequestScreen> {
  int get _totalModes =>
      _categories.fold(0, (sum, cat) => sum + cat.modes.length);

  void _selectMode(_GameMode mode) {
    // Don't submit to server yet — wait until the user sends their first
    // message so we never create empty coaching requests.
    final request = CoachingRequest(mode: mode.label);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(
          request: request,
          onRequestCreated: widget.onSubmitRequest,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: RadarBackground(
        child: SafeArea(
          child: Column(
            children: [
              // ── Header ──────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppTopBar(
                      title: 'Request Coaching',
                      subtitle: 'Select a game mode to start',
                      icon: Icons.sports_esports_rounded,
                    ),
                    const SizedBox(height: 12),
                    Row(children: [
                      Text('CHOOSE YOUR MODE',
                          style: TextStyle(
                              color: _lime.withValues(alpha: 0.45),
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2.5)),
                      const Spacer(),
                      Text('$_totalModes AVAILABLE',
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.18),
                              fontSize: 9,
                              letterSpacing: 1.0)),
                    ]),
                    const SizedBox(height: 8),
                    Container(height: 1, color: _lime.withValues(alpha: 0.06)),
                  ],
                ),
              ),

              // ── Mode list ───────────────────────────────────────────────
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  itemCount: _categories.length,
                  itemBuilder: (context, catIdx) {
                    final cat = _categories[catIdx];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (catIdx > 0) const SizedBox(height: 20),

                        // Category header
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Container(
                                width: 3, height: 12,
                                decoration: BoxDecoration(
                                  color: cat.accent,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(cat.title,
                                  style: TextStyle(
                                      color: cat.accent.withValues(alpha: 0.70),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 2.0)),
                              const Spacer(),
                              Text('${cat.modes.length}',
                                  style: TextStyle(
                                      color: cat.accent.withValues(alpha: 0.25),
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),

                        // Mode tiles
                        ...cat.modes.map((mode) => _ModeTile(
                          mode: mode,
                          onTap: () => _selectMode(mode),
                        )),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Mode tile ─────────────────────────────────────────────────────────────────

class _ModeTile extends StatelessWidget {
  final _GameMode mode;
  final VoidCallback onTap;

  const _ModeTile({
    required this.mode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: _surf,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.06),
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 34, height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: mode.accent.withValues(alpha: 0.08),
                border: Border.all(color: mode.accent.withValues(alpha: 0.22)),
              ),
              child: Icon(mode.icon,
                  color: mode.accent.withValues(alpha: 0.70), size: 15),
            ),
            const SizedBox(width: 12),

            // Label
            Expanded(
              child: Text(mode.label,
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.80),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.4)),
            ),

            Icon(Icons.arrow_forward_ios_rounded,
                color: mode.accent.withValues(alpha: 0.25), size: 12),
          ],
        ),
      ),
    );
  }
}

// ── Legacy shared cards (kept for profile screen compatibility) ───────────────

class CoachingPreviewCard extends StatelessWidget {
  final String mode, weakness, goal, sessionLength, urgency, notes;
  final bool patchAware, includeLoadoutReview, includeVodReview;

  const CoachingPreviewCard({
    super.key,
    required this.mode,
    required this.weakness,
    required this.goal,
    required this.sessionLength,
    required this.urgency,
    required this.patchAware,
    required this.includeLoadoutReview,
    required this.includeVodReview,
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: const BorderRadius.all(Radius.circular(3)),
        border: Border.all(color: const Color(0xFF252525)),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Preview',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5)),
            const SizedBox(height: 12),
            RequestLine(label: 'Mode', value: mode),
            if (weakness.isNotEmpty)
              RequestLine(label: 'Weakness', value: weakness),
            if (goal.isNotEmpty)
              RequestLine(label: 'Goal', value: goal),
            if (sessionLength.isNotEmpty)
              RequestLine(label: 'Session', value: sessionLength),
            if (urgency.isNotEmpty)
              RequestLine(label: 'Urgency', value: urgency),
            if (patchAware)
              RequestLine(label: 'Patch-aware', value: 'Yes'),
            if (notes.trim().isNotEmpty) ...[
              const SizedBox(height: 10),
              const Text('Notes',
                  style: TextStyle(
                      color: Color(0xFFA6FF2E),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2)),
              const SizedBox(height: 6),
              Text(notes.trim(),
                  style: const TextStyle(
                      color: Color(0xFFAAAAAA), fontSize: 13, height: 1.5)),
            ],
          ]),
    );
  }
}

class CoachingSummaryCard extends StatelessWidget {
  final CoachingRequest request;
  const CoachingSummaryCard({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0C130C),
        borderRadius: const BorderRadius.all(Radius.circular(3)),
        border: Border.all(color: _lime.withValues(alpha: 0.18)),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Icon(Icons.verified_rounded, color: _lime, size: 14),
              const SizedBox(width: 8),
              const Text('Active Request',
                  style: TextStyle(
                      color: _lime,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2)),
            ]),
            const SizedBox(height: 12),
            RequestLine(label: 'Mode', value: request.mode),
            if (request.sessionLength.isNotEmpty)
              RequestLine(label: 'Session', value: request.sessionLength),
            if (request.urgency.isNotEmpty)
              RequestLine(label: 'Urgency', value: request.urgency),
          ]),
    );
  }
}
