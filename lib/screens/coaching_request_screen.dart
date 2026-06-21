import 'package:flutter/material.dart';
import '../data/models/coaching_request.dart';
import '../services/coaching_service.dart';
import '../shared/widgets/radar_background.dart';
import '../shared/widgets/request_line.dart';
import 'home_screen.dart'; // AppTopBar

const _lime = Color(0xFFA6FF2E);
const _bg   = Color(0xFF050A05);
const _surf = Color(0xFF0C130C);

// ── Game-mode definitions ─────────────────────────────────────────────────────

class _GameMode {
  final String id;
  final String label;
  final String tag;
  final IconData icon;
  final Color accent;
  final List<String> weaknesses;
  final List<String> goals;
  final String? extraLabel;
  final List<String>? extras;

  const _GameMode({
    required this.id,
    required this.label,
    required this.tag,
    required this.icon,
    required this.accent,
    required this.weaknesses,
    required this.goals,
    this.extraLabel,
    this.extras,
  });
}

const _sessionLengths = ['30 MIN', '60 MIN', '90 MIN', '120 MIN'];
const _urgencies      = ['TONIGHT', 'THIS WEEK', 'NEXT SESSION', 'NO RUSH'];

const _modes = <_GameMode>[
  _GameMode(
    id: 'warzone',
    label: 'WARZONE BR',
    tag: 'Battle Royale · Squads',
    icon: Icons.public_rounded,
    accent: Color(0xFF6E9BFF),
    weaknesses: [
      'Positioning & Rotations', 'Gunfights', 'Zone Management',
      'Final Circle Play', 'Looting & Loadouts', 'Game Sense',
    ],
    goals: ['Get More Wins', 'Improve K/D', 'Better Endgame', 'Survive Longer'],
    extraLabel: 'SQUAD ROLE',
    extras: ['FRAGGER', 'IGL', 'SUPPORT', 'FLEX'],
  ),
  _GameMode(
    id: 'resurgence',
    label: 'RESURGENCE',
    tag: 'Ranked · Respawn',
    icon: Icons.refresh_rounded,
    accent: Color(0xFFA6FF2E),
    weaknesses: [
      'Aggressive Pushes', 'Respawn Timing', 'Rotation & Cover',
      'Communication', 'Loadout Selection',
    ],
    goals: ['Rank Up', 'Top 10 Consistency', 'More Eliminations', 'Better IGL Play'],
    extraLabel: 'CURRENT RANK',
    extras: ['BRONZE', 'SILVER', 'GOLD', 'PLATINUM', 'DIAMOND', 'CRIMSON'],
  ),
  _GameMode(
    id: 'multiplayer',
    label: 'MULTIPLAYER',
    tag: '6v6 · Core Modes',
    icon: Icons.groups_rounded,
    accent: Color(0xFFFF9F2E),
    weaknesses: [
      'Movement & Positioning', 'Aim & Gunfights', 'Map Knowledge',
      'Mode Mechanics', 'Utility Usage',
    ],
    goals: ['Improve K/D', 'Better Obj Play', 'Win More Rounds', 'Consistent Performance'],
    extraLabel: 'GAME TYPE',
    extras: ['HARDPOINT', 'SEARCH & DESTROY', 'CONTROL', 'TDM', 'DOMINATION'],
  ),
  _GameMode(
    id: 'ranked',
    label: 'RANKED MP',
    tag: 'Ranked · Competitive',
    icon: Icons.emoji_events_rounded,
    accent: Color(0xFFFFD700),
    weaknesses: [
      'Clutch Situations', 'Rotation Timing', 'Map Control',
      'Anti-Strat', 'Consistency Under Pressure',
    ],
    goals: ['Rank Up Fast', 'Hit Iridescent', 'Improve Win Rate', 'SR Consistency'],
    extraLabel: 'RANK RANGE',
    extras: ['0 – 2,500 SR', '2,500 – 5,000 SR', '5,000 – 7,500 SR', '7,500+ SR'],
  ),
  _GameMode(
    id: 'hot_pursuit',
    label: 'HOT PURSUIT',
    tag: 'Vehicles · Zone Control',
    icon: Icons.speed_rounded,
    accent: Color(0xFFFF6B6B),
    weaknesses: [
      'Vehicle Control', 'Zone Control', 'Engagement Timing',
      'Route Selection', 'Team Coordination',
    ],
    goals: ['More Wins', 'Consistent Placement', 'Better Mechanics', 'Zone Dominance'],
    extraLabel: null,
    extras: null,
  ),
];

