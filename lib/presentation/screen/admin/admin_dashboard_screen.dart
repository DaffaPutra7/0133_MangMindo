import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projek_akhir/core/components/cards.dart';
import 'package:projek_akhir/core/core.dart';
import 'package:projek_akhir/presentation/admin/menu/bloc/menu_bloc.dart';
import 'package:projek_akhir/presentation/screen/admin/menu/add_menu_screen.dart';
import 'package:projek_akhir/presentation/screen/admin/menu/edit_menu_screen.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  // Panggil event untuk mengambil data saat halaman pertama kali dibuka
  @override
  void initState() {
    super.initState();
    // Gunakan context.read untuk memanggil event dari BLoC yang sudah ada
    context.read<MenusBloc>().add(GetMenu());
  }

  @override
  Widget build(BuildContext context) {
    // Hapus BlocProvider dari sini
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin - Menu'),
        backgroundColor: AppColors.primaryRed,
        foregroundColor: AppColors.white,
      ),
      body: BlocBuilder<MenusBloc, MenuState>(
        builder: (context, state) {
          if (state is MenuLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MenuError) {
            return Center(child: Text(state.message));
          }
          if (state is MenuLoaded) {
            if (state.menuResponse.data.isEmpty) {
              return const Center(
                child: Text('Belum ada menu. Tekan + untuk menambah.'),
              );
            }
            // Tampilkan daftar menu
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: state.menuResponse.data.length,
              itemBuilder: (context, index) {
                final menu = state.menuResponse.data[index];
                return MenuCard(
                  data: menu, 
                  onEditTap: () async {
                    final result = await Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => EditMenuScreen(menu: menu),
                      ),
                    );
                    if (result == true) {
                      context.read<MenusBloc>().add(GetMenu());
                    }
                  }, 
                  onDeleteTap: () {
                    // TODO: Tampilkan dialog konfirmasi hapus
                  },
                );
              },
            );
          }
          return const Center(child: Text('Silakan muat ulang.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigasi ke AddMenuPage dan tunggu hasilnya
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddMenuscreen()),
          );

          // Jika hasilnya 'true' (sukses menambah menu), refresh daftarnya
          if (result == true) {
            context.read<MenusBloc>().add(GetMenu());
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
