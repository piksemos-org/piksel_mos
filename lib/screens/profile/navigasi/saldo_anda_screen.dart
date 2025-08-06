// lib/screens/profile/navigasi/saldo_anda_screen.dart
import 'package:flutter/material.dart';

class SaldoAndaScreen extends StatelessWidget {
  const SaldoAndaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saldo Anda'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Saldo Anda Screen (Placeholder)'),
      ),
    );
  }
}