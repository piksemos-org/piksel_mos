import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:piksel_mos/screens/auth/register_screen.dart';
import 'package:piksel_mos/screens/auth/forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  // Constructor untuk menerima pesan awal (misal dari RegisterScreen)
  final String? initialMessage;
  const LoginScreen({super.key, this.initialMessage});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  String? _notificationMessage; // State untuk pesan notifikasi

  // Controllers untuk input fields (ditambahkan untuk kesiapan)
  final TextEditingController _emailPhoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set pesan notifikasi dari argumen initialMessage jika ada
    _notificationMessage = widget.initialMessage;

    // TODO: Di masa depan, di sini akan ada logika untuk memanggil API login
    // dan mengecek status verifikasi email/nomor HP.
    // Jika belum diverifikasi, _notificationMessage akan diupdate dengan:
    // "Email ini Belum di Verifikasi" atau "Anda belum memverifikasi nomor HP ini"
  }

  @override
  void dispose() {
    _emailPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Placeholder fungsi untuk login
  void _performLogin() {
    // TODO: Implementasi panggilan API login di sini
    // Untuk simulasi, set pesan verifikasi:
    // Misalnya, jika diasumsikan email belum verifikasi setelah login:
    // setState(() {
    //   _notificationMessage = 'Email ini Belum di Verifikasi';
    // });
    // Atau jika nomor HP belum verifikasi:
    // setState(() {
    //   _notificationMessage = 'Anda belum memverifikasi nomor HP ini';
    // });
    print('Melakukan proses login...');
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
                // Tampilkan pesan notifikasi jika ada
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
                // Sesuaikan jarak setelah notifikasi
                SizedBox(height: _notificationMessage != null ? 16 : 48),
                // Kolom input Email atau Nomor Telepon
                TextField(
                  controller: _emailPhoneController,
                  decoration: const InputDecoration(
                    labelText: 'Email atau Nomor Telepon',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                // Kolom input Password dengan toggle visibility
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
                  onPressed: _performLogin, // Panggil fungsi login
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('MASUK'),
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