// lib/screens/profile/navigasi/dalam_proses_screen.dart
import 'package:flutter/material.dart';

class DalamProsesScreen extends StatelessWidget {
  const DalamProsesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dalam Proses'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Dalam Proses Screen (Placeholder)'),
      ),
    );
  }
}