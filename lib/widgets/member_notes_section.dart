// lib/widgets/member_notes_section.dart
// Optional text area for extra context / coaching notes

import 'package:flutter/material.dart';

/// Member notes input section for the coaching request form
/// Provides an optional text area for additional context
class MemberNotesSection extends StatelessWidget {
  const MemberNotesSection({
    super.key,
    required this.notes,
    required this.onChanged,
  });

  final String notes;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Member notes (optional)',
          style: TextStyle(
            color: const Color(0xFFFD7B560),
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: 'Anything else the coach should know?',
            hintStyle: TextStyle(
              color: const Color(0xFF9330AF).withOpacity(0.4),
            ),
            filled: true,
            fillColor: Colors.black.withOpacity(0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          style: const TextStyle(color: Colors.white, fontSize: 11, height: 1.35),
          keyboardType: TextInputType.multiline,
          minLines: 3,
          maxLines: 5,
          controller: _notesController ??= TextEditingController(text: notes),
          onChanged: onChanged,
        ),
      ],
    );
  }

  TextEditingController? _notesController;

  @override
  void dispose() {
    _notesController?.dispose();
    super.dispose();
  }
}
