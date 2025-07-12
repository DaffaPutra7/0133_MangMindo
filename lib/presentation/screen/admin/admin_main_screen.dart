import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projek_akhir/presentation/admin/menu/bloc/menu_bloc.dart';
import 'package:projek_akhir/presentation/screen/admin/admin_dashboard_screen.dart';
import 'package:projek_akhir/presentation/screen/admin/admin_order_screen.dart';
import 'package:projek_akhir/presentation/screen/admin/menu/add_menu_screen.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _selectedIndex = 0;

  // Daftar halaman yang akan dinavigasi
  final List<Widget> _pages = [
    const AdminDashboardPage(), // Halaman untuk kelola menu
    const AdminOrderScreen(),     // Halaman untuk kelola pesanan
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0
            ? 'Dashboard Admin - Menu'
            : 'Dashboard Admin - Pesanan'),
      ),
      body: _pages[_selectedIndex], 
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
            onPressed: () async {
              final result = await Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const AddMenuscreen()),
              );
              if (result == true) {
                context.read<MenusBloc>().add(GetMenu());
              }
            },
            child: const Icon(Icons.add),
          )
        : null, // Sembunyikan tombol jika bukan di halaman menu
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Pesanan',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}