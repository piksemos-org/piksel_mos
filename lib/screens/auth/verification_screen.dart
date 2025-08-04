import 'dart:async'; // Untuk Timer
import 'package:flutter/material.dart';
import 'package:piksel_mos/screens/auth/login_screen.dart'; // Untuk navigasi kembali ke LoginScreen

class VerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String email;

  const VerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.email,
  });

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController _otpController = TextEditingController();

  // States untuk timer dan cooldown
  int _resendCountdown = 180; // 3 menit
  Timer? _countdownTimer;
  DateTime? _cooldownEndTime; // Waktu berakhir cooldown
  String? _cooldownMessage; // Pesan sisa waktu cooldown

  // States untuk verifikasi
  int _failedAttempts = 0;
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _startCountdown(); // Mulai timer saat halaman dimuat
  }

  @override
  void dispose() {
    _otpController.dispose();
    _countdownTimer?.cancel(); // Pastikan timer di-cancel
    super.dispose();
  }

  // Mengubah detik menjadi format MM:SS
  String _formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  // Fungsi untuk memulai/mengulang countdown timer
  void _startCountdown() {
    _resendCountdown = 180; // Reset ke 3 menit
    _countdownTimer?.cancel(); // Batalkan timer sebelumnya jika ada
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown == 0) {
        _countdownTimer?.cancel();
        setState(() {}); // Perbarui UI agar tombol "Kirim Ulang" aktif
      } else {
        setState(() {
          _resendCountdown--;
        });
      }
    });
  }

  // Placeholder untuk mengirim ulang OTP
  Future<void> _sendOtpAgain() async {
    // Implementasi simulasi pengiriman ulang OTP ke backend
    // Misalnya, panggil API untuk mengirim ulang OTP ke widget.phoneNumber
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Simulasi delay API
      await Future.delayed(const Duration(seconds: 2));

      // Setelah berhasil simulasi pengiriman ulang
      _startCountdown(); // Mulai countdown lagi
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kode OTP telah dikirim ulang.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal mengirim ulang OTP. Coba lagi.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fungsi untuk memverifikasi OTP
  Future<void> _verifyOtp() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _cooldownMessage = null;
    });

    // Cek cooldown
    if (_cooldownEndTime != null && DateTime.now().isBefore(_cooldownEndTime!)) {
      setState(() {
        final remaining = _cooldownEndTime!.difference(DateTime.now());
        _cooldownMessage = 'Terlalu banyak percobaan. Silakan coba lagi dalam ${_formatDuration(remaining.inSeconds)}.';
        _isLoading = false;
      });
      return;
    }

    final String enteredOtp = _otpController.text;

    if (enteredOtp.isEmpty || enteredOtp.length != 6) {
      setState(() {
        _errorMessage = 'Mohon masukkan 6 digit kode OTP.';
        _isLoading = false;
      });
      return;
    }

    // Simulasi panggilan API verifikasi OTP
    // Ganti dengan panggilan API sebenarnya nanti
    try {
      await Future.delayed(const Duration(seconds: 2)); // Simulasi delay

      const String correctOtp = "123456"; // OTP mock

      if (enteredOtp == correctOtp) {
        // OTP Benar
        // Reset percobaan gagal jika sukses
        _failedAttempts = 0;
        _cooldownEndTime = null;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verifikasi OTP berhasil!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigasi kembali ke LoginScreen dengan pesan sukses verifikasi
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(
              initialMessage: 'Verifikasi sukses! Anda sekarang dapat masuk.',
            ),
          ),
              (Route<dynamic> route) => false, // Hapus semua rute sebelumnya
        );
      } else {
        // OTP Salah
        _failedAttempts++;

        if (_failedAttempts >= 3) {
          // Logika Cooldown
          Duration cooldownDuration;
          if (_failedAttempts == 3) {
            cooldownDuration = const Duration(minutes: 5);
            _errorMessage = 'Terlalu banyak percobaan. Silakan coba lagi dalam 5 menit.';
          } else if (_failedAttempts == 4) {
            cooldownDuration = const Duration(minutes: 30);
            _errorMessage = 'Terlalu banyak percobaan. Silakan coba lagi dalam 30 menit.';
          } else {
            // Untuk percobaan gagal > 4, setiap gagal selanjutnya tambahkan 30 menit dari waktu saat ini
            cooldownDuration = Duration(minutes: 30 * (_failedAttempts - 3)); // 30*1, 30*2, dst
            _errorMessage = 'Terlalu banyak percobaan. Silakan coba lagi dalam ${_formatDuration(cooldownDuration.inSeconds)}.';
          }
          _cooldownEndTime = DateTime.now().add(cooldownDuration);

          // Batalkan timer OTP jika cooldown aktif
          _countdownTimer?.cancel();
          _resendCountdown = 0; // Pastikan countdown terlihat selesai
        } else {
          _errorMessage = 'Kode OTP salah. Sisa percobaan: ${5 - _failedAttempts}.'; // Batas 5 percobaan total
        }

        // Jika percobaan gagal mencapai 5, berikan pesan final atau blokir sementara
        if (_failedAttempts >= 5) {
          _errorMessage = 'Anda telah mencapai batas percobaan verifikasi OTP. Akun Anda mungkin terkunci sementara. Harap hubungi dukungan.';
          // Mungkin juga navigasi ke halaman error fatal
        }
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan saat memverifikasi OTP. Silakan coba lagi.';
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mengecek apakah cooldown masih aktif setiap kali build
    final bool isCooldownActive = _cooldownEndTime != null && DateTime.now().isBefore(_cooldownEndTime!);
    if (isCooldownActive) {
      // Memperbarui cooldown message setiap detik jika cooldown aktif
      if (_countdownTimer == null || !_countdownTimer!.isActive) {
        _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (mounted) {
            setState(() {
              final remaining = _cooldownEndTime!.difference(DateTime.now());
              if (remaining.isNegative) {
                _cooldownEndTime = null;
                _cooldownMessage = null;
                timer.cancel();
              } else {
                _cooldownMessage = 'Terlalu banyak percobaan. Silakan coba lagi dalam ${_formatDuration(remaining.inSeconds)}.';
              }
            });
          }
        });
      }
    }


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.deepPurple),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                const Text(
                  'Verifikasi Nomor Telepon',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Masukkan 6 digit kode OTP yang telah kami kirimkan ke nomor telepon ${widget.phoneNumber} dan email ${widget.email}.',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24, letterSpacing: 8),
                  decoration: InputDecoration(
                    hintText: '------',
                    border: const OutlineInputBorder(),
                    counterText: "", // Menyembunyikan counter karakter
                    enabled: !isCooldownActive, // Nonaktifkan saat cooldown
                  ),
                  enabled: !isCooldownActive, // Nonaktifkan saat cooldown
                ),
                const SizedBox(height: 24),

                // Tampilkan pesan error atau cooldown
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (_cooldownMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      _cooldownMessage!,
                      style: const TextStyle(color: Colors.orange, fontSize: 14, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // Timer Kirim Ulang OTP
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    _resendCountdown > 0
                        ? 'Kirim ulang OTP dalam ${_formatDuration(_resendCountdown)}'
                        : 'Kode tidak terkirim?',
                    style: TextStyle(
                      color: _resendCountdown > 0 ? Colors.grey : Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: _resendCountdown == 0 && !isCooldownActive && !_isLoading
                      ? _sendOtpAgain
                      : null,
                  child: const Text(
                    'Kirim Ulang OTP',
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Tombol Verifikasi OTP
                ElevatedButton(
                  onPressed: _isLoading || isCooldownActive ? null : _verifyOtp,
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
                      : const Text('Verifikasi OTP'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}