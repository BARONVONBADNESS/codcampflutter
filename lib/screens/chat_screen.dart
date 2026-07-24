import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../data/models/chat_message.dart';
import '../data/models/coaching_request.dart';
import '../services/coaching_service.dart';

const _lime    = Color(0xFFA6FF2E);
const _bg      = Color(0xFF050A05);
const _surface = Color(0xFF0A120A);

class ChatScreen extends StatefulWidget {
  final CoachingRequest request;
  /// Called when the coaching request is first submitted to the server
  /// (deferred until the user sends their first message).
  final void Function(CoachingRequest)? onRequestCreated;

  const ChatScreen({
    super.key,
    required this.request,
    this.onRequestCreated,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();
  List<ChatMessage> _messages = [];
  bool _sending = false;
  bool _loading = true;
  Timer? _pollTimer;
  late AnimationController _pulseCtrl;
  late CoachingRequest _request;

  @override
  void initState() {
    super.initState();
    _request = widget.request;
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _loadMessages();
    _pollTimer =
        Timer.periodic(const Duration(seconds: 4), (_) => _loadMessages());
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _pollTimer?.cancel();
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    final requestId = _request.requestId;
    if (requestId == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    final msgs = await CoachingService.getMessages(requestId);
    if (!mounted) return;
    setState(() {
      _messages = msgs;
      _loading = false;
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty || _sending) return;

    setState(() => _sending = true);
    _input.clear();

    // ── Deferred submission: create request on first message ──
    String? requestId = _request.requestId;
    if (requestId == null) {
      // Submit the coaching request now, using the first message as notes
      // so the server-side validation passes.
      final reqWithNotes = CoachingRequest(
        mode: _request.mode,
        weakness: _request.weakness,
        goal: _request.goal,
        sessionLength: _request.sessionLength,
        urgency: _request.urgency,
        notes: text,
        patchAware: _request.patchAware,
        includeLoadoutReview: _request.includeLoadoutReview,
        includeVodReview: _request.includeVodReview,
      );
      requestId = await CoachingService.submitRequest(reqWithNotes);
      if (requestId != null) {
        final created = reqWithNotes.copyWithRequestId(requestId);
        _request = created;
        widget.onRequestCreated?.call(created);
      } else {
        // Server unreachable — show message locally only
        if (mounted) setState(() => _sending = false);
        return;
      }
    }

    final optimistic = ChatMessage(
      id: 'pending_${DateTime.now().millisecondsSinceEpoch}',
      sender: 'member',
      senderName: 'Member',
      text: text,
      timestamp: DateTime.now(),
    );
    setState(() => _messages = [..._messages, optimistic]);
    _scrollToBottom();

    await CoachingService.sendMessage(requestId, text);
    await _loadMessages();
    if (mounted) setState(() => _sending = false);
  }

  @override
  Widget build(BuildContext context) {
    final req = _request;
    final hasServer = req.requestId != null;

    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          // ── Premium header with hero image ───────────────────────────
          _ChatHeader(
            mode: req.mode,
            goal: req.goal,
            hasServer: hasServer,
            pulseAnimation: _pulseCtrl,
            onBack: () => Navigator.pop(context),
          ),

          // ── Detail strip (only for legacy requests with fields) ─────
          if (req.weakness.isNotEmpty ||
              req.sessionLength.isNotEmpty ||
              req.urgency.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF070D07),
                border: Border(
                  bottom:
                      BorderSide(color: _lime.withValues(alpha: 0.06)),
                ),
              ),
              child: Wrap(
                spacing: 16,
                runSpacing: 4,
                children: [
                  if (req.weakness.isNotEmpty)
                    _DetailChip(label: 'Weakness', value: req.weakness),
                  if (req.sessionLength.isNotEmpty)
                    _DetailChip(label: 'Session', value: req.sessionLength),
                  if (req.urgency.isNotEmpty)
                    _DetailChip(label: 'Urgency', value: req.urgency),
                ],
              ),
            ),
          ],

          // ── Info banner ────────────────────────────────────────────────

          // ── Messages ──────────────────────────────────────────────────
          Expanded(
            child: _loading
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                  color: _lime, strokeWidth: 2),
                            ),
                            const SizedBox(height: 12),
                            Text('ESTABLISHING LINK',
                                style: TextStyle(
                                    color: _lime.withValues(alpha: 0.30),
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 2.0)),
                          ],
                        ),
                      )
                    : _messages.isEmpty
                        ? _EmptyThread(pulseAnimation: _pulseCtrl)
                        : ListView.builder(
                            controller: _scroll,
                            padding:
                                const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            itemCount: _messages.length,
                            itemBuilder: (_, i) =>
                                _MessageBubble(message: _messages[i]),
                          ),
          ),

          // ── Compose bar ──────────────────────────────────────────────
          _ComposeBar(
            controller: _input,
            sending: _sending,
            onSend: _send,
          ),
        ],
      ),
    );
  }
}

