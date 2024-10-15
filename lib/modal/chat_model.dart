class Friend {
  final String id;
  final String name;

  Friend({required this.id, required this.name, required imageUrl});

  get imageUrl => null;
}

class Message {
  final String senderId;
  final String receiverId;
  final String content;
  final bool isImage;
  final DateTime timestamp;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.content,
    this.isImage = false,
    required this.timestamp,
  });
}
