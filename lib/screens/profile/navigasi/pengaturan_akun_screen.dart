import 'package:flutter/material.dart';

class PengaturanAkunScreen extends StatelessWidget {
  const PengaturanAkunScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan Akun')),
      body: const Center(child: Text('Halaman Pengaturan Akun')),
    );
  }
}