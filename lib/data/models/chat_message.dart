class ChatMessage {
  final String id;
  final String sender;     // 'member' | 'coach'
  final String senderName;
  final String text;
  final DateTime timestamp;

  const ChatMessage({
    required this.id,
    required this.sender,
    required this.senderName,
    required this.text,
    required this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    id:         json['id']         as String,
    sender:     json['sender']     as String,
    senderName: json['senderName'] as String? ?? json['sender'] as String,
    text:       json['text']       as String,
    timestamp:  DateTime.parse(json['timestamp'] as String).toLocal(),
  );

  bool get isCoach => sender == 'coach';
}
