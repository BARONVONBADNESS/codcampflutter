import 'package:flutter/material.dart';
import '../data/models/intel_item.dart';
import '../shared/widgets/info_chip.dart';
import '../shared/widgets/meta_pill.dart';
import '../shared/widgets/empty_state_card.dart';

class TipsFeedScreen extends StatelessWidget {
  final List<IntelItem> items;
  final Set<String> savedTipIds;
  final void Function(String id) onToggleSaved;
  final void Function(IntelItem item) onOpenTip;

  const TipsFeedScreen({
    super.key,
    required this.items,
    required this.savedTipIds,
    required this.onToggleSaved,
    required this.onOpenTip,
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
                title: 'Tips Feed',
                subtitle: 'Ranked intel for your playstyle',
                icon: Icons.tips_and_updates_rounded,
              ),
              const SizedBox(height: 20),
              if (items.isEmpty)
                const EmptyStateCard(
                  title: 'No tips available',
                  subtitle: 'Check back after the next content update.',
                )
              else ...[
                const FeedSectionLabel(title: 'Top Picks'),
                const SizedBox(height: 12),
                ...items.take(3).map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: PremiumTipFeedCard(
                        item: item,
                        isSaved: savedTipIds.contains(item.id),
                        onToggleSaved: () => onToggleSaved(item.id),
                        onTap: () => onOpenTip(item),
                      ),
                    )),
                if (items.length > 3) ...[
                  const SizedBox(height: 8),
                  const FeedSectionLabel(title: 'More Intel'),
                  const SizedBox(height: 12),
                  ...items.skip(3).map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: PremiumTipFeedCard(
                          item: item,
                          isSaved: savedTipIds.contains(item.id),
                          onToggleSaved: () => onToggleSaved(item.id),
                          onTap: () => onOpenTip(item),
                        ),
                      )),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class PremiumTipFeedCard extends StatelessWidget {
  final IntelItem item;
  final bool isSaved;
  final VoidCallback onToggleSaved;
  final VoidCallback onTap;

  const PremiumTipFeedCard({
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
              Text(item.source,
                  style: TextStyle(color: item.accent, fontSize: 11, fontWeight: FontWeight.w700)),
              Text(item.timeLabel,
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
          Text(item.body,
              maxLines: 3, overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Color(0xFF93A0AF), fontSize: 13, height: 1.5)),
          const SizedBox(height: 10),
          Row(children: [
            MetaPill(label: item.category.toUpperCase(), color: item.accent),
            const SizedBox(width: 6),
            InfoChip(label: item.dayLabel, color: const Color(0xFF687483)),
            const Spacer(),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFFD7B56D), size: 16),
          ]),
        ]),
      ),
    );
  }
}

class FeedSectionLabel extends StatelessWidget {
  final String title;
  const FeedSectionLabel({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        width: 3, height: 16,
        decoration: BoxDecoration(color: const Color(0xFFD7B56D), borderRadius: BorderRadius.circular(2)),
      ),
      const SizedBox(width: 8),
      Text(title.toUpperCase(),
          style: const TextStyle(color: Color(0xFFD7B56D), fontSize: 11,
              fontWeight: FontWeight.w800, letterSpacing: 1.2)),
    ]);
  }
}