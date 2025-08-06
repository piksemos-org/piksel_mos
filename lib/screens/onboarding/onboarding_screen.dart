import 'dart:async';
import 'package:flutter/material.dart';
import 'package:piksel_mos/screens/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:piksel_mos/screens/home/main_screen_wrapper.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  // Controller untuk animasi masuk (entry animation)
  late final AnimationController _entryAnimationController;

  @override
  void initState() {
    super.initState();
    _entryAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    // Memulai animasi setelah build pertama selesai
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _entryAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _entryAnimationController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainScreenWrapper()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade900,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              const Text(
                'Jelajahi Fitur Andalan Kami',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 48),

              // Kartu fitur sekarang dibungkus dengan widget animasi
              AnimatedFeatureCard(
                controller: _entryAnimationController,
                interval: const Interval(0.0, 0.6, curve: Curves.easeOut),
                icon: Icons.verified_user_outlined,
                title: 'Kenali Validator Cerdas Kami',
                description: 'Cegah kesalahan cetak dengan pengecekan file otomatis.',
              ),
              const SizedBox(height: 16),
              AnimatedFeatureCard(
                controller: _entryAnimationController,
                interval: const Interval(0.2, 0.8, curve: Curves.easeOut),
                icon: Icons.brush_outlined,
                title: 'Temukan Desainer di Piksel Studio',
                description: 'Wujudkan idemu bersama desainer profesional kami.',
              ),
              const SizedBox(height: 16),
              AnimatedFeatureCard(
                controller: _entryAnimationController,
                interval: const Interval(0.4, 1.0, curve: Curves.easeOut),
                icon: Icons.local_shipping_outlined,
                title: 'Lacak Pesananmu dengan Mudah',
                description: 'Lihat status pesanan dari dicetak hingga tiba di tujuan.',
              ),
              const Spacer(flex: 3),

              ElevatedButton(
                onPressed: () => _completeOnboarding(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('MASUK KE APLIKASI', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => _completeOnboarding(context),
                child: const Text(
                  'Lewati untuk Sekarang',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget terpisah untuk kartu fitur agar dapat mengelola animasinya sendiri
class AnimatedFeatureCard extends StatefulWidget {
  final AnimationController controller;
  final Interval interval;
  final IconData icon;
  final String title;
  final String description;

  const AnimatedFeatureCard({
    super.key,
    required this.controller,
    required this.interval,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  State<AnimatedFeatureCard> createState() => _AnimatedFeatureCardState();
}

class _AnimatedFeatureCardState extends State<AnimatedFeatureCard>
    with TickerProviderStateMixin {
  // Controller untuk animasi standby (standby animation)
  late final AnimationController _standbyController;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _standbyController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true); // Loop animasi maju-mundur

    _opacityAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _standbyController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _standbyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 3a. Implementasi Animasi Masuk (Entry Animation)
    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: widget.controller, curve: widget.interval),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: widget.controller, curve: widget.interval),
        ),
        child:
        // 3b. Implementasi Animasi Standby (Standby Animation)
        AnimatedBuilder(
          animation: _opacityAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnimation.value,
              child: child,
            );
          },
          child: Card(
            elevation: 4,
            shadowColor: Colors.black.withOpacity(0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // 3c. Persiapan Animasi Hero (ditempatkan di sini)
                  // TODO: Bungkus Icon dengan Hero widget jika halaman detail sudah ada
                  // Hero(
                  //   tag: 'onboarding_icon_${widget.title}',
                  //   child: Icon(widget.icon, size: 40, color: Colors.deepPurple.shade700),
                  // ),
                  Icon(widget.icon, size: 40, color: Colors.deepPurple.shade700),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // TODO: Bungkus Text dengan Hero widget jika halaman detail sudah ada
                        // Hero(
                        //   tag: 'onboarding_title_${widget.title}',
                        //   child: Material( // Diperlukan agar teks tidak error saat transisi
                        //     color: Colors.transparent,
                        //     child: Text(widget.title, ...),
                        //   ),
                        // ),
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.description,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
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