// lib/screens/profile/navigasi/menunggu_bayar_screen.dart
import 'package:flutter/material.dart';

class MenungguBayarScreen extends StatelessWidget {
  const MenungguBayarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menunggu Bayar'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Menunggu Bayar Screen (Placeholder)'),
      ),
    );
  }
}