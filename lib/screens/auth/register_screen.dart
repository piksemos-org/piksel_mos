import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:piksel_mos/screens/auth/verification_screen.dart';
import 'package:piksel_mos/utils/validators.dart'; // 1. Impor file validators

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // 2. Kunci untuk mengelola state Form
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String? _serverErrorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    // 3. Trigger validasi pada semua field
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
        _serverErrorMessage = null;
      });

      try {
        final url = Uri.parse('http://178.128.18.30:3000/api/auth/register');
        final headers = {'Content-Type': 'application/json; charset=UTF-8'};
        final body = json.encode({
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'password': _passwordController.text,
        });

        final response = await http.post(url, headers: headers, body: body);

        if (mounted) {
          if (response.statusCode == 201) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => VerificationScreen(
                  phoneNumber: _phoneController.text,
                ),
              ),
            );
          } else {
            final responseData = json.decode(response.body);
            setState(() {
              _serverErrorMessage = responseData['message'] ?? 'Terjadi kesalahan saat registrasi.';
            });
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _serverErrorMessage = 'Gagal terhubung ke server. Periksa koneksi internet Anda.';
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            // 2. Bungkus kolom dengan Form
            child: Form(
              key: _formKey,
              // Validasi akan berjalan saat pengguna berinteraksi dengan field
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  const Text(
                    'Buat Akun Baru',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 32),
                  // 4. Ubah TextField menjadi TextFormField dan terapkan validasi
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Nama Lengkap', border: OutlineInputBorder()),
                    // 5. Terapkan formatter
                    inputFormatters: [Formatters.nameCapitalizationFormatter],
                    validator: Validators.validateName,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.validateEmail,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: 'Nomor Telepon', border: OutlineInputBorder()),
                    keyboardType: TextInputType.phone,
                    validator: Validators.validatePhone,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                    validator: (value) => Validators.validatePassword(
                      value,
                      name: _nameController.text,
                      email: _emailController.text,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Konfirmasi Password', border: OutlineInputBorder()),
                    validator: (value) => Validators.validateConfirmPassword(
                      _passwordController.text,
                      value,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_serverErrorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        _serverErrorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _register,
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
                        : const Text('DAFTAR'),
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