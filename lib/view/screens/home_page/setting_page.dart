import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controller/themeprovider.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    final wallpapers = [
      'https://i.pinimg.com/564x/78/3e/b7/783eb7685687941720eef23cda90f650.jpg',
      'https://i.pinimg.com/564x/1e/02/d7/1e02d720cfdbb424410526fc6d026d18.jpg',
      'https://i.pinimg.com/564x/fa/a5/1d/faa51dfc8b45bb9b1d4316286ccb12eb.jpg',
      'https://i.pinimg.com/564x/1e/29/8f/1e298f3c7e3a60120f332d2cfcd46dbc.jpg',
      'https://i.pinimg.com/564x/7c/29/29/7c2929ff41f2406df117969a5bf46bf7.jpg',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Preferences',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: themeNotifier.isDarkTheme,
              onChanged: (value) {
                themeNotifier.toggleTheme();
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Wallpaper',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: wallpapers.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      themeNotifier.setWallpaper(wallpapers[index]);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: themeNotifier.wallpaperUrl == wallpapers[index]
                              ? Colors.blue
                              : Colors.transparent,
                        ),
                      ),
                      child: Image.network(
                        wallpapers[index],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
