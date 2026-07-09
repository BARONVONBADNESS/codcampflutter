import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../shared/widgets/radar_background.dart';
import '../services/stats_service.dart';
import 'home_screen.dart'; // for AppTopBar

// ── Mode definitions (mirrors Discord bot) ────────────────────────────────────
class _Mode {
  final String key;
  final String label;
  final String emoji;
  final List<_StatField> fields;
  const _Mode({required this.key, required this.label, required this.emoji, required this.fields});
}

class _StatField {
  final String key;
  final String label;
  final String hint;
  final String unit;
  const _StatField({required this.key, required this.label, required this.hint, this.unit = ''});
}

const _modes = [
  _Mode(key: 'battle_royale', label: 'Battle Royale', emoji: '🪂', fields: [
    _StatField(key: 'kd_ratio',            label: 'K/D Ratio',         hint: 'e.g. 1.48'),
    _StatField(key: 'win_rate',            label: 'Win Rate',          hint: 'e.g. 8',    unit: '%'),
    _StatField(key: 'gulag_win_pct',       label: 'Gulag Win Rate',    hint: 'e.g. 52',   unit: '%'),
    _StatField(key: 'avg_kills_per_game',  label: 'Avg Kills / Game',  hint: 'e.g. 4.2'),
    _StatField(key: 'avg_damage_per_game', label: 'Avg Damage / Game', hint: 'e.g. 1240'),
  ]),
  _Mode(key: 'resurgence', label: 'Resurgence', emoji: '🔄', fields: [
    _StatField(key: 'kd_ratio',            label: 'K/D Ratio',         hint: 'e.g. 1.80'),
    _StatField(key: 'win_rate',            label: 'Win Rate',          hint: 'e.g. 12',   unit: '%'),
    _StatField(key: 'avg_kills_per_game',  label: 'Avg Kills / Game',  hint: 'e.g. 6.5'),
    _StatField(key: 'avg_damage_per_game', label: 'Avg Damage / Game', hint: 'e.g. 1500'),
    _StatField(key: 'avg_placement',       label: 'Avg Placement',     hint: 'e.g. 8'),
  ]),
  _Mode(key: 'multiplayer', label: 'Multiplayer', emoji: '🎯', fields: [
    _StatField(key: 'elim_death_ratio',   label: 'Elim / Death Ratio', hint: 'e.g. 1.35'),
    _StatField(key: 'win_loss_ratio',     label: 'Win / Loss Ratio',   hint: 'e.g. 1.2'),
    _StatField(key: 'score_per_minute',   label: 'Score Per Minute',   hint: 'e.g. 420'),
    _StatField(key: 'avg_elims_per_game', label: 'Avg Elims / Game',   hint: 'e.g. 18'),
    _StatField(key: 'highest_streak',     label: 'Highest Streak',     hint: 'e.g. 14'),
  ]),
  _Mode(key: 'hot_pursuit', label: 'Hot Pursuit', emoji: '🚗', fields: [
    _StatField(key: 'kd_ratio',           label: 'K/D Ratio',         hint: 'e.g. 2.1'),
    _StatField(key: 'win_rate',           label: 'Win Rate',          hint: 'e.g. 55',  unit: '%'),
    _StatField(key: 'avg_kills_per_game', label: 'Avg Kills / Game',  hint: 'e.g. 8'),
    _StatField(key: 'avg_placement',      label: 'Avg Placement',     hint: 'e.g. 3'),
  ]),
  _Mode(key: 'ranked', label: 'Ranked Play', emoji: '🏆', fields: [
    _StatField(key: 'skill_rating',   label: 'Current SR',  hint: 'e.g. 1240'),
    _StatField(key: 'peak_sr',        label: 'Peak SR',     hint: 'e.g. 1480'),
    _StatField(key: 'win_loss_ratio', label: 'W/L Ratio',   hint: 'e.g. 1.1'),
    _StatField(key: 'kd_ratio',       label: 'K/D Ratio',   hint: 'e.g. 1.05'),
  ]),
];

