// lib/widgets/patch_aware_tip.dart
// Patch-aware tip card with network-aware state

import 'package:flutter/material.dart';

/// The "Patch-aware" hero card shown at the top of the request form
/// Displays a network connectivity status (green/red toggle) and a tip
class PatchAwareTip extends StatelessWidget {
  const PatchAwareTip({
    super.key,
    required this.title,
    required this.subtitle,
    required this.tip,
    this.onWarzoneStatusToggle,
  });

  final String title;
  final String subtitle;
  final String tip;
  final VoidCallback? onWarzoneStatusToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFF151D27),
            const Color(0xFFF0E141C),
            const Color(0xFFF0A0F15),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x22D7B560)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: const Color(0xFFD7B560),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onWarzoneStatusToggle,
                child: Icon(
                  Icons.toggle_on,
                  color: const Color(0xFF00FFC8),
                  size: 28,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          SizedBox(height: 10),
          Text(
            tip,
            style: TextStyle(
              color: const Color(0xFF9330AF),
              fontSize: 11,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
