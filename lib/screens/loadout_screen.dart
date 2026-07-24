import 'package:flutter/material.dart';
import '../services/loadout_service.dart';
import '../shared/widgets/radar_background.dart';
import 'home_screen.dart'; // for AppTopBar

class LoadoutScreen extends StatefulWidget {
  final Set<String> savedLoadoutIds;
  final void Function(String id) onToggleSaved;

  const LoadoutScreen({
    super.key,
    required this.savedLoadoutIds,
    required this.onToggleSaved,
  });

  @override
  State<LoadoutScreen> createState() => _LoadoutScreenState();
}

class _LoadoutScreenState extends State<LoadoutScreen> {
  List<Loadout> _loadouts = [];
  bool _loading = true;
  String _filter = '';
  String _sortBy = 'score'; // 'score', 'date', 'name'

  static const _green  = Color(0xFFA6FF2E);
  static const _dim    = Color(0xFF6E7F3E);
  static const _bg     = Color(0xFF0A0A0A);
  static const _surf   = Color(0xFF111111);
  static const _border = Color(0xFF252525);
  static const _soft   = Color(0xFF555555);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await LoadoutService.fetchLoadouts();
    if (mounted) setState(() { _loadouts = data; _loading = false; });
  }

  List<Loadout> get _filtered {
    var list = List<Loadout>.from(_loadouts);
    if (_filter.isNotEmpty) {
      final q = _filter.toLowerCase();
      list = list.where((l) =>
        l.name.toLowerCase().contains(q) ||
        l.weapon.toLowerCase().contains(q) ||
        l.weaponClass.toLowerCase().contains(q)
      ).toList();
    }
    switch (_sortBy) {
      case 'score':
        list.sort((a, b) => b.metaScore.compareTo(a.metaScore));
        break;
      case 'date':
        list.sort((a, b) => b.sharedAt.compareTo(a.sharedAt));
        break;
      case 'name':
        list.sort((a, b) => a.weapon.toLowerCase().compareTo(b.weapon.toLowerCase()));
        break;
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: RadarBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppTopBar(
                      title: 'Loadouts',
                      subtitle: 'Coach-approved weapon builds',
                      icon: Icons.tune_rounded,
                    ),
                    const SizedBox(height: 14),
                    // Search bar
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: _surf,
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(color: _border),
                      ),
                      child: TextField(
                        onChanged: (v) => setState(() => _filter = v),
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        decoration: const InputDecoration(
                          hintText: 'Search weapon or build name...',
                          hintStyle: TextStyle(color: Color(0xFF555555), fontSize: 13),
                          prefixIcon: Icon(Icons.search, color: Color(0xFF555555), size: 18),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Sort chips
                    Row(children: [
                      const Text('SORT BY', style: TextStyle(color: Color(0xFF555555), fontSize: 9, letterSpacing: 1.5, fontWeight: FontWeight.w700)),
                      const SizedBox(width: 10),
                      ...[
                        ('score', 'SCORE', Icons.star_rounded),
                        ('date',  'DATE',  Icons.schedule_rounded),
                        ('name',  'A–Z',   Icons.sort_by_alpha_rounded),
                      ].map((s) {
                        final sel = _sortBy == s.$1;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () => setState(() => _sortBy = s.$1),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: sel ? _dim.withValues(alpha: 0.2) : _surf,
                                borderRadius: BorderRadius.circular(3),
                                border: Border.all(color: sel ? _dim : _border),
                              ),
                              child: Row(mainAxisSize: MainAxisSize.min, children: [
                                Icon(s.$3, size: 12, color: sel ? _green : _soft),
                                const SizedBox(width: 5),
                                Text(s.$2, style: TextStyle(
                                  color: sel ? _green : _soft,
                                  fontSize: 9,
                                  fontWeight: sel ? FontWeight.w800 : FontWeight.w500,
                                  letterSpacing: 0.5,
                                )),
                              ]),
                            ),
                          ),
                        );
                      }),
                    ]),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator(color: _green))
                    : _filtered.isEmpty
                        ? _empty()
                        : RefreshIndicator(
                            color: _green,
                            onRefresh: _load,
                            child: ListView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
                              itemCount: _filtered.length,
                              itemBuilder: (ctx, i) {
                                final lo = _filtered[i];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _BuildCard(
                                    loadout: lo,
                                    isSaved: widget.savedLoadoutIds.contains(lo.id),
                                    onToggleSaved: () => widget.onToggleSaved(lo.id),
                                  ),
                                );
                              },
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _empty() => Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.tune_rounded, color: Color(0xFF333333), size: 48),
      const SizedBox(height: 12),
      const Text('No builds yet', style: TextStyle(color: Color(0xFF666666), fontSize: 15, fontWeight: FontWeight.w700)),
      const SizedBox(height: 6),
      const Text('Coaches share builds via /loadout in Discord', style: TextStyle(color: Color(0xFF444444), fontSize: 12)),
    ]),
  );
}

