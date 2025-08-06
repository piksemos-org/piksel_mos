// lib/screens/home/akun_saya_screen.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:piksel_mos/screens/auth/login_screen.dart';

// Import halaman-halaman navigasi dari lokasi baru
import 'package:piksel_mos/screens/profile/navigasi/riwayat_screen.dart';
import 'package:piksel_mos/screens/profile/navigasi/desain_saya_screen.dart';
import 'package:piksel_mos/screens/profile/navigasi/menunggu_bayar_screen.dart';
import 'package:piksel_mos/screens/profile/navigasi/dalam_proses_screen.dart';

// Import halaman-halaman pengaturan dari lokasi baru
import 'package:piksel_mos/screens/profile/settings/profile_setting_screen.dart';
import 'package:piksel_mos/screens/profile/settings/notification_settings_screen.dart';
import 'package:piksel_mos/screens/profile/settings/chat_piksel_mos_screen.dart';
import 'package:piksel_mos/screens/profile/settings/pusat_bantuan_screen.dart';


class AkunSayaScreen extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String userPhoneNumber;
  final String userRole; // Tambahan: Role pengguna
  final String? userPhotoUrl;

  const AkunSayaScreen({
    super.key,
    this.userName = 'Nama Pengguna',
    this.userEmail = 'email@contoh.com',
    this.userPhoneNumber = '081234567890',
    this.userRole = 'Customer', // Default placeholder role
    this.userPhotoUrl,
  });

  @override
  State<AkunSayaScreen> createState() => _AkunSayaScreenState();
}

class _AkunSayaScreenState extends State<AkunSayaScreen> {
  String _maskPhoneNumber(String phoneNumber) {
    if (phoneNumber.length < 9) return phoneNumber;
    return '${phoneNumber.substring(0, 4)}****${phoneNumber.substring(phoneNumber.length - 4)}';
  }

  void _uploadProfilePicture() {
    print('Buka galeri untuk unggah foto profil');
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
              // Bagian Atas: Info Profil (Foto, Nama, Role, Nomor HP Masking)
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 40, // Radius lebih kecil
                          backgroundColor: Colors.deepPurple.shade100,
                          backgroundImage: widget.userPhotoUrl != null && widget.userPhotoUrl!.isNotEmpty
                              ? CachedNetworkImageProvider(widget.userPhotoUrl!) as ImageProvider<Object>?
                              : null,
                          child: widget.userPhotoUrl == null || widget.userPhotoUrl!.isEmpty
                              ? Icon(
                            Icons.person,
                            size: 40, // Ukuran ikon lebih kecil
                            color: Colors.deepPurple.shade700,
                          )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: _uploadProfilePicture,
                            child: CircleAvatar(
                              radius: 14, // Ukuran tombol kamera lebih kecil
                              backgroundColor: Colors.deepPurple,
                              child: const Icon(
                                Icons.camera_alt,
                                size: 14, // Ukuran ikon kamera lebih kecil
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12), // Jarak disesuaikan
                    Text(
                      widget.userName,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Role: ${widget.userRole}', // Menampilkan Role Pengguna
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _maskPhoneNumber(widget.userPhoneNumber), // Menggunakan nomor HP dari properti widget
                      style: const TextStyle(fontSize: 16, color: Colors.black54), // Warna hitam 54
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Bagian Tengah: Kotak Navigasi "Kontrol Cepat Transaksi" (Grid 2x2)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0), // Padding horizontal lebih besar
                child: GridView.count( // Menggunakan GridView.count karena tidak memerlukan builder untuk data dinamis di sini
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 1.5, // Menyesuaikan rasio aspek untuk kotak lebih compact
                  children: [
                    _buildNavigationCard(
                      context,
                      icon: Icons.history,
                      title: 'Riwayat Pesanan', // Teks diubah
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RiwayatScreen())),
                    ),
                    _buildNavigationCard(
                      context,
                      icon: Icons.design_services, // Ikon baru
                      title: 'Desain Saya',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DesainSayaScreen())),
                    ),
                    _buildNavigationCard(
                      context,
                      icon: Icons.receipt_long, // Ikon baru
                      title: 'Menunggu Bayar', // Teks diubah
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MenungguBayarScreen())),
                    ),
                    _buildNavigationCard(
                      context,
                      icon: Icons.production_quantity_limits, // Ikon baru
                      title: 'Dalam Proses', // Teks diubah
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DalamProsesScreen())),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Bagian Bawah: Opsi Pengaturan & Bantuan (Daftar Vertikal)
              Column(
                children: [
                  _buildSettingTile(
                    context,
                    icon: Icons.settings,
                    title: 'Profile Setting',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileSettingScreen())),
                  ),
                  const Divider(), // Divider
                  _buildSettingTile(
                    context,
                    icon: Icons.notifications,
                    title: 'Pengaturan Notifikasi',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationSettingsScreen())),
                  ),
                  const Divider(), // Divider
                  _buildSettingTile(
                    context,
                    icon: Icons.chat,
                    title: 'Chat Piksel.mos',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatPikselMosScreen())),
                  ),
                  const Divider(), // Divider
                  _buildSettingTile(
                    context,
                    icon: Icons.help_outline,
                    title: 'Pusat Bantuan',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PusatBantuanScreen())),
                  ),
                  const Divider(), // Divider
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
          padding: const EdgeInsets.all(8.0), // Padding disesuaikan agar lebih kecil
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: Colors.deepPurple), // Ukuran ikon disesuaikan
              const SizedBox(height: 4), // Spasi dikurangi
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600), // Ukuran teks disesuaikan
                maxLines: 2, // Batasi teks menjadi 2 baris
                overflow: TextOverflow.ellipsis, // Tambahkan ellipsis jika melebihi 2 baris
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
    return InkWell( // Menggunakan InkWell untuk efek visual pada tile
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.0),
      child: Card(
        elevation: 0, // Card tanpa elevasi agar terlihat seperti ListTile biasa
        margin: EdgeInsets.zero, // Hilangkan margin default Card
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0), // Padding vertikal konsisten
          child: ListTile(
            leading: Icon(icon, color: Colors.deepPurple),
            title: Text(title),
            trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
            // onTap dihapus dari ListTile karena sudah ditangani oleh InkWell Card
          ),
        ),
      ),
    );
  }
}