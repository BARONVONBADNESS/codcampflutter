import 'package:flutter/material.dart';
import '../data/models/intel_item.dart';
import '../shared/widgets/detail_panel.dart';
import '../shared/widgets/info_chip.dart';
import '../shared/widgets/meta_pill.dart';

class TipDetailScreen extends StatelessWidget {
  final IntelItem item;
  final List<IntelItem> visibleItems;
  final bool isSaved;
  final String? selectedReaction;
  final VoidCallback onToggleSaved;
  final void Function(String? reaction) onSetReaction;
  final void Function(IntelItem item) onOpenTip;

  const TipDetailScreen({
    super.key,
    required this.item,
    required this.visibleItems,
    required this.isSaved,
    required this.selectedReaction,
    required this.onToggleSaved,
    required this.onSetReaction,
    required this.onOpenTip,
  });

  @override
  Widget build(BuildContext context) {
    final relatedItems = visibleItems
        .where((e) => e.id != item.id && e.category == item.category)
        .take(3)
        .toList();

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
                      Expanded(child: Text(item.source,
                          style: TextStyle(color: item.accent, fontSize: 11,
                              fontWeight: FontWeight.w800, letterSpacing: 1.1))),
                      InfoChip(label: item.dayLabel, color: item.accent),
                    ]),
                    const SizedBox(height: 14),
                    Text(item.title,
                        style: const TextStyle(color: Colors.white, fontSize: 20,
                            fontWeight: FontWeight.w800, height: 1.25)),
                    const SizedBox(height: 12),
                    Text(item.body,
                        style: const TextStyle(color: Color(0xFFB0BEC5), fontSize: 14, height: 1.6)),
                    const SizedBox(height: 14),
                    Wrap(spacing: 8, runSpacing: 8, children: [
                      MetaPill(label: item.category.toUpperCase(), color: item.accent),
                      MetaPill(label: item.timeLabel, color: const Color(0xFF687483)),
                    ]),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              DetailPanel(
                title: 'Takeaway',
                body: item.footer,
                icon: Icons.lightbulb_outline_rounded,
                accent: item.accent,
              ),
              const SizedBox(height: 16),
              _ReactionRow(
                reactions: item.reactions,
                selectedReaction: selectedReaction,
                onSetReaction: onSetReaction,
              ),
              if (relatedItems.isNotEmpty) ...[
                const SizedBox(height: 24),
                const _SectionLabel(title: 'Related Tips'),
                const SizedBox(height: 12),
                ...relatedItems.map((related) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _RelatedTipCard(item: related, onTap: () => onOpenTip(related)),
                    )),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class FocusCard extends StatelessWidget {
  final String title;
  final String body;
  final IconData icon;
  final Color accent;

  const FocusCard({super.key, required this.title, required this.body, required this.icon, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withOpacity(0.2)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 38, height: 38,
          decoration: BoxDecoration(color: accent.withOpacity(0.14), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: accent, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(body, style: const TextStyle(color: Color(0xFF93A0AF), fontSize: 13, height: 1.5)),
        ])),
      ]),
    );
  }
}

class BulletCard extends StatelessWidget {
  final List<String> bullets;
  final Color accent;

  const BulletCard({super.key, required this.bullets, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F141B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x14FFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: bullets.map((bullet) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(width: 6, height: 6,
                margin: const EdgeInsets.only(top: 6, right: 10),
                decoration: BoxDecoration(color: accent, shape: BoxShape.circle)),
            Expanded(child: Text(bullet,
                style: const TextStyle(color: Color(0xFFB0BEC5), fontSize: 13, height: 1.5))),
          ]),
        )).toList(),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color accent;

  const InfoCard({super.key, required this.label, required this.value, required this.icon, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F141B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0x14FFFFFF)),
      ),
      child: Row(children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(color: accent.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: accent, size: 18),
        ),
        const SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
          Text(label, style: const TextStyle(color: Color(0xFF687483), fontSize: 11)),
        ]),
      ]),
    );
  }
}

class _ReactionRow extends StatelessWidget {
  final List<String> reactions;
  final String? selectedReaction;
  final void Function(String? reaction) onSetReaction;

  const _ReactionRow({required this.reactions, required this.selectedReaction, required this.onSetReaction});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: reactions.map((r) {
        final isSelected = selectedReaction == r;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => onSetReaction(isSelected ? null : r),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0x1AD7B56D) : const Color(0xFF0F141B),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isSelected ? const Color(0x44D7B56D) : const Color(0x14FFFFFF)),
              ),
              child: Text(r, style: const TextStyle(fontSize: 18)),
            ),
          ),
        );
      }).toList(),
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

class _RelatedTipCard extends StatelessWidget {
  final IntelItem item;
  final VoidCallback onTap;

  const _RelatedTipCard({required this.item, required this.onTap});

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
          const Icon(Icons.chevron_right_rounded, color: Color(0xFFD7B56D), size: 18),
        ]),
      ),
    );
  }
}