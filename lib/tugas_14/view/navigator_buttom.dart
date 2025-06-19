import 'package:daftar_siswa_app/tugas_14/view/about_bitcoin.dart';
import 'package:daftar_siswa_app/tugas_14/view/bitcoin_list_screen.dart';
import 'package:flutter/material.dart';

class NavigatorButtom extends StatefulWidget {
  const NavigatorButtom({super.key});

  @override
  State<NavigatorButtom> createState() => _TugasTigaBelas();
}

class _TugasTigaBelas extends State<NavigatorButtom> {
  final List<Widget> _screen = [AboutBitcoin(), CryptoMarketsScreen()];
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.info), label: "About"),
          BottomNavigationBarItem(icon: Icon(Icons.shop), label: "Market"),
        ],
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      ),
      body: _screen[_selectedIndex],
    );
  }
}
