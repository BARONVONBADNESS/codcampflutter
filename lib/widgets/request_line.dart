// lib/widgets/request_line.dart
// Key-value display line used in the request summary

import 'package:flutter/material.dart';

/// Displays a single key-value line in the request summary panel
/// Supports multiline values and muted state for empty fields
class RequestLine extends StatelessWidget {
  const RequestLine({
    super.key,
    required this.label,
    required this.value,
    this.muted = false,
    this.multiline = false,
  });

  final String label;
  final String value;
  final bool muted;
  final bool multiline;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 88,
          child: Text(
            '$label:',
            style: TextStyle(
              color: muted ? Colors.white24 : const Color(0xFFD7B560),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: muted ? Colors.white24 : Colors.white,
              fontSize: 11,
              height: multiline ? 1.3 : 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
