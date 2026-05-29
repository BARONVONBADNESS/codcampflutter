import 'package:flutter/material.dart';
import '../models/intel_item.dart';
import '../models/patch_intel_item.dart';
import '../models/plan_task.dart';
import '../models/coaching_request.dart';
import '../data/app_data.dart';
import '../shared/widgets/request_line.dart';
import '../shared/widgets/meta_pill.dart';
import '../shared/widgets/info_chip.dart';
import '../shared/widgets/detail_panel.dart';
import '../shared/widgets/empty_state_card.dart';

class AppTopBar extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const AppTopBar({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: const Color(0xFF111821),
            border: Border.all(color: const Color(0x33D7B56D)),
          ),
          child: Icon(icon, color: const Color(0xFFD7B56D)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF8C97A5),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF10161E),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0x14FFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withAlpha(36),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF93A0AF),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final bool hideDuplicates;
  final int savedTipCount;
  final int savedPatchCount;
  final int completedTaskCount;
  final bool hasRequest;

  const HomeScreen({
    super.key,
    required this.hideDuplicates,
    required this.savedTipCount,
    required this.savedPatchCount,
    required this.completedTaskCount,
    required this.hasRequest,
  });

  @override
  Widget build(BuildContext context) {
    final totalTips = AppData.intelItems.length;
    final totalDuplicates = AppData.intelItems.where((e) => e.isDuplicate).length;
    final totalPatchItems = AppData.patchItems.length;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppTopBar(
                title: 'CoD Camp',
                subtitle: 'Ghost_Protocol app shell',
                icon: Icons.sports_esports_rounded,
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF151D27),
                      Color(0xFF0E141C),
                      Color(0xFF0A0F15),
                    ],
                  ),
                  border: Border.all(color: const Color(0x22D7B56D)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'LIVE APP DIRECTION',
                      style: TextStyle(
                        color: Color(0xFFD7B56D),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Tips, coaching, patch intelligence, and weekly plans.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      hasRequest
                          ? 'Your latest coaching request is now saved in the member profile and ready for follow-up.'
                          : 'The next premium action is a structured coaching request that uses the same patch-aware intelligence flow.',
                      style: const TextStyle(
                        color: Color(0xFF93A0AF),
                        fontSize: 13,
                        height: 1.55,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const SectionTitle(title: 'Overview'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      label: 'Tips',
                      value: '$totalTips',
                      icon: Icons.lightbulb_outline_rounded,
                      color: const Color(0xFFD7B56D),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      label: 'Patch Intel',
                      value: '$totalPatchItems',
                      icon: Icons.newspaper_rounded,
                      color: const Color(0xFF93A0AF),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      label: 'Saved Tips',
                      value: '$savedTipCount',
                      icon: Icons.bookmark_rounded,
                      color: const Color(0xFFD7B56D),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      label: 'Saved Patch',
                      value: '$savedPatchCount',
                      icon: Icons.inventory_2_rounded,
                      color: const Color(0xFF93A0AF),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      label: 'Plan Done',
                      value: '$completedTaskCount',
                      icon: Icons.check_circle_outline_rounded,
                      color: const Color(0xFFD7B56D),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      label: 'Request',
                      value: hasRequest ? 'Live' : 'None',
                      icon: Icons.send_rounded,
                      color: const Color(0xFF93A0AF),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      label: 'Duplicates',
                      value: '$totalDuplicates',
                      icon: Icons.copy_all_rounded,
                      color: const Color(0xFFD7B56D),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      label: 'De-dupe',
                      value: hideDuplicates ? 'On' : 'Off',
                      icon: Icons.tune_rounded,
                      color: const Color(0xFF93A0AF),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
