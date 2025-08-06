import 'package:flutter/material.dart';

class PikselStudioScreen extends StatelessWidget {
  const PikselStudioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Piksel Studio')),
      body: const Center(child: Text('Halaman Piksel Studio')),
    );
  }
}