// lib/screens/profile/navigasi/belum_dibayar_screen.dart
import 'package:flutter/material.dart';

class BelumDibayarScreen extends StatelessWidget {
  const BelumDibayarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Belum Dibayar'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Belum Dibayar Screen (Placeholder)'),
      ),
    );
  }
}