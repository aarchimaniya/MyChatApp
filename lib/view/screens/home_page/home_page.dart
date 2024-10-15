import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:my_chat_app/view/screens/home_page/setting_page.dart';
import 'package:provider/provider.dart';

import '../../../controller/chat_controller.dart';
import '../../../controller/themeprovider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _advancedDrawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    final chatController = Provider.of<ChatController>(context);
    final user = FirebaseAuth.instance.currentUser;
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return AdvancedDrawer(
      backdropColor: const Color(0xFF0c0701),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: false,
      childDecoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
        borderRadius: BorderRadius.circular(20),
      ),
      drawer: SafeArea(
        child: ListTileTheme(
          textColor: Colors.white,
          iconColor: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                accountName: Text(user?.displayName ?? 'User Name'),
                accountEmail: Text(user?.email ?? 'Email not available'),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: user?.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : AssetImage('lib/assets/image/img.png') as ImageProvider,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.group_add),
                title: const Text('Add Friends'),
                onTap: () {
                  Navigator.pushNamed(context, '/add-friends');
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Sign Out'),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, '/sign-in');
                },
              ),
              const Spacer(),
              ListTile(
                leading: const Icon(Icons.close),
                title: const Text('Close Drawer'),
                onTap: () {
                  _advancedDrawerController.hideDrawer();
                },
              ),
            ],
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: Color(0xFFFAFAFA),
        appBar: AppBar(
          backgroundColor: Color(0xFFFAFAFA),
          title: const Text(
            'Home',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _advancedDrawerController.showDrawer();
            },
          ),
        ),
        body: ListView.builder(
          itemCount: chatController.friends.length,
          itemBuilder: (context, index) {
            final friend = chatController.friends[index];
            return ListTile(
              title: Text(
                friend.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/chat', arguments: friend);
              },
            );
          },
        ),
      ),
    );
  }
}
