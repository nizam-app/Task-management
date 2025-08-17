enum MessageType { text, image, document, system }

class Message {
  final String id;
  final String content;
  final String senderId;
  final String senderName;
  final DateTime timestamp;
  final MessageType type;
  final bool isOwn;
  final String? attachmentUrl;

  Message({
    required this.id,
    required this.content,
    required this.senderId,
    required this.senderName,
    required this.timestamp,
    this.type = MessageType.text,
    required this.isOwn,
    this.attachmentUrl,
  });

  String get timeString {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'senderId': senderId,
      'senderName': senderName,
      'timestamp': timestamp.toIso8601String(),
      'type': type.toString().split('.').last,
      'isOwn': isOwn,
      'attachmentUrl': attachmentUrl,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      content: json['content'],
      senderId: json['senderId'],
      senderName: json['senderName'],
      timestamp: DateTime.parse(json['timestamp']),
      type: MessageType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type']
      ),
      isOwn: json['isOwn'],
      attachmentUrl: json['attachmentUrl'],
    );
  }
}

class Conversation {
  final String id;
  final String name;
  final String role;
  final String? facility;
  final String lastMessage;
  final DateTime timestamp;
  final int unreadCount;
  final bool isGroup;
  final String avatar;
  final int? participants;

  Conversation({
    required this.id,
    required this.name,
    required this.role,
    this.facility,
    required this.lastMessage,
    required this.timestamp,
    this.unreadCount = 0,
    this.isGroup = false,
    required this.avatar,
    this.participants,
  });

  String get timeString {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(timestamp.year, timestamp.month, timestamp.day);
    
    if (messageDate == today) {
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else if (now.difference(timestamp).inDays < 7) {
      const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return weekdays[timestamp.weekday - 1];
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'facility': facility,
      'lastMessage': lastMessage,
      'timestamp': timestamp.toIso8601String(),
      'unreadCount': unreadCount,
      'isGroup': isGroup,
      'avatar': avatar,
      'participants': participants,
    };
  }

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      name: json['name'],
      role: json['role'],
      facility: json['facility'],
      lastMessage: json['lastMessage'],
      timestamp: DateTime.parse(json['timestamp']),
      unreadCount: json['unreadCount'],
      isGroup: json['isGroup'],
      avatar: json['avatar'],
      participants: json['participants'],
    );
  }
}