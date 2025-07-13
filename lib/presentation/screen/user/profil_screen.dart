import 'package:flutter/material.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // AppBar sudah diatur oleh UserMainScreen, jadi di sini hanya body
    return const Center(
      child: Text('Halaman Profil Pengguna akan ada di sini.'),
    );
  }
}