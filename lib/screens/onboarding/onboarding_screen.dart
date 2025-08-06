import 'dart:async';
import 'package:flutter/material.dart';
import 'package:piksel_mos/screens/home/main_screen_wrapper.dart';
import 'package:piksel_mos/screens/onboarding/onboarding_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:piksel_mos/screens/auth/auth_wrapper.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin {
  late final AnimationController _entryAnimationController;

  @override
  void initState() {
    super.initState();
    _entryAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
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
        MaterialPageRoute(builder: (context) => const AuthWrapper()),
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

              // Kartu fitur sekarang menjadi widget animasi
              _AnimatedFeatureCard(
                controller: _entryAnimationController,
                interval: const Interval(0.0, 0.7, curve: Curves.easeOut),
                iconData: Icons.verified_user_outlined,
                title: 'Kenali Validator Cerdas Kami',
                description: 'Cegah kesalahan cetak dengan pengecekan file otomatis.',
                iconHeroTag: 'icon-1',
                titleHeroTag: 'title-1',
              ),
              const SizedBox(height: 16),
              _AnimatedFeatureCard(
                controller: _entryAnimationController,
                interval: const Interval(0.2, 0.9, curve: Curves.easeOut),
                iconData: Icons.brush_outlined,
                title: 'Temukan Desainer di Piksel Studio',
                description: 'Wujudkan idemu bersama desainer profesional kami.',
                iconHeroTag: 'icon-2',
                titleHeroTag: 'title-2',
              ),
              const SizedBox(height: 16),
              _AnimatedFeatureCard(
                controller: _entryAnimationController,
                interval: const Interval(0.4, 1.0, curve: Curves.easeOut),
                iconData: Icons.local_shipping_outlined,
                title: 'Lacak Pesananmu dengan Mudah',
                description: 'Lihat status pesanan dari dicetak hingga tiba di tujuan.',
                iconHeroTag: 'icon-3',
                titleHeroTag: 'title-3',
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
class _AnimatedFeatureCard extends StatefulWidget {
  final AnimationController controller;
  final Interval interval;
  final IconData iconData;
  final String title;
  final String description;
  final String iconHeroTag;
  final String titleHeroTag;

  const _AnimatedFeatureCard({
    required this.controller,
    required this.interval,
    required this.iconData,
    required this.title,
    required this.description,
    required this.iconHeroTag,
    required this.titleHeroTag,
  });

  @override
  State<_AnimatedFeatureCard> createState() => __AnimatedFeatureCardState();
}

class __AnimatedFeatureCardState extends State<_AnimatedFeatureCard> with TickerProviderStateMixin {
  late final AnimationController _standbyController;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _standbyController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
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
    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: widget.controller, curve: widget.interval),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.5, 0.0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: widget.controller, curve: widget.interval),
        ),
        child: AnimatedBuilder(
          animation: _opacityAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnimation.value,
              child: child,
            );
          },
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 500),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      OnboardingDetailScreen(
                        title: widget.title,
                        description: widget.description,
                        iconData: widget.iconData,
                        iconHeroTag: widget.iconHeroTag,
                        titleHeroTag: widget.titleHeroTag,
                      ),
                ),
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
                    Hero(
                      tag: widget.iconHeroTag,
                      child: Icon(widget.iconData, size: 40, color: Colors.deepPurple.shade700),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: widget.titleHeroTag,
                            child: Material(
                              color: Colors.transparent,
                              child: Text(
                                widget.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
      ),
    );
  }
}