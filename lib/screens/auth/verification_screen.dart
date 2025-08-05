import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:piksel_mos/screens/auth/login_screen.dart';

class VerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const VerificationScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _otpController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  int _cooldownSeconds = 60;
  Timer? _cooldownTimer;
  bool _canResend = false;
  int _failedAttempts = 0;

  @override
  void initState() {
    super.initState();
    _startCooldownTimer();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _startCooldownTimer() {
    setState(() {
      _canResend = false;
      _cooldownSeconds = 60;
    });
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_cooldownSeconds == 0) {
        timer.cancel();
        setState(() {
          _canResend = true;
        });
      } else {
        setState(() {
          _cooldownSeconds--;
        });
      }
    });
  }

  // --- FUNGSI UTAMA YANG DIREVISI ---
  Future<void> _verifyOtp() async {
    if (_otpController.text.length != 6) {
      setState(() {
        _errorMessage = 'Kode OTP harus 6 digit.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 3b. Implementasi Panggilan API
      final url = Uri.parse('http://178.128.18.30:3000/api/auth/verify-otp');
      final headers = {'Content-Type': 'application/json; charset=UTF-8'};
      final body = json.encode({
        'phoneNumber': widget.phoneNumber,
        'otpCode': _otpController.text,
      });

      final response = await http.post(url, headers: headers, body: body);

      if (mounted) {
        if (response.statusCode == 200) {
          // --- SUKSES ---
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Verifikasi berhasil! Silakan login.'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const LoginScreen(
                initialMessage: "Verifikasi sukses! Anda sekarang dapat masuk.",
              ),
            ),
                (Route<dynamic> route) => false,
          );
        } else {
          // --- GAGAL ---
          final responseData = json.decode(response.body);
          setState(() {
            _errorMessage = responseData['message'] ?? 'Kode OTP salah atau tidak valid.';
            _failedAttempts++;
            if (_failedAttempts >= 3) {
              _startCooldownTimer();
              _failedAttempts = 0;
            }
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

  Future<void> _sendOtpAgain() async {
    if (!_canResend) return;

    // (Logika kirim ulang OTP tetap sama, diasumsikan sudah terhubung ke server)
    try {
      final url = Uri.parse('http://178.128.18.30:3000/api/auth/resend-otp');
      final headers = {'Content-Type': 'application/json; charset=UTF-8'};
      final body = json.encode({'phoneNumber': widget.phoneNumber});
      final response = await http.post(url, headers: headers, body: body);

      if (mounted) {
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Kode OTP baru telah dikirim ulang.'),
              backgroundColor: Colors.blue,
            ),
          );
          _startCooldownTimer();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal mengirim ulang kode. Coba lagi nanti.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal terhubung ke server.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifikasi Nomor Telepon'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                Text(
                  'Masukkan Kode Verifikasi',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  'Kami telah mengirimkan kode 6 digit ke nomor ${widget.phoneNumber}.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey.shade700),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _otpController,
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'Kode OTP', border: OutlineInputBorder()),
                  buildCounter: (context,
                      {required currentLength,
                        required isFocused,
                        maxLength}) =>
                  null,
                ),
                const SizedBox(height: 16),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(_errorMessage!,
                        style:
                        const TextStyle(color: Colors.red, fontSize: 14),
                        textAlign: TextAlign.center),
                  ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _verifyOtp,
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: _isLoading
                      ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 3))
                      : const Text('VERIFIKASI OTP'),
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: _canResend ? _sendOtpAgain : null,
                  child: Text(_canResend
                      ? 'Kirim Ulang OTP'
                      : 'Kirim ulang dalam $_cooldownSeconds detik'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}