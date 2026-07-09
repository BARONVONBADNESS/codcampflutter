import 'package:flutter/material.dart';

/// Session accent tags — mirror the keys returned by GET /api/plans ("live"/"ab"/"solo").
enum PlanSessionTag { live, ab, solo }

PlanSessionTag planSessionTagFromKey(String? key) {
  switch (key) {
    case 'ab':
      return PlanSessionTag.ab;
    case 'solo':
      return PlanSessionTag.solo;
    case 'live':
    default:
      return PlanSessionTag.live;
  }
}

/// One scheduled training session within a day.
class PlanSession {
  final String title;
  final String time;
  final String iconKey; // vod | aim | coach | drill
  final PlanSessionTag tag;

  const PlanSession({
    required this.title,
    required this.time,
    required this.iconKey,
    required this.tag,
  });

  factory PlanSession.fromJson(Map<String, dynamic> j) => PlanSession(
        title: (j['title'] as String? ?? '').trim(),
        time: (j['time'] as String? ?? '').trim(),
        iconKey: (j['icon'] as String? ?? 'drill').trim(),
        tag: planSessionTagFromKey(j['tag'] as String?),
      );
}

/// Week-level completion summary shown in the progress card.
class WeekProgress {
  final int percent;
  final int completed;
  final int total;

  const WeekProgress({
    required this.percent,
    required this.completed,
    required this.total,
  });

  factory WeekProgress.fromJson(Map<String, dynamic>? j) => WeekProgress(
        percent: (j?['percent'] as num? ?? 0).round(),
        completed: (j?['completed'] as num? ?? 0).round(),
        total: (j?['total'] as num? ?? 0).round(),
      );

  double get fraction => total <= 0 ? (percent / 100.0) : completed / total;
}

/// The full weekly plan: per-day sessions keyed MON..SUN, plus week progress.
class WeeklyPlan {
  final WeekProgress progress;
  final Map<String, List<PlanSession>> days;
  final String author;
  final DateTime? updatedAt;

  const WeeklyPlan({
    required this.progress,
    required this.days,
    required this.author,
    this.updatedAt,
  });

  List<PlanSession> sessionsFor(String day) => days[day] ?? const [];

  factory WeeklyPlan.fromJson(Map<String, dynamic> j) {
    final rawDays = (j['days'] as Map<String, dynamic>? ?? {});
    final days = <String, List<PlanSession>>{};
    rawDays.forEach((day, list) {
      days[day] = (list as List<dynamic>? ?? [])
          .map((e) => PlanSession.fromJson(e as Map<String, dynamic>))
          .toList();
    });
    return WeeklyPlan(
      progress: WeekProgress.fromJson(j['weekProgress'] as Map<String, dynamic>?),
      days: days,
      author: (j['author'] as String? ?? 'Lt. Reaper'),
      updatedAt: DateTime.tryParse(j['updatedAt'] as String? ?? ''),
    );
  }
}

/// Maps the backend icon key to a Material icon (kept out of the model consumers).
IconData planIconFor(String key) {
  switch (key) {
    case 'vod':
      return Icons.play_circle_outline_rounded;
    case 'aim':
      return Icons.gps_fixed_rounded;
    case 'coach':
      return Icons.sports_esports_rounded;
    case 'drill':
      return Icons.fitness_center_rounded;
    default:
      return Icons.bolt_rounded;
  }
}
