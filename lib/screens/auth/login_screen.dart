// lib/screens/auth/login_screen.dart
import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:piksel_mos/screens/auth/register_screen.dart';
import 'package:piksel_mos/screens/auth/forgot_password_screen.dart';
import 'package:piksel_mos/screens/home/main_screen_wrapper.dart';
import 'package:piksel_mos/config/api_constants.dart';


class LoginScreen extends StatefulWidget {
  final String? initialMessage;
  const LoginScreen({super.key, this.initialMessage});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  String? _notificationMessage;
  String? _loginErrorMessage;

  final TextEditingController _emailPhoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _notificationMessage = widget.initialMessage;
  }

  @override
  void dispose() {
    _emailPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _performLogin() async {
    setState(() {
      _isLoading = true;
      _loginErrorMessage = null;
      _notificationMessage = null;
    });

    final String identifier = _emailPhoneController.text.trim();
    final String password = _passwordController.text.trim();

    if (identifier.isEmpty || password.isEmpty) {
      setState(() {
        _loginErrorMessage = 'Email/Nomor Telepon dan Password harus diisi.';
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('ApiConstants.login/api/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'identifier': identifier,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseData['status'] == 'success') {
          // Login berhasil, navigasi ke MainScreenWrapper
          final String userName = responseData['data']['name'] ?? 'Pengguna';
          final String userEmail = responseData['data']['email'] ?? 'email@contoh.com';
          final String userPhoneNumber = responseData['data']['phone'] ?? identifier;
          final String userRole = responseData['data']['role'] ?? 'Customer';
          final String? userPhotoUrl = responseData['data']['photo_url'];
          // DEFINISIKAN VARIABEL isEmailVerified DI SINI
          final bool isEmailVerified = responseData['data']['is_email_verified'] ?? false;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreenWrapper(
                userName: userName,
                userEmail: userEmail,
                userPhoneNumber: userPhoneNumber,
                userRole: userRole,
                userPhotoUrl: userPhotoUrl,
                isEmailVerified: isEmailVerified, // Sekarang variabelnya sudah ada
              ),
            ),
          );
        } else {
          setState(() {
            _loginErrorMessage = responseData['message'] ?? 'Login gagal. Silakan coba lagi.';
          });
        }
      } else if (response.statusCode == 401) {
        setState(() {
          _loginErrorMessage = responseData['message'] ?? 'Email/Telepon atau Password salah.';
        });
      } else if (response.statusCode == 403) {
        String message = responseData['message'] ?? 'Akun Anda belum diverifikasi.';
        setState(() {
          _notificationMessage = message;
          _loginErrorMessage = null;
        });
      } else {
        setState(() {
          _loginErrorMessage = responseData['message'] ?? 'Terjadi kesalahan saat login. Silakan coba lagi.';
        });
      }
    } catch (e) {
      setState(() {
        _loginErrorMessage = 'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.';
      });
      print('Login error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
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
                if (_notificationMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      _notificationMessage!,
                      style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                SizedBox(height: _notificationMessage != null ? 16 : 48),
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
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                if (_loginErrorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      _loginErrorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                      );
                    },
                    child: const Text(
                      'Lupa Password?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _performLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                      : const Text('MASUK'),
                ),
                const SizedBox(height: 24),
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('atau', style: TextStyle(color: Colors.grey)),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: () {
                    print('Tombol Lanjutkan dengan Google ditekan');
                  },
                  icon: const Icon(Icons.g_mobiledata_rounded),
                  label: const Text('Lanjutkan dengan Google'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: Colors.grey.shade400),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Belum punya akun?',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterScreen()),
                        );
                      },
                      child: const Text(
                        'Daftar di sini',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}