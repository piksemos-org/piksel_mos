import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:piksel_mos/screens/auth/reset_password_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailPhoneController = TextEditingController();
  bool _isLoading = false;
  // 3a. State untuk pesan error
  String? _errorMessage;

  @override
  void dispose() {
    _emailPhoneController.dispose();
    super.dispose();
  }

  Future<void> _sendResetCode() async {
    if (_emailPhoneController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Kolom tidak boleh kosong.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final url = Uri.parse('http://178.128.18.30:3000/api/auth/forgot-password');
      final headers = {'Content-Type': 'application/json; charset=UTF-8'};
      final body = json.encode({'emailOrPhone': _emailPhoneController.text});

      final response = await http.post(url, headers: headers, body: body);

      if (mounted) {
        // 3b. Penanganan respons yang lebih detail
        if (response.statusCode == 200) {
          // 1. Sukses
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResetPasswordScreen(
                emailOrPhone: _emailPhoneController.text,
              ),
            ),
          );
        } else if (response.statusCode == 403) {
          // 2. Belum Terverifikasi
          final responseData = json.decode(response.body);
          setState(() {
            _errorMessage = responseData['message'] ?? 'Akun ini belum diverifikasi.';
          });
        } else {
          // 3. Error Lainnya
          final responseData = json.decode(response.body);
          setState(() {
            _errorMessage = responseData['message'] ?? 'Terjadi kesalahan. Silakan coba lagi.';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Gagal terhubung ke server. Periksa koneksi Anda.';
        });
      }
    } finally {
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                Text(
                  'Lupa Password',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Masukkan email atau nomor telepon Anda yang terdaftar. Kami akan mengirimkan kode verifikasi untuk mengatur ulang password Anda.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _emailPhoneController,
                  decoration: const InputDecoration(
                    labelText: 'Email atau Nomor Telepon',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // 3c. Tampilkan Pesan Error di UI
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),

                ElevatedButton(
                  onPressed: _isLoading ? null : _sendResetCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                      : const Text('KIRIM KODE VERIFIKASI'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}