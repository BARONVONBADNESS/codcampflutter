// lib/widgets/request_option.dart
// Reusable option button for coaching request form

import 'package:flutter/material.dart';

/// A selectable option widget used in the coaching request form
/// (e.g. for Mode and Urgency selection)
class RequestOption extends StatelessWidget {
  const RequestOption({
    super.key,
    required this.label,
    required this.active,
    this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: active
                ? const Color(0xFF00FFC8).withValues(alpha: 0.1)
                : Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: active
                  ? const Color(0xFF00FFC8)
                  : Colors.white.withValues(alpha: 0.1),
              width: active ? 2 : 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: active ? const Color(0xFF00FFC8) : Colors.white70,
              fontSize: 12,
              fontWeight: active ? FontWeight.w800 : FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
