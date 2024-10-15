import 'package:flutter/material.dart';

import '../modal/chat_model.dart';

class ChatController extends ChangeNotifier {
  List<Friend> _friends = [];
  Map<String, List<Message>> _messages = {};
  TextEditingController _messageController = TextEditingController();

  List<Friend> get friends => _friends;
  TextEditingController get messageController => _messageController;

  void addFriend(String name) {
    final newFriend =
        Friend(id: DateTime.now().toString(), name: name, imageUrl: null);
    _friends.add(newFriend);
    notifyListeners();
  }

  void sendMessage(String friendId, String content, {bool isImage = false}) {
    final newMessage = Message(
      senderId: 'currentUserId',
      receiverId: friendId,
      content: content,
      isImage: isImage,
      timestamp: DateTime.now(),
    );

    if (_messages[friendId] == null) {
      _messages[friendId] = [];
    }

    _messages[friendId]!.add(newMessage);
    notifyListeners();
  }

  List<Message> getMessages(String friendId) {
    return _messages[friendId] ?? [];
  }

  void deleteChat(String friendId) {
    _messages.remove(friendId);
    notifyListeners();
  }
}
