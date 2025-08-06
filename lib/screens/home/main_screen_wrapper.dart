import 'package:flutter/material.dart';
import 'package:piksel_mos/screens/home/wujudkan_screen.dart';
import 'package:piksel_mos/screens/home/piksel_studio_screen.dart';
import 'package:piksel_mos/screens/home/lacak_pesanan_screen.dart';
import 'package:piksel_mos/screens/home/riwayat_screen.dart';
import 'package:piksel_mos/screens/home/akun_saya_screen.dart';

class MainScreenWrapper extends StatefulWidget {
  const MainScreenWrapper({super.key});

  @override
  State<MainScreenWrapper> createState() => _MainScreenWrapperState();
}

class _MainScreenWrapperState extends State<MainScreenWrapper> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    WujudkanScreen(),
    PikselStudioScreen(),
    LacakPesananScreen(),
    RiwayatScreen(),
    AkunSayaScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold berbeda untuk setiap halaman agar AppBar bisa dikontrol secara individual
    return Scaffold(
      appBar: AppBar(
        title: const Text('Piksel.mos'),
        automaticallyImplyLeading: false,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Agar 5 item muat
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline),
            activeIcon: Icon(Icons.lightbulb),
            label: 'Wujudkan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.brush_outlined),
            activeIcon: Icon(Icons.brush),
            label: 'Piksel Studio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping_outlined),
            activeIcon: Icon(Icons.local_shipping),
            label: 'Lacak',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Akun Saya',
          ),
        ],
      ),
    );
  }
}