// ── Premium header ──────────────────────────────────────────────────────────

class _ChatHeader extends StatelessWidget {
  final String mode;
  final String goal;
  final bool hasServer;
  final AnimationController pulseAnimation;
  final VoidCallback onBack;

  const _ChatHeader({
    required this.mode,
    required this.goal,
    required this.hasServer,
    required this.pulseAnimation,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return Container(
      height: topPad + 120,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Hero image
          Image.asset(
            'assets/images/lt_reaper.png',
            fit: BoxFit.cover,
            alignment: const Alignment(0.3, -0.2),
            errorBuilder: (_, _, _) => Container(color: _surface),
          ),

          // Gradient overlays for readability
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    _bg.withValues(alpha: 0.50),
                    _bg.withValues(alpha: 0.20),
                    _bg.withValues(alpha: 0.85),
                    _bg,
                  ],
                  stops: const [0.0, 0.3, 0.75, 1.0],
                ),
              ),
            ),
          ),

          // Left edge vignette
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    _bg.withValues(alpha: 0.7),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.4],
                ),
              ),
            ),
          ),

          // Animated scan line
          AnimatedBuilder(
            animation: pulseAnimation,
            builder: (context, child) {
              final val = pulseAnimation.value;
              return Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 1,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        _lime.withValues(alpha: 0.15 * val),
                        _lime.withValues(alpha: 0.30 * val),
                        _lime.withValues(alpha: 0.15 * val),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // Content
          Positioned(
            top: topPad + 8,
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                // Top row: back + status
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: _lime, size: 18),
                        onPressed: onBack,
                      ),
                      const Spacer(),
                      // Live indicator
                      AnimatedBuilder(
                        animation: pulseAnimation,
                        builder: (context, child) {
                          final glow = 0.4 + 0.6 * pulseAnimation.value;
                          return Container(
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: hasServer
                                  ? _lime.withValues(alpha: 0.06)
                                  : const Color(0xFF1A0E0E),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: hasServer
                                    ? _lime.withValues(alpha: 0.20 * glow)
                                    : const Color(0xFF4E2E10),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (hasServer)
                                  Container(
                                    width: 6,
                                    height: 6,
                                    margin: const EdgeInsets.only(right: 6),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          _lime.withValues(alpha: glow),
                                      boxShadow: [
                                        BoxShadow(
                                          color: _lime.withValues(
                                              alpha: 0.3 * glow),
                                          blurRadius: 6,
                                        ),
                                      ],
                                    ),
                                  ),
                                Text(
                                  hasServer ? 'LIVE' : 'OFFLINE',
                                  style: TextStyle(
                                    color: hasServer
                                        ? _lime
                                        : const Color(0xFFD7B56D),
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Bottom: mode label + subtitle
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Lt. Reaper tag
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: _lime.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(2),
                                border: Border.all(
                                    color: _lime.withValues(alpha: 0.18)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.military_tech_rounded,
                                      color: _lime.withValues(alpha: 0.7),
                                      size: 10),
                                  const SizedBox(width: 4),
                                  Text('LT. REAPER',
                                      style: TextStyle(
                                          color:
                                              _lime.withValues(alpha: 0.70),
                                          fontSize: 8,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 1.5)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),
                            // Mode name
                            Text(mode,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.0,
                                    height: 1.1)),
                            const SizedBox(height: 2),
                            Text(
                              goal.isNotEmpty
                                  ? goal
                                  : 'Coaching Session',
                              style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.35),
                                  fontSize: 11,
                                  letterSpacing: 0.5),
                            ),
                          ],
                        ),
                      ),
                    ],
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

// ── Compose bar ──────────────────────────────────────────────────────────────

class _ComposeBar extends StatelessWidget {
  final TextEditingController controller;
  final bool sending;
  final VoidCallback onSend;

