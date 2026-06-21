import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../data/models/intel_item.dart';

/// ─────────────────────────────────────────────────────────────
///  TARGET DEVICE — switch this when you change device:
///
///  Emulator   →  'http://10.0.2.2:18790'
///  Physical   →  'http://192.168.1.173:18790'   (current)
/// ─────────────────────────────────────────────────────────────
const String kTipsLanUrl = 'http://192.168.1.173:18790';

/// Resolved automatically: localhost for Chrome/web, emulator/LAN IP for Android.
final String kTipsBaseUrl = kIsWeb ? 'http://localhost:18790' : kTipsLanUrl;

class TipsService {
  static Future<List<IntelItem>> fetchLiveTips() async {
    try {
      final response = await http
          .get(Uri.parse('$kTipsBaseUrl/api/tips'))
          .timeout(const Duration(seconds: 6));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final tipsList = data['tips'] as List<dynamic>;
        return tipsList
            .map((t) => _mapToIntelItem(t as Map<String, dynamic>))
            .where((item) => item.body.isNotEmpty)
            .toList();
      }
    } catch (e) {
      // ignore: avoid_print
      print('[TipsService] fetch failed: $e');
    }
    return [];
  }

  static IntelItem _mapToIntelItem(Map<String, dynamic> t) {
    final content = (t['content'] as String? ?? '').trim();
    final timestamp = DateTime.tryParse(t['timestamp'] as String? ?? '')
        ?.toLocal() ?? DateTime.now();

    return IntelItem(
      id:        t['id'] as String,
      source:    t['source'] as String? ?? 'Sgt. Brief',
      title:     _extractTitle(content),
      body:      content,
      shortBody: _truncate(content, 120),
      dayLabel:  _formatDay(timestamp),
      timeLabel: _formatTime(timestamp),
      category:  _detectCategory(content),
      footer:    '',
      icon:      _detectIcon(content),
      accent:    const Color(0xFFD7B56D),
      reactions: const ['❤️', '👍', '👎'],
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  static String _extractTitle(String content) {
    final firstLine = content.split('\n').first.trim();
    return _truncate(firstLine, 72);
  }

  static String _truncate(String s, int max) {
    if (s.length <= max) return s;
    return '${s.substring(0, max - 3)}...';
  }

  static String _formatDay(DateTime dt) {
    final now = DateTime.now();
    final isToday = dt.year == now.year &&
        dt.month == now.month &&
        dt.day == now.day;
    if (isToday) return 'Today';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${dt.day} ${months[dt.month - 1]}';
  }

  static String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  static String _detectCategory(String content) {
    final s = content.toLowerCase();
    if (s.contains('audio') || s.contains('footstep') || s.contains('sound') || s.contains('headphone')) return 'Audio';
    if (s.contains('loadout') || s.contains('weapon') || s.contains('gun') || s.contains('ar ') || s.contains('smg') || s.contains('snip')) return 'Weapon';
    if (s.contains('position') || s.contains('high ground') || s.contains('rotation') || s.contains('elevation') || s.contains('height')) return 'Positioning';
    if (s.contains('ranked') || s.contains('rank')) return 'Ranked';
    if (s.contains('movement') || s.contains('slide') || s.contains('sprint') || s.contains('mantle')) return 'Movement';
    if (s.contains('patch') || s.contains('update') || s.contains('nerf') || s.contains('buff')) return 'Patch';
    return 'Intel';
  }

  static IconData _detectIcon(String content) {
    final s = content.toLowerCase();
    if (s.contains('audio') || s.contains('sound') || s.contains('footstep') || s.contains('headphone')) return Icons.hearing_rounded;
    if (s.contains('loadout') || s.contains('weapon') || s.contains('gun')) return Icons.gps_fixed_rounded;
    if (s.contains('position') || s.contains('high ground') || s.contains('elevation')) return Icons.terrain_rounded;
    if (s.contains('ranked')) return Icons.emoji_events_rounded;
    if (s.contains('patch') || s.contains('update')) return Icons.newspaper_rounded;
    if (s.contains('movement') || s.contains('slide')) return Icons.directions_run_rounded;
    return Icons.tips_and_updates_rounded;
  }
}
