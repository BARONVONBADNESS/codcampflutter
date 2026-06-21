import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

const String kLoadoutLanUrl = 'http://192.168.1.173:18790';
final String kLoadoutBaseUrl = kIsWeb ? 'http://localhost:18790' : kLoadoutLanUrl;

class LoadoutAttachments {
  final String muzzle;
  final String barrel;
  final String underbarrel;
  final String magazine;
  final String rearGrip;

  const LoadoutAttachments({
    required this.muzzle,
    required this.barrel,
    required this.underbarrel,
    required this.magazine,
    required this.rearGrip,
  });

  factory LoadoutAttachments.fromJson(Map<String, dynamic> j) => LoadoutAttachments(
        muzzle:      j['muzzle']      ?? '—',
        barrel:      j['barrel']      ?? '—',
        underbarrel: j['underbarrel'] ?? '—',
        magazine:    j['magazine']    ?? '—',
        rearGrip:    j['rear_grip']   ?? '—',
      );

  List<MapEntry<String, String>> get entries => [
        MapEntry('Muzzle',      muzzle),
        MapEntry('Barrel',      barrel),
        MapEntry('Underbarrel', underbarrel),
        MapEntry('Magazine',    magazine),
        MapEntry('Rear Grip',   rearGrip),
      ];
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
