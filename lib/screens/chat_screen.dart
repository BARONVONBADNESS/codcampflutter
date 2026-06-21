import 'dart:async';
import 'package:flutter/material.dart';
import '../data/models/chat_message.dart';
import '../data/models/coaching_request.dart';
import '../services/coaching_service.dart';

class ChatScreen extends StatefulWidget {
  final CoachingRequest request;

  const ChatScreen({super.key, required this.request});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();
  List<ChatMessage> _messages = [];
  bool _sending = false;
  bool _loading = true;
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _pollTimer = Timer.periodic(const Duration(seconds: 4), (_) => _loadMessages());
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    final requestId = widget.request.requestId;
    if (requestId == null) return;
    final msgs = await CoachingService.getMessages(requestId);
    if (!mounted) return;
    setState(() {
      _messages = msgs;
      _loading  = false;
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
    final requestId = widget.request.requestId;
    if (requestId == null) return;

    setState(() => _sending = true);
    _input.clear();

    // Optimistic local insert
    final optimistic = ChatMessage(
      id:         'pending_${DateTime.now().millisecondsSinceEpoch}',
      sender:     'member',
      senderName: 'Member',
      text:       text,
      timestamp:  DateTime.now(),
    );
    setState(() => _messages = [..._messages, optimistic]);
    _scrollToBottom();

    await CoachingService.sendMessage(requestId, text);
    await _loadMessages();
    if (mounted) setState(() => _sending = false);
  }

  @override
  Widget build(BuildContext context) {
    final req = widget.request;
    final hasServer = req.requestId != null;

    return Scaffold(
      backgroundColor: const Color(0xFF050A05),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A120A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFFA6FF2E), size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              req.mode,
              style: const TextStyle(
                  color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800),
            ),
            Text(
              req.goal,
              style: const TextStyle(color: Color(0xFF687483), fontSize: 11),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: hasServer
                  ? const Color(0xFF0F1F0F)
                  : const Color(0xFF1A0E0E),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                  color: hasServer
                      ? const Color(0xFF2E4E10)
                      : const Color(0xFF4E2E10)),
            ),
            child: Text(
              hasServer ? 'LIVE' : 'OFFLINE',
              style: TextStyle(
                color: hasServer
                    ? const Color(0xFFA6FF2E)
                    : const Color(0xFFD7B56D),
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Request details strip ─────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: const Color(0xFF070D07),
            child: Wrap(
              spacing: 16,
              runSpacing: 4,
              children: [
                _DetailChip(label: 'Weakness', value: req.weakness),
                _DetailChip(label: 'Session',  value: req.sessionLength),
                _DetailChip(label: 'Urgency',  value: req.urgency),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFF1E2E1E)),

          // ── No-server banner ──────────────────────────────────────────────
          if (!hasServer)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: const Color(0xFF1A0E05),
              child: const Text(
                'This request was saved locally — server was unreachable when submitted. Messaging unavailable.',
                style: TextStyle(color: Color(0xFFD7B56D), fontSize: 11, height: 1.5),
              ),
            ),

          // ── Messages ──────────────────────────────────────────────────────
          Expanded(
            child: !hasServer
                ? const Center(
                    child: Text('No connection',
                        style: TextStyle(color: Color(0xFF2A3A2A), fontSize: 13)))
                : _loading
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: Color(0xFFA6FF2E), strokeWidth: 2))
                    : _messages.isEmpty
                        ? const _EmptyThread()
                        : ListView.builder(
                            controller: _scroll,
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            itemCount: _messages.length,
                            itemBuilder: (_, i) =>
                                _MessageBubble(message: _messages[i]),
                          ),
          ),

          // ── Compose bar ───────────────────────────────────────────────────
          if (hasServer)
            Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              decoration: const BoxDecoration(
                color: Color(0xFF0A120A),
                border: Border(top: BorderSide(color: Color(0xFF1E2E1E))),
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F170F),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF1E2E1E)),
                        ),
                        child: TextField(
                          controller: _input,
                          maxLines: 4,
                          minLines: 1,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14, height: 1.4),
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            hintText: 'Message your coach…',
                            hintStyle: TextStyle(color: Color(0xFF3A4A3A)),
                            border: InputBorder.none,
                          ),
                          onSubmitted: (_) => _send(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _send,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: _sending
                              ? const Color(0xFF2A4A10)
                              : const Color(0xFFA6FF2E),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: _sending
                            ? const Center(
                                child: SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2),
                                ),
                              )
                            : const Icon(Icons.send_rounded,
                                color: Color(0xFF050A05), size: 20),
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

// ── Message bubble ────────────────────────────────────────────────────────────

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isCoach = message.isCoach;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment:
            isCoach ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isCoach) ...[
            Container(
              width: 28,
              height: 28,
              margin: const EdgeInsets.only(right: 8, bottom: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF0F1F0F),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF1E3E1E)),
              ),
              child: const Icon(Icons.person_rounded,
                  color: Color(0xFF3A5A3A), size: 16),
            ),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              decoration: BoxDecoration(
                color: isCoach
                    ? const Color(0xFF1A2E08)
                    : const Color(0xFF0E180E),
                borderRadius: BorderRadius.only(
                  topLeft:     const Radius.circular(14),
                  topRight:    const Radius.circular(14),
                  bottomLeft:  Radius.circular(isCoach ? 14 : 4),
                  bottomRight: Radius.circular(isCoach ? 4 : 14),
                ),
                border: Border.all(
                  color: isCoach
                      ? const Color(0xFF2E4E10)
                      : const Color(0xFF1E2E1E),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.senderName.toUpperCase(),
                    style: TextStyle(
                      color: isCoach
                          ? const Color(0xFFA6FF2E)
                          : const Color(0xFF687483),
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message.text,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 13, height: 1.5),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: const TextStyle(
                        color: Color(0xFF3A4A3A), fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
          if (isCoach) ...[
            Container(
              width: 28,
              height: 28,
              margin: const EdgeInsets.only(left: 8, bottom: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF0F200A),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF2E4E10)),
              ),
              child: const Icon(Icons.military_tech_rounded,
                  color: Color(0xFFA6FF2E), size: 16),
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

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyThread extends StatelessWidget {
  const _EmptyThread();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF0A1A0A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF1E3E1E)),
            ),
            child: const Icon(Icons.chat_bubble_outline_rounded,
                color: Color(0xFF2A4A2A), size: 26),
          ),
          const SizedBox(height: 14),
          const Text('Thread open',
              style: TextStyle(
                  color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          const Text('A coach will reply here shortly.',
              style: TextStyle(color: Color(0xFF687483), fontSize: 12)),
        ],
      ),
    );
  }
}

// ── Detail chip ───────────────────────────────────────────────────────────────

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
            style: const TextStyle(color: Color(0xFF555555), fontSize: 10)),
        TextSpan(
            text: value,
            style: const TextStyle(
                color: Color(0xFFA6FF2E),
                fontSize: 10,
                fontWeight: FontWeight.w800)),
      ]),
    );
  }
}
