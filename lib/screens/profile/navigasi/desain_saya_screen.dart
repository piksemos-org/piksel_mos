// lib/screens/profile/navigasi/desain_saya_screen.dart
import 'package:flutter/material.dart';

class DesainSayaScreen extends StatelessWidget {
  const DesainSayaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Desain Saya'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Desain Saya Screen (Placeholder)'),
      ),
    );
  }
}