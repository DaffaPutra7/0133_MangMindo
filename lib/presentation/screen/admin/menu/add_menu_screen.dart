import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projek_akhir/core/helper/image_helper.dart';
import 'package:projek_akhir/data/model/request/admin/admin_menu_request_model.dart';
import 'package:projek_akhir/data/repository/admin_menu_repository.dart';
import 'package:projek_akhir/presentation/admin/addMenu/bloc/add_menu_bloc.dart';
import 'package:projek_akhir/service/service_http_client.dart';
import '../../../../core/core.dart';

class AddMenuscreen extends StatefulWidget {
  const AddMenuscreen({super.key});

  @override
  State<AddMenuscreen> createState() => _AddMenuscreenState();
}

class _AddMenuscreenState extends State<AddMenuscreen> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  XFile? _imageFile;

  void _pickImage() async {
    final image = await ImageHelper().pickFromGallery();
    if (image != null) {
      setState(() {
        _imageFile = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddMenuBloc(
        AdminMenuRepository(ServiceHttpClient()),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tambah Menu Baru'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              CustomTextField(controller: nameController, label: 'Nama Menu'),
              const SpaceHeight(20),
              CustomTextField(
                controller: priceController,
                label: 'Harga',
                keyboardType: TextInputType.number,
              ),
              const SpaceHeight(20),
              CustomTextField(
                controller: descriptionController,
                label: 'Deskripsi',
                maxLines: 3,
              ),
              const SpaceHeight(20),
              // Image Picker
              InkWell(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: _imageFile != null
                      ? Image.file(File(_imageFile!.path), fit: BoxFit.cover)
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo, color: AppColors.grey),
                            Text('Pilih Gambar', style: TextStyle(color: AppColors.grey)),
                          ],
                        ),
                ),
              ),
              const SpaceHeight(40),
              BlocConsumer<AddMenuBloc, AddMenuState>(
                listener: (context, state) {
                  if (state is AddMenuSuccess) {
                    Navigator.pop(context, true); // Kembali & kirim sinyal sukses
                  }
                  if (state is AddMenuFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: AppColors.primaryRed,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return Button.filled(
                    isLoading: state is AddMenuLoading,
                    onPressed: () {
                      final model = AddMenuRequestModel(
                        name: nameController.text,
                        price: int.tryParse(priceController.text) ?? 0,
                        description: descriptionController.text,
                        image: _imageFile,
                      );
                      context.read<AddMenuBloc>().add(AddNewMenu(model: model));
                    },
                    label: 'Simpan Menu',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}