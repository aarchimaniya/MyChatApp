import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../../controller/themeprovider.dart';
import '../../../controller/chat_controller.dart';
import '../../../modal/chat_model.dart';

class ChatPage extends StatelessWidget {
  final String currentUserId = 'currentUserId';
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final friend = ModalRoute.of(context)?.settings.arguments as Friend;
    final chatController = Provider.of<ChatController>(context);
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFAFAFA),
        title: Text(friend.name),
      ),
      body: Stack(
        children: [
          if (themeNotifier.wallpaperUrl.isNotEmpty)
            Positioned.fill(
              child: Image.network(
                themeNotifier.wallpaperUrl,
                fit: BoxFit.cover,
              ),
            ),
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: chatController.getMessages(friend.id).length,
                  itemBuilder: (context, index) {
                    final message =
                        chatController.getMessages(friend.id)[index];
                    final isSentByMe = message.senderId == currentUserId;

                    return GestureDetector(
                      onLongPress: () {
                        _showDeleteOptionsDialog(context, chatController,
                            friend.id, index, isSentByMe);
                      },
                      child: Align(
                        alignment: isSentByMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                          decoration: BoxDecoration(
                            color: isSentByMe
                                ? Colors.blue[100]
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(message.content),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.attach_file, color: Colors.white),
                      onPressed: () {
                        _showCupertinoAttachDialog(
                            context, chatController, friend.id);
                      },
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        padding: EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: TextField(
                              controller: chatController.messageController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Type a message',
                                hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.7)),
                              ),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send, color: Colors.white),
                      onPressed: () {
                        chatController.sendMessage(
                            friend.id, chatController.messageController.text);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCupertinoAttachDialog(
      BuildContext context, ChatController chatController, String friendId) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text('Choose an option'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text('Choose from Gallery'),
              onPressed: () {
                _sendImageFromGallery(chatController, friendId);
                Navigator.pop(context);
              },
            ),
            CupertinoActionSheetAction(
              child: Text('Take a Photo'),
              onPressed: () {
                _takePhoto(chatController, friendId);
                Navigator.pop(context);
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  void _sendImageFromGallery(
      ChatController chatController, String friendId) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      chatController.sendMessage(friendId, pickedFile.path, isImage: true);
    }
  }

  void _takePhoto(ChatController chatController, String friendId) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      chatController.sendMessage(friendId, pickedFile.path, isImage: true);
    }
  }

  void _showDeleteOptionsDialog(
      BuildContext context,
      ChatController chatController,
      String friendId,
      int messageIndex,
      bool isSentByMe) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Message?'),
          actions: [
            if (isSentByMe)
              TextButton(
                onPressed: () {
                  chatController.getMessages(friendId).removeAt(messageIndex);
                  chatController.notifyListeners();
                  Navigator.of(context).pop();
                },
                child: Text('Delete for Everyone',
                    style: TextStyle(color: Colors.red)),
              ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
