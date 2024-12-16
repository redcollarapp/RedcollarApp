import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'settings_screen.dart';
import 'signin_Screen.dart';

class ProfileControllerScreen extends StatelessWidget {
  const ProfileControllerScreen({super.key});

  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  bool isAdmin(User? user) {
    // Replace this logic with your actual admin validation, such as checking roles in Firebase
    const adminEmail = 'redcollar@gmail.com';
    return user?.email == adminEmail;
  }

  @override
  Widget build(BuildContext context) {
    final user = getCurrentUser();
    final email = user?.email ?? 'Guest';
    final photoURL = user?.photoURL;
    final isUserAdmin = isAdmin(user);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Profile Header
          GestureDetector(
            onTap: () {
              if (photoURL != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullScreenProfileImage(
                      photoURL: photoURL,
                    ),
                  ),
                );
              }
            },
            child: Hero(
              tag: 'profile-pic',
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                color: Colors.grey[900],
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          photoURL != null ? NetworkImage(photoURL) : null,
                      child: photoURL == null
                          ? const Icon(Icons.person,
                              size: 50, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      email,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Options
          if (isUserAdmin)
            ListTile(
              leading: const Icon(Icons.dashboard, color: Colors.black),
              title: const Text('Dashboard'),
              subtitle: const Text('View admin dashboard and stats'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Navigate to the admin-only dashboard
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminDashboardScreen(),
                  ),
                );
              },
            ),
          if (isUserAdmin) const Divider(),

          ListTile(
            leading: const Icon(Icons.settings, color: Colors.black),
            title: const Text('Settings'),
            subtitle: const Text('Adjust your preferences'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout'),
            subtitle: const Text('Sign out from your account'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const SignInScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

class FullScreenProfileImage extends StatelessWidget {
  final String? photoURL;

  const FullScreenProfileImage({super.key, required this.photoURL});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
            tag: 'profile-pic',
            child: CircleAvatar(
              radius: 150,
              backgroundImage:
                  photoURL != null ? NetworkImage(photoURL!) : null,
              child: photoURL == null
                  ? const Icon(Icons.person, size: 150, color: Colors.white)
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: const Center(
        child: Text(
          'Admin Dashboard',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
