import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:piksel_mos/screens/auth/register_screen.dart';
import 'package:piksel_mos/screens/auth/forgot_password_screen.dart';
import 'package:piksel_mos/screens/home/home_screen.dart'; // Import halaman home

class LoginScreen extends StatefulWidget {
  final String? initialMessage;
  const LoginScreen({super.key, this.initialMessage});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 3a. State Management
  final _emailPhoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  bool _isLoading = false;
  String? _errorMessage;
  String? _notificationMessage;

  @override
  void initState() {
    super.initState();
    // Menampilkan pesan awal jika ada (misalnya setelah verifikasi berhasil)
    if (widget.initialMessage != null) {
      // Menampilkan SnackBar setelah frame pertama selesai build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.initialMessage!),
            backgroundColor: Colors.green,
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _emailPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 3b. Implementasi fungsi _performLogin()
  Future<void> _performLogin() async {
    // 1. Mulai Loading
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _notificationMessage = null;
    });

    try {
      // 2. Ambil Data
      final identifier = _emailPhoneController.text;
      final password = _passwordController.text;

      // 3. Kirim ke Server
      final url = Uri.parse('http://178.128.18.30:3000/api/auth/login');
      final headers = {'Content-Type': 'application/json; charset=UTF-8'};
      final body = json.encode({
        'identifier': identifier,
        'password': password,
      });

      final response = await http.post(url, headers: headers, body: body);
      final responseData = json.decode(response.body);

      // 4. Tangani Respons
      if (mounted) {
        if (response.statusCode == 200) {
          // --- Sukses ---
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else if (response.statusCode == 403) {
          // --- Belum Terverifikasi ---
          setState(() {
            _notificationMessage = responseData['message'] ?? 'Akun Anda belum terverifikasi.';
          });
        } else if (response.statusCode == 401) {
          // --- Kredensial Salah ---
          setState(() {
            _errorMessage = responseData['message'] ?? 'Email/Telepon atau Password salah.';
          });
        } else {
          // --- Error Lain dari Server ---
          setState(() {
            _errorMessage = responseData['message'] ?? 'Terjadi kesalahan tidak diketahui.';
          });
        }
      }
    } catch (e) {
      // --- Error Koneksi ---
      if (mounted) {
        setState(() {
          _errorMessage = 'Gagal terhubung ke server. Periksa koneksi Anda.';
        });
      }
    } finally {
      // 5. Selesai Loading
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 48),
                const Icon(
                  Icons.print,
                  size: 64,
                  color: Colors.deepPurple,
                ),
                const SizedBox(height: 48),

                // c. Feedback Visual (Pesan Notifikasi - Kuning/Oranye)
                if (_notificationMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      _notificationMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                    ),
                  ),

                TextField(
                  controller: _emailPhoneController,
                  decoration: const InputDecoration(
                    labelText: 'Email atau Nomor Telepon',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                // ... (Link Lupa Password tetap sama) ...
                const SizedBox(height: 24),

                // c. Feedback Visual (Pesan Error - Merah)
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),

                // c. Feedback Visual (Tombol Loading)
                ElevatedButton(
                  onPressed: _isLoading ? null : _performLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                  )
                      : const Text('MASUK'),
                ),
                // ... (Sisa UI tetap sama)
              ],
            ),
          ),
        ),
      ),
    );
  }
}