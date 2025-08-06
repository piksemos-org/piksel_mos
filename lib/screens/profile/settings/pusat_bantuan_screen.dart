// lib/screens/profile/navigasi/pusat_bantuan_screen.dart
import 'package:flutter/material.dart';

class PusatBantuanScreen extends StatelessWidget {
  const PusatBantuanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pusat Bantuan'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Pusat Bantuan Screen (Placeholder)'),
      ),
    );
  }
}