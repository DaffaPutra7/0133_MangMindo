import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projek_akhir/core/core.dart';
// import 'package:projek_akhir/data/repository/customer_menu_repository.dart';
// import 'package:projek_akhir/presentation/screen/user/order/order_screen.dart';
import 'package:projek_akhir/presentation/user/cart/bloc/cart_bloc.dart';
import 'package:projek_akhir/presentation/user/menu/bloc/customer_menu_bloc.dart';
// import 'package:projek_akhir/service/service_http_client.dart';

class CustomerMenuPage extends StatelessWidget {
  const CustomerMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerMenuBloc, CustomerMenuState>(
      builder: (context, state) {
        if (state is CustomerMenuLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is CustomerMenuError) {
          return Center(child: Text(state.message));
        }
        if (state is CustomerMenuLoaded) {
          if (state.menuResponse.data.isEmpty) {
            return const Center(child: Text('Saat ini belum ada menu.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: state.menuResponse.data.length,
            itemBuilder: (context, index) {
              final menu = state.menuResponse.data[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16.0),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: const Icon(
                    Icons.fastfood,
                    size: 40,
                    color: Colors.grey,
                  ),
                  title: Text(
                    menu.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        menu.price.toInt().currencyFormatRp,
                        style: const TextStyle(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (menu.description != null &&
                          menu.description!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            menu.description!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.add_shopping_cart,
                      color: AppColors.primaryRed,
                    ),
                    onPressed: () {
                      context.read<CartBloc>().add(AddToCart(item: menu));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${menu.name} ditambahkan ke keranjang.',
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        }
        return const Center(child: Text('Selamat Datang!'));
      },
    );
  }
}
