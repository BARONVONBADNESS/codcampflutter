import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../data/models/plan_task.dart';
import '../data/models/patch_intel_item.dart';
import '../shared/widgets/empty_state_card.dart';

class WeeklyPlanScreen extends StatelessWidget {
  final Set<String> completedTaskIds;
  final Set<String> savedPatchIds;
  final void Function(String id) onToggleTask;

  const WeeklyPlanScreen({
    super.key,
    required this.completedTaskIds,
    required this.savedPatchIds,
    required this.onToggleTask,
  });

  @override
  Widget build(BuildContext context) {
    final completedCount = completedTaskIds.length;
    final totalCount = AppData.weeklyTasks.length;
    final savedPatchCount = savedPatchIds.length;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppTopBar(
                title: 'Weekly Plan',
                subtitle: 'Patch-aware training focus',
                icon: Icons.event_note_rounded,
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
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('WEEKLY FOCUS',
                        style: TextStyle(
                          color: Color(0xFFD7B56D),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.1,
                        )),
                    SizedBox(height: 12),
                    Text('This week\'s ranked improvement tasks.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        )),
                    SizedBox(height: 10),
                    Text(
                      'Tasks are built from your patch intel and coaching signals. '
                      'Check them off as you focus on each skill in your sessions.',
                      style: TextStyle(color: Color(0xFF93A0AF), fontSize: 13, height: 1.55),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const SectionTitle(title: 'Progress'),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: StatCard(label: 'Completed', value: '$completedCount / $totalCount', icon: Icons.check_circle_outline_rounded, color: const Color(0xFFD7B56D))),
                const SizedBox(width: 12),
                Expanded(child: StatCard(label: 'Saved Patch', value: '$savedPatchCount', icon: Icons.inventory_2_rounded, color: const Color(0xFF93A0AF))),
              ]),
              const SizedBox(height: 20),
              const SectionTitle(title: 'This Week\'s Tasks'),
              const SizedBox(height: 12),
              if (AppData.weeklyTasks.isEmpty)
                const EmptyStateCard(title: 'No tasks this week', subtitle: 'Check back after the next patch cycle.'),
              ...AppData.weeklyTasks.map((task) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: PlanTaskCard(task: task, isCompleted: completedTaskIds.contains(task.id), onToggle: () => onToggleTask(task.id)),
                  )),
              if (savedPatchIds.isNotEmpty) ...[
                const SizedBox(height: 8),
                const SectionTitle(title: 'Saved Patch Context'),
                const SizedBox(height: 12),
                ...AppData.patchItems.where((p) => savedPatchIds.contains(p.id)).take(3).map((p) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _SavedPatchContextCard(item: p),
                    )),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class PlanTaskCard extends StatelessWidget {
  final PlanTask task;
  final bool isCompleted;
  final VoidCallback onToggle;

  const PlanTaskCard({super.key, required this.task, required this.isCompleted, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        decoration: BoxDecoration(
          color: isCompleted ? const Color(0x1AD7B56D) : const Color(0xFF0F141B),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: isCompleted ? const Color(0x44D7B56D) : const Color(0x14FFFFFF)),
        ),
        child: Row(children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(color: task.accent.withOpacity(0.12), borderRadius: BorderRadius.circular(14)),
            child: Icon(task.icon, color: task.accent, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(task.title, style: TextStyle(
              color: isCompleted ? const Color(0xFFD7B56D) : Colors.white,
              fontSize: 15, fontWeight: FontWeight.w800,
              decoration: isCompleted ? TextDecoration.lineThrough : null,
              decorationColor: const Color(0xFFD7B56D),
            )),
            const SizedBox(height: 4),
            Text(task.subtitle, style: const TextStyle(color: Color(0xFF93A0AF), fontSize: 12, height: 1.45)),
          ])),
          const SizedBox(width: 12),
          Icon(
            isCompleted ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
            color: isCompleted ? const Color(0xFFD7B56D) : const Color(0xFF687483),
            size: 24,
          ),
        ]),
      ),
    );
  }
}

class _SavedPatchContextCard extends StatelessWidget {
  final PatchIntelItem item;
  const _SavedPatchContextCard({required this.item});

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
      ]),
    );
  }
}