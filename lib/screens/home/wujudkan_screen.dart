import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:piksel_mos/widgets/feed_card_widget.dart';

class WujudkanScreen extends StatefulWidget {
  const WujudkanScreen({super.key});

  @override
  State<WujudkanScreen> createState() => _WujudkanScreenState();
}

class _WujudkanScreenState extends State<WujudkanScreen> {
  bool _isLoading = true;
  List<dynamic> _feedData = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchFeed();
  }

  Future<void> _fetchFeed() async {
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
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = 'Gagal memuat data feed.';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Gagal terhubung ke server.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }

    return RefreshIndicator(
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
}