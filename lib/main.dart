import 'package:flutter/material.dart';
import 'app.dart';
import 'data/models/intel_item.dart';
import 'data/models/patch_intel_item.dart';
import 'data/models/plan_task.dart';
import 'data/models/coaching_request.dart';
import 'data/app_data.dart';

void main() {
  runApp(const CodCampApp());
}

class AppData {
  static const List<IntelItem> intelItems = [
    IntelItem(
      id: 'tip_001',
      source: 'Ghost Intel',
      title: 'Meta Tip of the Day: Master Footstep Audio',
      body:
          'Average players miss kills because they do not react to enemy footsteps. Turn on directional audio in settings and practice identifying where shots are coming from. This single skill can cut reaction time dramatically and help you pre-aim before the enemy fully appears.',
      shortBody:
          'Directional audio can improve reaction speed before you even see the enemy.',
      dayLabel: '11 May',
      timeLabel: '11:10',
      category: 'Audio',
      footer: 'Audio awareness can rank you up faster than aim alone',
      icon: Icons.surround_sound_rounded,
      accent: Color(0xFFD7B56D),
      reactions: ['❤️', '👍', '👎'],
    ),
    IntelItem(
      id: 'tip_002',
      source: 'Ghost Intel',
      title: 'Meta Tip of the Day: Audio Cues Are Your Radar',
      body:
          'Sound is one of the most underrated tools for average players. Focus on footsteps, listen for directional audio to pre-aim corners, and boost game audio volume if needed. Audio awareness alone can help rank you up faster than raw mechanical aim.',
      shortBody:
          'Use directional audio to pre-aim corners and improve fight prep.',
      dayLabel: '16 May',
      timeLabel: '20:21',
      category: 'Audio',
      footer: 'Treat sound like radar, not background noise',
      icon: Icons.radar_rounded,
      accent: Color(0xFFD7B56D),
      reactions: ['❤️', '👍', '👎'],
    ),
    IntelItem(
      id: 'tip_003',
      source: 'Ghost Intel',
      title: 'Meta Tip of the Day: Audio Positioning',
      body:
          'Turn your headphones up and listen for footsteps first for enemy direction, gunfire pitch for distance, and reload sounds for vulnerable opponents. Learning to pre-aim based on audio alone beats eyes-first plays and gives you cleaner challenges.',
      shortBody:
          'Footsteps, gunfire pitch, and reload sounds should shape your pre-aim.',
      dayLabel: '17 May',
      timeLabel: '16:05',
      category: 'Audio',
      footer: 'Hear the fight before you see it',
      icon: Icons.hearing_rounded,
      accent: Color(0xFFD7B56D),
      reactions: ['❤️', '👍', '👎'],
    ),
    IntelItem(
      id: 'tip_004',
      source: 'Ghost Intel',
      title: 'Meta Tip of the Day: High Ground Wins Gunfights',
      body:
          'Elevation advantage is crucial in CoD. Position yourself higher than your opponent on stairs, windows, roofs, or raised ground whenever possible. Higher positions give better sightlines and make you harder to hit, so learn the high-ground routes on every map.',
      shortBody:
          'Prioritise height to improve sightlines and take cleaner fights.',
      dayLabel: '17 May',
      timeLabel: '16:29',
      category: 'Positioning',
      footer: 'Height often creates easier first shots',
      icon: Icons.terrain_rounded,
      accent: Color(0xFF93A0AF),
      reactions: ['❤️', '👍', '👎'],
    ),
    IntelItem(
      id: 'tip_005',
      source: 'OpenClaw-CoachingBot',
      title: 'Meta Tip of the Day: Start with MXR-17',
      body:
          'If you are grinding ranked, the MXR-17 is your foundation gun. It is a strong AR with near-zero recoil, works well at mid-to-long range, and gives you more time to adjust aim. That means one less thing to worry about so you can focus on positioning.',
      shortBody:
          'MXR-17 is a steady foundation weapon for ranked players.',
      dayLabel: '18 May',
      timeLabel: '18:08',
      category: 'Weapon',
      footer: 'Master one stable gun first, then experiment later',
      icon: Icons.track_changes_rounded,
      accent: Color(0xFF93A0AF),
      reactions: ['❤️', '👍', '👎'],
    ),
    IntelItem(
      id: 'tip_006',
      source: 'OpenClaw-CoachingBot',
      title: 'Meta Tip of the Day: Audio Wins Fights',
      body:
          'Footsteps, reloads, and glass breaks are half the battle. Play with headphones turned up in Resurgence and you will hear rotations, pushes, and revives coming before they reach you. That gives you an edge pure aim cannot buy.',
      shortBody:
          'Audio gives you earlier reads on rotations, pushes, and revives.',
      dayLabel: 'Today',
      timeLabel: '15:50',
      category: 'Audio',
      footer: 'Headphones + awareness = earlier decisions',
      icon: Icons.graphic_eq_rounded,
      accent: Color(0xFFD7B56D),
      reactions: ['❤️', '👍', '👎'],
    ),
    IntelItem(
      id: 'tip_007',
      source: 'OpenClaw-CoachingBot',
      title: 'Meta Tip of the Day: Start with MXR-17',
      body:
          'If you are grinding ranked, the MXR-17 is your foundation gun. S-tier AR with near-zero recoil, works mid-to-long range, and gives you time to adjust aim. One less thing to worry about, so you can focus on positioning instead.',
      shortBody:
          'MXR-17 remains the easiest stable ranked recommendation in the feed.',
      dayLabel: 'Today',
      timeLabel: '17:05',
      category: 'Weapon',
      footer: 'Low recoil lets you focus on smarter fights',
      icon: Icons.gps_fixed_rounded,
      accent: Color(0xFF93A0AF),
      reactions: ['❤️', '👍', '👎'],
    ),
    IntelItem(
      id: 'tip_008',
      source: 'OpenClaw-CoachingBot',
      title: 'Meta Tip of the Day: Start with MXR-17',
      body:
          'If you are grinding ranked, the MXR-17 is your foundation gun. S-tier AR with near-zero recoil, works mid-to-long range, and gives you time to adjust aim. One less thing to worry about, so you can focus on positioning instead.',
      shortBody:
          'Live duplicate retained so the app still reflects the current channel state.',
      dayLabel: 'Today',
      timeLabel: '17:22',
      category: 'Weapon',
      footer: 'Duplicate currently visible in the live Discord feed',
      icon: Icons.copy_all_rounded,
      accent: Color(0xFFD7B56D),
      reactions: ['❤️', '👍', '👎'],
      isDuplicate: true,
    ),
  ];