// ── Mode Dropdown ─────────────────────────────────────────────────────────────

class _ModeDropdown extends StatefulWidget {
  final _GameMode? selected;
  final void Function(_GameMode) onSelect;

  const _ModeDropdown({required this.selected, required this.onSelect});

  @override
  State<_ModeDropdown> createState() => _ModeDropdownState();
}

class _ModeDropdownState extends State<_ModeDropdown> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final sel    = widget.selected;
    final accent = sel?.accent ?? _lime;

    return Column(
      children: [

        // ── Trigger ──────────────────────────────────────────────────────────
        GestureDetector(
          onTap: () => setState(() => _open = !_open),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              color: sel != null
                  ? sel.accent.withValues(alpha: 0.06)
                  : _surf,
              borderRadius: BorderRadius.circular(3),
              border: Border.all(
                color: sel != null
                    ? sel.accent.withValues(alpha: 0.55)
                    : (_open
                        ? _lime.withValues(alpha: 0.30)
                        : _lime.withValues(alpha: 0.14)),
                width: sel != null ? 1.5 : 1.0,
              ),
              boxShadow: sel != null
                  ? [BoxShadow(
                      color: sel.accent.withValues(alpha: 0.08),
                      blurRadius: 14)]
                  : null,
            ),
            child: Row(
              children: [
                // Icon circle
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 34, height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accent.withValues(alpha: 0.10),
                    border: Border.all(
                        color: accent.withValues(
                            alpha: sel != null ? 0.50 : 0.20)),
                  ),
                  child: Icon(
                    sel?.icon ?? Icons.sports_esports_rounded,
                    color: accent.withValues(alpha: sel != null ? 1.0 : 0.35),
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),

                // Label
                Expanded(
                  child: sel != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(sel.label,
                                style: TextStyle(
                                    color: sel.accent,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 2.0)),
                            const SizedBox(height: 1),
                            Text(sel.tag,
                                style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.32),
                                    fontSize: 10)),
                          ],
                        )
                      : Text('SELECT DEPLOYMENT MODE',
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.30),
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2.0)),
                ),

                // Chevron
                AnimatedRotation(
                  turns: _open ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: accent.withValues(alpha: sel != null ? 0.65 : 0.28),
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Options panel ─────────────────────────────────────────────────
        AnimatedSize(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          child: _open
              ? Container(
                  margin: const EdgeInsets.only(top: 2),
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: const Color(0xFF080E08),
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: _lime.withValues(alpha: 0.10)),
                  ),
                  child: Column(
                    children: _modes.map((m) {
                      final isSelected = m.id == sel?.id;
                      return GestureDetector(
                        onTap: () {
                          widget.onSelect(m);
                          setState(() => _open = false);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 140),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? m.accent.withValues(alpha: 0.07)
                                : Colors.transparent,
                            border: Border(
                              bottom: BorderSide(
                                  color: _lime.withValues(alpha: 0.05)),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32, height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: m.accent.withValues(alpha: 0.10),
                                  border: Border.all(
                                    color: m.accent.withValues(
                                        alpha: isSelected ? 0.55 : 0.22),
                                  ),
                                ),
                                child: Icon(m.icon, color: m.accent, size: 15),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(m.label,
                                        style: TextStyle(
                                            color: isSelected
                                                ? m.accent
                                                : Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 1.8)),
                                    const SizedBox(height: 1),
                                    Text(m.tag,
                                        style: TextStyle(
                                            color: Colors.white
                                                .withValues(alpha: 0.28),
                                            fontSize: 10)),
                                  ],
                                ),
                              ),
                              isSelected
                                  ? Icon(Icons.check_rounded,
                                      color: m.accent, size: 16)
                                  : Icon(Icons.arrow_forward_ios_rounded,
                                      color:
                                          Colors.white.withValues(alpha: 0.14),
                                      size: 11),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

// ── Chip selector ─────────────────────────────────────────────────────────────

class _ChipSelector extends StatelessWidget {
  final String label;
  final List<String> options;
  final String? selected;
  final Color accent;
  final void Function(String) onSelect;

  const _ChipSelector({
    required this.label,
    required this.options,
    required this.selected,
    required this.accent,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                color: accent.withValues(alpha: 0.45),
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: 2.2)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 7,
          runSpacing: 7,
          children: options.map((opt) {
            final active = opt == selected;
            return GestureDetector(
              onTap: () => onSelect(opt),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 140),
                padding:
                    const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
                decoration: BoxDecoration(
                  color: active
                      ? accent.withValues(alpha: 0.12)
                      : _surf,
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(
                    color: active
                        ? accent.withValues(alpha: 0.65)
                        : Colors.white.withValues(alpha: 0.09),
                    width: active ? 1.5 : 1.0,
                  ),
                  boxShadow: active
                      ? [BoxShadow(
                          color: accent.withValues(alpha: 0.10),
                          blurRadius: 8)]
                      : null,
                ),
                child: Text(opt,
                    style: TextStyle(
                        color: active
                            ? accent
                            : Colors.white.withValues(alpha: 0.38),
                        fontSize: 10,
                        fontWeight:
                            active ? FontWeight.w800 : FontWeight.w600,
                        letterSpacing: 0.6)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ── Toggle row ────────────────────────────────────────────────────────────────

class _ToggleRow extends StatelessWidget {
  final String label;
  final String sublabel;
  final bool value;
  final Color accent;
  final ValueChanged<bool> onToggle;

  const _ToggleRow({
    required this.label,
    required this.sublabel,
    required this.value,
    required this.accent,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onToggle(!value),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.75),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5)),
                const SizedBox(height: 2),
                Text(sublabel,
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.28),
                        fontSize: 10)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            width: 40, height: 22,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              color: value
                  ? accent.withValues(alpha: 0.18)
                  : const Color(0xFF111811),
              border: Border.all(
                  color: value
                      ? accent.withValues(alpha: 0.65)
                      : Colors.white.withValues(alpha: 0.12),
                  width: 1.2),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 160),
              alignment:
                  value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.all(2.5),
                width: 15, height: 15,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: value
                      ? accent
                      : Colors.white.withValues(alpha: 0.25),
                  boxShadow: value
                      ? [BoxShadow(
                          color: accent.withValues(alpha: 0.40),
                          blurRadius: 6)]
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Thin divider ──────────────────────────────────────────────────────────────

Widget _divider(Color accent) =>
    Container(height: 1, color: accent.withValues(alpha: 0.07));

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
  _GameMode? _mode;
  String?    _weakness;
  String?    _goal;
  String?    _extra;
  String     _sessionLength  = '60 MIN';
  String     _urgency        = 'THIS WEEK';
  bool       _patchAware     = true;
  bool       _includeLoadout = true;
  final      _notesCtrl      = TextEditingController();
  bool       _submitting     = false;

  bool get _canSubmit =>
      _mode != null && _weakness != null && _goal != null;

  void _onModeSelected(_GameMode mode) {
    if (_mode?.id == mode.id) return;
    setState(() {
      _mode     = mode;
      _weakness = null;
      _goal     = null;
      _extra    = null;
    });
  }

  String _buildNotes() {
    final parts = <String>[];
    final m = _mode;
    if (m != null && m.extraLabel != null && _extra != null) {
      parts.add('${m.extraLabel}: $_extra');
    }
    final userNotes = _notesCtrl.text.trim();
    if (userNotes.isNotEmpty) parts.add(userNotes);
    return parts.join('\n');
  }

  Future<void> _submit() async {
    if (!_canSubmit || _submitting) return;
    setState(() => _submitting = true);

    final request = CoachingRequest(
      mode:                 _mode!.label,
      weakness:             _weakness!,
      goal:                 _goal!,
      sessionLength:        _sessionLength,
      urgency:              _urgency,
      notes:                _buildNotes(),
      patchAware:           _patchAware,
      includeLoadoutReview: _includeLoadout,
      includeVodReview:     false,
    );

    final requestId = await CoachingService.submitRequest(request);
    final finalRequest = requestId != null
        ? request.copyWithRequestId(requestId)
        : request;

    widget.onSubmitRequest(finalRequest);
    if (!mounted) return;
    setState(() => _submitting = false);

    final accent = _mode?.accent ?? _lime;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF0C130C),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: BorderSide(color: accent.withValues(alpha: 0.25))),
        title: Row(children: [
          Icon(Icons.check_circle_rounded, color: accent, size: 18),
          const SizedBox(width: 8),
          const Text('REQUEST CONFIRMED',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5)),
        ]),
        content: Text(
          requestId != null
              ? 'Intel received. Lt. Reaper will brief you in your coaching thread.'
              : 'Saved locally — server unreachable. Briefing will arrive once the server is running.',
          style: const TextStyle(color: Color(0xFF778888), height: 1.55),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('CONFIRMED',
                style: TextStyle(
                    color: accent,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = _mode?.accent ?? _lime;

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
                      subtitle: 'Lt. Reaper will brief you',
                      icon: Icons.sports_esports_rounded,
                    ),
                    const SizedBox(height: 16),
                    Row(children: [
                      Text('DEPLOYMENT MODE',
                          style: TextStyle(
                              color: _lime.withValues(alpha: 0.45),
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2.5)),
                      const Spacer(),
                      Text('${_modes.length} AVAILABLE',
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.18),
                              fontSize: 9,
                              letterSpacing: 1.0)),
                    ]),
                    const SizedBox(height: 8),
                    _ModeDropdown(
                        selected: _mode, onSelect: _onModeSelected),
                    const SizedBox(height: 8),
                    Container(height: 1, color: _lime.withValues(alpha: 0.06)),
                  ],
                ),
              ),

              // ── Form area ────────────────────────────────────────────────
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeOut,
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.04),
                        end: Offset.zero,
                      ).animate(anim),
                      child: child,
                    ),
                  ),
                  child: _mode == null
                      ? _emptyState()
                      : _formContent(accent),
                ),
              ),

              // ── Deploy button ────────────────────────────────────────────
              AnimatedOpacity(
                opacity: _mode != null ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  decoration: BoxDecoration(
                    color: _bg,
                    border: Border(
                        top: BorderSide(
                            color: accent.withValues(alpha: 0.10))),
                  ),
                  padding: EdgeInsets.fromLTRB(
                      16, 12, 16,
                      MediaQuery.of(context).padding.bottom + 12),
                  child: GestureDetector(
                    onTap: _canSubmit ? _submit : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 54,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: _canSubmit
                            ? accent.withValues(alpha: 0.10)
                            : Colors.transparent,
                        border: Border.all(
                          color: _canSubmit
                              ? accent.withValues(alpha: 0.60)
                              : Colors.white.withValues(alpha: 0.10),
                          width: _canSubmit ? 1.5 : 1.0,
                        ),
                      ),
                      child: Center(
                        child: _submitting
                            ? SizedBox(
                                width: 18, height: 18,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: accent.withValues(alpha: 0.8)))
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.send_rounded,
                                      color: _canSubmit
                                          ? accent
                                          : Colors.white
                                              .withValues(alpha: 0.18),
                                      size: 15),
                                  const SizedBox(width: 10),
                                  Text('DEPLOY REQUEST',
                                      style: TextStyle(
                                          color: _canSubmit
                                              ? accent
                                              : Colors.white
                                                  .withValues(alpha: 0.18),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 3.0)),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Empty state ───────────────────────────────────────────────────────────

  Widget _emptyState() {
    return Center(
      key: const ValueKey('empty'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _lime.withValues(alpha: 0.04),
              border: Border.all(color: _lime.withValues(alpha: 0.12)),
            ),
            child: Icon(Icons.arrow_upward_rounded,
                color: _lime.withValues(alpha: 0.28), size: 26),
          ),
          const SizedBox(height: 16),
          Text('SELECT A DEPLOYMENT MODE',
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.22),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.0)),
          const SizedBox(height: 6),
          Text('to configure your briefing',
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.14),
                  fontSize: 10,
                  letterSpacing: 0.5)),
        ],
      ),
    );
  }

  // ── Form content (per mode) ───────────────────────────────────────────────

  Widget _formContent(Color accent) {
    final m = _mode!;

    return ListView(
      key: ValueKey(m.id),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      children: [

        // Weakness
        _ChipSelector(
          label: 'WEAKNESS',
          options: m.weaknesses,
          selected: _weakness,
          accent: accent,
          onSelect: (v) => setState(() => _weakness = v),
        ),
        const SizedBox(height: 20),
        _divider(accent),
        const SizedBox(height: 20),

        // Goal
        _ChipSelector(
          label: 'SESSION GOAL',
          options: m.goals,
          selected: _goal,
          accent: accent,
          onSelect: (v) => setState(() => _goal = v),
        ),

        // Mode-specific extra field
        if (m.extraLabel != null && m.extras != null) ...[
          const SizedBox(height: 20),
          _divider(accent),
          const SizedBox(height: 20),
          _ChipSelector(
            label: m.extraLabel!,
            options: m.extras!,
            selected: _extra,
            accent: accent,
            onSelect: (v) => setState(() => _extra = v),
          ),
        ],

        const SizedBox(height: 20),
        _divider(accent),
        const SizedBox(height: 20),

        // Session length
        _ChipSelector(
          label: 'SESSION LENGTH',
          options: _sessionLengths,
          selected: _sessionLength,
          accent: accent,
          onSelect: (v) => setState(() => _sessionLength = v),
        ),
        const SizedBox(height: 20),
        _divider(accent),
        const SizedBox(height: 20),

        // Urgency
        _ChipSelector(
          label: 'URGENCY',
          options: _urgencies,
          selected: _urgency,
          accent: accent,
          onSelect: (v) => setState(() => _urgency = v),
        ),
        const SizedBox(height: 20),
        _divider(accent),
        const SizedBox(height: 20),

        // Toggles
        _ToggleRow(
          label: 'Patch-Aware',
          sublabel: 'Include current meta context in your briefing',
          value: _patchAware,
          accent: accent,
          onToggle: (v) => setState(() => _patchAware = v),
        ),
        const SizedBox(height: 14),
        _ToggleRow(
          label: 'Loadout Review',
          sublabel: 'Request a weapon recommendation for your mode',
          value: _includeLoadout,
          accent: accent,
          onToggle: (v) => setState(() => _includeLoadout = v),
        ),
        const SizedBox(height: 20),
        _divider(accent),
        const SizedBox(height: 20),

        // Notes
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ADDITIONAL INTEL',
                style: TextStyle(
                    color: accent.withValues(alpha: 0.45),
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2.2)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: _surf,
                borderRadius: BorderRadius.circular(3),
                border: Border.all(
                    color: Colors.white.withValues(alpha: 0.09)),
              ),
              child: TextField(
                controller: _notesCtrl,
                maxLines: 3,
                style: const TextStyle(
                    color: Colors.white, fontSize: 12, height: 1.5),
                decoration: InputDecoration(
                  hintText: 'Any extra context for Lt. Reaper…',
                  hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.22),
                      fontSize: 12),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 80),
      ],
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
            RequestLine(label: 'Weakness', value: weakness),
            RequestLine(label: 'Goal', value: goal),
            RequestLine(label: 'Session', value: sessionLength),
            RequestLine(label: 'Urgency', value: urgency),
            RequestLine(label: 'Patch-aware', value: patchAware ? 'Yes' : 'No'),
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
            RequestLine(label: 'Session', value: request.sessionLength),
            RequestLine(label: 'Urgency', value: request.urgency),
          ]),
    );
  }
}
