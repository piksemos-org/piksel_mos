import 'package:flutter/material.dart';

class OnboardingDetailScreen extends StatelessWidget {
  final String title;
  final String description;
  final IconData iconData;
  final String iconHeroTag;
  final String titleHeroTag;
  // final String lottieAsset; // Disiapkan untuk masa depan

  const OnboardingDetailScreen({
    super.key,
    required this.title,
    required this.description,
    required this.iconData,
    required this.iconHeroTag,
    required this.titleHeroTag,
    // required this.lottieAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade900,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.deepPurple.shade900,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Hero animation untuk Ikon dan Judul
            Hero(
              tag: iconHeroTag,
              child: Icon(iconData, size: 64, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Hero(
              tag: titleHeroTag,
              child: Material(
                color: Colors.transparent,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 48),

            // Placeholder untuk animasi Lottie
            const Icon(Icons.animation, size: 150, color: Colors.white38),
            // Di masa depan, ganti dengan Lottie.asset(lottieAsset),

            const SizedBox(height: 48),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}