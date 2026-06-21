import 'package:flutter/material.dart';
import '../data/models/patch_intel_item.dart';
import '../shared/widgets/meta_pill.dart';
import 'home_screen.dart';

const _lime  = Color(0xFFA6FF2E);
const _amber = Color(0xFFD7A430);
const _bg    = Color(0xFF050A05);

// ── Zone definitions ──────────────────────────────────────────────────────────

class _Zone {
  final String id;
  final String label;
  final double relX; // fraction of MAP AREA width
  final double relY; // fraction of MAP AREA height
  final Color color;
  const _Zone(this.id, this.label, this.relX, this.relY, this.color);
}

// Spot positions as fractions of the terrain image (patch_intel_screen.png).
const _spotPositions = [
  (relX: 0.378, relY: 0.342, color: Color(0xFFFFD700)),
  (relX: 0.589, relY: 0.386, color: Color(0xFFA6FF2E)),
  (relX: 0.361, relY: 0.501, color: Color(0xFF6E9BFF)),
  (relX: 0.606, relY: 0.564, color: Color(0xFFFF6B6B)),
  (relX: 0.486, relY: 0.679, color: Color(0xFF00D4FF)),
];

List<_Zone> _buildZones(List<PatchIntelItem> items) {
  final counts = <String, int>{};
  for (final item in items) {
    counts[item.type] = (counts[item.type] ?? 0) + 1;
  }
  final types = counts.keys.toList()
    ..sort((a, b) => counts[b]!.compareTo(counts[a]!));
  return List.generate(
    types.length.clamp(0, _spotPositions.length),
    (i) {
      final s = _spotPositions[i];
      return _Zone(types[i], types[i].toUpperCase(), s.relX, s.relY, s.color);
    },
  );
}

// ── Background grid painter ───────────────────────────────────────────────────

class _GridPainter extends CustomPainter {
  const _GridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = _bg);
    final gp = Paint()
      ..color = _lime.withValues(alpha: 0.035)
      ..strokeWidth = 0.5;
    const cols = 16;
    const rows = 28;
    for (int i = 0; i <= cols; i++) {
      final x = size.width * i / cols;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gp);
    }
    for (int j = 0; j <= rows; j++) {
      final y = size.height * j / rows;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gp);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => false;
}

// ── HUD helpers ───────────────────────────────────────────────────────────────

class _HudCell extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _HudCell({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(children: [
          Icon(icon, color: color.withValues(alpha: 0.65), size: 10),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  color: color.withValues(alpha: 0.42),
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5)),
        ]),
        const SizedBox(height: 2),
        Text(value,
            style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8)),
      ],
    );
  }
}

class _HudDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
      width: 1,
      height: 28,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      color: _lime.withValues(alpha: 0.10));
}

// ── Top HUD ───────────────────────────────────────────────────────────────────

class _TopHud extends StatelessWidget {
  final int itemCount;
  final int highImpactCount;
  final int typeCount;
  final bool isLive;

