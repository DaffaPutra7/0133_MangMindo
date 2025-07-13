import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projek_akhir/core/constants/colors.dart';
import 'package:projek_akhir/presentation/screen/user/customer_menu_screen.dart';
import 'package:projek_akhir/presentation/screen/user/order/order_screen.dart';
import 'package:projek_akhir/presentation/screen/user/profil_screen.dart';
import 'package:projek_akhir/presentation/screen/user/riwayat_order_screen.dart';
import 'package:projek_akhir/presentation/user/cart/bloc/cart_bloc.dart';
import 'package:projek_akhir/presentation/user/menu/bloc/customer_menu_bloc.dart';

class UserMainScreen extends StatefulWidget {
  const UserMainScreen({super.key});

  @override
  State<UserMainScreen> createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const CustomerMenuPage(),
    const RiwayatOrderScreen(),
    const ProfilScreen(),
  ];

  @override
  void initState() {
    super.initState();
    context.read<CustomerMenuBloc>().add(FetchCustomerMenus());
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> pageTitles = [
      'Pesan Makanan & Minuman',
      'Riwayat Pesanan',
      'Profil Saya',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitles[_selectedIndex]),
        backgroundColor: AppColors.primaryRed,
        foregroundColor: Colors.white,
        actions: [
          if (_selectedIndex == 0)
            BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                if (state is CartLoaded && state.items.isNotEmpty) {
                  final totalQuantity = state.items.fold<int>(
                    0,
                    (previousValue, element) =>
                        previousValue + element.quantity,
                  );
                  return Badge(
                    label: Text('$totalQuantity'),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OrderScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.shopping_cart_outlined),
                    ),
                  );
                }
                return IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OrderScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart_outlined),
                );
              },
            ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primaryRed,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
