import 'package:flutter/material.dart';
import '../data/models/patch_intel_item.dart';
import '../shared/widgets/meta_pill.dart';
import '../shared/widgets/empty_state_card.dart';

class PatchIntelScreen extends StatelessWidget {
  final List<PatchIntelItem> items;
  final Set<String> savedPatchIds;
  final void Function(String id) onToggleSaved;
  final void Function(PatchIntelItem item) onOpenPatch;

  const PatchIntelScreen({
    super.key,
    required this.items,
    required this.savedPatchIds,
    required this.onToggleSaved,
    required this.onOpenPatch,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppTopBar(
                title: 'Patch Intel',
                subtitle: 'Latest balance changes & meta shifts',
                icon: Icons.radar_rounded,
              ),
              const SizedBox(height: 20),
              if (items.isEmpty)
                const EmptyStateCard(
                  title: 'No patch intel',
                  subtitle: 'New intel drops after each patch cycle.',
                )
              else
                ...items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: PatchIntelCard(
                        item: item,
                        isSaved: savedPatchIds.contains(item.id),
                        onToggleSaved: () => onToggleSaved(item.id),
                        onTap: () => onOpenPatch(item),
                      ),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}

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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0F141B),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0x14FFFFFF)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: item.accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item.icon, color: item.accent, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item.issueCode,
                  style: TextStyle(color: item.accent, fontSize: 11, fontWeight: FontWeight.w700)),
              Text(item.timeAgo,
                  style: const TextStyle(color: Color(0xFF687483), fontSize: 11)),
            ])),
            GestureDetector(
              onTap: onToggleSaved,
              child: Icon(
                isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                color: isSaved ? const Color(0xFFD7B56D) : const Color(0xFF687483),
                size: 20,
              ),
            ),
          ]),
          const SizedBox(height: 12),
          Text(item.title,
              style: const TextStyle(color: Colors.white, fontSize: 15,
                  fontWeight: FontWeight.w800, height: 1.25)),
          const SizedBox(height: 6),
          Text(item.subtitle,
              maxLines: 2, overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Color(0xFF93A0AF), fontSize: 13, height: 1.5)),
          const SizedBox(height: 10),
          Wrap(spacing: 6, runSpacing: 6, children: [
            MetaPill(label: item.type.toUpperCase(), color: item.accent),
            MetaPill(
              label: 'IMPACT ${item.impact.toUpperCase()}',
              color: item.impact == 'High'
                  ? const Color(0xFFD7B56D)
                  : const Color(0xFF687483),
            ),
          ]),
        ]),
      ),
    );
  }
}