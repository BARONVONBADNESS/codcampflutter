// CoD UI overhaul applied:
//   - AppTopBar: sharp icon container, neon accent border, theme typography
//   - SectionTitle: uppercase + wide letter-spacing via titleLarge
//   - StatCard: sharp 3 px corners, theme surface, left accent bar
//   - HomeScreen hero panel: kept dark gradient, tightened copy style

import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../shared/widgets/radar_background.dart';

// ── Shared chrome widgets (imported by all screens) ────────────────────────

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
    final theme = Theme.of(context);
    return Row(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(3)),
          child: Image.asset(
            'assets/images/app_logo.png',
            width: 46,
            height: 46,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title.toUpperCase(), style: theme.textTheme.titleLarge),
              const SizedBox(height: 2),
              Text(subtitle, style: theme.textTheme.labelSmall),
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
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: const BorderRadius.all(Radius.circular(1)),
          ),
        ),
        const SizedBox(width: 8),
        Text(title.toUpperCase(), style: theme.textTheme.titleMedium),
      ],
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
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(3)),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: const BorderRadius.all(Radius.circular(3)),
              border: Border.all(color: color.withValues(alpha: 0.25)),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 12),
          Text(value,
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontSize: 20, letterSpacing: -0.5)),
          const SizedBox(height: 2),
          Text(label, style: theme.textTheme.labelSmall),
        ],
      ),
    );
  }
}

// ── HomeScreen ─────────────────────────────────────────────────────────────

class HomeScreen extends StatelessWidget {
  final int savedTipCount;
  final int savedLoadoutCount;
  final int completedTaskCount;
  final bool hasRequest;

  const HomeScreen({
    super.key,
    required this.savedTipCount,
    required this.savedLoadoutCount,
    required this.completedTaskCount,
    required this.hasRequest,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalTips = AppData.intelItems.length;
    final totalPatchItems = AppData.patchItems.length;

    return Scaffold(
      backgroundColor: const Color(0xFF050A05),
      body: RadarBackground(
        child: SafeArea(
          child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppTopBar(
                title: 'CoD Camp',
                subtitle: 'Ghost_Protocol · Warzone Intelligence',
                icon: Icons.sports_esports_rounded,
              ),
              const SizedBox(height: 18),

              // ── Hero banner ───────────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(3)),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF111A0A),
                      Color(0xFF0A0F05),
                      Color(0xFF080808),
                    ],
                  ),
                  border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.25)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('// LIVE INTEL',
                        style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            letterSpacing: 2.0)),
                    const SizedBox(height: 10),
                    Text(
                      'Tips · Coaching · Patch Intel · Weekly Plans',
                      style: theme.textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      hasRequest
                          ? 'Coaching request live. Check your profile for follow-up.'
                          : 'Submit a coaching request to activate the full Ghost Protocol workflow.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),
              const SectionTitle(title: 'Overview'),
              const SizedBox(height: 12),

              // ── Stat grid ─────────────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      label: 'Tips',
                      value: '$totalTips',
                      icon: Icons.tips_and_updates_rounded,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      label: 'Patch Intel',
                      value: '$totalPatchItems',
                      icon: Icons.radar_rounded,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      label: 'Saved Tips',
                      value: '$savedTipCount',
                      icon: Icons.bookmark_rounded,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      label: 'Saved Builds',
                      value: '$savedLoadoutCount',
                      icon: Icons.inventory_2_rounded,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      label: 'Plan Done',
                      value: '$completedTaskCount',
                      icon: Icons.check_circle_outline_rounded,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      label: 'Request',
                      value: hasRequest ? 'LIVE' : 'NONE',
                      icon: Icons.send_rounded,
                      color: hasRequest
                          ? theme.colorScheme.primary
                          : theme.colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
