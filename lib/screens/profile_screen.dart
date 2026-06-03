import 'package:flutter/material.dart';
import '../data/models/intel_item.dart';
import '../data/models/patch_intel_item.dart';
import '../data/models/coaching_request.dart';
import '../shared/widgets/empty_state_card.dart';
import 'patch_detail_screen.dart';

class ProfileScreen extends StatefulWidget {
  final Set<String> savedTipIds;
  final Set<String> savedPatchIds;
  final List<IntelItem> allTips;
  final List<PatchIntelItem> allPatches;
  final List<CoachingRequest> coachingHistory;
  final void Function(String id) onToggleSavedTip;
  final void Function(String id) onToggleSavedPatch;
  final void Function(IntelItem item) onOpenTip;
  final void Function(PatchIntelItem item) onOpenPatch;

  const ProfileScreen({
    super.key,
    required this.savedTipIds,
    required this.savedPatchIds,
    required this.allTips,
    required this.allPatches,
    required this.coachingHistory,
    required this.onToggleSavedTip,
    required this.onToggleSavedPatch,
    required this.onOpenTip,
    required this.onOpenPatch,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final savedTips = widget.allTips.where((t) => widget.savedTipIds.contains(t.id)).toList();
    final savedPatches = widget.allPatches.where((p) => widget.savedPatchIds.contains(p.id)).toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppTopBar(
                title: 'Profile',
                subtitle: 'Your saved intel & history',
                icon: Icons.person_rounded,
              ),
              const SizedBox(height: 20),
              // Stats row
              Row(children: [
                Expanded(child: MiniProfileStat(label: 'Saved Tips', value: '${widget.savedTipIds.length}', icon: Icons.bookmark_rounded, color: const Color(0xFFD7B56D))),
                const SizedBox(width: 10),
                Expanded(child: MiniProfileStat(label: 'Saved Patches', value: '${widget.savedPatchIds.length}', icon: Icons.inventory_2_rounded, color: const Color(0xFF93A0AF))),
                const SizedBox(width: 10),
                Expanded(child: MiniProfileStat(label: 'Sessions', value: '${widget.coachingHistory.length}', icon: Icons.sports_esports_rounded, color: const Color(0xFF6C8EAD))),
              ]),
              const SizedBox(height: 20),
              // Tab bar
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F141B),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0x14FFFFFF)),
                ),
                child: Row(children: [
                  _TabButton(label: 'Tips', index: 0, selected: _selectedTab, onTap: (i) => setState(() => _selectedTab = i)),
                  _TabButton(label: 'Patches', index: 1, selected: _selectedTab, onTap: (i) => setState(() => _selectedTab = i)),
                  _TabButton(label: 'History', index: 2, selected: _selectedTab, onTap: (i) => setState(() => _selectedTab = i)),
                ]),
              ),
              const SizedBox(height: 16),
              if (_selectedTab == 0) ...[
                if (savedTips.isEmpty)
                  const EmptyStateCard(title: 'No saved tips', subtitle: 'Bookmark tips from the feed to see them here.')
                else
                  ...savedTips.map((tip) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: SavedTipCard(
                          item: tip,
                          onToggleSaved: () => widget.onToggleSavedTip(tip.id),
                          onTap: () => widget.onOpenTip(tip),
                        ),
                      )),
              ],
              if (_selectedTab == 1) ...[
                if (savedPatches.isEmpty)
                  const EmptyStateCard(title: 'No saved patches', subtitle: 'Bookmark patch intel to track important changes.')
                else
                  ...savedPatches.map((patch) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: SavedPatchCard(
                          item: patch,
                          onToggleSaved: () => widget.onToggleSavedPatch(patch.id),
                          onTap: () => widget.onOpenPatch(patch),
                        ),
                      )),
              ],
              if (_selectedTab == 2) ...[
                if (widget.coachingHistory.isEmpty)
                  const EmptyStateCard(title: 'No sessions yet', subtitle: 'Complete a coaching request to see your history.')
                else
                  ...widget.coachingHistory.reversed.map((req) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _HistoryCard(request: req),
                      )),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class MiniProfileStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const MiniProfileStat({super.key, required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F141B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0x14FFFFFF)),
      ),
      child: Column(children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Color(0xFF687483), fontSize: 10), textAlign: TextAlign.center),
      ]),
    );
  }
}

class SavedTipCard extends StatelessWidget {
  final IntelItem item;
  final VoidCallback onToggleSaved;
  final VoidCallback onTap;

  const SavedTipCard({super.key, required this.item, required this.onToggleSaved, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: const Color(0xFF0F141B),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0x14FFFFFF)),
        ),
        child: Row(children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(color: item.accent.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
            child: Icon(item.icon, color: item.accent, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700, height: 1.3)),
            const SizedBox(height: 2),
            Text(item.category, style: const TextStyle(color: Color(0xFF687483), fontSize: 11)),
          ])),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onToggleSaved,
            child: const Icon(Icons.bookmark_rounded, color: Color(0xFFD7B56D), size: 20),
          ),
        ]),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final int index;
  final int selected;
  final void Function(int) onTap;

  const _TabButton({required this.label, required this.index, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isSelected = index == selected;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1A2535) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: isSelected ? Border.all(color: const Color(0x22D7B56D)) : null,
          ),
          child: Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? const Color(0xFFD7B56D) : const Color(0xFF687483),
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
              )),
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final CoachingRequest request;
  const _HistoryCard({required this.request});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F141B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x14FFFFFF)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: const Color(0x14D7B56D), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.sports_esports_rounded, color: Color(0xFFD7B56D), size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(request.focus, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
            Text(request.role, style: const TextStyle(color: Color(0xFF687483), fontSize: 11)),
          ])),
          Text(request.dateLabel, style: const TextStyle(color: Color(0xFF687483), fontSize: 11)),
        ]),
        if (request.notes.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(request.notes,
              maxLines: 2, overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Color(0xFF93A0AF), fontSize: 12, height: 1.45)),
        ],
      ]),
    );
  }
}