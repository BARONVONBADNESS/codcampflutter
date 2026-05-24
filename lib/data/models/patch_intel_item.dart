import 'package:flutter/material.dart';

class PatchIntelItem {
  final String id;
  final String issueCode;
  final String title;
  final String subtitle;
  final String body;
  final String type;
  final String dateLabel;
  final String impact;
  final String status;
  final String timeAgo;
  final IconData icon;
  final Color accent;
  final List<String> bullets;
  final List<String> tags;

  const PatchIntelItem({
    required this.id,
    required this.issueCode,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.type,
    required this.dateLabel,
    required this.impact,
    required this.status,
    required this.timeAgo,
    required this.icon,
    required this.accent,
    required this.bullets,
    required this.tags,
  });
}
