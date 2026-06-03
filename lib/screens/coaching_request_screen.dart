import 'package:flutter/material.dart';
import '../../data/app_data.dart';
import '../../models/coaching_request.dart';
import '../../shared/widgets/selection_card.dart';
import '../../shared/widgets/settings_switch_tile.dart';

class CoachingRequestScreen extends StatefulWidget {
  final CoachingRequest? latestRequest;
  final void Function(CoachingRequest) onSubmitRequest;

  const CoachingRequestScreen({
    super.key,
    required this.latestRequest,
    required this.onSubmitRequest,
  });

  @override
  State<CoachingRequestScreen> createState() => _CoachingRequestScreenState();
}

class _CoachingRequestScreenState extends State<CoachingRequestScreen> {
  final TextEditingController notesController = TextEditingController();
  String selectedMode = 'Ranked Resurgence';
  String selectedWeakness = 'Positioning';
  String selectedGoal = 'Win more ranked fights';
  String selectedSession = '60 min';
  String selectedUrgency = 'This week';
  bool patchAware = true;
  bool includeLoadoutReview = true;
  bool includeVodReview = false;

  final List<String> modes = const [
    'Ranked Resurgence', 'Warzone BR', 'Multiplayer Ranked', 'Public Match Practice',
  ];
  final List<String> weaknesses = const [
    'Positioning', 'Audio awareness', 'Aim consistency', 'Decision making', 'Rotations', 'Loadout choice',
  ];
  final List<String> goals = const [
    'Win more ranked fights', 'Improve KD', 'Climb rank faster', 'Stop losing late game', 'Learn patch-aware loadouts',
  ];
  final List<String> sessions = const [
    '30 min', '60 min', '90 min', '120 min',
  ];
  final List<String> urgencies = const [
    'Tonight', 'This week', 'Next session', 'No rush',
  ];

