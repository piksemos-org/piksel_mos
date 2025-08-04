import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import package http
import 'dart:convert'; // Import untuk json encoding

import 'package:piksel_mos/screens/auth/verification_screen.dart'; // Import halaman verifikasi

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // 3a. Persiapan State Management
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  // Fungsi untuk membersihkan controller saat widget tidak lagi digunakan
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // 3b. Implementasi Logika Tombol "DAFTAR"
  Future<void> _register() async {
    // 1. Validasi dasar di sisi aplikasi
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Semua kolom wajib diisi.';
      });
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Password dan konfirmasi password tidak cocok.';
      });
      return;
    }

    // 2. Mulai loading
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 3. Kirim Data ke Server (Koneksi Nyata)
      final url = Uri.parse('http://178.128.18.30:3000/api/auth/register');
      final headers = {'Content-Type': 'application/json; charset=UTF-8'};
      final body = json.encode({
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'password': _passwordController.text,
      });

      final response = await http.post(url, headers: headers, body: body);

      // 4. Tangani Respons Server
      if (response.statusCode == 201) {
        // Pendaftaran berhasil
        if (mounted) { // Cek apakah widget masih ada di tree
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const VerificationScreen()),
          );
        }
      } else {
        // Pendaftaran gagal
        final responseData = json.decode(response.body);
        setState(() {
          _errorMessage = responseData['message'] ?? 'Terjadi kesalahan saat registrasi.';
        });
      }
    } catch (e) {
      // Tangani error koneksi
      setState(() {
        _errorMessage = 'Gagal terhubung ke server. Periksa koneksi internet Anda.';
      });
    } finally {
      // 5. Selesai Loading
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // ... (AppBar tetap sama)
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ... (Judul dan teks lainnya tetap sama)

                // Hubungkan controller ke setiap TextField
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nama Lengkap', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Nomor Telepon', border: OutlineInputBorder()),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true, // Untuk simplicity, fitur show/hide dihilangkan sementara
                  decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Konfirmasi Password', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),

                // c. Feedback Visual di UI (Error Message)
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // Tombol Aksi "DAFTAR"
                ElevatedButton(
                  onPressed: _isLoading ? null : _register, // Tombol disable saat loading
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                  // c. Feedback Visual di UI (Loading Indicator)
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                      : const Text('DAFTAR'),
                ),
                // ... (Sisa widget tetap sama)
              ],
            ),
          ),
        ),
      ),
    );
  }
}