import 'package:flutter/material.dart';
import 'package:piksel_mos/screens/home/home_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 3. STRUKTUR & LAYOUT UTAMA
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade900,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              // 4a. Judul Halaman
              const Text(
                'Jelajahi Fitur Andalan Kami',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 48),

              // 4b. Checklist Interaktif
              _buildFeatureCard(
                icon: Icons.verified_user_outlined,
                title: 'Kenali Validator Cerdas Kami',
                description: 'Cegah kesalahan cetak dengan pengecekan file otomatis.',
              ),
              const SizedBox(height: 16),
              _buildFeatureCard(
                icon: Icons.brush_outlined,
                title: 'Temukan Desainer di Piksel Studio',
                description: 'Wujudkan idemu bersama desainer profesional kami.',
              ),
              const SizedBox(height: 16),
              _buildFeatureCard(
                icon: Icons.local_shipping_outlined,
                title: 'Lacak Pesananmu dengan Mudah',
                description: 'Lihat status pesanan dari dicetak hingga tiba di tujuan.',
              ),
              const Spacer(flex: 3),

              // 4c. Tombol Aksi
              ElevatedButton(
                onPressed: () {
                  // 5. Fungsionalitas Navigasi
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                        (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('MASUK KE APLIKASI', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  // 5. Fungsionalitas Navigasi (Sama dengan tombol utama)
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                        (route) => false,
                  );
                },
                child: const Text(
                  'Lewati untuk Sekarang',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget untuk membuat kartu fitur agar kode tidak berulang (prinsip DRY)
  Widget _buildFeatureCard({required IconData icon, required String title, required String description}) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.deepPurple.shade700),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}