import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/models/weekly_plan.dart';
import 'tips_service.dart' show kTipsBaseUrl;

/// Fetches the weekly training plan from tips_server (GET /api/plans).
/// Offline-tolerant: returns null on any failure so the screen can fall back
/// to its built-in default schedule.
class WeeklyPlanService {
  static Future<WeeklyPlan?> fetchPlan() async {
    try {
      final response = await http
          .get(Uri.parse('$kTipsBaseUrl/api/plans'))
          .timeout(const Duration(seconds: 6));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final plan = data['plan'] as Map<String, dynamic>?;
        if (plan != null) return WeeklyPlan.fromJson(plan);
      }
    } catch (e) {
      // ignore: avoid_print
      print('[WeeklyPlanService] fetch failed: $e');
    }
    return null;
  }
}
