import 'dart:convert';
import 'package:http/http.dart' as http;
import 'tips_service.dart'; // reuses kTipsBaseUrl
import 'auth_service.dart';

/// Syncs user stats with the tips server.
/// Falls back to local-only when offline or not logged in.
class StatsService {
  /// GET /api/stats/:userId — returns the user's saved stats from the server.
  static Future<Map<String, Map<String, double>>?> fetchStats() async {
    final userId = AuthService.userId;
    if (userId == null || userId.isEmpty) return null;

    try {
      final response = await http
          .get(Uri.parse('$kTipsBaseUrl/api/stats/$userId'))
          .timeout(const Duration(seconds: 6));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final raw = data['stats'] as Map<String, dynamic>? ?? {};
        return raw.map((modeKey, modeStats) => MapEntry(
          modeKey,
          Map<String, double>.from(
            (modeStats as Map).map((k, v) => MapEntry(k as String, (v as num).toDouble())),
          ),
        ));
      }
    } catch (e) {
      // ignore: avoid_print
      print('[StatsService] fetchStats failed: $e');
    }
    return null;
  }

  /// POST /api/stats — saves the user's stats to the server.
  static Future<bool> saveStats(Map<String, Map<String, double>> stats) async {
    final userId = AuthService.userId;
    if (userId == null || userId.isEmpty) return false;

    try {
      final response = await http
          .post(
            Uri.parse('$kTipsBaseUrl/api/stats'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'userId': userId,
              'stats': stats,
            }),
          )
          .timeout(const Duration(seconds: 6));

      return response.statusCode == 200;
    } catch (e) {
      // ignore: avoid_print
      print('[StatsService] saveStats failed: $e');
      return false;
    }
  }
}
