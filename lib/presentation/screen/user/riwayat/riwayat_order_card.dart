import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projek_akhir/core/core.dart';
import 'package:projek_akhir/data/model/response/user/order_riwayat_model.dart';
import 'package:projek_akhir/presentation/screen/user/review/add_review_screen.dart';

class RiwayatOrderCard extends StatelessWidget {
  final OrderModel data;

  final VoidCallback? onReviewSuccess;

  const RiwayatOrderCard({super.key, required this.data, this.onReviewSuccess});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;

    switch (data.status) {
      case 'pending':
        statusColor = Colors.orange;
        statusText = 'Menunggu Konfirmasi';
        break;
      case 'diterima':
        statusColor = Colors.blue;
        statusText = 'Pesanan Diterima';
        break;
      case 'dimasak':
        statusColor = Colors.deepPurple;
        statusText = 'Pesanan Sedang Dimasak';
        break;
      case 'diantar':
        statusColor = Colors.lightBlue;
        statusText = 'Pesanan Sedang Diantar';
        break;
      case 'selesai':
        statusColor = AppColors.primaryGreen;
        statusText = 'Pesanan Sudah Diterima';
        break;
      case 'cancelled':
        statusColor = AppColors.primaryRed;
        statusText = 'Pesanan Dibatalkan';
        break;
      default:
        statusColor = Colors.grey;
        statusText = data.status.toUpperCase();
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pesanan #${data.id}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              DateFormat('dd MMMM yyyy, HH:mm').format(data.createdAt),
              style: const TextStyle(color: Colors.grey),
            ),
            const Divider(height: 24),
            // Menampilkan ringkasan item
            Text(
              data.items
                  .map((item) => '${item.quantity}x ${item.menu.name}')
                  .join('\n'),
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Harga', style: TextStyle(color: Colors.grey)),
                Text(
                  data.totalPrice.toInt().currencyFormatRp,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            if (data.status == 'selesai' &&
                data.review == null &&
                onReviewSuccess != null) ...[
              const Divider(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddReviewScreen(orderId: data.id),
                      ),
                    );
                    if (result == true) {
                      onReviewSuccess?.call();
                    }
                  },
                  child: const Text('Beri Ulasan'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
