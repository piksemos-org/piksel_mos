// lib/screens/home/main_screen_wrapper.dart
import 'package:flutter/material.dart';
import 'package:piksel_mos/screens/home/akun_saya_screen.dart';
import 'package:piksel_mos/screens/home/home_screen.dart';
import 'package:piksel_mos/screens/home/lacak_pesanan_screen.dart'; // Tetap ada jika masih digunakan di Lacak Pesanan
import 'package:piksel_mos/screens/home/piksel_studio_screen.dart';
import 'package:piksel_mos/screens/home/wujudkan_screen.dart';

class MainScreenWrapper extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String userPhoneNumber;
  final String userRole; // Tambahkan userRole
  final String? userPhotoUrl;

  const MainScreenWrapper({
    super.key,
    this.userName = 'Nama Pengguna',
    this.userEmail = 'email@contoh.com',
    this.userPhoneNumber = '081234567890',
    this.userRole = 'Customer', // Default placeholder
    this.userPhotoUrl,
  });

  @override
  State<MainScreenWrapper> createState() => _MainScreenWrapperState();
}

class _MainScreenWrapperState extends State<MainScreenWrapper> {
  int _selectedIndex = 2; // Home (index 2) sebagai tab default

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = <Widget>[
      const WujudkanScreen(),
      const PikselStudioScreen(),
      const HomeScreen(),
      const LacakPesananScreen(),
      AkunSayaScreen( // AkunSayaScreen kini menerima data pengguna dan role
        userName: widget.userName,
        userEmail: widget.userEmail,
        userPhoneNumber: widget.userPhoneNumber,
        userRole: widget.userRole, // Meneruskan role
        userPhotoUrl: widget.userPhotoUrl,
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.palette_outlined),
            label: 'Wujudkan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.design_services_outlined),
            label: 'Piksel Studio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes_outlined),
            label: 'Lacak',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}