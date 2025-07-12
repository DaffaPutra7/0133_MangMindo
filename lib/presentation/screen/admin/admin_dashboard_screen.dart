import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projek_akhir/core/components/cards.dart';
import 'package:projek_akhir/core/core.dart';
import 'package:projek_akhir/presentation/admin/menu/bloc/menu_bloc.dart';
// import 'package:projek_akhir/presentation/screen/admin/menu/add_menu_screen.dart';
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
    return BlocListener<MenusBloc, MenuState>(
      listener: (context, state) {
        if (state is MenuActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.primaryGreen,
            ),
          );
          // Muat ulang daftar menu
          context.read<MenusBloc>().add(GetMenu());
        }
        if (state is MenuActionFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.primaryRed,
            ),
          );
        }
      },
      child: BlocBuilder<MenusBloc, MenuState>(
        builder: (context, state) {
          if (state is MenuLoaded) {
            if (state.menuResponse.data.isEmpty) {
              return const Center(
                child: Text('Belum ada menu. Tekan + untuk menambah menu'),
              );
            }
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
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: const Text('Konfirmasi Hapus'),
                          content: Text(
                            'Apakah Anda yakin ingin menghapus menu "${menu.name}"?',
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                              },
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<MenusBloc>().add(
                                  DeleteMenu(menuId: menu.id),
                                );
                                Navigator.of(dialogContext).pop();
                              },
                              child: const Text(
                                'Hapus',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            );
          }
          if (state is MenuLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MenuError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Belum ada menu.'));
        },
      ),
    );
  }
}
