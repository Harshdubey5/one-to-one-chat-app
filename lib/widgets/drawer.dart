import 'package:chat/auth/auth_services.dart';
import 'package:chat/pages/settingspage.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout() {
    // get auth service
    final auth = AuthService();
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                child: Center(
                  child: Icon(
                    Icons.message,
                    color: Theme.of(context).colorScheme.primary,
                    size: 40,
                  ),
                ),
              ),
              // homelist tile
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: ListTile(
                  title: const Text('H O M E'),
                  leading: const Icon(Icons.home),
                  onTap: () {},
                ),
              ),
              // settingslist tile
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: ListTile(
                  title: const Text('S E T T I N G S'),
                  leading: const Icon(Icons.settings),
                  onTap: () {
                    // pop the drawer
                    Navigator.pop(context);
                    // navigate to settings page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          // logoutlist tile
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 20),
            child: ListTile(
              title: const Text('L O G O U T'),
              leading: const Icon(Icons.logout),
              onTap: logout,
            ),
          ),
        ],
      ),
    );
  }
}
