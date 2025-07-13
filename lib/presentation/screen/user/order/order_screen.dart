import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart'; 
import 'package:projek_akhir/core/core.dart';
import 'package:projek_akhir/data/model/request/user/order_request_model.dart';
import 'package:projek_akhir/data/model/response/auth/auth_response_model.dart'; 
import 'package:projek_akhir/data/repository/order_repository.dart';
import 'package:projek_akhir/presentation/auth/login/bloc/login_bloc.dart'; 
import 'package:projek_akhir/presentation/user/cart/bloc/cart_bloc.dart';
import 'package:projek_akhir/presentation/user/order/bloc/order_bloc.dart';
import 'package:projek_akhir/service/service_http_client.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  // state untuk menyimpan alamat dan data user
  String _userAddress = 'Memuat alamat...';
  User? _user;

  @override
  void initState() {
    super.initState();
    final authState = context.read<LoginBloc>().state;
    if (authState is LoginSuccess) {
      _user = authState.authResponse.user;
      // Panggil fungsi untuk mendapatkan alamat dari koordinat
      _getUserAddress();
    } else {
      _userAddress = 'Gagal memuat data pengguna.';
    }
  }

  // Fungsi untuk mengubah koordinat (lat, long) menjadi alamat lengkap
  Future<void> _getUserAddress() async {
    // Pastikan user dan koordinatnya tidak null
    if (_user?.latitude != null && _user?.longitude != null) {
      try {
        // Lakukan reverse geocoding
        final placemarks = await placemarkFromCoordinates(
          double.parse(_user!.latitude!),
          double.parse(_user!.longitude!),
        );

        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          // Update state dengan alamat yang sudah diformat
          setState(() {
            _userAddress =
                '${p.street}, ${p.subLocality}, ${p.locality}, ${p.postalCode}, ${p.country}';
          });
        }
      } catch (e) {
        setState(() {
          _userAddress = 'Gagal mengubah koordinat menjadi alamat.';
        });
      }
    } else {
      setState(() {
        _userAddress = 'Pengguna ini tidak mendaftarkan lokasi.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderBloc(OrderRepository(ServiceHttpClient())),
      child: Scaffold(
        appBar: AppBar(title: const Text('Konfirmasi Pesanan')),
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is! CartLoaded || state.items.isEmpty) {
              return const Center(child: Text('Keranjang Anda kosong.'));
            }
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const Text('Item Pesanan', style: TextStyle(fontWeight: FontWeight.bold)),
                ...state.items.map((item) {
                  return ListTile(
                    title: Text(item.menu.name),
                    subtitle: Text(
                        '${item.quantity} x ${item.menu.price.toInt().currencyFormatRp}'),
                    trailing: Text(
                        (item.quantity * item.menu.price).toInt().currencyFormatRp),
                  );
                }).toList(),
                const Divider(),
                
                // Tampilkan alamat dari state _userAddress
                const Text('Alamat Pengiriman', style: TextStyle(fontWeight: FontWeight.bold)),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(_userAddress),
                  ),
                ),
                const SpaceHeight(16),

                const Text('Metode Pembayaran', style: TextStyle(fontWeight: FontWeight.bold)),
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Row(children: [
                      Icon(Icons.money),
                      SpaceWidth(10),
                      Text('Cash On Delivery (COD)')
                    ]),
                  ),
                ),
                const SpaceHeight(24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Harga:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(state.totalPrice.toInt().currencyFormatRp,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
                const SpaceHeight(24),
                BlocConsumer<OrderBloc, OrderState>(
                  listener: (context, orderState) {
                    if (orderState is OrderSuccess) {
                      context.read<CartBloc>().add(ClearCart());

                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Pesanan berhasil dibuat!'),
                        backgroundColor: AppColors.primaryGreen,
                      ));
                      Navigator.pop(context); // Kembali ke halaman menu
                    }
                    if (orderState is OrderFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(orderState.message),
                        backgroundColor: AppColors.primaryRed,
                      ));
                    }
                  },
                  builder: (context, orderState) {
                    return Button.filled(
                      isLoading: orderState is OrderLoading,
                      onPressed: () {
                        final orderModel = OrderRequestModel(items: state.items);
                        context.read<OrderBloc>().add(DoOrder(model: orderModel));
                      },
                      label: 'Pesan Sekarang',
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}