  void submitRequest() {
    final request = CoachingRequest(
      mode: selectedMode,
      weakness: selectedWeakness,
      goal: selectedGoal,
      sessionLength: selectedSession,
      urgency: selectedUrgency,
      notes: notesController.text.trim(),
      patchAware: patchAware,
      includeLoadoutReview: includeLoadoutReview,
      includeVodReview: includeVodReview,
    );
    widget.onSubmitRequest(request);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF10161E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Request submitted', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Your coaching request has been saved to your member profile.',
          style: TextStyle(color: Color(0xFF93A0AF), height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done', style: TextStyle(color: Color(0xFFD7B56D))),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final latestRequest = widget.latestRequest;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppTopBar(
                title: 'Request Coaching',
                subtitle: 'Patch-aware session request',
                icon: Icons.send_rounded,
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF151D27), Color(0xFF0E141C), Color(0xFF0A0F15)],
                  ),
                  border: Border.all(color: const Color(0x22D7B56D)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('MEMBER REQUEST',
                      style: TextStyle(color: Color(0xFFD7B56D), fontSize: 11,
                        fontWeight: FontWeight.w800, letterSpacing: 1.1)),
                    SizedBox(height: 12),
                const SectionTitle(title: 'Latest Request'),
                const SizedBox(height: 12),
                CoachingSummaryCard(request: latestRequest),
                const SizedBox(height: 20),
              ],
              const SectionTitle(title: 'Session Setup'),
              const SizedBox(height: 12),
              SelectionCard(
                title: 'Mode', value: selectedMode,
                icon: Icons.sports_esports_rounded, accent: const Color(0xFFD7B56D),
                onTap: () async {
                  final value = await _showPicker(context, 'Select mode', modes);
                  if (value != null) setState(() => selectedMode = value);
                },
              ),
              const SizedBox(height: 12),
              SelectionCard(
                title: 'Main weakness', value: selectedWeakness,
                icon: Icons.warning_amber_rounded, accent: const Color(0xFF93A0AF),
                onTap: () async {
                  final value = await _showPicker(context, 'Select weakness', weaknesses);
                  if (value != null) setState(() => selectedWeakness = value);
                },
              ),
              const SizedBox(height: 12),
              SelectionCard(
                title: 'Goal', value: selectedGoal,
                icon: Icons.flag_rounded, accent: const Color(0xFFD7B56D),
                onTap: () async {
                  final value = await _showPicker(context, 'Select goal', goals);
                  if (value != null) setState(() => selectedGoal = value);
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: SelectionCard(
                      title: 'Session', value: selectedSession,
                      icon: Icons.timer_outlined, accent: const Color(0xFF93A0AF),
                      onTap: () async {
                        final value = await _showPicker(context, 'Session length', sessions);
                        if (value != null) setState(() => selectedSession = value);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SelectionCard(
                      title: 'Urgency', value: selectedUrgency,
                      icon: Icons.bolt_rounded, accent: const Color(0xFFD7B56D),
                      onTap: () async {
                        final value = await _showPicker(context, 'Select urgency', urgencies);
                        if (value != null) setState(() => selectedUrgency = value);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const SectionTitle(title: 'Request Options'),
              const SizedBox(height: 12),
              SettingsSwitchTile(
                title: 'Patch-aware coaching',
                subtitle: 'Use live patch summaries and weapon changes in the session.',
                value: patchAware, icon: Icons.newspaper_rounded,
                accent: const Color(0xFFD7B56D),
                onChanged: (value) => setState(() => patchAware = value),
              ),
              const SizedBox(height: 12),
              SettingsSwitchTile(
                title: 'Include loadout review',
                subtitle: 'Add weapon and attachment recommendations.',
                value: includeLoadoutReview, icon: Icons.track_changes_rounded,
                accent: const Color(0xFF93A0AF),
                onChanged: (value) => setState(() => includeLoadoutReview = value),
              ),
              const SizedBox(height: 12),
              SettingsSwitchTile(
                title: 'Include VOD review',
                subtitle: 'Prepare the request for gameplay breakdown support.',
                value: includeVodReview, icon: Icons.ondemand_video_rounded,
                accent: const Color(0xFFD7B56D),
                onChanged: (value) => setState(() => includeVodReview = value),
              ),
              const SizedBox(height: 24),
              const SectionTitle(title: 'Extra Notes'),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF0F141B),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0x14FFFFFF)),
                ),
                child: TextField(
                  controller: notesController,
                  maxLines: 5,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(16),
                    hintText: 'Example: I keep losing rooftop fights and I want a simple ranked setup for this week.',
                    hintStyle: TextStyle(color: Color(0xFF7D8997)),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const SectionTitle(title: 'Request Preview'),
              const SizedBox(height: 12),
              CoachingPreviewCard(
                mode: selectedMode, weakness: selectedWeakness, goal: selectedGoal,
                sessionLength: selectedSession, urgency: selectedUrgency,
                patchAware: patchAware, includeLoadoutReview: includeLoadoutReview,
                includeVodReview: includeVodReview, notes: notesController.text,
              ),
              const SizedBox(height: 18),
              ElevatedButton.icon(
                onPressed: submitRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD7B56D),
                  foregroundColor: const Color(0xFF0A0D11),
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                icon: const Icon(Icons.send_rounded),
                label: const Text('Submit coaching request', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> _showPicker(BuildContext context, String title, List<String> options) async {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: const Color(0xFF10161E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 14),
                ...options.map(
                  (option) => ListTile(
                    title: Text(option, style: const TextStyle(color: Colors.white)),
                    trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFFD7B56D)),
                    onTap: () => Navigator.pop(context, option),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ├── Shared widgets (also used by TipsFeedScreen and ProfileScreen) ─────────────────────────────────────────

class CoachingPreviewCard extends StatelessWidget {
  final String mode, weakness, goal, sessionLength, urgency, notes;
  final bool patchAware, includeLoadoutReview, includeVodReview;
  const CoachingPreviewCard({
    super.key,
    required this.mode, required this.weakness, required this.goal,
    required this.sessionLength, required this.urgency,
    required this.patchAware, required this.includeLoadoutReview,
    required this.includeVodReview, required this.notes,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0F141B), borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x14FFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Preview', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          RequestLine(label: 'Mode', value: mode),
          RequestLine(label: 'Weakness', value: weakness),
          RequestLine(label: 'Goal', value: goal),
          RequestLine(label: 'Session', value: sessionLength),
          RequestLine(label: 'Urgency', value: urgency),
          RequestLine(label: 'Patch-aware', value: patchAware ? 'Yes' : 'No'),
          RequestLine(label: 'Loadout review', value: includeLoadoutReview ? 'Yes' : 'No'),
          RequestLine(label: 'VOD review', value: includeVodReview ? 'Yes' : 'No'),
          if (notes.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            const Text('Notes', style: TextStyle(color: Color(0xFFD7B56D), fontSize: 12, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(notes.trim(), style: const TextStyle(color: Color(0xFF93A0AF), fontSize: 13, height: 1.5)),
          ],
        ],
      ),
    );
  }
}

class CoachingSummaryCard extends StatelessWidget {
  final CoachingRequest request;
  const CoachingSummaryCard({super.key, required this.request});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0F141B), borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x14FFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.verified_rounded, color: Color(0xFFD7B56D), size: 18),
              SizedBox(width: 8),
              Text('Saved request', style: TextStyle(color: Color(0xFFD7B56D), fontSize: 13, fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 12),
          RequestLine(label: 'Mode', value: request.mode),
          RequestLine(label: 'Weakness', value: request.weakness),
          RequestLine(label: 'Goal', value: request.goal),
          RequestLine(label: 'Session', value: request.sessionLength),
          RequestLine(label: 'Urgency', value: request.urgency),
          RequestLine(label: 'Patch-aware', value: request.patchAware ? 'Enabled' : 'Disabled'),
          RequestLine(label: 'Loadout review', value: request.includeLoadoutReview ? 'Included' : 'Off'),
          RequestLine(label: 'VOD review', value: request.includeVodReview ? 'Included' : 'Off'),
          if (request.notes.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            const Text('Member notes', style: TextStyle(color: Color(0xFFD7B56D), fontSize: 12, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(request.notes.trim(), style: const TextStyle(color: Color(0xFF93A0AF), fontSize: 13, height: 1.5)),
          ],
        ],
      ),
    );
  }
}
                    Text('Turn live intel into a real coaching request.',
                      style: TextStyle(color: Colors.white, fontSize: 24,
                        fontWeight: FontWeight.w800, height: 1.2)),
                    SizedBox(height: 10),
                    Text(
                      'Warzone Intel is already tracking recurring patch notes, summaries, and weapon changes, so this form helps the player ask for coaching that matches the live meta.',
                      style: TextStyle(color: Color(0xFF93A0AF), fontSize: 13, height: 1.55),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (latestRequest != null) ...[
