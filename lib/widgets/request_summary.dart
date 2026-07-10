// lib/widgets/request_summary.dart
// Terminal-style animated preview summary

import 'package:flutter/material.dart';
import '../data/models/coaching_request_model.dart';
import 'toggle_row.dart';

/// Request summary card displayed in the preview panel
/// Shows a terminal-style animated summary of the coaching request
class RequestSummary extends StatelessWidget {
  const RequestSummary({
    super.key,
    required this.snapshot,
    this.onConfirm,
  });

  final FullRequest snapshot;
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    final req = snapshot.latest;
    if (req == null) {
      return _emptyStateWidget();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              color: Colors.white.withOpacity(0.05),
              child: Text(
                'MEMBER REQUEST',
                style: TextStyle(
                  color: const Color(0xFFFD7B560),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                ),
              ),
            ),
            const SizedBox(height: 12),
// Padding
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\'Turn live intel into a real coaching request.\'',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Warzone Intel is already tracking recurring patch notes, summaries, and weapon changes, so this screen just focuses on your immediate coaching needs.',
                    style: TextStyle(
                      color: const Color(0xFF9330AF),
                      fontSize: 11,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: Color(0x33FFFFFF), height: 1),
                  const SizedBox(height: 12),

                  // Mode
                  AnimatedSummaryLine(
                    label: 'Mode',
                    value: req.mode,
                    delay: 0,
                  ),
                  const SizedBox(height: 6),

                  // Weakness
                  AnimatedSummaryLine(
                    label: 'Weakness',
                    value: req.weakness.isEmpty ? '(not specified)' : req.weakness,
                    delay: 1,
                    muted: req.weakness.isEmpty,
                  ),
                  const SizedBox(height: 6),

                  // Goal
                  AnimatedSummaryLine(
                    label: 'Goal',
                    value: req.goal.isEmpty ? '(not specified)' : req.goal,
                    delay: 2,
                    muted: req.goal.isEmpty,
                  ),
                  const SizedBox(height: 6),

                  // Session
                  AnimatedSummaryLine(
                    label: 'Session',
                    value: '\${req.sessionLength.toInt()} min',
                    delay: 3,
                  ),
                  const SizedBox(height: 6),

                  // Urgency
                  AnimatedSummaryLine(
                    label: 'Urgency',
                    value: req.urgency,
                    delay: 4,
                  ),

                  // Toggles
                  const SizedBox(height: 12),
                  ToggleRow(
                    label: 'Patch-aware',
                    active: req.patchAware,
                    onToggle: () {},
                  ),
                  const SizedBox(height: 8),
                  ToggleRow(
                    label: 'Loadout review',
                    active: req.includeLoadoutReview,
                    onToggle: () {},
                  ),
                  const SizedBox(height: 8),
                  ToggleRow(
                    label: 'VOD review',
                    active: req.includeVodReview,
                    onToggle: () {},
                  ),

                  // Notes
                  if (req.notes.trim().isNotEmpty) ...[
                    const SizedBox(height: 10),
                    const Divider(color: Color(0x33FFFFFF), height: 1),
                    const SizedBox(height: 10),
                    Text(
                      'Member notes',
                      style: TextStyle(
                        color: const Color(0xFFFD7B560),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    AnimatedSummaryLine(
                      label: 'Notes',
                      value: req.notes.trim(),
                      delay: 5,
                      multiline: true,
                    ),
                  ],

                  const SizedBox(height: 16),
                  // Confirm button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onConfirm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00FFC8),
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'CONFIRM REQUEST',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyStateWidget() {
    return Center(
      child: Text(
        'Awaiting input...\n',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white.withOpacity(0.4),
          fontSize: 11,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}

/// Animates content appearance with a delay
/// Used for the terminal-typewriter effect in the preview
class AnimatedSummaryLine extends StatefulWidget {
  const AnimatedSummaryLine({
    super.key,
    required this.label,
    required this.value,
    required this.delay,
    this.muted = false,
    this.multiline = false,
  });

  final String label;
  final String value;
  final int delay;
  final bool muted;
  final bool multiline;

  @override
  State<AnimatedSummaryLine> createState() => _AnimatedSummaryLineState();
}

class _AnimatedSummaryLineState extends State<AnimatedSummaryLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    Future.delayed(Duration(milliseconds: widget.delay * 400), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 80,
              child: Text(
                '\${widget.label}:',
                style: TextStyle(
                  color: widget.muted
                      ? Colors.white24
                      : const Color(0xFFD7B560),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: Text(
                widget.value,
                style: TextStyle(
                  color: widget.muted ? Colors.white24 : Colors.white,
                  fontSize: 11,
                  height: widget.multiline ? 1.3 : 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
