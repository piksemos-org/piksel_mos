import 'package:flutter/material.dart'; // BENAR (menggunakan titik dua :)
import 'package:shared_preferences/shared_preferences.dart';

import 'package:piksel_mos/screens/auth/login_screen.dart';
import 'package:piksel_mos/screens/onboarding/onboarding_screen.dart';
import 'package:piksel_mos/screens/home/main_screen_wrapper.dart';


// 4. Implementasi "Mode Review"
const bool IS_REVIEW_MODE = true;

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  // State untuk menentukan halaman mana yang harus ditampilkan
  Widget _currentPage = const Scaffold(body: Center(child: CircularProgressIndicator()));

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('session_token');
    final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;

    print('AuthWrapper Check: Token = $token, Onboarding Completed = $onboardingCompleted');

    // Logika "Gerbang Cerdas"
    if (IS_REVIEW_MODE) {
      // Logika untuk Mode Review
      if (token != null) {
        setState(() {
          _currentPage = const MainScreenWrapper();
        });
      } else {
        setState(() {
          _currentPage = const LoginScreen();
        });
      }
    } else {
      // Logika normal untuk rilis
      if (token != null) {
        if (onboardingCompleted) {
          setState(() {
            _currentPage = const MainScreenWrapper();
          });
        } else {
          setState(() {
            _currentPage = const OnboardingScreen();
          });
        }
      } else {
        setState(() {
          _currentPage = const LoginScreen();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _currentPage;
  }
}