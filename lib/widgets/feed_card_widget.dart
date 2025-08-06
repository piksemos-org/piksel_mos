import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FeedCardWidget extends StatefulWidget {
  final String imageUrl;
  final String description;

  const FeedCardWidget({
    super.key,
    required this.imageUrl,
    required this.description,
  });

  @override
  State<FeedCardWidget> createState() => _FeedCardWidgetState();
}

class _FeedCardWidgetState extends State<FeedCardWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // Logika untuk mendeteksi apakah teks perlu dipotong
    final textPainter = TextPainter(
      text: TextSpan(text: widget.description, style: Theme.of(context).textTheme.bodyMedium),
      maxLines: 3,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width - 56); // Lebar kartu dikurangi padding

    final isTextLong = textPainter.didExceedMaxLines;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Postingan
          CachedNetworkImage(
            imageUrl: widget.imageUrl,
            placeholder: (context, url) => const AspectRatio(
              aspectRatio: 16 / 9,
              child: Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => const AspectRatio(
              aspectRatio: 16 / 9,
              child: Center(child: Icon(Icons.error)),
            ),
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          // Deskripsi dan Tombol Interaksi
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: Text(
                    widget.description,
                    maxLines: _isExpanded ? null : 3,
                    overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                  ),
                ),
                if (isTextLong)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _isExpanded ? 'Sembunyikan' : 'Baca Selengkapnya...',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.favorite_outline),
                      onPressed: () {
                        print('Tombol Suka ditekan');
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.share_outlined),
                      onPressed: () {
                        print('Tombol Bagikan ditekan');
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}