import 'package:flutter/material.dart';
import 'package:notepad_with_isar/components/drawer_title.dart';
import 'package:notepad_with_isar/pages/settings_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      
      child: Column(
        children: [
          // header
          const DrawerHeader(
            child: Icon(Icons.edit),
          ),
          const SizedBox(
            height: 25,
          ),

          //notes tile
          DrawerTitle(
            title: 'Notes',
            leading: const Icon(Icons.home),
            onTap: () => Navigator.pop(context),
          ),

          //settings title
          DrawerTitle(
            title: 'Settings',
            leading: const Icon(Icons.settings),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
