import 'package:flutter/material.dart';
import '../data/models/patch_intel_item.dart';
import '../shared/widgets/detail_panel.dart';
import '../shared/widgets/meta_pill.dart';

class PatchDetailScreen extends StatelessWidget {
  final PatchIntelItem item;
  final List<PatchIntelItem> relatedItems;
  final bool isSaved;
  final VoidCallback onToggleSaved;
  final void Function(PatchIntelItem item) onOpenPatch;

  const PatchDetailScreen({
    super.key,
    required this.item,
    required this.relatedItems,
    required this.isSaved,
    required this.onToggleSaved,
    required this.onOpenPatch,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF091018),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 42, height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F141B),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0x14FFFFFF)),
                    ),
                    child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onToggleSaved,
                  child: Container(
                    width: 42, height: 42,
                    decoration: BoxDecoration(
                      color: isSaved ? const Color(0x14D7B56D) : const Color(0xFF0F141B),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: isSaved ? const Color(0x44D7B56D) : const Color(0x14FFFFFF)),
                    ),
                    child: Icon(
                      isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                      color: isSaved ? const Color(0xFFD7B56D) : const Color(0xFF687483),
                      size: 20,
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                    colors: [Color(0xFF151D27), Color(0xFF0E141C), Color(0xFF0A0F15)],
                  ),
                  border: Border.all(color: const Color(0x22D7B56D)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: item.accent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(item.icon, color: item.accent, size: 18),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text(item.issueCode,
                          style: TextStyle(color: item.accent, fontSize: 11,
                              fontWeight: FontWeight.w800, letterSpacing: 1.1))),
                      _ImpactBadge(impact: item.impact),
                    ]),
                    const SizedBox(height: 14),
                    Text(item.title,
                        style: const TextStyle(color: Colors.white, fontSize: 20,
                            fontWeight: FontWeight.w800, height: 1.25)),
                    const SizedBox(height: 8),
                    Text(item.subtitle,
                        style: const TextStyle(color: Color(0xFF93A0AF), fontSize: 13, height: 1.5)),
                    const SizedBox(height: 14),
                    Text(item.body,
                        style: const TextStyle(color: Color(0xFFB0BEC5), fontSize: 14, height: 1.6)),
                    const SizedBox(height: 14),
                    Wrap(spacing: 8, runSpacing: 8, children: [
                      MetaPill(label: item.type.toUpperCase(), color: item.accent),
                      MetaPill(label: item.dateLabel, color: const Color(0xFF687483)),
                      MetaPill(label: item.timeAgo, color: const Color(0xFF687483)),
                    ]),
                  ],
                ),
              ),
              if (item.tags.isNotEmpty) ...[
                const SizedBox(height: 20),
                const _SectionLabel(title: 'Tags'),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8, runSpacing: 8,
                  children: item.tags.map((tag) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F141B),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0x18FFFFFF)),
                    ),
                    child: Text(tag, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                  )).toList(),
                ),
              ],
              if (item.bullets.isNotEmpty) ...[
                const SizedBox(height: 20),
                DetailPanel(
                  title: 'Key Points',
                  body: item.bullets.join('\n'),
                  icon: Icons.format_list_bulleted_rounded,
                  accent: item.accent,
                ),
              ],
              if (relatedItems.isNotEmpty) ...[
                const SizedBox(height: 24),
                const _SectionLabel(title: 'Related Intel'),
                const SizedBox(height: 12),
                ...relatedItems.map((related) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _RelatedPatchCard(item: related, onTap: () => onOpenPatch(related)),
                    )),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class SavedPatchCard extends StatelessWidget {
  final PatchIntelItem item;
  final VoidCallback onToggleSaved;
  final VoidCallback onTap;

  const SavedPatchCard({super.key, required this.item, required this.onToggleSaved, required this.onTap});

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
            Text(item.issueCode, style: TextStyle(color: item.accent, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.8)),
            const SizedBox(height: 2),
            Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700, height: 1.3)),
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

class _ImpactBadge extends StatelessWidget {
  final String impact;
  const _ImpactBadge({required this.impact});

  @override
  Widget build(BuildContext context) {
    final color = impact == 'High'
        ? const Color(0xFFD7B56D)
        : impact == 'Medium'
            ? const Color(0xFF93A0AF)
            : const Color(0xFF687483);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(impact.toUpperCase(),
          style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.8)),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String title;
  const _SectionLabel({required this.title});

  @override
  Widget build(BuildContext context) => Text(title,
      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 0.2));
}

class _RelatedPatchCard extends StatelessWidget {
  final PatchIntelItem item;
  final VoidCallback onTap;

  const _RelatedPatchCard({required this.item, required this.onTap});

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
            Text(item.type, style: const TextStyle(color: Color(0xFF687483), fontSize: 11)),
          ])),
          const Icon(Icons.chevron_right_rounded, color: Color(0xFFD7B56D), size: 18),
        ]),
      ),
    );
  }
}