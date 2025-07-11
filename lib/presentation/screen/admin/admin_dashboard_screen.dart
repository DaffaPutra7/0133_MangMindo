import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projek_akhir/core/core.dart';
import 'package:projek_akhir/data/repository/admin_menu_repository.dart';
import 'package:projek_akhir/presentation/admin/menu/bloc/menu_bloc.dart';
import 'package:projek_akhir/presentation/screen/admin/menu/add_menu_screen.dart';
import 'package:projek_akhir/service/service_http_client.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              MenusBloc(AdminMenuRepository(ServiceHttpClient()))
                ..add(GetMenu()), // Langsung panggil event untuk mengambil data
      child: Scaffold(
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
                return const Center(child: Text('Belum ada menu.'));
              }
              // Tampilkan daftar menu
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: state.menuResponse.data.length,
                itemBuilder: (context, index) {
                  final menu = state.menuResponse.data[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12.0),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        // Tampilkan gambar jika ada, jika tidak tampilkan ikon
                        child:
                            menu.image != null
                                ? Image.network(
                                  // TODO: Ganti dengan URL gambar dari server Anda jika sudah production
                                  'http://10.0.2.2:8000/storage/menus/${menu.image!.split('/').last}',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.fastfood, size: 40);
                                  },
                                )
                                : const Icon(Icons.fastfood, size: 40),
                      ),
                      title: Text(
                        menu.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        // Format harga ke Rupiah
                        int.parse(
                          menu.price.toString().split('.').first,
                        ).currencyFormatRp,
                        style: const TextStyle(color: AppColors.primaryGreen),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: AppColors.grey),
                            onPressed: () {
                              // TODO: Navigasi ke halaman edit menu
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: AppColors.primaryRed,
                            ),
                            onPressed: () {
                              // TODO: Tampilkan dialog konfirmasi hapus
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(child: Text('Silakan muat ulang.'));
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigasi ke halaman AddMenuPage saat tombol ditekan
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddMenuscreen()),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
