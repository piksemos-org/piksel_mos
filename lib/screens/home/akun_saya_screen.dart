import 'package:flutter/material.dart';

class AkunSayaScreen extends StatelessWidget {
  const AkunSayaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Akun Saya')),
      body: const Center(child: Text('Halaman Akun Saya')),
    );
  }
}