  const _TopHud({
    required this.itemCount,
    required this.highImpactCount,
    required this.typeCount,
    required this.isLive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.78),
        border: Border(
            bottom: BorderSide(color: _lime.withValues(alpha: 0.12), width: 1)),
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Row(
        children: [
          _HudCell(
            label: 'SECTOR',
            value: isLive ? 'LIVE' : 'OFFLINE',
            icon: Icons.signal_cellular_alt_rounded,
            color: isLive ? _lime : Colors.white38,
          ),
          _HudDivider(),
          _HudCell(
            label: 'DRILL',
            value: '$highImpactCount HIGH',
            icon: Icons.local_fire_department_rounded,
            color: highImpactCount > 0 ? _amber : Colors.white38,
          ),
          _HudDivider(),
          _HudCell(
            label: 'INTEL LEVEL',
            value: '$typeCount ZONES',
            icon: Icons.radar_rounded,
            color: _lime,
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('ITEMS  $itemCount',
                  style: TextStyle(
                      color: _lime.withValues(alpha: 0.55),
                      fontSize: 8,
                      fontFamily: 'monospace')),
              Text('GPC-752-BRAVO',
                  style: TextStyle(
                      color: _lime.withValues(alpha: 0.28),
                      fontSize: 7,
                      fontFamily: 'monospace')),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Bottom HUD ────────────────────────────────────────────────────────────────

class _BottomHud extends StatelessWidget {
  final VoidCallback onShowAll;
  final int itemCount;

  const _BottomHud({required this.onShowAll, required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.82),
        border: Border(
            top: BorderSide(color: _lime.withValues(alpha: 0.12), width: 1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text('OPERATION',
              style: TextStyle(
                  color: _lime.withValues(alpha: 0.33), fontSize: 7, letterSpacing: 1.5)),
          const Text('SHADOW FRONT',
              style: TextStyle(
                  color: Colors.white60, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1.0)),
        ]),
        Container(
            width: 1, height: 26,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            color: _lime.withValues(alpha: 0.10)),
        Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text('PATCH ID',
              style: TextStyle(
                  color: _lime.withValues(alpha: 0.33), fontSize: 7, letterSpacing: 1.5)),
          Text('V${DateTime.now().year}.${itemCount.toString().padLeft(2, '0')}',
              style: const TextStyle(
                  color: Colors.white60, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1.0)),
        ]),
        const Spacer(),
        GestureDetector(
          onTap: onShowAll,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: _lime.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(2),
              border: Border.all(color: _lime.withValues(alpha: 0.25)),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text('INTEL SUMMARY',
                  style: TextStyle(
                      color: _lime.withValues(alpha: 0.80),
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2)),
              const SizedBox(width: 4),
              Icon(Icons.arrow_outward_rounded,
                  color: _lime.withValues(alpha: 0.60), size: 12),
            ]),
          ),
        ),
      ]),
    );
  }
}

// ── Pulsing zone node ─────────────────────────────────────────────────────────

class _ZoneNode extends StatelessWidget {
  final _Zone zone;
  final bool isActive;
  final bool panelOpen;
  final AnimationController pulse;
  final VoidCallback onTap;

  const _ZoneNode({
    required this.zone,
    required this.isActive,
    required this.panelOpen,
    required this.pulse,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        AnimatedBuilder(
          animation: pulse,
          builder: (_, __) {
            final g = isActive ? pulse.value : 0.0;
            return Stack(alignment: Alignment.center, children: [
              if (isActive)
                Container(
                  width: 50 + g * 10, height: 50 + g * 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: zone.color.withValues(alpha: 0.18 + g * 0.12),
                        width: 1),
                  ),
                ),
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: zone.color.withValues(alpha: isActive ? 0.20 : 0.09),
                  border: Border.all(
                      color: zone.color.withValues(
                          alpha: isActive ? 0.65 + g * 0.28 : 0.26),
                      width: isActive ? 1.5 : 1.0),
                  boxShadow: isActive
                      ? [BoxShadow(
                          color: zone.color.withValues(alpha: 0.28 + g * 0.22),
                          blurRadius: 14 + g * 10, spreadRadius: 2)]
                      : null,
                ),
                child: Center(
                  child: Container(
                    width: 8, height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: zone.color.withValues(
                          alpha: isActive ? 0.9 + g * 0.1 : 0.35),
                    ),
                  ),
                ),
              ),
            ]);
          },
        ),
        const SizedBox(height: 4),
        Text(zone.label,
            style: TextStyle(
                color: isActive
                    ? zone.color
                    : zone.color.withValues(alpha: panelOpen ? 0.22 : 0.50),
                fontSize: 8,
                fontWeight: isActive ? FontWeight.w900 : FontWeight.w600,
                letterSpacing: 1.0,
                shadows: isActive
                    ? [Shadow(color: zone.color.withValues(alpha: 0.50), blurRadius: 8)]
                    : null)),
      ]),
    );
  }
}

// ── Slide-up intel panel ──────────────────────────────────────────────────────

class _IntelPanel extends StatelessWidget {
  final _Zone? zone;
  final List<PatchIntelItem> items;
  final Set<String> savedPatchIds;
  final void Function(String) onToggleSaved;
  final void Function(PatchIntelItem) onOpenPatch;
  final VoidCallback onClose;