  static const List<PatchIntelItem> patchItems = [
    PatchIntelItem(
      id: 'patch_001',
      issueCode: 'COD-303',
      title: 'BO7 & Warzone Season 03 Reloaded – Patch Summary (Apr 30 2026)',
      subtitle: 'Large reloaded update summary',
      body:
          'BO7 & Warzone Season 03 Reloaded patch summary posted to Discord patch notes. The visible issue detail references weapon buffs in Warzone, including assault rifle adjustments such as DS20 MIRAGE receiving more damage at mid range, and positions this entry as a broad summary card for the reloaded update.',
      type: 'Summary',
      dateLabel: 'Apr 30 2026',
      impact: 'High',
      status: 'done',
      timeAgo: '4h ago',
      icon: Icons.summarize_rounded,
      accent: Color(0xFFD7B56D),
      bullets: [
        'Season Reloaded changes were important enough to receive a standalone summary.',
        'This is the broad-view patch card players should scan before changing loadouts.',
        'Visible detail text mentions weapon buffs in Warzone and mid-range AR changes.',
      ],
      tags: ['Season 03', 'Reloaded', 'Patch Notes', 'Warzone'],
    ),
    PatchIntelItem(
      id: 'patch_002',
      issueCode: 'COD-299',
      title: 'Season 03 Reloaded: Weapon Balance & New Hot Pursuit Mode',
      subtitle: 'Weapons plus playlist impact',
      body:
          'This issue is framed around weapon balance and the addition of Hot Pursuit mode, making it one of the clearest examples of a patch item that affects both loadout selection and player decision-making in live playlists.',
      type: 'Weapons',
      dateLabel: 'May 2026',
      impact: 'High',
      status: 'done',
      timeAgo: 'recent',
      icon: Icons.track_changes_rounded,
      accent: Color(0xFF93A0AF),
      bullets: [
        'Weapon balance was important enough to be broken out on its own.',
        'Hot Pursuit mode was also tracked as a notable change.',
        'This kind of update should drive weekly loadout recommendations.',
      ],
      tags: ['Weapon Balance', 'Mode Update', 'Hot Pursuit'],
    ),
    PatchIntelItem(
      id: 'patch_003',
      issueCode: 'COD-301',
      title: 'Monitor Call of Duty Patch Notes',
      subtitle: 'Ongoing tracking task',
      body:
          'This issue shows that Warzone Intel is not a one-post system. Patch monitoring is recurring and active, which means the app should treat patch awareness as an ongoing habit rather than a one-time read.',
      type: 'Monitor',
      dateLabel: 'Recent',
      impact: 'Medium',
      status: 'done',
      timeAgo: 'recent',
      icon: Icons.monitor_rounded,
      accent: Color(0xFFD7B56D),
      bullets: [
        'Patch monitoring is recurring, not one-off.',
        'Intel should update continuously in the product.',
        'The weekly plan should feel like a living checklist.',
      ],
      tags: ['Monitoring', 'Recurring', 'Ops'],
    ),
    PatchIntelItem(
      id: 'patch_004',
      issueCode: 'COD-298',
      title: 'Monitor Call of Duty Patch Notes',
      subtitle: 'Repeated patch surveillance',
      body:
          'A second monitoring issue reinforces the cadence: patch surveillance is part of the product loop, not just background admin. This supports ranked reminders and frequent plan refreshes.',
      type: 'Monitor',
      dateLabel: 'Recent',
      impact: 'Medium',
      status: 'done',
      timeAgo: 'recent',
      icon: Icons.radar_rounded,
      accent: Color(0xFF93A0AF),
      bullets: [
        'Repeated monitoring confirms a persistent patch workflow.',
        'This supports ranked reminders and frequent plan updates.',
        'The plan screen should stay tied to patch cadence.',
      ],
      tags: ['Monitoring', 'Workflow', 'Recurring'],
    ),
    PatchIntelItem(
      id: 'patch_005',
      issueCode: 'COD-294',
      title: 'Monitor Call of Duty Patch Notes',
      subtitle: 'Live issue stream monitoring',
      body:
          'Another monitoring issue in the recent list shows how often the patch pipeline is running. In product terms, this justifies alerts, recent updates, and a more dynamic intelligence feed.',
      type: 'Monitor',
      dateLabel: 'Recent',
      impact: 'Medium',
      status: 'done',
      timeAgo: 'recent',
      icon: Icons.notifications_active_rounded,
      accent: Color(0xFFD7B56D),
      bullets: [
        'The monitoring cadence is frequent.',
        'This supports a rolling “latest patch signals” view.',
        'Useful for notifications and freshness indicators.',
      ],
      tags: ['Recent', 'Monitoring', 'Freshness'],
    ),
    PatchIntelItem(
      id: 'patch_006',
      issueCode: 'COD-290',
      title: 'Monitor Call of Duty Patch Notes',
      subtitle: 'Earlier patch intelligence checkpoint',
      body:
          'This issue continues the same recurring pattern and helps the app justify a history-style archive of patch checks instead of only showing the newest items.',
      type: 'Monitor',
      dateLabel: 'Recent',
      impact: 'Low',
      status: 'done',
      timeAgo: 'recent',
      icon: Icons.history_rounded,
      accent: Color(0xFF93A0AF),
      bullets: [
        'Supports a deeper patch archive view.',
        'Shows continuity in the monitoring pipeline.',
        'Useful for timeline-based tracking later.',
      ],
      tags: ['Archive', 'History', 'Monitoring'],
    ),
    PatchIntelItem(
      id: 'patch_007',
      issueCode: 'COD-293',
      title: 'BO7 & Warzone Season 03 Reloaded Patch Summary — April 30, 2026',
      subtitle: 'Alternate patch summary issue',
      body:
          'A second summary entry reinforces that Season 03 Reloaded was a major update cluster. The app should treat season-level summaries as hero items and not bury them below smaller monitoring entries.',
      type: 'Summary',
      dateLabel: 'Apr 30 2026',
      impact: 'High',
      status: 'done',
      timeAgo: 'recent',
      icon: Icons.article_rounded,
      accent: Color(0xFFD7B56D),
      bullets: [
        'A second summary issue reinforces Reloaded as a major focus.',
        'Season-level summary cards deserve hero placement.',
        'This helps shape weekly plan focus.',
      ],
      tags: ['Season 03', 'Reloaded', 'Summary'],
    ),
    PatchIntelItem(
      id: 'patch_008',
      issueCode: 'COD-288',
      title: 'Monitor Call of Duty Patch Notes',
      subtitle: 'Mid-cycle patch tracking',
      body:
          'This is another monitoring-style entry in the live issue stream. It suggests the app should support repeated update checking without making the user read the same content twice.',
      type: 'Monitor',
      dateLabel: 'Recent',
      impact: 'Low',
      status: 'done',
      timeAgo: 'recent',
      icon: Icons.update_rounded,
      accent: Color(0xFF93A0AF),
      bullets: [
        'Mid-cycle tracking supports update confidence.',
        'Repeated checks justify de-duplication and better summarisation.',
        'Useful for “what actually changed” views.',
      ],
      tags: ['Update', 'Mid-cycle', 'Monitor'],
    ),
    PatchIntelItem(
      id: 'patch_009',
      issueCode: 'COD-282',
      title: 'Monitor Call of Duty Patch Notes',
      subtitle: 'Earlier recurring monitor task',
      body:
          'This earlier monitor issue confirms the pattern across multiple runs and dates. It supports building a product that expects recurring patch changes instead of treating them as rare events.',
      type: 'Monitor',
      dateLabel: 'Recent',
      impact: 'Low',
      status: 'done',
      timeAgo: 'recent',
      icon: Icons.timeline_rounded,
      accent: Color(0xFFD7B56D),
      bullets: [
        'Confirms repeated issue generation across time.',
        'Supports timeline features and trend summaries.',
        'Good basis for future historical comparisons.',
      ],
      tags: ['Timeline', 'Recurring', 'Patch Ops'],
    ),
    PatchIntelItem(
      id: 'patch_010',
      issueCode: 'COD-287',
      title: 'Season 3 Reloaded Patch Summary - May 2026',
      subtitle: 'Recent reloaded recap',
      body:
          'This recap-style issue is ideal for ranked-facing interpretation. Instead of just repeating notes, it should tell players what the reloaded changes mean for their actual sessions and habits.',
      type: 'Ranked',
      dateLabel: 'May 2026',
      impact: 'Medium',
      status: 'done',
      timeAgo: 'recent',
      icon: Icons.emoji_events_rounded,
      accent: Color(0xFF93A0AF),
      bullets: [
        'A ranked-facing recap matters because players want action, not just notes.',
        'Ideal for “what changed for ranked” summaries.',
        'Should influence weekly mistakes-to-avoid prompts.',
      ],
      tags: ['Ranked', 'Reloaded', 'Summary'],
    ),
  ];

  static const List<PlanTask> weeklyTasks = [
    PlanTask(
      id: 'task_001',
      title: 'Audio-first fights',
      subtitle: 'Spend one session challenging only after clear sound cues.',
      icon: Icons.hearing_rounded,
      accent: Color(0xFFD7B56D),
    ),
    PlanTask(
      id: 'task_002',
      title: 'Run MXR-17 only',
      subtitle: 'Keep the gun choice simple and stable for ranked reps.',
      icon: Icons.gps_fixed_rounded,
      accent: Color(0xFF93A0AF),
    ),
    PlanTask(
      id: 'task_003',
      title: 'High-ground review',
      subtitle: 'Take height before peeking in at least five fights.',
      icon: Icons.terrain_rounded,
      accent: Color(0xFFD7B56D),
    ),
    PlanTask(
      id: 'task_004',
      title: 'Patch recap check',
      subtitle: 'Read one patch summary before your next ranked session.',
      icon: Icons.newspaper_rounded,
      accent: Color(0xFF93A0AF),
    ),
    PlanTask(
      id: 'task_005',
      title: 'Avoid ego challs',
      subtitle: 'Back out of weak angles instead of forcing bad trades.',
      icon: Icons.shield_outlined,
      accent: Color(0xFFD7B56D),
    ),
  ];
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  final Set<String> savedTipIds = {};
  final Map<String, String?> selectedReactions = {};
  final Set<String> savedPatchIds = {};
  final Set<String> completedPlanTaskIds = {};
  bool hideDuplicates = false;
  String patchFilter = 'All';
  CoachingRequest? latestRequest;

