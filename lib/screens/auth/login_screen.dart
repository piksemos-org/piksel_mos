import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:piksel_mos/screens/auth/register_screen.dart';
import 'package:piksel_mos/screens/auth/forgot_password_screen.dart';
import 'package:piksel_mos/screens/auth/verification_screen.dart';
import 'package:piksel_mos/screens/home/home_screen.dart';
import 'package:piksel_mos/utils/validators.dart';

class LoginScreen extends StatefulWidget {
  final String? initialMessage;
  const LoginScreen({super.key, this.initialMessage});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailPhoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  String? _feedbackMessage;
  Color _feedbackColor = Colors.red;

  @override
  void initState() {
    super.initState();
    if (widget.initialMessage != null) {
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

  Future<void> _performLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
        _feedbackMessage = null;
      });

      try {
        final identifier = _emailPhoneController.text;
        final password = _passwordController.text;

        final url = Uri.parse('http://10.0.2.2:3000/api/auth/login');
        final headers = {'Content-Type': 'application/json; charset=UTF-8'};
        final body = json.encode({
          'identifier': identifier,
          'password': password,
        });

        final response = await http.post(url, headers: headers, body: body);

        if (mounted) {
          final responseData = json.decode(response.body);

          // --- PERUBAHAN UTAMA DI SINI ---
          if (response.statusCode == 200) {
            // a. Login Sukses
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (route) => false,
            );
          } else if (response.statusCode == 403) {
            // b. Akun Belum Diverifikasi
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VerificationScreen(
                  phoneNumber: _emailPhoneController.text, // Mengirim nomor telepon
                ),
              ),
            );
          } else if (response.statusCode == 401) {
            // c. Kredensial Salah
            setState(() {
              _feedbackMessage = responseData['message'] ?? 'Email/Telepon atau Password salah.';
              _feedbackColor = Colors.red;
            });
          } else {
            // d. Error Lainnya
            setState(() {
              _feedbackMessage = responseData['message'] ?? 'Terjadi kesalahan pada server.';
              _feedbackColor = Colors.red;
            });
          }
          // --- AKHIR PERUBAHAN ---
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _feedbackMessage = 'Gagal terhubung ke server. Periksa koneksi Anda.';
            _feedbackColor = Colors.red;
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      if (value.contains('@')) {
                        return Validators.validateEmail(value);
                      }
                      return Validators.validatePhone(value);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password tidak boleh kosong.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
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

                  if (_feedbackMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Text(
                        _feedbackMessage!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _feedbackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

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
      ),
    );
  }
}