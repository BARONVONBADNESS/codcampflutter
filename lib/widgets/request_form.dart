// lib/widgets/request_form.dart
// Modular request creation form extracted from CoachingRequestScreen

import 'package:flutter/material.dart';
import '../data/models/coaching_request_model.dart';
import 'request_option.dart';
import 'patch_aware_tip.dart';
import 'member_notes_section.dart';
import 'toggle_row.dart';

/// The main form widget that captures all coaching request fields
/// Extracted to allow reuse and independent testing
class RequestForm extends StatefulWidget {
  const RequestForm({super.key, required this.controller, this.onChanged});

  final CoachingRequestController controller;
  final VoidCallback? onChanged;

  @override
  State<RequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  void _notifyChanged() {
    widget.onChanged?.call();
    setState(() {}); // Rebuild to update validation state
  }

  // ── Input helpers (shared with preview) ────────────────────────
  void _updateStringField(
    String Function() getter,
    void Function(String) setter, {
    String minText = '',
  }) {
    final value = getter().trim();
    if (value != minText && value.length >= minText.length) {
      setter(value);
      _notifyChanged();
    }
  }

  void _updateIntField(String Function() getter, void Function(String) setter) {
    final v = getter().replaceAll(RegExp(r'[^0-9]'), '');
    final n = int.tryParse(v) ?? 0;
    setter(n.toString());
    _notifyChanged();
  }

  // ── ─────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    return Column(
      children: [
        PatchAwareTip(
          title: 'PATCH-AWARE',
          subtitle: 'Turn live intel into a real coaching request.',
          tip:
              'Warzone Intel is already tracking recurring patch notes, summaries, and weapon changes, so this screen just focuses on your immediate coaching needs.',
        ),
        const SizedBox(height: 8),
        Text(
          'What do you want to improve?',
          style: TextStyle(
            color: const Color(0xFF00FFC8),
            fontSize: 20,
            fontWeight: FontWeight.w800,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 20),

        // ── MODE ───────────────────────────────────────────
        Text(
          'Mode',
          style: TextStyle(
            color: const Color(0xFFD7B560),
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            RequestOption(
              label: 'Ranked',
              active: c.mode == 'Ranked',
              onTap: () {
                c.mode = 'Ranked';
                _notifyChanged();
              },
            ),
            const SizedBox(width: 8),
            RequestOption(
              label: 'Casual',
              active: c.mode == 'Casual',
              onTap: () {
                c.mode = 'Casual';
                _notifyChanged();
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: RequestOption(
                label: 'Other',
                active: c.mode == 'Other',
                onTap: () {
                  c.mode = 'Other';
                  _notifyChanged();
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (c.mode == 'Other')
          TextField(
            decoration: InputDecoration(
              hintText: 'Describe your mode',
              hintStyle: TextStyle(
                color: const Color(0xFF9330AF).withValues(alpha: 0.4),
              ),
              filled: true,
              fillColor: Colors.black.withValues(alpha: 0.2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
            ),
            style: const TextStyle(color: Colors.white, fontSize: 12),
            controller: _otherModeController ??= TextEditingController(
              text: c.modeDetail,
            ),
            onChanged: (v) {
              c.modeDetail = v;
              _notifyChanged();
            },
          ),

        // ── WEAKNESS / GOAL ─────────────────────────────────
        SizedBox(height: c.mode == 'Other' ? 8 : 20),
        Text(
          "What's your biggest weakness?",
          style: TextStyle(
            color: const Color(0xFFD7B560),
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            hintText:
                'Weapon control, positioning, map awareness, clutching, aim, loadout...',
            hintStyle: TextStyle(
              color: const Color(0xFF9330AF).withValues(alpha: 0.4),
            ),
            filled: true,
            fillColor: Colors.black.withValues(alpha: 0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
          ),
          style: const TextStyle(color: Colors.white, fontSize: 12),
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 4,
          controller: _weaknessController ??= TextEditingController(
            text: c.weakness,
          ),
          onChanged: (v) =>
              _updateStringField(() => c.weakness, (val) => c.weakness = val),
        ),
        const SizedBox(height: 20),
        Text(
          "What's the goal for this session?",
          style: TextStyle(
            color: const Color(0xFFD7B560),
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Push Diamond, hit kill threshold, stop r57ing...',
            hintStyle: TextStyle(
              color: const Color(0xFF9330AF).withValues(alpha: 0.4),
            ),
            filled: true,
            fillColor: Colors.black.withValues(alpha: 0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
          ),
          style: const TextStyle(color: Colors.white, fontSize: 12),
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 4,
          controller: _goalController ??= TextEditingController(text: c.goal),
          onChanged: (v) =>
              _updateStringField(() => c.goal, (val) => c.goal = val),
        ),

        // ── SESSION LENGTH ───────────────────────────────────
        const SizedBox(height: 20),
        Text(
          'How long is the session?',
          style: TextStyle(
            color: const Color(0xFFD7B560),
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            hintText: '60',
            hintStyle: TextStyle(
              color: const Color(0xFF9330AF).withValues(alpha: 0.4),
            ),
            filled: true,
            fillColor: Colors.black.withValues(alpha: 0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
          ),
          style: const TextStyle(color: Colors.white, fontSize: 12),
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          controller: _sessionController ??= TextEditingController(
            text: c.sessionLength,
          ),
          onChanged: (v) => _updateIntField(
            () => c.sessionLength,
            (val) => c.sessionLength = val,
          ),
        ),

        // ── URGENCY ──────────────────────────────────────────
        const SizedBox(height: 20),
        Text(
          'How urgent is this?',
          style: TextStyle(
            color: const Color(0xFFD7B560),
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            RequestOption(
              label: 'Now',
              active: c.urgency == 'Now',
              onTap: () {
                c.urgency = 'Now';
                _notifyChanged();
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: RequestOption(
                label: 'Within 24h',
                active: c.urgency == 'Within 24h',
                onTap: () {
                  c.urgency = 'Within 24h';
                  _notifyChanged();
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: RequestOption(
                label: 'Anytime',
                active: c.urgency == 'Anytime',
                onTap: () {
                  c.urgency = 'Anytime';
                  _notifyChanged();
                },
              ),
            ),
          ],
        ),

        // ── TOGGLES ──────────────────────────────────────────
        const SizedBox(height: 20),
        ToggleRow(
          label: 'Patch-aware',
          active: c.patchAware,
          onToggle: () {
            c.patchAware = !c.patchAware;
            _notifyChanged();
          },
        ),
        const SizedBox(height: 12),
        ToggleRow(
          label: 'Loadout review',
          active: c.includeLoadoutReview,
          onToggle: () {
            c.includeLoadoutReview = !c.includeLoadoutReview;
            _notifyChanged();
          },
        ),
        const SizedBox(height: 12),
        ToggleRow(
          label: 'VOD review',
          active: c.includeVodReview,
          onToggle: () {
            c.includeVodReview = !c.includeVodReview;
            _notifyChanged();
          },
        ),

        // ── MEMBER NOTES ─────────────────────────────────────
        const SizedBox(height: 24),
        MemberNotesSection(
          notes: c.notes,
          onChanged: (v) {
            c.notes = v;
            _notifyChanged();
          },
        ),
      ],
    );
  }

  TextEditingController? _otherModeController;
  TextEditingController? _weaknessController;
  TextEditingController? _goalController;
  TextEditingController? _sessionController;

  @override
  void dispose() {
    _otherModeController?.dispose();
    _weaknessController?.dispose();
    _goalController?.dispose();
    _sessionController?.dispose();
    super.dispose();
  }
}
