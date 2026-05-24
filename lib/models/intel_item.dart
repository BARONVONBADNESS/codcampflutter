import 'package:flutter/material.dart';

class IntelItem {
  final String id;
  final String source;
  final String title;
  final String body;
  final String shortBody;
  final String dayLabel;
  final String timeLabel;
  final String category;
  final String footer;
  final IconData icon;
  final Color accent;
  final List<String> reactions;
  final bool isDuplicate;

  const IntelItem({
    required this.id,
    required this.source,
    required this.title,
    required this.body,
    required this.shortBody,
    required this.dayLabel,
    required this.timeLabel,
    required this.category,
    required this.footer,
    required this.icon,
    required this.accent,
    required this.reactions,
    this.isDuplicate = false,
  });
}