import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:piksel_mos/widgets/feed_card_widget.dart';

// Callback untuk mengubah tab
typedef TabCallback = void Function(int index);

class HomeScreen extends StatefulWidget {
  final TabCallback onTabChange;
  const HomeScreen({super.key, required this.onTabChange});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  List<dynamic> _feedData = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchFeed();
  }

  Future<void> _fetchFeed() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final url = Uri.parse('http://178.128.18.30:3000/api/feed');
      final response = await http.get(url).timeout(const Duration(seconds: 20));

      if (mounted) {
        if (response.statusCode == 200) {
          setState(() {
            _feedData = json.decode(response.body);
          });
        } else {
          setState(() {
            _errorMessage = 'Gagal memuat data feed.';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Gagal terhubung ke server.';
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

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    } else if (_errorMessage != null) {
      content = Center(child: Text(_errorMessage!));
    } else if (_feedData.isEmpty) {
      // Penanganan Empty State
      content = Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.auto_awesome_outlined, size: 80, color: Colors.grey),
              const SizedBox(height: 24),
              const Text(
                'Selamat Datang di Piksel.mos!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Nantikan promo dan update menarik lainnya di sini.',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Panggil callback untuk pindah ke tab Wujudkan (indeks 0)
                  widget.onTabChange(0);
                },
                child: const Text('Mulai Cetak Sekarang'),
              ),
            ],
          ),
        ),
      );
    } else {
      content = RefreshIndicator(
        onRefresh: _fetchFeed,
        child: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: _feedData.length,
          itemBuilder: (context, index) {
            final post = _feedData[index];
            return FeedCardWidget(
              imageUrl: post['imageUrl'],
              description: post['description'],
            );
          },
        ),
      );
    }

    return Scaffold(
      body: content,
    );
  }
}