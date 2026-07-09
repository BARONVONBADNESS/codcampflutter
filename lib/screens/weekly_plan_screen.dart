import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../data/models/weekly_plan.dart';
import '../services/weekly_plan_service.dart';

const _lime  = Color(0xFFA6FF2E);
const _amber = Color(0xFFD7A430);
const _bg    = Color(0xFF050A05);
const _surf  = Color(0xFF0C130C);

// ── Session types ─────────────────────────────────────────────────────────────

enum _SessionTag { live, ab, solo }

extension _SessionTagX on _SessionTag {
  String get label {
    switch (this) {
      case _SessionTag.live: return 'LIVE SESSION';
      case _SessionTag.ab:   return 'A/B';
      case _SessionTag.solo: return 'SOLO';
    }
  }

  Color get color {
    switch (this) {
      case _SessionTag.live: return _lime;
      case _SessionTag.ab:   return _amber;
      case _SessionTag.solo: return const Color(0xFF6E9BFF);
    }
  }
}

// ── Data model ────────────────────────────────────────────────────────────────

class _Session {
  final String title;
  final String time;
  final IconData icon;
  final _SessionTag tag;
  final bool enabled;

  const _Session({
    required this.title,
    required this.time,
    required this.icon,
    required this.tag,
    this.enabled = true,
  });
}

// Default session schedule per day
const _defaultSessions = <_Session>[
  _Session(title: 'VOD REVIEW',     time: '7:30 PM',  icon: Icons.play_circle_outline_rounded, tag: _SessionTag.live),
  _Session(title: 'AIM TRAINING',   time: '8:30 PM',  icon: Icons.gps_fixed_rounded,           tag: _SessionTag.ab),
  _Session(title: '1V1 COACHING',   time: '9:30 PM',  icon: Icons.sports_esports_rounded,      tag: _SessionTag.live),
  _Session(title: 'CUSTOM DRILLS',  time: '10:30 PM', icon: Icons.fitness_center_rounded,       tag: _SessionTag.ab),
];

// ── Day selector cell ─────────────────────────────────────────────────────────

class _DayCell extends StatelessWidget {
  final String day;
  final bool active;
  final bool today;
  final VoidCallback onTap;

  const _DayCell({
    required this.day,
    required this.active,
    required this.today,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        width: 40,
        height: 48,
        decoration: BoxDecoration(
          color: active
              ? _lime.withValues(alpha: 0.12)
              : today
                  ? _lime.withValues(alpha: 0.04)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(
            color: active
                ? _lime.withValues(alpha: 0.50)
                : today
                    ? _lime.withValues(alpha: 0.20)
                    : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(day,
                style: TextStyle(
                    color: active
                        ? _lime
                        : today
                            ? _lime.withValues(alpha: 0.50)
                            : Colors.white.withValues(alpha: 0.25),
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5)),
            if (today && !active) ...[
              const SizedBox(height: 3),
              Container(
                  width: 4, height: 4,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _lime.withValues(alpha: 0.40))),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Session row ───────────────────────────────────────────────────────────────

class _SessionRow extends StatelessWidget {
  final int index;
  final _Session session;

  const _SessionRow({required this.index, required this.session});

  @override
  Widget build(BuildContext context) {
    final tagColor = session.tag.color;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: _surf,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(children: [

        // Index number
        SizedBox(
          width: 24,
          child: Text(index.toString().padLeft(2, '0'),
              style: TextStyle(
                  color: _lime.withValues(alpha: 0.20),
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'monospace')),
        ),

        const SizedBox(width: 10),

        // Icon
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: tagColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Icon(session.icon, color: tagColor, size: 18),
        ),

        const SizedBox(width: 12),

        // Title + time
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(session.title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5)),
            const SizedBox(height: 2),
            Text(session.time,
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.30),
                    fontSize: 11)),
          ],
        )),

        // Tag chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: tagColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: tagColor.withValues(alpha: 0.30)),
          ),
          child: Text(session.tag.label,
              style: TextStyle(
                  color: tagColor,
                  fontSize: 8,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0)),
        ),
      ]),
    );
  }
}

// ── Screen ────────────────────────────────────────────────────────────────────

class WeeklyPlanScreen extends StatefulWidget {
  final Set<String> completedTaskIds;
  final Set<String> savedPatchIds;
  final void Function(String id) onToggleTask;

  const WeeklyPlanScreen({
    super.key,
    required this.completedTaskIds,
    required this.savedPatchIds,
    required this.onToggleTask,
  });

  @override
  State<WeeklyPlanScreen> createState() => _WeeklyPlanScreenState();
}

class _WeeklyPlanScreenState extends State<WeeklyPlanScreen> {
  static const _days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
  int _selectedDay = 2; // WED default (matches mockup)

