import 'package:flutter/material.dart';
import 'package:piksel_mos/screens/home/wujudkan_screen.dart';
import 'package:piksel_mos/screens/home/piksel_studio_screen.dart';
import 'package:piksel_mos/screens/home/home_screen.dart';
import 'package:piksel_mos/screens/home/lacak_pesanan_screen.dart';
import 'package:piksel_mos/screens/home/akun_saya_screen.dart';

class MainScreenWrapper extends StatefulWidget {
  const MainScreenWrapper({super.key});

  @override
  State<MainScreenWrapper> createState() => _MainScreenWrapperState();
}

class _MainScreenWrapperState extends State<MainScreenWrapper> {
  int _selectedIndex = 2; // Default tab adalah Home

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // Inisialisasi daftar halaman, passing callback ke HomeScreen
    _pages = <Widget>[
      const WujudkanScreen(),
      const PikselStudioScreen(),
      HomeScreen(onTabChange: _onItemTapped), // Pass callback ke HomeScreen
      const LacakPesananScreen(),
      const AkunSayaScreen(),
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
      appBar: AppBar(
        title: const Text('Piksel.mos'),
        automaticallyImplyLeading: false,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.print_outlined),
            activeIcon: Icon(Icons.print),
            label: 'Wujudkan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.brush_outlined),
            activeIcon: Icon(Icons.brush),
            label: 'Piksel Studio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home, size: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping_outlined),
            activeIcon: Icon(Icons.local_shipping),
            label: 'Lacak',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}