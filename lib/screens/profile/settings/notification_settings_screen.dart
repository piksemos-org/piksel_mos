// lib/screens/profile/navigasi/notification_settings_screen.dart
import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Notifikasi'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Pengaturan Notifikasi Screen (Placeholder)'),
      ),
    );
  }
}