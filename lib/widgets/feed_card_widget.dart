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
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Postingan
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: CachedNetworkImage(
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
          ),
          // Deskripsi dengan "Baca Selengkapnya"
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
                // Tampilkan tombol jika teks lebih dari 3 baris
                // (Logika sederhana, bisa disempurnakan dengan TextPainter)
                if (widget.description.length > 100) // Asumsi panjang teks
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
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}