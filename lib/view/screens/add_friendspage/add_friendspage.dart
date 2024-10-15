import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controller/chat_controller.dart';

class AddFriendsPage extends StatefulWidget {
  @override
  _AddFriendsPageState createState() => _AddFriendsPageState();
}

class _AddFriendsPageState extends State<AddFriendsPage> {
  final _nameController = TextEditingController();
  bool _isAddingFriend = false;

  @override
  Widget build(BuildContext context) {
    final chatController = Provider.of<ChatController>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Add Friends',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/image/frameadd.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isAddingFriend)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 150.0),
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Friend\'s Name',
                        labelStyle: const TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        suffixIcon: IconButton(
                          icon:
                              const Icon(Icons.add_circle, color: Colors.teal),
                          onPressed: () {
                            if (_nameController.text.isNotEmpty) {
                              chatController.addFriend(_nameController.text);
                            }
                            Navigator.pop(context);
                          },
                        ),
                        // border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(12.0),
                        // ),
                      ),
                    ),
                  ),
                SizedBox(height: 200),
                if (!_isAddingFriend)
                  Center(
                    child: IconButton(
                      icon: Icon(Icons.add_circle,
                          size: 50, color: Colors.transparent),
                      onPressed: () {
                        setState(
                          () {
                            _isAddingFriend = !_isAddingFriend;
                          },
                        );
                      },
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
