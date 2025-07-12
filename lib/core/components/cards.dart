import 'package:flutter/material.dart';
import 'package:projek_akhir/data/model/response/admin/admin_menu_response_model.dart';
import 'package:projek_akhir/core/core.dart';

class MenuCard extends StatelessWidget {
  final Menu data;
  final VoidCallback onEditTap;
  final VoidCallback onDeleteTap;

  const MenuCard({
    super.key,
    required this.data,
    required this.onEditTap,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12.0),
        leading: const Icon(
          Icons.fastfood,
          size: 40,
          color: Colors.grey,
        ),
        title: Text(
          data.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            // Harga
            Text(
              data.price.toInt().currencyFormatRp,
              style: const TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4.0), 
            // Deskripsi
            Text(
              // Menangani jika deskripsi kosong (null)
              data.description ?? 'Tidak ada deskripsi', 
              style: TextStyle(color: Colors.grey[600]),
              maxLines: 2, 
              overflow: TextOverflow.ellipsis, 
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: AppColors.grey),
              onPressed: onEditTap,
            ),
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: AppColors.primaryRed,
              ),
              onPressed: onDeleteTap,
            ),
          ],
        ),
      ),
    );
  }
}