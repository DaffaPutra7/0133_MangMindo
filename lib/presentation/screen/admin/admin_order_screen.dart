import 'package:flutter/material.dart';

class AdminOrderScreen extends StatelessWidget {
  const AdminOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold ini akan memiliki AppBar-nya sendiri
    return Scaffold(
      body: const Center(
        child: Text('Halaman untuk mengelola pesanan akan ada di sini.'),
      ),
    );
  }
}