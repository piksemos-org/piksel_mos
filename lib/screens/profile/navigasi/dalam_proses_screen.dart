import 'package:flutter/material.dart';

class DalamProsesScreen extends StatelessWidget {
  const DalamProsesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dalam Proses')),
      body: const Center(child: Text('Halaman Dalam Proses')),
    );
  }
}