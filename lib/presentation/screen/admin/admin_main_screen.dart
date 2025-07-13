import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projek_akhir/core/constants/colors.dart';
import 'package:projek_akhir/presentation/admin/menu/bloc/menu_bloc.dart';
import 'package:projek_akhir/presentation/admin/notifikasi/bloc/notification_bloc.dart';
import 'package:projek_akhir/presentation/admin/order/bloc/admin_order_bloc.dart';
import 'package:projek_akhir/presentation/auth/login/bloc/login_bloc.dart';
import 'package:projek_akhir/presentation/screen/admin/admin_dashboard_screen.dart';
import 'package:projek_akhir/presentation/screen/admin/admin_order_screen.dart';
import 'package:projek_akhir/presentation/screen/admin/menu/add_menu_screen.dart';
import 'package:projek_akhir/presentation/screen/login_screen.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const AdminDashboardPage(),
    const AdminOrderScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Memulai pemeriksaan notifikasi saat halaman ini dibuka
    context.read<NotificationBloc>().add(StartOrderCheck());
  }

  // Method dispose sekarang bisa disederhanakan/dihapus karena BLoC mengurus dirinya sendiri
  // @override
  // void dispose() {
  //   super.dispose();
  // }

  void _onItemTapped(int index) {
    // Jika tab Pesanan (index 1) diklik, muat ulang datanya
    if (index == 1) {
      context.read<AdminOrderBloc>().add(FetchAllOrders());
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginInitial) {
              // Hentikan timer notifikasi sebelum logout
              context.read<NotificationBloc>().add(StopOrderCheck());
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            }
          },
        ),
        BlocListener<NotificationBloc, NotificationState>(
          listener: (context, state) {
            if (state is NewOrderReceived) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${state.newOrderCount} pesanan baru masuk!'),
                  backgroundColor: AppColors.primaryGreen,
                  action: SnackBarAction(
                    label: 'LIHAT',
                    textColor: Colors.white,
                    onPressed: () {
                      _onItemTapped(1);
                    },
                  ),
                ),
              );
              context.read<AdminOrderBloc>().add(FetchAllOrders());
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _selectedIndex == 0
                ? 'Dashboard Admin - Menu'
                : 'Dashboard Admin - Pesanan',
          ),
          backgroundColor: AppColors.primaryRed,
          foregroundColor: AppColors.white,
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Apakah Anda yakin ingin logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: const Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          context.read<LoginBloc>().add(LogoutButtonPressed());
                        },
                        child: const Text('Logout', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: _pages[_selectedIndex],
        floatingActionButton: _selectedIndex == 0
            ? FloatingActionButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddMenuscreen(),
                    ),
                  );
                  if (result == true) {
                    context.read<MenusBloc>().add(GetMenu());
                  }
                },
                child: const Icon(Icons.add),
              )
            : null,
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: 'Menu'),
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
      ),
    );
  }
}