// ── Individual build card ─────────────────────────────────────────────────────
class _BuildCard extends StatefulWidget {
  final Loadout loadout;
  final bool isSaved;
  final VoidCallback onToggleSaved;
  const _BuildCard({required this.loadout, required this.isSaved, required this.onToggleSaved});

  @override
  State<_BuildCard> createState() => _BuildCardState();
}

class _BuildCardState extends State<_BuildCard> {
  bool _expanded = false;

  static const _green  = Color(0xFFA6FF2E);
  static const _surf   = Color(0xFF111111);
  static const _border = Color(0xFF252525);

  Color _tierColor(String tier) {
    switch (tier) {
      case 'S': return const Color(0xFFFFD700);
      case 'A': return const Color(0xFFA6FF2E);
      case 'B': return const Color(0xFF6E9BFF);
      default:  return const Color(0xFF888888);
    }
  }

  Widget _statBar(String label, int value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(children: [
        SizedBox(
          width: 80,
          child: Text(label, style: const TextStyle(color: Color(0xFF888888), fontSize: 10, letterSpacing: 0.5)),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: value / 100,
              backgroundColor: const Color(0xFF1A1A1A),
              valueColor: AlwaysStoppedAnimation<Color>(
                value > 80 ? _green : value > 60 ? const Color(0xFF6E9BFF) : const Color(0xFF555555),
              ),
              minHeight: 5,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text('$value', style: const TextStyle(color: Color(0xFF888888), fontSize: 10, fontWeight: FontWeight.w700)),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = widget.loadout;
    final tierColor = _tierColor(l.tier);

    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _surf,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(
            color: _expanded ? const Color(0xFF6E7F3E) : _border,
          ),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header row
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(children: [
              // Tier badge
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  color: tierColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: tierColor.withValues(alpha: 0.4)),
                ),
                child: Center(
                  child: Text(l.tier,
                    style: TextStyle(color: tierColor, fontSize: 13, fontWeight: FontWeight.w900)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(l.name,
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text('${l.weapon}  ·  ${l.weaponClass}',
                    style: const TextStyle(color: Color(0xFF888888), fontSize: 11)),
                ]),
              ),
              // Meta score
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('${l.metaScore}', style: TextStyle(color: tierColor, fontSize: 16, fontWeight: FontWeight.w900)),
                const Text('SCORE', style: TextStyle(color: Color(0xFF555555), fontSize: 8, letterSpacing: 1.2)),
              ]),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: widget.onToggleSaved,
                child: Icon(
                  widget.isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                  color: widget.isSaved ? const Color(0xFFD7B56D) : const Color(0xFF555555),
                  size: 18,
                ),
              ),
              const SizedBox(width: 6),
              Icon(_expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: const Color(0xFF555555), size: 18),
            ]),
          ),

          // Best-for tags (always visible)
          if (l.bestFor.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              child: Wrap(
                spacing: 6,
                children: l.bestFor.map((mode) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0A0A),
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(color: const Color(0xFF252525)),
                  ),
                  child: Text(mode.replaceAll('_', ' ').toUpperCase(),
                    style: const TextStyle(color: Color(0xFF6E7F3E), fontSize: 9, letterSpacing: 1.2, fontWeight: FontWeight.w700)),
                )).toList(),
              ),
            ),

          // Expanded section
          if (_expanded) ...[
            const Divider(color: Color(0xFF1A1A1A), height: 1),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // Attachments
                const Text('ATTACHMENTS', style: TextStyle(color: Color(0xFF6E7F3E), fontSize: 9, letterSpacing: 2, fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                ...l.attachments.entries.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(children: [
                    SizedBox(
                      width: 88,
                      child: Text(e.key.toUpperCase(),
                        style: const TextStyle(color: Color(0xFF555555), fontSize: 9, letterSpacing: 1.2)),
                    ),
                    Text(e.value,
                      style: TextStyle(
                        color: e.value == '—' ? const Color(0xFF333333) : Colors.white,
                        fontSize: 12, fontWeight: FontWeight.w600)),
                  ]),
                )),

                if (l.baseStats.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  const Text('BASE STATS', style: TextStyle(color: Color(0xFF6E7F3E), fontSize: 9, letterSpacing: 2, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  ...l.baseStats.entries.map((e) =>
                    _statBar(e.key.replaceAll('_', ' ').toUpperCase(), e.value)),
                ],

                if (l.notes.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  const Text('COACH NOTES', style: TextStyle(color: Color(0xFF6E7F3E), fontSize: 9, letterSpacing: 2, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A0A0A),
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(color: const Color(0xFF1A1A1A)),
                    ),
                    child: Text(l.notes,
                      style: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 12, height: 1.5)),
                  ),
                ],

                const SizedBox(height: 10),
                Text('Shared by ${l.author} · ${l.sharedAt.length > 10 ? l.sharedAt.substring(0, 10) : l.sharedAt}',
                  style: const TextStyle(color: Color(0xFF444444), fontSize: 10)),
              ]),
            ),
          ],
        ]),
      ),
    );
  }
}