  const _ComposeBar({
    required this.controller,
    required this.sending,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(12, 10, 12, bottomPad + 10),
      decoration: BoxDecoration(
        color: _surface,
        border: Border(
          top: BorderSide(color: _lime.withValues(alpha: 0.08)),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0F170F),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: _lime.withValues(alpha: 0.10)),
              ),
              child: TextField(
                controller: controller,
                maxLines: 4,
                minLines: 1,
                style: const TextStyle(
                    color: Colors.white, fontSize: 14, height: 1.4),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  hintText: 'Message Lt. Reaper…',
                  hintStyle: TextStyle(
                      color: _lime.withValues(alpha: 0.15),
                      fontSize: 13),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => onSend(),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onSend,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: sending
                      ? [const Color(0xFF1A3008), const Color(0xFF1A3008)]
                      : [_lime, const Color(0xFF7ACC20)],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: sending
                    ? null
                    : [
                        BoxShadow(
                          color: _lime.withValues(alpha: 0.25),
                          blurRadius: 12,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: sending
                  ? const Center(
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            color: _lime, strokeWidth: 2),
                      ),
                    )
                  : const Icon(Icons.send_rounded,
                      color: Color(0xFF050A05), size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Message bubble ──────────────────────────────────────────────────────────

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isCoach = message.isCoach;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isCoach ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Coach avatar
          if (isCoach) ...[
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(right: 10, top: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: _lime.withValues(alpha: 0.25), width: 1.5),
                image: const DecorationImage(
                  image: AssetImage('assets/images/lt_reaper.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment(0.6, -0.3),
                ),
              ),
            ),
          ],

          // Bubble
          Flexible(
            child: Container(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
              decoration: BoxDecoration(
                color: isCoach
                    ? const Color(0xFF0E1A08)
                    : const Color(0xFF111811),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isCoach ? 4 : 16),
                  bottomRight: Radius.circular(isCoach ? 16 : 4),
                ),
                border: Border.all(
                  color: isCoach
                      ? _lime.withValues(alpha: 0.12)
                      : Colors.white.withValues(alpha: 0.06),
                ),
                boxShadow: isCoach
                    ? [
                        BoxShadow(
                          color: _lime.withValues(alpha: 0.04),
                          blurRadius: 12,
                        ),
                      ]
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        message.senderName.toUpperCase(),
                        style: TextStyle(
                          color: isCoach
                              ? _lime.withValues(alpha: 0.70)
                              : Colors.white.withValues(alpha: 0.35),
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatTime(message.timestamp),
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.15),
                            fontSize: 9),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    message.text,
                    style: TextStyle(
                      color: isCoach
                          ? Colors.white.withValues(alpha: 0.90)
                          : Colors.white.withValues(alpha: 0.75),
                      fontSize: 13,
                      height: 1.55,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Member avatar
          if (!isCoach) ...[
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(left: 10, top: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF111811),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Icon(Icons.person_rounded,
                  color: Colors.white.withValues(alpha: 0.25), size: 16),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

// ── Empty state ─────────────────────────────────────────────────────────────

class _EmptyThread extends StatelessWidget {
  final AnimationController pulseAnimation;
  const _EmptyThread({required this.pulseAnimation});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated reaper avatar
          AnimatedBuilder(
            animation: pulseAnimation,
            builder: (context, child) {
              final glow = pulseAnimation.value;
              return Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: _lime.withValues(alpha: 0.15 + 0.15 * glow),
                      width: 2),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/lt_reaper.png'),
                    fit: BoxFit.cover,
                    alignment: Alignment(0.5, -0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _lime.withValues(alpha: 0.08 * glow),
                      blurRadius: 24,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          const Text('CHANNEL OPEN',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0)),
          const SizedBox(height: 6),
          Text('Lt. Reaper is standing by.',
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.30),
                  fontSize: 12)),
          const SizedBox(height: 16),
          // Typing indicator dots
          AnimatedBuilder(
            animation: pulseAnimation,
            builder: (context, child) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (i) {
                  final offset = (pulseAnimation.value + i * 0.33) % 1.0;
                  final alpha = 0.15 + 0.35 * math.sin(offset * math.pi);
                  return Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _lime.withValues(alpha: alpha),
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ── Detail chip ─────────────────────────────────────────────────────────────

class _DetailChip extends StatelessWidget {
  final String label;
  final String value;

  const _DetailChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
            text: '$label  ',
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.25), fontSize: 10)),
        TextSpan(
            text: value,
            style: const TextStyle(
                color: _lime,
                fontSize: 10,
                fontWeight: FontWeight.w800)),
      ]),
    );
  }
}
