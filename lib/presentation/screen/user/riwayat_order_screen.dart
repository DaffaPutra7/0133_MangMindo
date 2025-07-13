import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projek_akhir/data/repository/order_repository.dart';
import 'package:projek_akhir/presentation/screen/user/riwayat/riwayat_order_card.dart';
import 'package:projek_akhir/presentation/user/riwayat/bloc/riwayat_bloc.dart';
import 'package:projek_akhir/service/service_http_client.dart';

class RiwayatOrderScreen extends StatelessWidget {
  const RiwayatOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RiwayatBloc(
        OrderRepository(ServiceHttpClient()),
      )..add(FetchRiwayat()),
      child: Scaffold(
        body: BlocBuilder<RiwayatBloc, RiwayatState>(
          builder: (context, state) {
            if (state is RiwayatLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is RiwayatError) {
              return Center(child: Text(state.message));
            }
            if (state is RiwayatLoaded) {
              if (state.RiwayatResponse.data.isEmpty) {
                return const Center(child: Text('Anda belum memiliki riwayat pesanan.'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: state.RiwayatResponse.data.length,
                itemBuilder: (context, index) {
                  final order = state.RiwayatResponse.data[index];
                  // Gunakan card yang sudah dibuat
                  return RiwayatOrderCard(data: order);
                },
              );
            }
            return const Center(child: Text('Tidak ada data.'));
          },
        ),
      ),
    );
  }
}