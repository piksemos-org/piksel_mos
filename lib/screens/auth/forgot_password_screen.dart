import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:piksel_mos/screens/auth/reset_password_screen.dart';
import 'package:piksel_mos/utils/validators.dart';
import 'package:piksel_mos/config/api_constants.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // 2. Kunci untuk mengelola state Form
  final _formKey = GlobalKey<FormState>();

  final _emailPhoneController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailPhoneController.dispose();
    super.dispose();
  }

  Future<void> _sendResetCode() async {
    // 3. Trigger validasi pada form sebelum mengirim
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final url = Uri.parse(ApiConstants.forgotPassword);
        final headers = {'Content-Type': 'application/json; charset=UTF-8'};
        final body = json.encode({'emailOrPhone': _emailPhoneController.text});

        final response = await http.post(url, headers: headers, body: body);

        if (mounted) {
          final responseData = json.decode(response.body);
          if (response.statusCode == 200) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResetPasswordScreen(
                  emailOrPhone: _emailPhoneController.text,
                ),
              ),
            );
          } else {
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
            // 2. Bungkus kolom dengan Form
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  // 4. Ubah TextField menjadi TextFormField dan terapkan validasi
                  TextFormField(
                    controller: _emailPhoneController,
                    decoration: const InputDecoration(
                      labelText: 'Email atau Nomor Telepon',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Kolom ini tidak boleh kosong.';
                      }
                      // Cek apakah input mengandung '@', jika ya, validasi sebagai email
                      if (value.contains('@')) {
                        return Validators.validateEmail(value);
                      }
                      // Jika tidak, validasi sebagai nomor telepon
                      return Validators.validatePhone(value);
                    },
                  ),
                  const SizedBox(height: 16),
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
      ),
    );
  }
}