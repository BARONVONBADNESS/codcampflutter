import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../data/models/patch_intel_item.dart';
import 'tips_service.dart'; // for kTipsBaseUrl

class PatchService {
  static Future<List<PatchIntelItem>> fetchLivePatches() async {
    try {
      final response = await http
          .get(Uri.parse('$kTipsBaseUrl/api/patches'))
          .timeout(const Duration(seconds: 6));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final list = data['patches'] as List<dynamic>;
        return list
            .map((p) => _mapToPatchItem(p as Map<String, dynamic>))
            .where((item) => item.body.isNotEmpty)
            .toList();
      }
    } catch (e) {
      // ignore: avoid_print
      print('[PatchService] fetch failed: $e');
    }
    return [];
  }

  static PatchIntelItem _mapToPatchItem(Map<String, dynamic> p) {
    final content = (p['content'] as String? ?? '').trim();
    final timestamp =
        DateTime.tryParse(p['timestamp'] as String? ?? '')?.toLocal() ??
        DateTime.now();

    final type = _detectType(content);
    final impact = _detectImpact(content);
    final lines = content
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();
    final title = _extractTitle(lines);
    final bullets = _extractBullets(lines);

    return PatchIntelItem(
      id: p['id'] as String,
      issueCode: _extractIssueCode(lines, timestamp),
      title: title,
      subtitle: _truncate(content.replaceAll(RegExp(r'\*+'), '').trim(), 100),
      body: content,
      type: type,
      dateLabel: _formatDay(timestamp),
      impact: impact,
      status: 'live',
      timeAgo: _timeAgo(timestamp),
      icon: _detectIcon(content),
      accent: const Color(0xFFD7B56D),
      bullets: bullets,
      tags: _extractTags(content, type),
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Builds the issueCode label in the format:
  /// INTEL HQ RE_DACTED : "Patch Name" , "Patch Date"
  /// Extracts patch name and date from the first line of the message.
  /// e.g. "**🎮 Warzone Season 03 Reloaded Patch – May 21, 2026**"
  static String _extractIssueCode(List<String> lines, DateTime timestamp) {
    String patchName = '';
    String patchDate = '';

    if (lines.isNotEmpty) {
      // Strip markdown bold markers and trim
      final clean = lines.first.replaceAll(RegExp(r'\*+'), '').trim();

      // Split on – or — separator to get name and date parts
      final parts = clean.split(RegExp(r'\s[–—]\s'));
      if (parts.length >= 2) {
        // Strip leading emoji from the name part
        patchName = parts[0]
            .replaceAll(RegExp(r'^[\s\S]*?(?=[A-Za-z])'), '')
            .trim();
        patchDate = parts[1].trim();
      } else {
        // No separator — try to extract inline date
        final dateMatch = RegExp(
          r'([A-Za-z]+ \d{1,2},?\s*\d{4})',
        ).firstMatch(clean);
        if (dateMatch != null) {
          patchDate = dateMatch.group(1) ?? '';
          patchName = clean
              .replaceAll(dateMatch.group(0) ?? '', '')
              .replaceAll(RegExp(r'[^\x00-\x7F]'), '')
              .trim();
        } else {
          patchName = clean.replaceAll(RegExp(r'[^\x00-\x7F]'), '').trim();
        }
      }
    }

    // Fallback date from timestamp
    if (patchDate.isEmpty) {
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      patchDate =
          '${months[timestamp.month - 1]} ${timestamp.day}, ${timestamp.year}';
    }

    // Fallback name
    if (patchName.isEmpty) patchName = 'Patch Update';

    // Normalise to title case
    patchName = _toTitleCase(patchName);
    patchDate = _toTitleCase(patchDate);

    return '📡 Intel HQ RE_DACTED : "$patchName" , "$patchDate"';
  }

  /// Converts a string to Title Case (first letter of each word capitalised).
  static String _toTitleCase(String s) {
    return s
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          // Preserve all-caps abbreviations (e.g. AR, SMG, LMG, MK)
          if (word.length <= 3 && word == word.toUpperCase()) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  static String _extractTitle(List<String> lines) {
    // Strip markdown bold markers (**text**)
    final first = lines.isNotEmpty ? lines.first : '';
    final clean = first.replaceAll(RegExp(r'\*+'), '').trim();
    return _truncate(clean.isNotEmpty ? clean : 'Patch Update', 80);
  }

  static List<String> _extractBullets(List<String> lines) {
    // Lines starting with - or • or numbers are bullets
    final bullets = lines
        .where((l) => RegExp(r'^[-•\d]').hasMatch(l))
        .map((l) => l.replaceFirst(RegExp(r'^[-•\d+\.\s]+'), '').trim())
        .where((l) => l.isNotEmpty)
        .take(4)
        .toList();
    // Fallback: split body into sentences if no bullets found
    if (bullets.isEmpty && lines.length > 1) {
      return lines.skip(1).take(3).toList();
    }
    return bullets;
  }

  static String _detectType(String content) {
    final s = content.toLowerCase();
    if (s.contains('weapon') ||
        s.contains('dmg') ||
        s.contains('damage') ||
        s.contains('nerf') ||
        s.contains('buff') ||
        s.contains('recoil')) {
      return 'Weapons';
    }
    if (s.contains('ranked') || s.contains('rank')) return 'Ranked';
    if (s.contains('season') ||
        s.contains('reloaded') ||
        s.contains('update') ||
        s.contains('patch') ||
        s.contains('summary')) {
      return 'Summary';
    }
    if (s.contains('monitor') || s.contains('track')) return 'Monitor';
    return 'Summary';
  }

  static String _detectImpact(String content) {
    final s = content.toLowerCase();
    if (s.contains('major') ||
        s.contains('significant') ||
        s.contains('season') ||
        s.contains('reloaded') ||
        s.contains('big') ||
        s.contains('massive')) {
      return 'High';
    }
    if (s.contains('minor') || s.contains('small') || s.contains('slight')) {
      return 'Low';
    }
    return 'Medium';
  }

  static IconData _detectIcon(String content) {
    final s = content.toLowerCase();
    if (s.contains('weapon') || s.contains('gun') || s.contains('damage')) {
      return Icons.track_changes_rounded;
    }
    if (s.contains('season') || s.contains('reloaded')) {
      return Icons.article_rounded;
    }
    if (s.contains('ranked')) return Icons.emoji_events_rounded;
    if (s.contains('monitor') || s.contains('track')) {
      return Icons.radar_rounded;
    }
    return Icons.newspaper_rounded;
  }

  static List<String> _extractTags(String content, String type) {
    final tags = <String>[type];
    final s = content.toLowerCase();
    if (s.contains('warzone')) tags.add('Warzone');
    if (s.contains('multiplayer') || s.contains(' mp ')) {
      tags.add('Multiplayer');
    }
    if (s.contains('ranked')) tags.add('Ranked');
    if (s.contains('season')) tags.add('Season');
    if (s.contains('weapon') || s.contains('loadout')) tags.add('Weapons');
    return tags.toSet().take(4).toList();
  }

  static String _truncate(String s, int max) {
    if (s.length <= max) return s;
    return '${s.substring(0, max - 3)}...';
  }

  static String _formatDay(DateTime dt) {
    final now = DateTime.now();
    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return 'Today';
    }
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  static String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${(diff.inDays / 7).floor()}w ago';
  }
}
