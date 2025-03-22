// message_model.dart
class Message {
  final String id;
  final String content;
  final String timestamp;
  final bool isSentByMe;
  final String contactId;
  final bool isRead;

  Message({
    required this.id, 
    required this.content,
    required this.timestamp,
    required this.isSentByMe,
    required this.contactId,
    this.isRead = false,
  });

  // Factory constructor to create a Message from a map (from database)
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] ?? '',
      content: map['content'] ?? '',
      timestamp: map['timestamp'] ?? '',
      isSentByMe: map['is_sent_by_me'] == 1,
      contactId: map['contact_id'] ?? '',
      isRead: map['is_read'] == 1,
    );
  }

  // Convert a Message to a map (for database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'timestamp': timestamp,
      'is_sent_by_me': isSentByMe ? 1 : 0,
      'contact_id': contactId,
      'is_read': isRead ? 1 : 0,
    };
  }
}