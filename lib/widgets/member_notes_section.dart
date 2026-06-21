// lib/widgets/member_notes_section.dart
// FIXED: StatelessWidget → StatefulWidget (non-final controller + dispose).

import 'package:flutter/material.dart';

class MemberNotesSection extends StatefulWidget {
  const MemberNotesSection({
    super.key,
    required this.notes,
    required this.onChanged,
  });

  final String notes;
  final ValueChanged<String> onChanged;

  @override
  State<MemberNotesSection> createState() => _MemberNotesSectionState();
}

class _MemberNotesSectionState extends State<MemberNotesSection> {
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.notes);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'MEMBER NOTES (OPTIONAL)',
          style: TextStyle(
            color: Color(0xFFD7B560),
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
              color: Colors.white.withValues(alpha: 0.25),
            ),
            filled: true,
            fillColor: Colors.black.withValues(alpha: 0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0x22FFFFFF)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0x22FFFFFF)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFFD7B560)),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          style: const TextStyle(
              color: Colors.white, fontSize: 13, height: 1.5),
          keyboardType: TextInputType.multiline,
          minLines: 3,
          maxLines: 5,
          controller: _notesController,
          onChanged: widget.onChanged,
        ),
      ],
    );
  }
}
