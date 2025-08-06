// lib/screens/home/akun_saya_screen.dart
import 'package:flutter/material.dart';
import 'package:piksel_mos/screens/auth/login_screen.dart'; // Untuk navigasi logout

class AkunSayaScreen extends StatelessWidget {
  const AkunSayaScreen({super.key});

  // Fungsi utility untuk masking nomor HP
  String _maskedPhoneNumber(String phone) {
    if (phone.length < 8) return phone; // Jika terlalu pendek, tidak di-mask
    return '${phone.substring(0, 4)}****${phone.substring(phone.length - 4)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Bagian Atas: Profil Pengguna (Foto, Nama, Nomor HP)
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.deepPurple.shade100,
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.deepPurple.shade700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Nama Pengguna', // Placeholder Nama Pengguna
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _maskedPhoneNumber('085157447507'), // Placeholder Nomor HP dengan masking
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Bagian Tengah: Kotak Navigasi (Grid 2x2)
              GridView.count(
                shrinkWrap: true, // Agar GridView mengambil ruang sesuai isinya
                physics: const NeverScrollableScrollPhysics(), // Nonaktifkan scrolling GridView
                crossAxisCount: 2, // 2 kolom
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: [
                  _buildNavigationCard(
                    context,
                    icon: Icons.history,
                    title: 'Riwayat',
                    onTap: () => print('Navigasi ke Riwayat'),
                  ),
                  _buildNavigationCard(
                    context,
                    icon: Icons.account_balance_wallet,
                    title: 'Saldo Anda',
                    onTap: () => print('Navigasi ke Saldo Anda'),
                  ),
                  _buildNavigationCard(
                    context,
                    icon: Icons.payment,
                    title: 'Belum Bayar',
                    onTap: () => print('Navigasi ke Belum Bayar'),
                  ),
                  _buildNavigationCard(
                    context,
                    icon: Icons.local_shipping,
                    title: 'Di Proses',
                    onTap: () => print('Navigasi ke Di Proses'),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Bagian Bawah: Opsi Pengaturan (Vertical List)
              Column(
                children: [
                  _buildSettingTile(
                    context,
                    icon: Icons.security,
                    title: 'Keamanan Ganda',
                    onTap: () => print('Navigasi ke Profile Setting (Keamanan Ganda)'),
                  ),
                  const SizedBox(height: 10),
                  _buildSettingTile(
                    context,
                    icon: Icons.notifications,
                    title: 'Pengaturan Notifikasi',
                    onTap: () => print('Navigasi ke Notification Settings'),
                  ),
                  const SizedBox(height: 10),
                  _buildSettingTile(
                    context,
                    icon: Icons.chat,
                    title: 'Chat Piksel.mos',
                    onTap: () => print('Buka Chat CS'),
                  ),
                  const SizedBox(height: 10),
                  _buildSettingTile(
                    context,
                    icon: Icons.help_outline,
                    title: 'Pusat Bantuan',
                    onTap: () => print('Navigasi ke Pusat Bantuan'),
                  ),
                  const SizedBox(height: 24),
                  // Tombol Logout
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.red, size: 18),
                    onTap: () {
                      // Fungsionalitas Logout: Kembali ke LoginScreen dan hapus semua route
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                            (Route<dynamic> route) => false,
                      );
                      print('User Logout');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget pembangun untuk kartu navigasi di bagian tengah
  Widget _buildNavigationCard(BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: Colors.deepPurple),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget pembangun untuk item pengaturan di bagian bawah
  Widget _buildSettingTile(BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}