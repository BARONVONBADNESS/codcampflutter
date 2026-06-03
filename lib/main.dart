import 'package:flutter/material.dart';
import 'app.dart';
import 'data/app_data.dart';
import 'data/models/intel_item.dart';
import 'data/models/patch_intel_item.dart';
import 'data/models/coaching_request.dart';
import 'screens/home_screen.dart';
import 'screens/coaching_request_screen.dart';
import 'screens/tips_feed_screen.dart';
import 'screens/patch_intel_screen.dart';
import 'screens/weekly_plan_screen.dart';
import 'screens/tip_detail_screen.dart';
import 'screens/patch_detail_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const CodCampApp());
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  // Tip state
  IntelItem? _openTip;
  String? _tipReaction;
  final Set<String> _savedTipIds = {};

  // Patch state
  PatchIntelItem? _openPatch;
  final Set<String> _savedPatchIds = {};

  // Weekly plan state
  final Set<String> _completedTaskIds = {};

  // Coaching history
  final List<CoachingRequest> _coachingHistory = [];

  void _openTipDetail(IntelItem item) => setState(() => _openTip = item);
  void _closeTipDetail() => setState(() { _openTip = null; _tipReaction = null; });
  void _toggleSavedTip(String id) => setState(() => _savedTipIds.contains(id) ? _savedTipIds.remove(id) : _savedTipIds.add(id));

  void _openPatchDetail(PatchIntelItem item) => setState(() => _openPatch = item);
  void _closePatchDetail() => setState(() => _openPatch = null);
  void _toggleSavedPatch(String id) => setState(() => _savedPatchIds.contains(id) ? _savedPatchIds.remove(id) : _savedPatchIds.add(id));

  void _toggleTask(String id) => setState(() => _completedTaskIds.contains(id) ? _completedTaskIds.remove(id) : _completedTaskIds.add(id));

  void _submitCoaching(CoachingRequest req) => setState(() => _coachingHistory.add(req));

  @override
  Widget build(BuildContext context) {
    // Detail screen overlays
    if (_openTip != null) {
      return TipDetailScreen(
        item: _openTip!,
        visibleItems: AppData.intelItems,
        isSaved: _savedTipIds.contains(_openTip!.id),
        selectedReaction: _tipReaction,
        onToggleSaved: () => _toggleSavedTip(_openTip!.id),
        onSetReaction: (r) => setState(() => _tipReaction = r),
        onOpenTip: _openTipDetail,
      );
    }

    if (_openPatch != null) {
      return PatchDetailScreen(
        item: _openPatch!,
        relatedItems: AppData.patchItems
            .where((p) => p.id != _openPatch!.id && p.type == _openPatch!.type)
            .take(3)
            .toList(),
        isSaved: _savedPatchIds.contains(_openPatch!.id),
        onToggleSaved: () => _toggleSavedPatch(_openPatch!.id),
        onOpenPatch: _openPatchDetail,
      );
    }

    // Main shell
    final screens = [
      HomeScreen(
        intelItems: AppData.intelItems,
        patchItems: AppData.patchItems,
        savedTipIds: _savedTipIds,
        savedPatchIds: _savedPatchIds,
        completedTaskIds: _completedTaskIds,
        onOpenTip: _openTipDetail,
        onOpenPatch: _openPatchDetail,
      ),
      CoachingRequestScreen(
        onSubmit: _submitCoaching,
      ),
      TipsFeedScreen(
        items: AppData.intelItems,
        savedTipIds: _savedTipIds,
        onToggleSaved: _toggleSavedTip,
        onOpenTip: _openTipDetail,
      ),
      PatchIntelScreen(
        items: AppData.patchItems,
        savedPatchIds: _savedPatchIds,
        onToggleSaved: _toggleSavedPatch,
        onOpenPatch: _openPatchDetail,
      ),
      WeeklyPlanScreen(
        completedTaskIds: _completedTaskIds,
        savedPatchIds: _savedPatchIds,
        onToggleTask: _toggleTask,
      ),
      ProfileScreen(
        savedTipIds: _savedTipIds,
        savedPatchIds: _savedPatchIds,
        allTips: AppData.intelItems,
        allPatches: AppData.patchItems,
        coachingHistory: _coachingHistory,
        onToggleSavedTip: _toggleSavedTip,
        onToggleSavedPatch: _toggleSavedPatch,
        onOpenTip: _openTipDetail,
        onOpenPatch: _openPatchDetail,
      ),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.sports_esports_rounded), label: 'Coaching'),
          BottomNavigationBarItem(icon: Icon(Icons.tips_and_updates_rounded), label: 'Tips'),
          BottomNavigationBarItem(icon: Icon(Icons.radar_rounded), label: 'Patch'),
          BottomNavigationBarItem(icon: Icon(Icons.event_note_rounded), label: 'Plan'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}
