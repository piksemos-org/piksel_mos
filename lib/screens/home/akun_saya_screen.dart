import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:piksel_mos/screens/auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import placeholder screens
import 'package:piksel_mos/screens/profile/navigasi/menunggu_pembayaran_screen.dart';
import 'package:piksel_mos/screens/profile/navigasi/dalam_proses_screen.dart';
import 'package:piksel_mos/screens/profile/navigasi/desain_saya_screen.dart';
import 'package:piksel_mos/screens/profile/navigasi/alamat_tersimpan_screen.dart';
import 'package:piksel_mos/screens/profile/navigasi/pengaturan_akun_screen.dart';
import 'package:piksel_mos/screens/profile/navigasi/riwayat_screen.dart'; // 4. Tambahkan import baru

class AkunSayaScreen extends StatelessWidget {
  final String userName;
  final String userRole;
  final bool isEmailVerified;

  const AkunSayaScreen({
    super.key,
    required this.userName,
    required this.userRole,
    this.isEmailVerified = false,
  });

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildProfileCard(context, userName: userName, userRole: userRole),
              const SizedBox(height: 16),

              if (!isEmailVerified) _buildVerificationBanner(context),

              _buildMenuGroup(
                context: context,
                title: 'Aktivitas Pesanan',
                items: [
                  _buildMenuTile(
                    context,
                    icon: Icons.wallet_outlined,
                    title: 'Menunggu Pembayaran',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MenungguPembayaranScreen())),
                  ),
                  _buildMenuTile(
                    context,
                    icon: Icons.sync,
                    title: 'Dalam Proses',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DalamProsesScreen())),
                  ),
                  // 4. Tambahkan ListTile untuk Riwayat
                  _buildMenuTile(
                    context,
                    icon: Icons.history_outlined,
                    title: 'Riwayat Pesanan',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RiwayatScreen())),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildMenuGroup(
                context: context,
                title: 'Aset & Data Saya',
                items: [
                  _buildMenuTile(
                    context,
                    icon: Icons.image_outlined,
                    title: 'Desain Saya',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DesainSayaScreen())),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildMenuGroup(
                context: context,
                title: 'History',
                items: [
                  _buildMenuTile(
                    context,
                    icon: Icons.location_on_outlined,
                    title: 'Alamat Tersimpan',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AlamatTersimpanScreen())),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildMenuGroup(
                context: context,
                title: 'Pengaturan & Bantuan',
                items: [
                  _buildMenuTile(
                    context,
                    icon: Icons.settings_outlined,
                    title: 'Pengaturan Akun',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PengaturanAkunScreen())),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('Logout', style: TextStyle(color: Colors.red)),
                  onTap: () => _logout(context),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // ... (semua widget helper lainnya tetap sama) ...
  Widget _buildProfileCard(BuildContext context, {required String userName, required String userRole}) {
    final initials = userName.isNotEmpty ? userName.trim().split(' ').map((l) => l[0]).take(2).join() : '';

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            color: Colors.deepPurple,
            child: Center(
              child: Text(
                initials.toUpperCase(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(userRole,
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () {
                print('Tombol Edit Profil ditekan');
              },
              style: IconButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                foregroundColor: Colors.deepPurple,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationBanner(BuildContext context) {
    return Card(
      color: Colors.amber.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.amber.shade800),
            const SizedBox(width: 12),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context)
                      .style
                      .copyWith(color: Colors.black87),
                  children: <TextSpan>[
                    const TextSpan(text: 'Email Anda belum diverifikasi. '),
                    TextSpan(
                        text: 'Verifikasi sekarang',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            print('Navigasi ke halaman verifikasi email...');
                          }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuGroup({
    required BuildContext context,
    required String title,
    required List<Widget> items,
  }) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _buildMenuTile(BuildContext context, {
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}