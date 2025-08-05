import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:piksel_mos/screens/auth/login_screen.dart';
import 'package:piksel_mos/utils/validators.dart'; // 1. Impor file validators

class ResetPasswordScreen extends StatefulWidget {
  final String emailOrPhone;

  const ResetPasswordScreen({
    super.key,
    required this.emailOrPhone,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  // 2. Kunci untuk mengelola state Form
  final _formKey = GlobalKey<FormState>();

  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _saveNewPassword() async {
    // 3. Trigger validasi pada semua field sebelum mengirim
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final url = Uri.parse('http://178.128.18.30:3000/api/auth/reset-password');
        final headers = {'Content-Type': 'application/json; charset=UTF-8'};
        final body = json.encode({
          'emailOrPhone': widget.emailOrPhone,
          'otpCode': _otpController.text,
          'newPassword': _newPasswordController.text,
        });

        final response = await http.post(url, headers: headers, body: body);

        if (mounted) {
          if (response.statusCode == 200) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(
                  initialMessage: "Password berhasil diubah. Silakan login.",
                ),
              ),
                  (route) => false,
            );
          } else {
            final responseData = json.decode(response.body);
            setState(() {
              _errorMessage = responseData['message'] ?? 'Gagal mereset password.';
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
            Navigator.of(context).pop();
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
                    'Atur Ulang Password',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Kode verifikasi telah dikirim ke ${widget.emailOrPhone}. Masukkan kode dan password baru Anda.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // 4. Ubah TextField menjadi TextFormField dan terapkan validasi
                  TextFormField(
                    controller: _otpController,
                    decoration: const InputDecoration(
                      labelText: 'Kode Verifikasi (OTP)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'OTP tidak boleh kosong.';
                      }
                      if (value.length < 6) {
                        return 'OTP harus 6 digit.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: !_isNewPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password Baru',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_isNewPasswordVisible ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => _isNewPasswordVisible = !_isNewPasswordVisible),
                      ),
                    ),
                    validator: (value) => Validators.validatePassword(value, email: widget.emailOrPhone),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: !_isConfirmPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Konfirmasi Password Baru',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                      ),
                    ),
                    validator: (value) => Validators.validateConfirmPassword(
                      _newPasswordController.text,
                      value,
                    ),
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
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _saveNewPassword,
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
                        : const Text('SIMPAN PASSWORD BARU'),
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