  WeeklyPlan? _plan; // null until loaded / on failure → use built-in defaults
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPlan();
  }

  Future<void> _loadPlan() async {
    final plan = await WeeklyPlanService.fetchPlan();
    if (!mounted) return;
    setState(() {
      _plan = plan;
      _loading = false;
    });
  }

  // Map a backend PlanSessionTag to the screen's private _SessionTag.
  _SessionTag _mapTag(PlanSessionTag t) {
    switch (t) {
      case PlanSessionTag.ab:
        return _SessionTag.ab;
      case PlanSessionTag.solo:
        return _SessionTag.solo;
      case PlanSessionTag.live:
        return _SessionTag.live;
    }
  }

  // Sessions to render for the selected day: live plan if available, else defaults.
  List<_Session> _sessionsForSelectedDay() {
    final plan = _plan;
    if (plan == null) return _defaultSessions;
    final live = plan.sessionsFor(_days[_selectedDay]);
    if (live.isEmpty) return const [];
    return live
        .map((s) => _Session(
              title: s.title,
              time: s.time,
              icon: planIconFor(s.iconKey),
              tag: _mapTag(s.tag),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final sessions = _sessionsForSelectedDay();
    final progress = _plan?.progress;
    final progressFraction = progress?.fraction ?? 0.68;
    final progressPercent =
        progress?.percent ?? 68;
    final progressLabel = progress != null
        ? '${progress.completed} / ${progress.total} SESSIONS COMPLETED'
        : '17 / 25 SESSIONS COMPLETED';
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Header ──────────────────────────────────────────────────
              const AppTopBar(
                title: 'Weekly Plan',
                subtitle: 'Ghost_Protocol · Schedule',
                icon: Icons.calendar_today_rounded,
              ),

              const SizedBox(height: 18),

              // ── Week progress card ──────────────────────────────────────
              Container(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                decoration: BoxDecoration(
                  color: _surf,
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: _lime.withValues(alpha: 0.18)),
                ),
                child: Row(children: [
                  Container(
                    width: 34, height: 34,
                    decoration: BoxDecoration(
                      color: _lime.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: const Icon(Icons.trending_up_rounded,
                        color: _lime, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Text('WEEK PROGRESS',
                            style: TextStyle(
                                color: _lime.withValues(alpha: 0.45),
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2.0)),
                        const Spacer(),
                        Text('$progressPercent%',
                            style: const TextStyle(
                                color: _lime,
                                fontSize: 13,
                                fontWeight: FontWeight.w900)),
                      ]),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(1),
                        child: LinearProgressIndicator(
                          value: progressFraction,
                          minHeight: 4,
                          backgroundColor: const Color(0xFF151F15),
                          valueColor: const AlwaysStoppedAnimation(_lime),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(progressLabel,
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.25),
                              fontSize: 9)),
                    ],
                  )),
                ]),
              ),

              const SizedBox(height: 16),

              // ── Day selector ────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_days.length, (i) => _DayCell(
                  day: _days[i],
                  active: i == _selectedDay,
                  today: i == 2, // WED = today for demo
                  onTap: () => setState(() => _selectedDay = i),
                )),
              ),

              const SizedBox(height: 18),

              // ── Day label ───────────────────────────────────────────────
              Row(children: [
                Text(_days[_selectedDay],
                    style: TextStyle(
                        color: _lime,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 3.0)),
                const SizedBox(width: 10),
                Text('— ${sessions.length} SESSIONS SCHEDULED',
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.25),
                        fontSize: 10)),
              ]),

              const SizedBox(height: 12),

              // ── Session list ────────────────────────────────────────────
              if (_loading && _plan == null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: SizedBox(
                      width: 18, height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(
                              _lime.withValues(alpha: 0.6))),
                    ),
                  ),
                )
              else if (sessions.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text('NO SESSIONS SCHEDULED — REST DAY.',
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.25),
                          fontSize: 10,
                          letterSpacing: 2.0)),
                )
              else
                ...sessions.asMap().entries.map((e) =>
                    _SessionRow(index: e.key + 1, session: e.value)),

              const SizedBox(height: 18),

              // ── EDIT SCHEDULE button ────────────────────────────────────
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: const Color(0xFF080E08),
                    border: Border.all(color: _lime.withValues(alpha: 0.25)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit_rounded,
                          color: _lime.withValues(alpha: 0.60), size: 16),
                      const SizedBox(width: 10),
                      Text('EDIT SCHEDULE',
                          style: TextStyle(
                              color: _lime.withValues(alpha: 0.60),
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 3.0)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Footer
              Center(
                child: Text('STAY IN THE FIGHT. EVERY DAY.',
                    style: TextStyle(
                        color: _lime.withValues(alpha: 0.12),
                        fontSize: 9,
                        letterSpacing: 3.0)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

