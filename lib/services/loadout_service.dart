import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

const String kLoadoutLanUrl = 'http://192.168.1.173:18790';
final String kLoadoutBaseUrl = kIsWeb ? 'http://localhost:18790' : kLoadoutLanUrl;

class LoadoutAttachments {
  /// All attachment slots, keyed by display label (e.g. "Muzzle", "Rear Grip").
  /// Only slots that have a real attachment are included — no "—" fillers.
  final Map<String, String> _slots;

  const LoadoutAttachments._(this._slots);

  /// Canonical slot order for display. Slots not in this list appear at the end.
  static const _slotOrder = [
    'muzzle', 'barrel', 'underbarrel', 'stock',
    'magazine', 'rear_grip', 'optic', 'laser',
  ];

  static const _slotLabels = {
    'muzzle':      'Muzzle',
    'barrel':      'Barrel',
    'underbarrel': 'Underbarrel',
    'stock':       'Stock',
    'magazine':    'Magazine',
    'rear_grip':   'Rear Grip',
    'optic':       'Optic',
    'laser':       'Laser',
  };

  factory LoadoutAttachments.fromJson(Map<String, dynamic> j) {
    final slots = <String, String>{};
    for (final key in _slotOrder) {
      final val = j[key] as String?;
      if (val != null && val.isNotEmpty && val != '—') {
        slots[_slotLabels[key] ?? key] = val;
      }
    }
    // Pick up any extra keys not in the canonical list
    for (final entry in j.entries) {
      final label = _slotLabels[entry.key] ?? entry.key;
      if (!slots.containsKey(label) && entry.value is String) {
        final v = entry.value as String;
        if (v.isNotEmpty && v != '—') slots[label] = v;
      }
    }
    return LoadoutAttachments._(slots);
  }

  List<MapEntry<String, String>> get entries => _slots.entries.toList();
}

class Loadout {
  final String id;
  final String name;
  final String weapon;
  final String weaponClass;
  final String tier;
  final int    metaScore;
  final String author;
  final String sharedAt;
  final String notes;
  final List<String> bestFor;
  final LoadoutAttachments attachments;
  final Map<String, int> baseStats;

  const Loadout({
    required this.id,
    required this.name,
    required this.weapon,
    required this.weaponClass,
    required this.tier,
    required this.metaScore,
    required this.author,
    required this.sharedAt,
    required this.notes,
    required this.bestFor,
    required this.attachments,
    required this.baseStats,
  });

  factory Loadout.fromJson(Map<String, dynamic> j, Map<String, dynamic> weaponDb) {
    final weaponName = j['weapon'] as String? ?? '';
    final wData      = (weaponDb['weapons'] as Map<String, dynamic>?)?[weaponName];
    return Loadout(
      id:          j['id']         ?? '',
      name:        j['name']       ?? '',
      weapon:      weaponName,
      weaponClass: wData?['class'] ?? 'Unknown',
      tier:        wData?['tier']  ?? '?',
      metaScore:   wData?['meta_score'] ?? 0,
      author:      j['author']     ?? '',
      sharedAt:    j['shared_at']  ?? '',
      notes:       j['notes']      ?? '',
      bestFor:     List<String>.from(j['best_for'] ?? []),
      attachments: LoadoutAttachments.fromJson(
          Map<String, dynamic>.from(j['attachments'] ?? {})),
      baseStats: wData != null
          ? Map<String, int>.from(
              (wData['base_stats'] as Map).map((k, v) => MapEntry(k as String, (v as num).toInt())))
          : {},
    );
  }
}

class LoadoutService {
  static Map<String, dynamic> _weaponDb = {};

  static Future<List<Loadout>> fetchLoadouts() async {
    try {
      final results = await Future.wait([
        http.get(Uri.parse('$kLoadoutBaseUrl/api/loadouts')).timeout(const Duration(seconds: 6)),
        http.get(Uri.parse('$kLoadoutBaseUrl/api/weapons')).timeout(const Duration(seconds: 6)),
      ]);

      if (results[1].statusCode == 200) {
        _weaponDb = jsonDecode(results[1].body) as Map<String, dynamic>;
      }

      if (results[0].statusCode == 200) {
        final data     = jsonDecode(results[0].body) as Map<String, dynamic>;
        final rawList  = data['loadouts'] as List<dynamic>;
        return rawList
            .map((r) => Loadout.fromJson(r as Map<String, dynamic>, _weaponDb))
            .toList()
            .reversed
            .toList();
      }
    } catch (e) {
      // ignore: avoid_print
      print('[LoadoutService] fetch failed: $e');
    }
    return [];
  }
}
