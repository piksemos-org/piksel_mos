import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:piksel_mos/screens/auth/login_screen.dart';
import 'package:piksel_mos/screens/onboarding/onboarding_screen.dart';
import 'package:piksel_mos/screens/home/main_screen_wrapper.dart';

const bool IS_REVIEW_MODE = true;

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  Widget _currentPage = const Scaffold(body: Center(child: CircularProgressIndicator()));

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  // Fungsi untuk mengambil data profil dari server
  Future<Map<String, dynamic>?> _fetchUserProfile(String token) async {
    try {
      final url = Uri.parse('http://10.0.2.2:3000/api/auth/profile');
      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token', // Kirim token untuk otorisasi
      };
      final response = await http.get(url, headers: headers).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      print('Gagal mengambil profil: $e');
    }
    return null;
  }

  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('session_token');
    final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;

    print('AuthWrapper Check: Token = $token, Onboarding Completed = $onboardingCompleted');

    if (token != null) {
      // Jika ada token, coba ambil data profil
      final userProfile = await _fetchUserProfile(token);

      if (userProfile != null) {
        // Data profil berhasil didapat
        final bool isEmailVerified = userProfile['is_email_verified'] ?? false;

        // Logika Gerbang Cerdas
        if (IS_REVIEW_MODE || !onboardingCompleted) {
          setState(() {
            _currentPage = const OnboardingScreen();
          });
        } else {
          setState(() {
            _currentPage = MainScreenWrapper(
              userName: userProfile['name'] ?? 'Pengguna',
              userEmail: userProfile['email'] ?? '',
              userPhoneNumber: userProfile['phone'] ?? '',
              userRole: userProfile['role'] ?? 'Customer',
              isEmailVerified: isEmailVerified,
            );
          });
        }
      } else {
        // Gagal ambil profil, anggap sesi tidak valid, arahkan ke login
        setState(() {
          _currentPage = const LoginScreen();
        });
      }
    } else {
      // Tidak ada token, arahkan ke login
      setState(() {
        _currentPage = const LoginScreen();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _currentPage;
  }
}