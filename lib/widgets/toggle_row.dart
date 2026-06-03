// lib/widgets/toggle_row.dart
// Shared toggle row widget used by RequestForm and RequestSummary

import 'package:flutter/material.dart';

/// Shared toggle row widget
/// Used by both RequestForm and RequestSummary for consistent UX
class ToggleRow extends StatelessWidget {
  const ToggleRow({
    super.key,
    required this.label,
    required this.active,
    required this.onToggle,
  });

  final String label;
  final bool active;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Row(
        children: [
          Icon(
            active ? Icons.toggle_on : Icons.toggle_off,
            color: active ? const Color(0xFF00FFC8) : Colors.grey.shade700,
            size: 28,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: active ? Colors.white : Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}
