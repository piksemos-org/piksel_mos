// lib/screens/home/akun_saya_screen.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Untuk foto profil dari network
import 'package:piksel_mos/screens/auth/login_screen.dart'; // Untuk navigasi logout

// Import halaman-halaman navigasi placeholder yang baru dibuat/dipindahkan
import 'package:piksel_mos/screens/profile/navigasi/riwayat_screen.dart';
import 'package:piksel_mos/screens/profile/navigasi/saldo_anda_screen.dart';
import 'package:piksel_mos/screens/profile/navigasi/belum_dibayar_screen.dart';
import 'package:piksel_mos/screens/profile/navigasi/di_proses_screen.dart';
import 'package:piksel_mos/screens/profile/settings/profile_settings_screen.dart';
import 'package:piksel_mos/screens/profile/settings/notification_settings_screen.dart';
import 'package:piksel_mos/screens/profile/settings/chat_piksel_mos_screen.dart';
import 'package:piksel_mos/screens/profile/settings/pusat_bantuan_screen.dart';


class AkunSayaScreen extends StatefulWidget { // Diubah menjadi StatefulWidget
  // Data pengguna yang akan diterima dari LoginScreen atau penyimpanan lokal
  final String userName;
  final String userEmail;
  final String userPhoneNumber;
  final String? userPhotoUrl; // Opsional, jika ada URL foto profil

  const AkunSayaScreen({
    super.key,
    this.userName = 'Nama Pengguna', // Default placeholder
    this.userEmail = 'email@contoh.com', // Default placeholder
    this.userPhoneNumber = '081234567890', // Default placeholder
    this.userPhotoUrl,
  });

  @override
  State<AkunSayaScreen> createState() => _AkunSayaScreenState();
}

class _AkunSayaScreenState extends State<AkunSayaScreen> {

  // Fungsi utility untuk masking nomor HP
  String _maskPhoneNumber(String phoneNumber) {
    if (phoneNumber.length < 9) return phoneNumber; // Minimal panjang untuk masking
    return '${phoneNumber.substring(0, 4)}****${phoneNumber.substring(phoneNumber.length - 4)}';
  }

  // Placeholder untuk fungsi unggah foto
  void _uploadProfilePicture() {
    print('Buka galeri untuk unggah foto profil');
    // Implementasi real akan melibatkan image_picker package dan upload ke server
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
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.deepPurple.shade100,
                          backgroundImage: widget.userPhotoUrl != null && widget.userPhotoUrl!.isNotEmpty
                              ? CachedNetworkImageProvider(widget.userPhotoUrl!) as ImageProvider<Object>?
                              : null,
                          child: widget.userPhotoUrl == null || widget.userPhotoUrl!.isEmpty
                              ? Icon(
                            Icons.person,
                            size: 60,
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
                              radius: 18,
                              backgroundColor: Colors.deepPurple,
                              child: const Icon(
                                Icons.camera_alt,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.userName, // Menggunakan nama pengguna dari properti widget
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _maskPhoneNumber(widget.userPhoneNumber), // Menggunakan nomor HP dari properti widget
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.userEmail, // Menampilkan email
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Bagian Tengah: Kotak Navigasi (Grid 2x2 yang Lebih Kecil)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0), // Menyesuaikan padding untuk efek lebih luas
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 1.8, // Menyesuaikan rasio aspek agar kotak lebih kecil
                  children: [
                    _buildNavigationCard(
                      context,
                      icon: Icons.history,
                      title: 'Riwayat',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RiwayatScreen())),
                    ),
                    _buildNavigationCard(
                      context,
                      icon: Icons.account_balance_wallet,
                      title: 'Saldo Anda',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SaldoAndaScreen())),
                    ),
                    _buildNavigationCard(
                      context,
                      icon: Icons.receipt, // Ikon baru untuk Belum Bayar
                      title: 'Belum Bayar',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BelumDibayarScreen())),
                    ),
                    _buildNavigationCard(
                      context,
                      icon: Icons.local_shipping,
                      title: 'Di Proses',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DiProsesScreen())),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Bagian Bawah: Opsi Pengaturan (Vertical List)
              Column(
                children: [
                  _buildSettingTile(
                    context,
                    icon: Icons.settings, // Ikon baru untuk Profile Setting
                    title: 'Profile Setting',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileSettingScreen())),
                  ),
                  const SizedBox(height: 10),
                  _buildSettingTile(
                    context,
                    icon: Icons.notifications,
                    title: 'Pengaturan Notifikasi',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationSettingsScreen())),
                  ),
                  const SizedBox(height: 10),
                  _buildSettingTile(
                    context,
                    icon: Icons.chat,
                    title: 'Chat Piksel.mos',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatPikselMosScreen())),
                  ),
                  const SizedBox(height: 10),
                  _buildSettingTile(
                    context,
                    icon: Icons.help_outline,
                    title: 'Pusat Bantuan',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PusatBantuanScreen())),
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