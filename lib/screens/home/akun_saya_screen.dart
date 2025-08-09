import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:piksel_mos/screens/auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:piksel_mos/config/api_constants.dart';

// Import placeholder screens
import 'package:piksel_mos/screens/profile/navigasi/menunggu_pembayaran_screen.dart';
import 'package:piksel_mos/screens/profile/navigasi/dalam_proses_screen.dart';
import 'package:piksel_mos/screens/profile/navigasi/desain_saya_screen.dart';
import 'package:piksel_mos/screens/profile/navigasi/alamat_tersimpan_screen.dart';
import 'package:piksel_mos/screens/profile/navigasi/pengaturan_akun_screen.dart';

class AkunSayaScreen extends StatefulWidget {
  final String userName;
  final String userRole;
  final bool isEmailVerified;
  final String? userPhotoUrl;

  const AkunSayaScreen({
    super.key,
    required this.userName,
    required this.userRole,
    required this.isEmailVerified,
    this.userPhotoUrl,
  });

  @override
  State<AkunSayaScreen> createState() => _AkunSayaScreenState();
}

class _AkunSayaScreenState extends State<AkunSayaScreen> {
  String? _currentPhotoUrl;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _currentPhotoUrl = widget.userPhotoUrl;
  }

  Future<void> _pickAndUploadImage() async {
    setState(() {
      _isUploading = true;
    });

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        var url = Uri.parse('ApiConstants.uploadPhoto/api/users/upload-photo');
        var request = http.MultipartRequest('POST', url);

        request.files.add(await http.MultipartFile.fromPath(
          'profile_picture',
          pickedFile.path,
        ));
        request.fields['userId'] = '1'; // Dummy user ID

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        if (mounted) {
          if (response.statusCode == 200) {
            final responseData = json.decode(response.body);
            // --- PERBAIKAN UTAMA DI SINI ---
            // Membaca URL dari dalam "amplop" data
            setState(() {
              _currentPhotoUrl = responseData['data']['photoUrl'];
            });
            // --- AKHIR PERBAIKAN ---
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Foto profil berhasil diperbarui!'), backgroundColor: Colors.green),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Gagal mengunggah foto.'), backgroundColor: Colors.red),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Terjadi kesalahan. Coba lagi.'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

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
              _buildProfileCard(context),
              const SizedBox(height: 16),
              if (!widget.isEmailVerified) _buildVerificationBanner(context),
              _buildMenuGroup(
                context: context,
                title: 'Aktivitas Pesanan',
                items: [
                  _buildMenuTile(context, icon: Icons.wallet_outlined, title: 'Menunggu Pembayaran', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MenungguPembayaranScreen()))),
                  _buildMenuTile(context, icon: Icons.sync, title: 'Dalam Proses', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DalamProsesScreen()))),
                ],
              ),
              const SizedBox(height: 16),
              _buildMenuGroup(
                context: context,
                title: 'Aset & Data Saya',
                items: [
                  _buildMenuTile(context, icon: Icons.image_outlined, title: 'Desain Saya', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DesainSayaScreen()))),
                ],
              ),
              const SizedBox(height: 16),
              _buildMenuGroup(
                context: context,
                title: 'History',
                items: [
                  _buildMenuTile(context, icon: Icons.location_on_outlined, title: 'Alamat Tersimpan', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AlamatTersimpanScreen()))),
                ],
              ),
              const SizedBox(height: 16),
              _buildMenuGroup(
                context: context,
                title: 'Pengaturan & Bantuan',
                items: [
                  _buildMenuTile(context, icon: Icons.settings_outlined, title: 'Pengaturan Akun', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PengaturanAkunScreen()))),
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

  Widget _buildProfileCard(BuildContext context) {
    final initials = widget.userName.isNotEmpty ? widget.userName.trim().split(' ').map((l) => l[0]).take(2).join() : '';
    final fullPhotoUrl = _currentPhotoUrl != null ? 'ApiConstants.akunSayaScreen$_currentPhotoUrl' : null;

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: Row(
        children: [
          GestureDetector(
            onTap: _isUploading ? null : _pickAndUploadImage,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(16)
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (fullPhotoUrl != null)
                    CachedNetworkImage(
                      imageUrl: fullPhotoUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: Colors.white)),
                      errorWidget: (context, url, error) => const Center(child: Icon(Icons.error, color: Colors.white)),
                    )
                  else
                    Center(
                      child: Text(
                        initials.toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                      ),
                    ),

                  if (_isUploading)
                    Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(child: CircularProgressIndicator(color: Colors.white)),
                    ),
                ],
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
                    widget.userName,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(widget.userRole, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () { print('Tombol Edit Profil ditekan'); },
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