  IntelItem? findItemById(String id) {
    try {
      return AppData.intelItems.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  PatchIntelItem? findPatchById(String id) {
    try {
      return AppData.patchItems.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  void toggleSaved(String id) {
    setState(() {
      if (savedTipIds.contains(id)) {
        savedTipIds.remove(id);
      } else {
        savedTipIds.add(id);
      }
    });
  }

  void setReaction(String id, String? reaction) {
    setState(() {
      if (reaction == null) {
        selectedReactions.remove(id);
      } else {
        selectedReactions[id] = reaction;
      }
    });
  }

  void toggleHideDuplicates(bool value) {
    setState(() {
      hideDuplicates = value;
    });
  }

  void toggleSavedPatch(String id) {
    setState(() {
      if (savedPatchIds.contains(id)) {
        savedPatchIds.remove(id);
      } else {
        savedPatchIds.add(id);
      }
    });
  }

  void setPatchFilter(String value) {
    setState(() {
      patchFilter = value;
    });
  }

  void togglePlanTask(String id) {
    setState(() {
      if (completedPlanTaskIds.contains(id)) {
        completedPlanTaskIds.remove(id);
      } else {
        completedPlanTaskIds.add(id);
      }
    });
  }

  void saveCoachingRequest(CoachingRequest request) {
    setState(() {
      latestRequest = request;
      _currentIndex = 5;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(
        hideDuplicates: hideDuplicates,
        savedTipCount: savedTipIds.length,
        savedPatchCount: savedPatchIds.length,
        completedTaskCount: completedPlanTaskIds.length,
        hasRequest: latestRequest != null,
      ),
      CoachingRequestScreen(
        latestRequest: latestRequest,
        onSubmitRequest: saveCoachingRequest,
      ),
      TipsFeedScreen(
        savedTipIds: savedTipIds,
        selectedReactions: selectedReactions,
        hideDuplicates: hideDuplicates,
        onToggleSaved: toggleSaved,
        onSetReaction: setReaction,
        onToggleHideDuplicates: toggleHideDuplicates,
      ),
      PatchIntelScreen(
        savedPatchIds: savedPatchIds,
        patchFilter: patchFilter,
        onToggleSavedPatch: toggleSavedPatch,
        onSetFilter: setPatchFilter,
      ),
      WeeklyPlanScreen(
        completedTaskIds: completedPlanTaskIds,
        savedPatchIds: savedPatchIds,
        onToggleTask: togglePlanTask,
      ),
      ProfileScreen(
        savedTipIds: savedTipIds,
        savedPatchIds: savedPatchIds,
        completedPlanTaskIds: completedPlanTaskIds,
        latestRequest: latestRequest,
        findItemById: findItemById,
        findPatchById: findPatchById,
        onToggleSaved: toggleSaved,
        onToggleSavedPatch: toggleSavedPatch,
        hideDuplicates: hideDuplicates,
        onToggleHideDuplicates: toggleHideDuplicates,
        selectedReactions: selectedReactions,
      ),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF091018),
        selectedItemColor: const Color(0xFFD7B56D),
        unselectedItemColor: const Color(0xFF687483),
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.send_rounded),
            label: 'Request',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline_rounded),
            label: 'Tips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper_rounded),
            label: 'Patch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note_rounded),
            label: 'Plan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final bool hideDuplicates;
  final int savedTipCount;
  final int savedPatchCount;
  final int completedTaskCount;
  final bool hasRequest;

  const HomeScreen({
    super.key,
    required this.hideDuplicates,
    required this.savedTipCount,
    required this.savedPatchCount,
    required this.completedTaskCount,
    required this.hasRequest,
  });

  @override
  Widget build(BuildContext context) {
    final totalTips = AppData.intelItems.length;
    final totalDuplicates =
        AppData.intelItems.where((e) => e.isDuplicate).length;
    final totalPatchItems = AppData.patchItems.length;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppTopBar(
                title: 'CoD Camp',
                subtitle: 'Ghost_Protocol app shell',
                icon: Icons.sports_esports_rounded,
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
                    colors: [
                      Color(0xFF151D27),
                      Color(0xFF0E141C),
                      Color(0xFF0A0F15),
                    ],
                  ),
                  border: Border.all(color: const Color(0x22D7B56D)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'LIVE APP DIRECTION',
                      style: TextStyle(
                        color: Color(0xFFD7B56D),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Tips, coaching, patch intelligence, and weekly plans.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      hasRequest
                          ? 'Your latest coaching request is now saved in the member profile and ready for follow-up.'
                          : 'The next premium action is a structured coaching request that uses the same patch-aware intelligence flow.',
                      style: const TextStyle(
                        color: Color(0xFF93A0AF),
                        fontSize: 13,
                        height: 1.55,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const SectionTitle(title: 'Overview'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      label: 'Tips',
                      value: '$totalTips',
                      icon: Icons.lightbulb_outline_rounded,
                      color: const Color(0xFFD7B56D),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      label: 'Patch Intel',
                      value: '$totalPatchItems',
                      icon: Icons.newspaper_rounded,
                      color: const Color(0xFF93A0AF),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      label: 'Saved Tips',
                      value: '$savedTipCount',
                      icon: Icons.bookmark_rounded,
                      color: const Color(0xFFD7B56D),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      label: 'Saved Patch',
                      value: '$savedPatchCount',
                      icon: Icons.inventory_2_rounded,
                      color: const Color(0xFF93A0AF),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      label: 'Plan Done',
                      value: '$completedTaskCount',
                      icon: Icons.check_circle_outline_rounded,
                      color: const Color(0xFFD7B56D),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      label: 'Request',
                      value: hasRequest ? 'Live' : 'None',
                      icon: Icons.send_rounded,
                      color: const Color(0xFF93A0AF),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      label: 'Duplicates',
                      value: '$totalDuplicates',
                      icon: Icons.copy_all_rounded,
                      color: const Color(0xFFD7B56D),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      label: 'De-dupe',
                      value: hideDuplicates ? 'On' : 'Off',
                      icon: Icons.tune_rounded,
                      color: const Color(0xFF93A0AF),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CoachingRequestScreen extends StatefulWidget {
  final CoachingRequest? latestRequest;
  final ValueChanged<CoachingRequest> onSubmitRequest;

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
    'Ranked Resurgence',
    'Warzone BR',
    'Multiplayer Ranked',
    'Public Match Practice',
  ];

  final List<String> weaknesses = const [
    'Positioning',
    'Audio awareness',
    'Aim consistency',
    'Decision making',
    'Rotations',
    'Loadout choice',
  ];

  final List<String> goals = const [
    'Win more ranked fights',
    'Improve KD',
    'Climb rank faster',
    'Stop losing late game',
    'Learn patch-aware loadouts',
  ];

  final List<String> sessions = const [
    '30 min',
    '60 min',
    '90 min',
    '120 min',
  ];

  final List<String> urgencies = const [
    'Tonight',
    'This week',
    'Next session',
    'No rush',
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
        title: const Text(
          'Request submitted',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Your coaching request has been saved to your member profile.',
          style: TextStyle(color: Color(0xFF93A0AF), height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Done',
              style: TextStyle(color: Color(0xFFD7B56D)),
            ),
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
                    colors: [
                      Color(0xFF151D27),
                      Color(0xFF0E141C),
                      Color(0xFF0A0F15),
                    ],
                  ),
                  border: Border.all(color: const Color(0x22D7B56D)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MEMBER REQUEST',
                      style: TextStyle(
                        color: Color(0xFFD7B56D),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Turn live intel into a real coaching request.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Warzone Intel is already tracking recurring patch notes, summaries, and weapon changes, so this form helps the player ask for coaching that matches the live meta.',
                      style: TextStyle(
                        color: Color(0xFF93A0AF),
                        fontSize: 13,
                        height: 1.55,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (latestRequest != null) ...[
                const SectionTitle(title: 'Latest Request'),
                const SizedBox(height: 12),
                CoachingSummaryCard(request: latestRequest),
                const SizedBox(height: 20),
              ],
              const SectionTitle(title: 'Session Setup'),
              const SizedBox(height: 12),
              SelectionCard(
                title: 'Mode',
                value: selectedMode,
                icon: Icons.sports_esports_rounded,
                accent: const Color(0xFFD7B56D),
                onTap: () async {
                  final value = await _showPicker(context, 'Select mode', modes);
                  if (value != null) {
                    setState(() {
                      selectedMode = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              SelectionCard(
                title: 'Main weakness',
                value: selectedWeakness,
                icon: Icons.warning_amber_rounded,
                accent: const Color(0xFF93A0AF),
                onTap: () async {
                  final value = await _showPicker(
                    context,
                    'Select weakness',
                    weaknesses,
                  );
                  if (value != null) {
                    setState(() {
                      selectedWeakness = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              SelectionCard(
                title: 'Goal',
                value: selectedGoal,
                icon: Icons.flag_rounded,
                accent: const Color(0xFFD7B56D),
                onTap: () async {
                  final value = await _showPicker(context, 'Select goal', goals);
                  if (value != null) {
                    setState(() {
                      selectedGoal = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: SelectionCard(
                      title: 'Session',
                      value: selectedSession,
                      icon: Icons.timer_outlined,
                      accent: const Color(0xFF93A0AF),
                      onTap: () async {
                        final value = await _showPicker(
                          context,
                          'Session length',
                          sessions,
                        );
                        if (value != null) {
                          setState(() {
                            selectedSession = value;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SelectionCard(
                      title: 'Urgency',
                      value: selectedUrgency,
                      icon: Icons.bolt_rounded,
                      accent: const Color(0xFFD7B56D),
                      onTap: () async {
                        final value = await _showPicker(
                          context,
                          'Select urgency',
                          urgencies,
                        );
                        if (value != null) {
                          setState(() {
                            selectedUrgency = value;
                          });
                        }
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
                subtitle:
                    'Use live patch summaries and weapon changes in the session.',
                value: patchAware,
                icon: Icons.newspaper_rounded,
                accent: const Color(0xFFD7B56D),
                onChanged: (value) {
                  setState(() {
                    patchAware = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              SettingsSwitchTile(
                title: 'Include loadout review',
                subtitle: 'Add weapon and attachment recommendations.',
                value: includeLoadoutReview,
                icon: Icons.track_changes_rounded,
                accent: const Color(0xFF93A0AF),
                onChanged: (value) {
                  setState(() {
                    includeLoadoutReview = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              SettingsSwitchTile(
                title: 'Include VOD review',
                subtitle: 'Prepare the request for gameplay breakdown support.',
                value: includeVodReview,
                icon: Icons.ondemand_video_rounded,
                accent: const Color(0xFFD7B56D),
                onChanged: (value) {
                  setState(() {
                    includeVodReview = value;
                  });
                },
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
                    hintText:
                        'Example: I keep losing rooftop fights and I want a simple ranked setup for this week.',
                    hintStyle: TextStyle(color: Color(0xFF7D8997)),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const SectionTitle(title: 'Request Preview'),
              const SizedBox(height: 12),
              CoachingPreviewCard(
                mode: selectedMode,
                weakness: selectedWeakness,
                goal: selectedGoal,
                sessionLength: selectedSession,
                urgency: selectedUrgency,
                patchAware: patchAware,
                includeLoadoutReview: includeLoadoutReview,
                includeVodReview: includeVodReview,
                notes: notesController.text,
              ),
              const SizedBox(height: 18),
              ElevatedButton.icon(
                onPressed: submitRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD7B56D),
                  foregroundColor: const Color(0xFF0A0D11),
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                icon: const Icon(Icons.send_rounded),
                label: const Text(
                  'Submit coaching request',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> _showPicker(
    BuildContext context,
    String title,
    List<String> options,
  ) async {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: const Color(0xFF10161E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 14),
                ...options.map(
                  (option) => ListTile(
                    title: Text(
                      option,
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFFD7B56D),
                    ),
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

class TipsFeedScreen extends StatelessWidget {
  final Set<String> savedTipIds;
  final Map<String, String?> selectedReactions;
  final bool hideDuplicates;
  final void Function(String id) onToggleSaved;
  final void Function(String id, String? reaction) onSetReaction;
  final void Function(bool value) onToggleHideDuplicates;

  const TipsFeedScreen({
    super.key,
    required this.savedTipIds,
    required this.selectedReactions,
    required this.hideDuplicates,
    required this.onToggleSaved,
    required this.onSetReaction,
    required this.onToggleHideDuplicates,
  });

  List<IntelItem> _visibleItems() {
    if (!hideDuplicates) return AppData.intelItems;
    return AppData.intelItems.where((item) => !item.isDuplicate).toList();
  }

  void _openTipDetail(
    BuildContext context,
    IntelItem item,
    List<IntelItem> visibleItems,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TipDetailScreen(
          item: item,
          visibleItems: visibleItems,
          isSaved: savedTipIds.contains(item.id),
          selectedReaction: selectedReactions[item.id],
          onToggleSaved: () => onToggleSaved(item.id),
          onSetReaction: (reaction) => onSetReaction(item.id, reaction),
          onOpenTip: (nextItem) => _openTipDetail(context, nextItem, visibleItems),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleItems = _visibleItems();
    final todayItems = visibleItems.where((e) => e.dayLabel == 'Today').toList();
    final archiveItems =
        visibleItems.where((e) => e.dayLabel != 'Today').toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppTopBar(
                title: 'Top Tier Tips',
                subtitle: '#top-tier-tips inspired feed',
                icon: Icons.lightbulb_outline_rounded,
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
                    colors: [
                      Color(0xFF151D27),
                      Color(0xFF0E141C),
                      Color(0xFF0A0F15),
                    ],
                  ),
                  border: Border.all(color: const Color(0x22D7B56D)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '# TOP-TIER-TIPS',
                      style: TextStyle(
                        color: Color(0xFFD7B56D),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Daily meta tips, weapon breakdowns, and strategy drops.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                        height: 1.25,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'This feed stays short and useful, but now every card can open into a proper detail view.',
                      style: TextStyle(
                        color: Color(0xFF93A0AF),
                        fontSize: 13,
                        height: 1.55,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      label: 'Visible Tips',
                      value: '${visibleItems.length}',
                      icon: Icons.article_rounded,
                      color: const Color(0xFFD7B56D),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      label: 'Saved',
                      value: '${savedTipIds.length}',
                      icon: Icons.bookmark_rounded,
                      color: const Color(0xFF93A0AF),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F141B),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0x14FFFFFF)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0x14D7B56D),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.filter_alt_rounded,
                        color: Color(0xFFD7B56D),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hide duplicate tips',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Useful while repeated MXR-17 posts are still live.',
                            style: TextStyle(
                              color: Color(0xFF93A0AF),
                              fontSize: 12,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: hideDuplicates,
                      onChanged: onToggleHideDuplicates,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const FeedSectionLabel(title: 'Today'),
              const SizedBox(height: 12),
              if (todayItems.isEmpty)
                const EmptyStateCard(
                  title: 'No tips visible for today',
                  subtitle: 'Either there are no new drops or duplicates are hidden.',
                ),
              ...todayItems.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: PremiumTipFeedCard(
                    item: item,
                    isSaved: savedTipIds.contains(item.id),
                    selectedReaction: selectedReactions[item.id],
                    onToggleSaved: () => onToggleSaved(item.id),
                    onSetReaction: (reaction) => onSetReaction(item.id, reaction),
                    onTap: () => _openTipDetail(context, item, visibleItems),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const FeedSectionLabel(title: 'Archive'),
              const SizedBox(height: 12),
              ...archiveItems.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: PremiumTipFeedCard(
                    item: item,
                    isSaved: savedTipIds.contains(item.id),
                    selectedReaction: selectedReactions[item.id],
                    onToggleSaved: () => onToggleSaved(item.id),
                    onSetReaction: (reaction) => onSetReaction(item.id, reaction),
                    onTap: () => _openTipDetail(context, item, visibleItems),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PatchIntelScreen extends StatelessWidget {
  final Set<String> savedPatchIds;
  final String patchFilter;
  final void Function(String id) onToggleSavedPatch;
  final void Function(String value) onSetFilter;

  const PatchIntelScreen({
    super.key,
    required this.savedPatchIds,
    required this.patchFilter,
    required this.onToggleSavedPatch,
    required this.onSetFilter,
  });

  List<PatchIntelItem> _filteredItems() {
    if (patchFilter == 'All') return AppData.patchItems;
    return AppData.patchItems.where((item) => item.type == patchFilter).toList();
  }

  void _openPatchDetail(BuildContext context, PatchIntelItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PatchDetailScreen(
          item: item,
          relatedItems: AppData.patchItems
              .where((e) => e.id != item.id && e.type == item.type)
              .take(3)
              .toList(),
          isSaved: savedPatchIds.contains(item.id),
          onToggleSaved: () => onToggleSavedPatch(item.id),
          onOpenPatch: (nextItem) => _openPatchDetail(context, nextItem),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleItems = _filteredItems();
    final heroItem = visibleItems.isNotEmpty ? visibleItems.first : null;
    const filters = ['All', 'Summary', 'Weapons', 'Monitor', 'Ranked'];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppTopBar(
                title: 'Patch Intel',
                subtitle: 'Warzone Intel • Patch & Meta Intelligence',
                icon: Icons.newspaper_rounded,
              ),
              const SizedBox(height: 18),
              if (heroItem != null)
                GestureDetector(
                  onTap: () => _openPatchDetail(context, heroItem),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF151D27),
                          Color(0xFF0E141C),
                          Color(0xFF0A0F15),
                        ],
                      ),
                      border: Border.all(color: const Color(0x22D7B56D)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          heroItem.issueCode,
                          style: const TextStyle(
                            color: Color(0xFFD7B56D),
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          heroItem.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                            fontWeight: FontWeight.w800,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          heroItem.subtitle,
                          style: const TextStyle(
                            color: Color(0xFF93A0AF),
                            fontSize: 13,
                            height: 1.55,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            MetaPill(
                              label: heroItem.type.toUpperCase(),
                              color: heroItem.accent,
                            ),
                            const MetaPill(
                              label: 'PATCH INTEL',
                              color: Color(0xFFD7B56D),
                            ),
                            MetaPill(
                              label: 'IMPACT ${heroItem.impact.toUpperCase()}',
                              color: heroItem.accent,
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        const Row(
                          children: [
                            Icon(
                              Icons.open_in_new_rounded,
                              color: Color(0xFFD7B56D),
                              size: 16,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Open detail view',
                              style: TextStyle(
                                color: Color(0xFFD7B56D),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      label: 'Entries',
                      value: '${visibleItems.length}',
                      icon: Icons.article_rounded,
                      color: const Color(0xFFD7B56D),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      label: 'Saved',
                      value: '${savedPatchIds.length}',
                      icon: Icons.bookmark_rounded,
                      color: const Color(0xFF93A0AF),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: filters.map((filter) {
                    final selected = patchFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => onSetFilter(filter),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0x14D7B56D)
                                : const Color(0x10FFFFFF),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: selected
                                  ? const Color(0x33D7B56D)
                                  : const Color(0x18FFFFFF),
                            ),
                          ),
                          child: Text(
                            filter,
                            style: TextStyle(
                              color: selected
                                  ? const Color(0xFFD7B56D)
                                  : Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 22),
              const FeedSectionLabel(title: 'Latest Intel'),
              const SizedBox(height: 12),
              if (visibleItems.isEmpty)
                const EmptyStateCard(
                  title: 'No patch entries for this filter',
                  subtitle: 'Try another filter to see more patch intelligence.',
                ),
              ...visibleItems.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: PatchIntelCard(
                    item: item,
                    isSaved: savedPatchIds.contains(item.id),
                    onToggleSaved: () => onToggleSavedPatch(item.id),
                    onTap: () => _openPatchDetail(context, item),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeeklyPlanScreen extends StatelessWidget {
  final Set<String> completedTaskIds;
  final Set<String> savedPatchIds;
  final void Function(String id) onToggleTask;

  const WeeklyPlanScreen({
    super.key,
    required this.completedTaskIds,
    required this.savedPatchIds,
    required this.onToggleTask,
  });

  @override
  Widget build(BuildContext context) {
    final totalTasks = AppData.weeklyTasks.length;
    final doneTasks = completedTaskIds.length;
    final progress = totalTasks == 0 ? 0.0 : doneTasks / totalTasks;
    final hasSavedPatchIntel = savedPatchIds.isNotEmpty;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppTopBar(
                title: 'Weekly Plan',
                subtitle: 'Patch-aware coaching routine',
                icon: Icons.event_note_rounded,
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
                    colors: [
                      Color(0xFF151D27),
                      Color(0xFF0E141C),
                      Color(0xFF0A0F15),
                    ],
                  ),
                  border: Border.all(color: const Color(0x22D7B56D)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'THIS WEEK',
                      style: TextStyle(
                        color: Color(0xFFD7B56D),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Play simpler, cleaner, and more patch-aware.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'This plan is built from the same Warzone Intel workflow that is repeatedly tracking patch notes, season reload summaries, weapon balance, and ranked-impact updates.',
                      style: TextStyle(
                        color: Color(0xFF93A0AF),
                        fontSize: 13,
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 18),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 10,
                        backgroundColor: const Color(0x14FFFFFF),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFFD7B56D),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$doneTasks of $totalTasks tasks completed',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      label: 'Plan Tasks',
                      value: '$totalTasks',
                      icon: Icons.checklist_rounded,
                      color: const Color(0xFFD7B56D),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      label: 'Saved Patch Intel',
                      value: '${savedPatchIds.length}',
                      icon: Icons.bookmark_rounded,
                      color: const Color(0xFF93A0AF),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const SectionTitle(title: 'Loadout Focus'),
              const SizedBox(height: 12),
              const FocusCard(
                title: 'MXR-17 this week',
                subtitle:
                    'The live tips feed repeatedly pushes MXR-17 as the foundation gun, while patch intelligence keeps weapon balance as an active tracked theme. Keep the build stable and use your reps to improve positioning, not chase random gun swaps.',
                accent: Color(0xFF93A0AF),
                icon: Icons.gps_fixed_rounded,
              ),
              const SizedBox(height: 24),
              const SectionTitle(title: 'Ranked Priorities'),
              const SizedBox(height: 12),
              const BulletCard(
                title: '3 priorities',
                accent: Color(0xFFD7B56D),
                items: [
                  'Use audio to pre-aim rather than reacting late.',
                  'Take height before forcing a challenge.',
                  'Read one patch summary before your ranked block.',
                ],
              ),
              const SizedBox(height: 12),
              const BulletCard(
                title: 'Mistakes to avoid',
                accent: Color(0xFF93A0AF),
                items: [
                  'Do not switch weapons every bad match.',
                  'Do not ego-chall flat lanes without information.',
                  'Do not ignore patch shifts before copying old loadouts.',
                ],
              ),
              const SizedBox(height: 24),
              const SectionTitle(title: 'Weekly Checklist'),
              const SizedBox(height: 12),
              ...AppData.weeklyTasks.map(
                (task) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: PlanTaskCard(
                    task: task,
                    completed: completedTaskIds.contains(task.id),
                    onToggle: () => onToggleTask(task.id),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const SectionTitle(title: 'Plan Notes'),
              const SizedBox(height: 12),
              InfoCard(
                title: hasSavedPatchIntel
                    ? 'Patch-aware routine active'
                    : 'Save patch intel to tighten your routine',
                subtitle: hasSavedPatchIntel
                    ? 'You already have saved patch intel, so this week’s plan is easier to anchor to real update notes before queueing ranked.'
                    : 'Your plan still works, but it gets better when you save patch entries and check them before sessions.',
                icon: hasSavedPatchIntel
                    ? Icons.verified_rounded
                    : Icons.info_outline_rounded,
                accent: hasSavedPatchIntel
                    ? const Color(0xFFD7B56D)
                    : const Color(0xFF93A0AF),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TipDetailScreen extends StatelessWidget {
  final IntelItem item;
  final List<IntelItem> visibleItems;
  final bool isSaved;
  final String? selectedReaction;
  final VoidCallback onToggleSaved;
  final ValueChanged<String?> onSetReaction;
  final void Function(IntelItem item) onOpenTip;

  const TipDetailScreen({
    super.key,
    required this.item,
    required this.visibleItems,
    required this.isSaved,
    required this.selectedReaction,
    required this.onToggleSaved,
    required this.onSetReaction,
    required this.onOpenTip,
  });

  @override
  Widget build(BuildContext context) {
    final related = visibleItems
        .where((e) => e.id != item.id && e.category == item.category)
        .take(3)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF06090D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF091018),
        elevation: 0,
        title: const Text(
          'Tip Detail',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: onToggleSaved,
            icon: Icon(
              isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: isSaved ? const Color(0xFFD7B56D) : Colors.white70,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF151D27),
                      Color(0xFF0E141C),
                      Color(0xFF0A0F15),
                    ],
                  ),
                  border: Border.all(color: const Color(0x22D7B56D)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: item.accent.withOpacity(0.14),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(item.icon, color: item.accent),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.source,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${item.dayLabel} • ${item.timeLabel}',
                                style: const TextStyle(
                                  color: Color(0xFF8B97A6),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        MetaPill(
                          label: item.category.toUpperCase(),
                          color: item.accent,
                        ),
                        if (item.isDuplicate)
                          const MetaPill(
                            label: 'DUPLICATE',
                            color: Color(0xFFD7B56D),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      item.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item.body,
                      style: const TextStyle(
                        color: Color(0xFF95A2B1),
                        fontSize: 15,
                        height: 1.65,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      item.footer,
                      style: TextStyle(
                        color: item.accent,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              DetailPanel(
                title: 'React to this tip',
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: item.reactions.map((reaction) {
                    final selected = selectedReaction == reaction;
                    return GestureDetector(
                      onTap: () {
                        onSetReaction(selected ? null : reaction);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? const Color(0x14D7B56D)
                              : const Color(0x12FFFFFF),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: selected
                                ? const Color(0x33D7B56D)
                                : const Color(0x18FFFFFF),
                          ),
                        ),
                        child: Text(
                          reaction,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 14),
              DetailPanel(
                title: 'Actions',
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: onToggleSaved,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD7B56D),
                        foregroundColor: const Color(0xFF0A0D11),
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      icon: Icon(
                        isSaved
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_border_rounded,
                      ),
                      label: Text(isSaved ? 'Saved to profile' : 'Save tip'),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white24),
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      icon: const Icon(Icons.arrow_back_rounded),
                      label: const Text('Back to tips'),
                    ),
                  ],
                ),
              ),
              if (related.isNotEmpty) ...[
                const SizedBox(height: 14),
                DetailPanel(
                  title: 'Related tips',
                  child: Column(
                    children: related.map((relatedTip) {
                      return GestureDetector(
                        onTap: () => onOpenTip(relatedTip),
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0C1117),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: const Color(0x14FFFFFF)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: relatedTip.accent.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  relatedTip.icon,
                                  color: relatedTip.accent,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      relatedTip.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      relatedTip.shortBody,
                                      style: const TextStyle(
                                        color: Color(0xFF93A0AF),
                                        fontSize: 12,
                                        height: 1.45,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.chevron_right_rounded,
                                color: Color(0xFF7C8795),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class PatchDetailScreen extends StatelessWidget {
  final PatchIntelItem item;
  final List<PatchIntelItem> relatedItems;
  final bool isSaved;
  final VoidCallback onToggleSaved;
  final void Function(PatchIntelItem item) onOpenPatch;

  const PatchDetailScreen({
    super.key,
    required this.item,
    required this.relatedItems,
    required this.isSaved,
    required this.onToggleSaved,
    required this.onOpenPatch,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF06090D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF091018),
        elevation: 0,
        title: Text(
          item.issueCode,
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: onToggleSaved,
            icon: Icon(
              isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: isSaved ? const Color(0xFFD7B56D) : Colors.white70,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF151D27),
                      Color(0xFF0E141C),
                      Color(0xFF0A0F15),
                    ],
                  ),
                  border: Border.all(color: const Color(0x22D7B56D)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        MetaPill(
                          label: item.issueCode,
                          color: item.accent,
                        ),
                        MetaPill(
                          label: item.type.toUpperCase(),
                          color: item.accent,
                        ),
                        MetaPill(
                          label: item.status.toUpperCase(),
                          color: const Color(0xFFD7B56D),
                        ),
                        MetaPill(
                          label: 'IMPACT ${item.impact.toUpperCase()}',
                          color: item.accent,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      item.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      item.subtitle,
                      style: const TextStyle(
                        color: Color(0xFF93A0AF),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        InfoChip(
                          icon: Icons.calendar_today_rounded,
                          label: item.dateLabel,
                        ),
                        const SizedBox(width: 8),
                        InfoChip(
                          icon: Icons.schedule_rounded,
                          label: item.timeAgo,
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      item.body,
                      style: const TextStyle(
                        color: Color(0xFF95A2B1),
                        fontSize: 15,
                        height: 1.65,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              DetailPanel(
                title: 'Patch takeaways',
                child: Column(
                  children: item.bullets.map((bullet) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.arrow_right_alt_rounded,
                            color: item.accent,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              bullet,
                              style: const TextStyle(
                                color: Color(0xFF93A0AF),
                                fontSize: 13,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 14),
              DetailPanel(
                title: 'Tags',
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: item.tags
                      .map((tag) => MetaPill(label: tag.toUpperCase(), color: item.accent))
                      .toList(),
                ),
              ),
              const SizedBox(height: 14),
              DetailPanel(
                title: 'Actions',
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: onToggleSaved,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD7B56D),
                        foregroundColor: const Color(0xFF0A0D11),
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      icon: Icon(
                        isSaved
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_border_rounded,
                      ),
                      label: Text(
                        isSaved ? 'Saved to profile library' : 'Save patch intel',
                      ),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white24),
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      icon: const Icon(Icons.arrow_back_rounded),
                      label: const Text('Back to patch feed'),
                    ),
                  ],
                ),
              ),
              if (relatedItems.isNotEmpty) ...[
                const SizedBox(height: 14),
                DetailPanel(
                  title: 'Related patch entries',
                  child: Column(
                    children: relatedItems.map((related) {
                      return GestureDetector(
                        onTap: () => onOpenPatch(related),
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0C1117),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: const Color(0x14FFFFFF)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: related.accent.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  related.icon,
                                  color: related.accent,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      related.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      related.subtitle,
                                      style: const TextStyle(
                                        color: Color(0xFF93A0AF),
                                        fontSize: 12,
                                        height: 1.45,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.chevron_right_rounded,
                                color: Color(0xFF7C8795),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  final Set<String> savedTipIds;
  final Set<String> savedPatchIds;
  final Set<String> completedPlanTaskIds;
  final CoachingRequest? latestRequest;
  final IntelItem? Function(String id) findItemById;
  final PatchIntelItem? Function(String id) findPatchById;
  final void Function(String id) onToggleSaved;
  final void Function(String id) onToggleSavedPatch;
  final bool hideDuplicates;
  final void Function(bool value) onToggleHideDuplicates;
  final Map<String, String?> selectedReactions;

  const ProfileScreen({
    super.key,
    required this.savedTipIds,
    required this.savedPatchIds,
    required this.completedPlanTaskIds,
    required this.latestRequest,
    required this.findItemById,
    required this.findPatchById,
    required this.onToggleSaved,
    required this.onToggleSavedPatch,
    required this.hideDuplicates,
    required this.onToggleHideDuplicates,
    required this.selectedReactions,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool pushAlerts = true;
  bool discordAlerts = true;
  bool dailyTips = true;

  void _openSavedTipDetail(BuildContext context, IntelItem item) {
    final visibleItems = widget.hideDuplicates
        ? AppData.intelItems.where((e) => !e.isDuplicate).toList()
        : AppData.intelItems;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TipDetailScreen(
          item: item,
          visibleItems: visibleItems,
          isSaved: widget.savedTipIds.contains(item.id),
          selectedReaction: widget.selectedReactions[item.id],
          onToggleSaved: () => widget.onToggleSaved(item.id),
          onSetReaction: (_) {},
          onOpenTip: (_) {},
        ),
      ),
    );
  }

  void _openSavedPatchDetail(BuildContext context, PatchIntelItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PatchDetailScreen(
          item: item,
          relatedItems: AppData.patchItems
              .where((e) => e.id != item.id && e.type == item.type)
              .take(3)
              .toList(),
          isSaved: widget.savedPatchIds.contains(item.id),
          onToggleSaved: () => widget.onToggleSavedPatch(item.id),
          onOpenPatch: (_) {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final savedItems = widget.savedTipIds
        .map(widget.findItemById)
        .whereType<IntelItem>()
        .where((item) => widget.hideDuplicates ? !item.isDuplicate : true)
        .toList();

    final savedPatches = widget.savedPatchIds
        .map(widget.findPatchById)
        .whereType<PatchIntelItem>()
        .toList();

    final completedTasks = widget.completedPlanTaskIds.length;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppTopBar(
                title: 'Profile',
                subtitle: 'Premium member hub',
                icon: Icons.person_outline_rounded,
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
                    colors: [
                      Color(0xFF171E28),
                      Color(0xFF101720),
                      Color(0xFF0A0F15),
                    ],
                  ),
                  border: Border.all(color: const Color(0x22D7B56D)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 62,
                          height: 62,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0x14D7B56D),
                            border: Border.all(
                              color: const Color(0x33D7B56D),
                              width: 1.5,
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'D',
                              style: TextStyle(
                                color: Color(0xFFD7B56D),
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Daniel',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Ghost Coach Elite Member',
                                style: TextStyle(
                                  color: Color(0xFFD7B56D),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Saved intel, coaching, patch tracking, and plan progress',
                                style: TextStyle(
                                  color: Color(0xFF93A0AF),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: MiniProfileStat(
                            label: 'Saved Tips',
                            value: '${savedItems.length}',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: MiniProfileStat(
                            label: 'Saved Patch',
                            value: '${savedPatches.length}',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: MiniProfileStat(
                            label: 'Plan Done',
                            value: '$completedTasks',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const SectionTitle(title: 'Settings'),
              const SizedBox(height: 12),
              SettingsSwitchTile(
                title: 'Push notifications',
                subtitle: 'Get notified for coaching replies and key updates.',
                value: pushAlerts,
                icon: Icons.notifications_active_rounded,
                accent: const Color(0xFFD7B56D),
                onChanged: (value) {
                  setState(() {
                    pushAlerts = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              SettingsSwitchTile(
                title: 'Discord alerts',
                subtitle: 'Receive Discord-linked reminders and coaching pings.',
                value: discordAlerts,
                icon: Icons.discord_rounded,
                accent: const Color(0xFF93A0AF),
                onChanged: (value) {
                  setState(() {
                    discordAlerts = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              SettingsSwitchTile(
                title: 'Daily tip notifications',
                subtitle: 'Enable alerts when a new meta tip is posted.',
                value: dailyTips,
                icon: Icons.lightbulb_rounded,
                accent: const Color(0xFFD7B56D),
                onChanged: (value) {
                  setState(() {
                    dailyTips = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              SettingsSwitchTile(
                title: 'Hide duplicate tips',
                subtitle: 'Filter repeated live posts like the current MXR-17 duplicate.',
                value: widget.hideDuplicates,
                icon: Icons.filter_alt_rounded,
                accent: const Color(0xFF93A0AF),
                onChanged: widget.onToggleHideDuplicates,
              ),
              const SizedBox(height: 24),
              const SectionTitle(title: 'Latest Coaching Request'),
              const SizedBox(height: 12),
              if (widget.latestRequest == null)
                const EmptyStateCard(
                  title: 'No coaching request yet',
                  subtitle: 'Submit a request from the Request tab and it will appear here.',
                )
              else
                CoachingSummaryCard(request: widget.latestRequest!),
              const SizedBox(height: 24),
              const SectionTitle(title: 'Saved Tips'),
              const SizedBox(height: 12),
              if (savedItems.isEmpty)
                const EmptyStateCard(
                  title: 'No saved tips yet',
                  subtitle: 'Save tips from the feed and they will appear here.',
                ),
              ...savedItems.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SavedTipCard(
                    item: item,
                    onRemove: () => widget.onToggleSaved(item.id),
                    onOpen: () => _openSavedTipDetail(context, item),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const SectionTitle(title: 'Saved Patch Intel'),
              const SizedBox(height: 12),
              if (savedPatches.isEmpty)
                const EmptyStateCard(
                  title: 'No saved patch intel yet',
                  subtitle: 'Save patch entries from the Patch tab and they will appear here.',
                ),
              ...savedPatches.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SavedPatchCard(
                    item: item,
                    onRemove: () => widget.onToggleSavedPatch(item.id),
                    onOpen: () => _openSavedPatchDetail(context, item),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CoachingPreviewCard extends StatelessWidget {
  final String mode;
  final String weakness;
  final String goal;
  final String sessionLength;
  final String urgency;
  final bool patchAware;
  final bool includeLoadoutReview;
  final bool includeVodReview;
  final String notes;

  const CoachingPreviewCard({
    super.key,
    required this.mode,
    required this.weakness,
    required this.goal,
    required this.sessionLength,
    required this.urgency,
    required this.patchAware,
    required this.includeLoadoutReview,
    required this.includeVodReview,
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0F141B),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x14FFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Preview',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          RequestLine(label: 'Mode', value: mode),
          RequestLine(label: 'Weakness', value: weakness),
          RequestLine(label: 'Goal', value: goal),
          RequestLine(label: 'Session', value: sessionLength),
          RequestLine(label: 'Urgency', value: urgency),
          RequestLine(label: 'Patch-aware', value: patchAware ? 'Yes' : 'No'),
          RequestLine(
            label: 'Loadout review',
            value: includeLoadoutReview ? 'Yes' : 'No',
          ),
          RequestLine(
            label: 'VOD review',
            value: includeVodReview ? 'Yes' : 'No',
          ),
          if (notes.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            const Text(
              'Notes',
              style: TextStyle(
                color: Color(0xFFD7B56D),
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              notes.trim(),
              style: const TextStyle(
                color: Color(0xFF93A0AF),
                fontSize: 13,
                height: 1.5,
              ),
            ),
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
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0F141B),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x14FFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.verified_rounded, color: Color(0xFFD7B56D), size: 18),
              SizedBox(width: 8),
              Text(
                'Saved request',
                style: TextStyle(
                  color: Color(0xFFD7B56D),
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          RequestLine(label: 'Mode', value: request.mode),
          RequestLine(label: 'Weakness', value: request.weakness),
          RequestLine(label: 'Goal', value: request.goal),
          RequestLine(label: 'Session', value: request.sessionLength),
          RequestLine(label: 'Urgency', value: request.urgency),
          RequestLine(
            label: 'Patch-aware',
            value: request.patchAware ? 'Enabled' : 'Disabled',
          ),
          RequestLine(
            label: 'Loadout review',
            value: request.includeLoadoutReview ? 'Included' : 'Off',
          ),
          RequestLine(
            label: 'VOD review',
            value: request.includeVodReview ? 'Included' : 'Off',
          ),
          if (request.notes.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            const Text(
              'Member notes',
              style: TextStyle(
                color: Color(0xFFD7B56D),
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              request.notes.trim(),
              style: const TextStyle(
                color: Color(0xFF93A0AF),
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class RequestLine extends StatelessWidget {
  final String label;
  final String value;

  const RequestLine({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF7E8A98),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SelectionCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;

  const SelectionCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0F141B),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0x14FFFFFF)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.14),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: accent),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF7E8A98),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.expand_more_rounded,
              color: Color(0xFFD7B56D),
            ),
          ],
        ),
      ),
    );
  }
}

class PremiumTipFeedCard extends StatelessWidget {
  final IntelItem item;
  final bool isSaved;
  final String? selectedReaction;
  final VoidCallback onToggleSaved;
  final ValueChanged<String?> onSetReaction;
  final VoidCallback onTap;

  const PremiumTipFeedCard({
    super.key,
    required this.item,
    required this.isSaved,
    required this.selectedReaction,
    required this.onToggleSaved,
    required this.onSetReaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0F141B),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSaved
              ? const Color(0x2AD7B56D)
              : const Color(0x14FFFFFF),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x16000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: item.accent.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(item.icon, color: item.accent),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.source,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${item.dayLabel} • ${item.timeLabel}',
                          style: const TextStyle(
                            color: Color(0xFF8C97A5),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onToggleSaved,
                    icon: Icon(
                      isSaved
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      color: isSaved
                          ? const Color(0xFFD7B56D)
                          : Colors.white70,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  MetaPill(
                    label: item.category.toUpperCase(),
                    color: item.accent,
                  ),
                  if (item.isDuplicate)
                    const MetaPill(
                      label: 'DUPLICATE',
                      color: Color(0xFFD7B56D),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                item.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.shortBody,
                style: const TextStyle(
                  color: Color(0xFF95A2B1),
                  fontSize: 13,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                item.footer,
                style: TextStyle(
                  color: item.accent,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: item.reactions.map((reaction) {
                  final selected = selectedReaction == reaction;
                  return GestureDetector(
                    onTap: () {
                      onSetReaction(selected ? null : reaction);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0x14D7B56D)
                            : const Color(0x10FFFFFF),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: selected
                              ? const Color(0x33D7B56D)
                              : const Color(0x18FFFFFF),
                        ),
                      ),
                      child: Text(
                        reaction,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PatchIntelCard extends StatelessWidget {
  final PatchIntelItem item;
  final bool isSaved;
  final VoidCallback onToggleSaved;
  final VoidCallback onTap;

  const PatchIntelCard({
    super.key,
    required this.item,
    required this.isSaved,
    required this.onToggleSaved,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF0F141B),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSaved
                ? const Color(0x2AD7B56D)
                : const Color(0x14FFFFFF),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: item.accent.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(item.icon, color: item.accent),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.issueCode,
                          style: TextStyle(
                            color: item.accent,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${item.dateLabel} • ${item.status}',
                          style: const TextStyle(
                            color: Color(0xFF8C97A5),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onToggleSaved,
                    icon: Icon(
                      isSaved
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      color: isSaved
                          ? const Color(0xFFD7B56D)
                          : Colors.white70,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  MetaPill(
                    label: item.type.toUpperCase(),
                    color: item.accent,
                  ),
                  MetaPill(
                    label: 'IMPACT ${item.impact.toUpperCase()}',
                    color: item.accent,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                item.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.subtitle,
                style: const TextStyle(
                  color: Color(0xFF95A2B1),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 14),
              ...item.bullets.take(2).map(
                (bullet) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.arrow_right_alt_rounded,
                        size: 18,
                        color: item.accent,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          bullet,
                          style: const TextStyle(
                            color: Color(0xFF93A0AF),
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 6),
              const Row(
                children: [
                  Icon(
                    Icons.open_in_new_rounded,
                    size: 16,
                    color: Color(0xFFD7B56D),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Open detail view',
                    style: TextStyle(
                      color: Color(0xFFD7B56D),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlanTaskCard extends StatelessWidget {
  final PlanTask task;
  final bool completed;
  final VoidCallback onToggle;

  const PlanTaskCard({
    super.key,
    required this.task,
    required this.completed,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: completed ? const Color(0x1014D7B56D) : const Color(0xFF0F141B),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: completed
                ? const Color(0x33D7B56D)
                : const Color(0x14FFFFFF),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: task.accent.withOpacity(0.14),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(task.icon, color: task.accent),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    task.subtitle,
                    style: const TextStyle(
                      color: Color(0xFF93A0AF),
                      fontSize: 12,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              completed
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: completed ? const Color(0xFFD7B56D) : Colors.white38,
            ),
          ],
        ),
      ),
    );
  }
}

class FocusCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color accent;
  final IconData icon;

  const FocusCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F141B),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0x14FFFFFF)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF93A0AF),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BulletCard extends StatelessWidget {
  final String title;
  final List<String> items;
  final Color accent;

  const BulletCard({
    super.key,
    required this.title,
    required this.items,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F141B),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0x14FFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.arrow_right_alt_rounded,
                    color: accent,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        color: Color(0xFF93A0AF),
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;

  const InfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F141B),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0x14FFFFFF)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF93A0AF),
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SavedTipCard extends StatelessWidget {
  final IntelItem item;
  final VoidCallback onRemove;
  final VoidCallback onOpen;

  const SavedTipCard({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onOpen,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0F141B),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0x14FFFFFF)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                MetaPill(
                  label: item.category.toUpperCase(),
                  color: item.accent,
                ),
                if (item.isDuplicate)
                  const MetaPill(
                    label: 'DUPLICATE',
                    color: Color(0xFFD7B56D),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              item.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.shortBody,
              style: const TextStyle(
                color: Color(0xFF93A0AF),
                fontSize: 13,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${item.dayLabel} • ${item.timeLabel} • ${item.source}',
              style: const TextStyle(
                color: Color(0xFF7C8795),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: onRemove,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.bookmark_remove_outlined),
                  label: const Text('Remove'),
                ),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  onPressed: onOpen,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFD7B56D),
                    side: const BorderSide(color: Color(0x33D7B56D)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.open_in_new_rounded),
                  label: const Text('Open'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SavedPatchCard extends StatelessWidget {
  final PatchIntelItem item;
  final VoidCallback onRemove;
  final VoidCallback onOpen;

  const SavedPatchCard({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onOpen,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0F141B),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0x14FFFFFF)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                MetaPill(
                  label: item.type.toUpperCase(),
                  color: item.accent,
                ),
                MetaPill(
                  label: item.issueCode,
                  color: item.accent,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              item.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.subtitle,
              style: const TextStyle(
                color: Color(0xFF93A0AF),
                fontSize: 13,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${item.dateLabel} • ${item.status} • ${item.timeAgo}',
              style: const TextStyle(
                color: Color(0xFF7C8795),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: onRemove,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.bookmark_remove_outlined),
                  label: const Text('Remove'),
                ),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  onPressed: onOpen,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFD7B56D),
                    side: const BorderSide(color: Color(0x33D7B56D)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.open_in_new_rounded),
                  label: const Text('Open'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MetaPill extends StatelessWidget {
  final String label;
  final Color color;

  const MetaPill({
    super.key,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withOpacity(0.18)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const InfoChip({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0x10FFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x18FFFFFF)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFFD7B56D)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class DetailPanel extends StatelessWidget {
  final String title;
  final Widget child;

  const DetailPanel({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F141B),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0x14FFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class EmptyStateCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const EmptyStateCard({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0F141B),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0x14FFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF93A0AF),
              fontSize: 13,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsSwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final IconData icon;
  final Color accent;
  final ValueChanged<bool> onChanged;

  const SettingsSwitchTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.icon,
    required this.accent,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F141B),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0x14FFFFFF)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF93A0AF),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class MiniProfileStat extends StatelessWidget {
  final String label;
  final String value;

  const MiniProfileStat({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0x0FFFFFFF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0x14FFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF8C97A5),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class FeedSectionLabel extends StatelessWidget {
  final String title;

  const FeedSectionLabel({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class AppTopBar extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const AppTopBar({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: const Color(0xFF111821),
            border: Border.all(color: const Color(0x33D7B56D)),
          ),
          child: Icon(icon, color: const Color(0xFFD7B56D)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF8C97A5),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF10161E),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0x14FFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF93A0AF),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}