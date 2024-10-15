import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_chat_app/view/screens/add_friendspage/add_friendspage.dart';
import 'package:my_chat_app/view/screens/chat_page/chat_page.dart';
import 'package:my_chat_app/view/screens/home_page/home_page.dart';
import 'package:my_chat_app/view/screens/home_page/setting_page.dart';
import 'package:my_chat_app/view/screens/signin_page/signin_page.dart';
import 'package:my_chat_app/view/screens/splash_screen/splash_screen.dart';
import 'package:provider/provider.dart';

import 'controller/chat_controller.dart';
import 'controller/themeprovider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatController()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Chat App',
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            initialRoute: '/',
            routes: {
              '/': (context) => SplashScreen(),
              '/sign-in': (context) => SignInPage(),
              '/home': (context) => HomePage(),
              '/add-friends': (context) => AddFriendsPage(),
              '/chat': (context) => ChatPage(),
              '/setting': (context) => SettingsPage(),
            },
          );
        },
      ),
    );
  }
}