// ── Screen ────────────────────────────────────────────────────────────────────
class MyStatsScreen extends StatefulWidget {
  const MyStatsScreen({super.key});

  @override
  State<MyStatsScreen> createState() => _MyStatsScreenState();
}

class _MyStatsScreenState extends State<MyStatsScreen> {
  static const _green  = Color(0xFFA6FF2E);
  static const _dim    = Color(0xFF6E7F3E);
  static const _surf   = Color(0xFF111111);
  static const _surfAlt= Color(0xFF161616);
  static const _border = Color(0xFF252525);
  static const _muted  = Color(0xFFAAAAAA);
  static const _soft   = Color(0xFF555555);

  int _selectedMode = 0;
  Map<String, Map<String, double>> _stats = {};
  bool _editing = false;
  bool _synced = false;
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  @override
  void dispose() {
    for (final c in _controllers.values) { c.dispose(); }
    super.dispose();
  }

  Future<void> _loadStats() async {
    // 1. Load local immediately (fast)
    final prefs = await SharedPreferences.getInstance();
    final raw   = prefs.getString('my_stats') ?? '{}';
    final local = (jsonDecode(raw) as Map<String, dynamic>).map((k, v) =>
      MapEntry(k, Map<String, double>.from(
        (v as Map).map((fk, fv) => MapEntry(fk as String, (fv as num).toDouble())))));
    setState(() => _stats = local);

    // 2. Try server (may have newer data from another device)
    final remote = await StatsService.fetchStats();
    if (remote != null && remote.isNotEmpty) {
      // Merge: server wins for modes it has, local fills gaps
      final merged = Map<String, Map<String, double>>.from(local);
      for (final entry in remote.entries) {
        merged[entry.key] = entry.value;
      }
      setState(() { _stats = merged; _synced = true; });
      await prefs.setString('my_stats', jsonEncode(merged));
    } else if (remote != null) {
      // Server returned empty — push local stats up if we have any
      if (local.isNotEmpty) {
        StatsService.saveStats(local);
      }
      setState(() => _synced = true);
    }
  }

  Future<void> _saveStats() async {
    // Save locally first (always works)
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('my_stats', jsonEncode(_stats));
    // Then sync to server (fire-and-forget)
    StatsService.saveStats(_stats).then((ok) {
      if (mounted) setState(() => _synced = ok);
    });
  }

  void _startEditing() {
    final mode = _modes[_selectedMode];
    _controllers.clear();
    for (final f in mode.fields) {
      final val = _stats[mode.key]?[f.key];
      _controllers[f.key] = TextEditingController(text: val != null ? '$val' : '');
    }
    setState(() => _editing = true);
  }

  Future<void> _saveEdits() async {
    final mode = _modes[_selectedMode];
    final modeStats = <String, double>{};
    for (final f in mode.fields) {
      final text = _controllers[f.key]?.text.trim().replaceAll('%', '') ?? '';
      final val  = double.tryParse(text);
      if (val != null) modeStats[f.key] = val;
    }
    setState(() {
      _stats[mode.key] = modeStats;
      _editing = false;
    });
    await _saveStats();
  }

