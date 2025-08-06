// lib/screens/profile/navigasi/profile_setting_screen.dart
import 'package:flutter/material.dart';

class ProfileSettingScreen extends StatelessWidget {
  const ProfileSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Setting'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Profile Setting Screen (Placeholder)'),
      ),
    );
  }
}