class ChatMessage {
  final String username;
  final String message;
  final DateTime timestamp;

  ChatMessage(
      {required this.username, required this.message, required this.timestamp});

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      username: json['username'],
      message: json['text'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