  @override
  Widget build(BuildContext context) {
    final mode     = _modes[_selectedMode];
    final modeData = _stats[mode.key] ?? {};

    return Scaffold(
      backgroundColor: const Color(0xFF050A05),
      body: RadarBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const AppTopBar(
                title: 'My Stats',
                subtitle: 'Your performance by game mode',
                icon: Icons.bar_chart_rounded,
              ),
              const SizedBox(height: 20),

              // Mode selector
              SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _modes.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (ctx, i) {
                    final m   = _modes[i];
                    final sel = i == _selectedMode;
                    return GestureDetector(
                      onTap: () => setState(() { _selectedMode = i; _editing = false; }),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: sel ? _dim.withValues(alpha: 0.2) : _surf,
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(color: sel ? _dim : _border),
                        ),
                        child: Text('${m.emoji} ${m.label}',
                          style: TextStyle(
                            color: sel ? _green : _soft,
                            fontSize: 11,
                            fontWeight: sel ? FontWeight.w800 : FontWeight.w500,
                            letterSpacing: 0.3,
                          )),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Stats display / edit form
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _surf,
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: _border),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Text('${mode.emoji} ${mode.label}'.toUpperCase(),
                      style: const TextStyle(color: _dim, fontSize: 9, letterSpacing: 2, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    if (!_editing)
                      GestureDetector(
                        onTap: _startEditing,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: _dim),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: const Text('EDIT', style: TextStyle(color: _green, fontSize: 9, letterSpacing: 1.5, fontWeight: FontWeight.w800)),
                        ),
                      ),
                    if (_editing)
                      Row(children: [
                        GestureDetector(
                          onTap: () => setState(() => _editing = false),
                          child: const Text('CANCEL', style: TextStyle(color: Color(0xFF555555), fontSize: 9, letterSpacing: 1.5)),
                        ),
                        const SizedBox(width: 14),
                        GestureDetector(
                          onTap: _saveEdits,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _green,
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: const Text('SAVE', style: TextStyle(color: Color(0xFF080808), fontSize: 9, letterSpacing: 1.5, fontWeight: FontWeight.w900)),
                          ),
                        ),
                      ]),
                  ]),
                  const SizedBox(height: 16),

                  if (_editing)
                    ...mode.fields.map((f) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(f.label.toUpperCase(),
                          style: const TextStyle(color: Color(0xFF666666), fontSize: 9, letterSpacing: 1.5)),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _controllers[f.key],
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
                          decoration: InputDecoration(
                            hintText: f.hint,
                            hintStyle: const TextStyle(color: Color(0xFF333333)),
                            suffixText: f.unit,
                            suffixStyle: const TextStyle(color: _dim, fontSize: 12),
                            filled: true,
                            fillColor: const Color(0xFF0A0A0A),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
                              borderSide: const BorderSide(color: Color(0xFF252525)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
                              borderSide: const BorderSide(color: _dim),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
                              borderSide: const BorderSide(color: Color(0xFF252525)),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                        ),
                      ]),
                    ))
                  else if (modeData.isEmpty)
                    GestureDetector(
                      onTap: _startEditing,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 28),
                        child: Column(children: [
                          const Icon(Icons.add_circle_outline, color: Color(0xFF333333), size: 36),
                          const SizedBox(height: 10),
                          const Text('No stats yet', style: TextStyle(color: Color(0xFF555555), fontSize: 13, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          Text('Tap to add your ${mode.label} stats',
                            style: const TextStyle(color: Color(0xFF444444), fontSize: 11)),
                        ]),
                      ),
                    )
                  else
                    ...mode.fields.map((f) {
                      final val = modeData[f.key];
                      if (val == null) return const SizedBox.shrink();
                      final display = val == val.truncateToDouble() ? '${val.toInt()}' : '$val';
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Row(children: [
                          Expanded(
                            child: Text(f.label,
                              style: const TextStyle(color: Color(0xFF888888), fontSize: 12)),
                          ),
                          Text('$display${f.unit}',
                            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                        ]),
                      );
                    }),
                ]),
              ),

              const SizedBox(height: 16),
              Row(children: [
                Icon(_synced ? Icons.cloud_done_outlined : Icons.cloud_off_outlined,
                  color: _synced ? const Color(0xFF4ade80) : const Color(0xFF444444), size: 14),
                const SizedBox(width: 6),
                Expanded(child: Text(
                  _synced
                    ? 'Stats synced to server. Your coach always has a fresh picture.'
                    : 'Stats saved locally. Sign in to sync across devices.',
                  style: const TextStyle(color: Color(0xFF444444), fontSize: 11, height: 1.5),
                )),
              ]),
            ]),
          ),
        ),
      ),
    );
  }
}