  const _IntelPanel({
    required this.zone,
    required this.items,
    required this.savedPatchIds,
    required this.onToggleSaved,
    required this.onOpenPatch,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final zc = zone?.color ?? Colors.white;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF070D07),
        border: Border(top: BorderSide(color: zc.withValues(alpha: 0.28), width: 1)),
        gradient: const LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [Color(0xFF0A120A), Color(0xFF050A05)],
        ),
      ),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
          child: Row(children: [
            Container(width: 10, height: 10,
              decoration: BoxDecoration(shape: BoxShape.circle, color: zc,
                boxShadow: [BoxShadow(color: zc.withValues(alpha: 0.5), blurRadius: 8)])),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(zone?.label ?? 'ALL INTEL',
                  style: TextStyle(color: zc, fontSize: 12,
                      fontWeight: FontWeight.w900, letterSpacing: 2.5)),
              Text('${items.length} INTEL ITEM${items.length == 1 ? '' : 'S'}',
                  style: const TextStyle(color: Color(0xFF444444), fontSize: 9, letterSpacing: 1.5)),
            ])),
            GestureDetector(
              onTap: onClose,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF151515),
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: const Color(0xFF252525)),
                ),
                child: const Icon(Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFF666666), size: 16),
              ),
            ),
          ]),
        ),
        const Divider(color: Color(0xFF161616), height: 1),
        Expanded(
          child: items.isEmpty
              ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.radar_rounded, color: zc.withValues(alpha: 0.20), size: 40),
                  const SizedBox(height: 10),
                  Text('No intel for this zone',
                      style: TextStyle(color: zc.withValues(alpha: 0.40),
                          fontSize: 13, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  const Text('Check back after the next patch',
                      style: TextStyle(color: Color(0xFF333333), fontSize: 11)),
                ]))
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 28),
                  itemCount: items.length,
                  itemBuilder: (ctx, i) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: PatchIntelCard(
                      item: items[i],
                      isSaved: savedPatchIds.contains(items[i].id),
                      onToggleSaved: () => onToggleSaved(items[i].id),
                      onTap: () => onOpenPatch(items[i]),
                    ),
                  ),
                ),
        ),
      ]),
    );
  }
}

// ── Patch intel card ──────────────────────────────────────────────────────────

class PatchIntelCard extends StatelessWidget {
  final PatchIntelItem item;
  final bool isSaved;
  final VoidCallback onToggleSaved;
  final VoidCallback onTap;

  const PatchIntelCard({
    super.key,
    required this.item,
    required this.isSaved,
    required this.onToggleSaved,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF0C1210),
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: const Color(0xFF1A1A1A)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(width: 34, height: 34,
              decoration: BoxDecoration(
                color: item.accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(3)),
              child: Icon(item.icon, color: item.accent, size: 17)),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item.issueCode,
                  style: TextStyle(color: item.accent, fontSize: 10,
                      fontWeight: FontWeight.w700, letterSpacing: 0.3)),
              const SizedBox(height: 2),
              Text(item.timeAgo,
                  style: const TextStyle(color: Color(0xFF555555), fontSize: 11)),
            ])),
            GestureDetector(
              onTap: onToggleSaved,
              child: Icon(
                  isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                  color: isSaved ? const Color(0xFFD7B56D) : const Color(0xFF444444),
                  size: 20),
            ),
          ]),
          const SizedBox(height: 10),
          Text(item.title,
              style: const TextStyle(color: Colors.white, fontSize: 14,
                  fontWeight: FontWeight.w800, height: 1.25)),
          const SizedBox(height: 5),
          Text(item.subtitle,
              maxLines: 2, overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Color(0xFF778888), fontSize: 12, height: 1.5)),
          const SizedBox(height: 8),
          Wrap(spacing: 6, runSpacing: 4, children: [
            MetaPill(label: item.type.toUpperCase(), color: item.accent),
            MetaPill(
                label: 'IMPACT ${item.impact.toUpperCase()}',
                color: item.impact == 'High'
                    ? const Color(0xFFD7B56D) : const Color(0xFF444444)),
          ]),
        ]),
      ),
    );
  }
}

// ── Screen ────────────────────────────────────────────────────────────────────

class PatchIntelScreen extends StatefulWidget {
  final List<PatchIntelItem> items;
  final Set<String> savedPatchIds;
  final void Function(String id) onToggleSaved;
  final void Function(PatchIntelItem item) onOpenPatch;
  final bool isLive;

