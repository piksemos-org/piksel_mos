// main_screen_wrapper.dart (Kode versi penuh karena baru dibuat)
import 'package:flutter/material.dart';
import 'package:piksel_mos/screens/home/akun_saya_screen.dart';
import 'package:piksel_mos/screens/home/home_screen.dart';
import 'package:piksel_mos/screens/home/lacak_pesanan_screen.dart';
import 'package:piksel_mos/screens/home/piksel_studio_screen.dart';
import 'package:piksel_mos/screens/home/wujudkan_screen.dart';

class MainScreenWrapper extends StatefulWidget {
  const MainScreenWrapper({super.key});

  @override
  State<MainScreenWrapper> createState() => _MainScreenWrapperState();
}

class _MainScreenWrapperState extends State<MainScreenWrapper> {
  int _selectedIndex = 2; // Home (index 2) sebagai tab default

  static const List<Widget> _screens = <Widget>[
    WujudkanScreen(),
    PikselStudioScreen(),
    HomeScreen(),
    LacakPesananScreen(),
    AkunSayaScreen(),
  ];

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