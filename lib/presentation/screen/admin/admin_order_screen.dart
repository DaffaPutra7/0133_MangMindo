import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projek_akhir/core/core.dart';
import 'package:projek_akhir/data/model/response/user/order_riwayat_model.dart';
import 'package:projek_akhir/data/repository/admin_order_repository.dart';
import 'package:projek_akhir/presentation/admin/order/bloc/admin_order_bloc.dart';
import 'package:projek_akhir/presentation/screen/user/riwayat/riwayat_order_card.dart';
import 'package:projek_akhir/service/service_http_client.dart';

class AdminOrderScreen extends StatelessWidget {
  const AdminOrderScreen({super.key});

  void _showUpdateStatusDialog(BuildContext context, OrderModel order) {
    final statuses = ['diterima', 'dimasak', 'diantar', 'selesai', 'cancelled'];
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return SimpleDialog(
          title: Text('Update Status Pesanan #${order.id}'),
          children: statuses.map((status) {
            return SimpleDialogOption(
              onPressed: () {
                context.read<AdminOrderBloc>().add(
                    UpdateStatusOrder(orderId: order.id, newStatus: status));
                Navigator.pop(dialogContext);
              },
              child: Text(status.toUpperCase()),
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminOrderBloc(
        AdminOrderRepository(ServiceHttpClient()),
      )..add(FetchAllOrders()),
      child: BlocListener<AdminOrderBloc, AdminOrderState>(
        listener: (context, state) {
          if (state is AdminOrderUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Status berhasil diubah.'),
              backgroundColor: AppColors.primaryGreen,
            ));
            context.read<AdminOrderBloc>().add(FetchAllOrders());
          }
           if (state is AdminOrderUpdateFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.primaryRed,
            ));
          }
        },
        child: BlocBuilder<AdminOrderBloc, AdminOrderState>(
          builder: (context, state) {
            if (state is AdminOrderLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is AdminOrderError) {
              return Center(child: Text(state.message));
            }
            if (state is AdminOrderLoaded) {
              if (state.orderResponse.data.isEmpty) {
                return const Center(child: Text('Belum ada pesanan masuk.'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: state.orderResponse.data.length,
                itemBuilder: (context, index) {
                  final order = state.orderResponse.data[index];
                  return GestureDetector(
                    onTap: () => _showUpdateStatusDialog(context, order),
                    child: RiwayatOrderCard(data: order),
                  );
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