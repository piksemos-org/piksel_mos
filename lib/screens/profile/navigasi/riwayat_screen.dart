// lib/screens/profile/navigasi/riwayat_screen.dart
import 'package:flutter/material.dart';

class RiwayatScreen extends StatelessWidget {
  const RiwayatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Riwayat Screen (Placeholder)'),
      ),
    );
  }
}