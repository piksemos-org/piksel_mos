// lib/screens/profile/navigasi/di_proses_screen.dart
import 'package:flutter/material.dart';

class DiProsesScreen extends StatelessWidget {
  const DiProsesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Di Proses'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Di Proses Screen (Placeholder)'),
      ),
    );
  }
}