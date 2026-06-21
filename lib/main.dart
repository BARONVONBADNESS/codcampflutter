import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'app.dart';
import 'services/auth_service.dart';
import 'services/discord_oauth.dart';
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
import 'screens/loadout_screen.dart';
import 'services/tips_service.dart';
import 'services/patch_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.init();
  DiscordOAuthService.init(); // Start listening for OAuth deep links

  // On web, check if we were redirected back with Discord user info in the URL.
  // The full page reload kills the auth completer, so we log in directly here.
  if (kIsWeb) {
    final uri = Uri.base;
    final discordId = uri.queryParameters['discord_id'];
    final username = uri.queryParameters['username'];
    if (discordId != null && username != null) {
      final avatar = uri.queryParameters['avatar'];
      await AuthService.loginWithDiscord(
        discordId: discordId,
        discordUsername: uri.queryParameters['global_name']?.isNotEmpty == true
            ? uri.queryParameters['global_name']!
            : username,
        discordAvatar: (avatar != null && avatar.isNotEmpty) ? avatar : null,
      );
    }
  }

  runApp(const CodCampApp());
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  final Set<String> _savedTipIds = {};
  final Map<String, String?> _selectedReactions = {};
  final Set<String> _savedPatchIds = {};
  final Set<String> _completedPlanTaskIds = {};
  final List<CoachingRequest> _coachingHistory = [];
  bool _hideDuplicates = false;

  // Live data — null = server unreachable, uses static fallback.
  List<IntelItem>? _liveTips;
  List<PatchIntelItem>? _livePatches;

  @override
  void initState() {
    super.initState();
    _loadLiveData();
  }

  Future<void> _loadLiveData() async {
    final results = await Future.wait([
      TipsService.fetchLiveTips(),
      PatchService.fetchLivePatches(),
    ]);
    if (!mounted) return;
    setState(() {
      final tips    = results[0] as List<IntelItem>;
      final patches = results[1] as List<PatchIntelItem>;
      _liveTips    = tips.isNotEmpty    ? tips    : null;
      _livePatches = patches.isNotEmpty ? patches : null;
    });
  }

  void _toggleSaved(String id) {
    setState(() {
      if (_savedTipIds.contains(id)) {
        _savedTipIds.remove(id);
      } else {
        _savedTipIds.add(id);
      }
    });
  }

  void _setReaction(String id, String? reaction) {
    setState(() {
      if (reaction == null) {
        _selectedReactions.remove(id);
      } else {
        _selectedReactions[id] = reaction;
      }
    });
  }

  void _toggleSavedPatch(String id) {
    setState(() {
      if (_savedPatchIds.contains(id)) {
        _savedPatchIds.remove(id);
      } else {
        _savedPatchIds.add(id);
      }
    });
  }

  void _togglePlanTask(String id) {
    setState(() {
      if (_completedPlanTaskIds.contains(id)) {
        _completedPlanTaskIds.remove(id);
      } else {
        _completedPlanTaskIds.add(id);
      }
    });
  }

  void _saveCoachingRequest(CoachingRequest request) {
    setState(() {
      _coachingHistory.add(request);
      _currentIndex = 0;
    });
  }

  void _openTipDetail(BuildContext context, IntelItem item) {
    final visibleItems = _hideDuplicates
        ? AppData.intelItems.where((e) => !e.isDuplicate).toList()
        : AppData.intelItems.toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TipDetailScreen(
          item: item,
          visibleItems: visibleItems,
          isSaved: _savedTipIds.contains(item.id),
          selectedReaction: _selectedReactions[item.id],
          onToggleSaved: () => _toggleSaved(item.id),
          onSetReaction: (r) => _setReaction(item.id, r),
          onOpenTip: (next) => _openTipDetail(context, next),
        ),
      ),
    );
  }

  void _openPatchDetail(BuildContext context, PatchIntelItem item) {
    final allPatches = _livePatches ?? AppData.patchItems.toList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PatchDetailScreen(
          item: item,
          relatedItems: allPatches
              .where((e) => e.id != item.id && e.type == item.type)
              .take(3)
              .toList(),
          isSaved: _savedPatchIds.contains(item.id),
          onToggleSaved: () => _toggleSavedPatch(item.id),
          onOpenPatch: (next) => _openPatchDetail(context, next),
        ),
      ),
    );
  }

  /// Returns live Discord tips if the server is reachable, otherwise static fallback.
  List<IntelItem> get _visibleTips {
    final source = _liveTips ?? AppData.intelItems.toList();
    return _hideDuplicates
        ? source.where((e) => !e.isDuplicate).toList()
        : source;
  }


  @override
  Widget build(BuildContext context) {
    final latestRequest =
        _coachingHistory.isNotEmpty ? _coachingHistory.last : null;

    final pages = [
      HomeScreen(
        hideDuplicates: _hideDuplicates,
        savedTipCount: _savedTipIds.length,
        savedPatchCount: _savedPatchIds.length,
        completedTaskCount: _completedPlanTaskIds.length,
        hasRequest: _coachingHistory.isNotEmpty,
      ),
      CoachingRequestScreen(
        latestRequest: latestRequest,
        onSubmitRequest: _saveCoachingRequest,
      ),
      TipsFeedScreen(
        items: _visibleTips,
        savedTipIds: _savedTipIds,
        onToggleSaved: _toggleSaved,
        onOpenTip: (item) => _openTipDetail(context, item),
        isLive: _liveTips != null,
      ),
      PatchIntelScreen(
        items: _livePatches ?? AppData.patchItems.toList(),
        savedPatchIds: _savedPatchIds,
        onToggleSaved: _toggleSavedPatch,
        onOpenPatch: (item) => _openPatchDetail(context, item),
        isLive: _livePatches != null,
      ),
      WeeklyPlanScreen(
        completedTaskIds: _completedPlanTaskIds,
        savedPatchIds: _savedPatchIds,
        onToggleTask: _togglePlanTask,
      ),
      ProfileScreen(
        savedTipIds: _savedTipIds,
        savedPatchIds: _savedPatchIds,
        allTips: AppData.intelItems.toList(),
        allPatches: _livePatches ?? AppData.patchItems.toList(),
        coachingHistory: _coachingHistory,
        onToggleSavedTip: _toggleSaved,
        onToggleSavedPatch: _toggleSavedPatch,
        onOpenTip: (item) => _openTipDetail(context, item),
        onOpenPatch: (item) => _openPatchDetail(context, item),
      ),
      const LoadoutScreen(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF091018),
        selectedItemColor: const Color(0xFFD7B56D),
        unselectedItemColor: const Color(0xFF687483),
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.tune_rounded),
            label: 'Loadouts',
          ),
        ],
      ),
    );
  }
}