  const PatchIntelScreen({
    super.key,
    required this.items,
    required this.savedPatchIds,
    required this.onToggleSaved,
    required this.onOpenPatch,
    this.isLive = false,
  });

  @override
  State<PatchIntelScreen> createState() => _PatchIntelScreenState();
}

class _PatchIntelScreenState extends State<PatchIntelScreen>
    with SingleTickerProviderStateMixin {
  String? _activeZoneId;
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1600))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  List<_Zone> get _zones => _buildZones(widget.items);

  List<PatchIntelItem> get _filtered {
    if (_activeZoneId == null || _activeZoneId == 'ALL') return widget.items;
    final match = _zones.where((z) => z.id == _activeZoneId);
    if (match.isEmpty) return widget.items;
    return widget.items.where((i) => i.type == match.first.id).toList();
  }

  _Zone? get _activeZone {
    if (_activeZoneId == null || _activeZoneId == 'ALL') return null;
    final match = _zones.where((z) => z.id == _activeZoneId);
    return match.isEmpty ? null : match.first;
  }

  void _selectZone(String id) =>
      setState(() => _activeZoneId = _activeZoneId == id ? null : id);

  void _dismiss() => setState(() => _activeZoneId = null);

  void _showAll() => setState(() => _activeZoneId = 'ALL');

  @override
  Widget build(BuildContext context) {
    final panelH    = MediaQuery.of(context).size.height * 0.62;
    final panelOpen = _activeZoneId != null;
    final highCount = widget.items.where((i) => i.impact == 'High').length;

    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        fit: StackFit.expand,
        children: [

          // ── Grid background ──────────────────────────────────────────────
          const CustomPaint(painter: _GridPainter()),

          // ── Column: topHUD / map area / bottomHUD ────────────────────────
          Column(children: [

            // Top HUD
            SafeArea(
              bottom: false,
              child: _TopHud(
                itemCount: widget.items.length,
                highImpactCount: highCount,
                typeCount: _zones.length,
                isLive: widget.isLive,
              ),
            ),

            // Map area: terrain image + zone nodes positioned relative to it
            Expanded(
              child: LayoutBuilder(
                builder: (ctx, constraints) {
                  final mapW = constraints.maxWidth;
                  final mapH = constraints.maxHeight;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [

                      // Terrain image — BoxFit.fill keeps relX/relY accurate
                      Positioned.fill(
                        child: Image.asset(
                          'assets/images/patch_intel_screen.png',
                          fit: BoxFit.fill,
                        ),
                      ),

                      // Vignette: blend map edges into HUDs
                      Positioned.fill(
                        child: IgnorePointer(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.50),
                                  Colors.transparent,
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.50),
                                ],
                                stops: const [0.0, 0.12, 0.88, 1.0],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Zone nodes — anchored to map area, not full screen
                      ..._zones.map((zone) => Positioned(
                        left: zone.relX * mapW - 22,
                        top:  zone.relY * mapH - 22,
                        child: _ZoneNode(
                          zone: zone,
                          isActive: zone.id == _activeZoneId,
                          panelOpen: panelOpen,
                          pulse: _pulse,
                          onTap: () => _selectZone(zone.id),
                        ),
                      )),

                    ],
                  );
                },
              ),
            ),

            // Bottom HUD
            SafeArea(
              top: false,
              child: _BottomHud(
                onShowAll: _showAll,
                itemCount: widget.items.length,
              ),
            ),

          ]),

          // ── Tap-to-dismiss above panel ───────────────────────────────────
          if (panelOpen)
            Positioned(
              top: 0, left: 0, right: 0,
              bottom: panelH,
              child: GestureDetector(
                onTap: _dismiss,
                child: Container(color: Colors.transparent),
              ),
            ),

          // ── Slide-up intel panel ─────────────────────────────────────────
          AnimatedPositioned(
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutCubic,
            bottom: 0, left: 0, right: 0,
            height: panelOpen ? panelH : 0,
            child: ClipRect(
              child: _IntelPanel(
                zone: _activeZone,
                items: _filtered,
                savedPatchIds: widget.savedPatchIds,
                onToggleSaved: widget.onToggleSaved,
                onOpenPatch: widget.onOpenPatch,
                onClose: _dismiss,
              ),
            ),
          ),

        ],
      ),
    );
  }
}
