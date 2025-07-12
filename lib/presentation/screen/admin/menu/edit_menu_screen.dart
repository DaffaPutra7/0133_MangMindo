import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projek_akhir/core/core.dart';
import 'package:projek_akhir/core/helper/image_helper.dart';
import 'package:projek_akhir/data/model/request/admin/admin_menu_request_model.dart';
import 'package:projek_akhir/data/model/response/admin/admin_menu_response_model.dart';
import 'package:projek_akhir/data/repository/admin_menu_repository.dart';
import 'package:projek_akhir/presentation/admin/editMenu/bloc/edit_menu_bloc.dart';
import 'package:projek_akhir/service/service_http_client.dart';

class EditMenuScreen extends StatefulWidget {
  final Menu menu;
  const EditMenuScreen({super.key, required this.menu});

  @override
  State<EditMenuScreen> createState() => _EditMenuScreenState();
}

class _EditMenuScreenState extends State<EditMenuScreen> {
  late final TextEditingController nameController;
  late final TextEditingController priceController;
  late final TextEditingController descriptionController;
  // XFile? _imageFile;

  @override
  void initState() {
    nameController = TextEditingController(text: widget.menu.name);
    priceController = TextEditingController(text: widget.menu.price.toInt().toString());
    descriptionController = TextEditingController(text: widget.menu.description ?? '');
    super.initState();
  }

  // void _pickImage() async {
  //   final image = await ImageHelper().pickFromGallery();
  //   if (image != null) {
  //     setState(() {
  //       _imageFile = image;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditMenuBloc(AdminMenuRepository(ServiceHttpClient())),
      child: Scaffold(
        appBar: AppBar(title: const Text('Edit Menu')),
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
              // InkWell(
              //   onTap: _pickImage,
              //   child: Container(
              //     width: double.infinity,
              //     height: 150,
              //     decoration: BoxDecoration(
              //       border: Border.all(color: AppColors.grey),
              //       borderRadius: BorderRadius.circular(10.0),
              //     ),
              //     child: _imageFile != null
              //         ? Image.file(File(_imageFile!.path), fit: BoxFit.cover)
              //         : (widget.menu.image != null
              //             ? Image.network(
              //                 'http://10.0.2.2:8000${widget.menu.image}',
              //                 fit: BoxFit.cover,
              //               )
              //             : const Column(
              //                 mainAxisAlignment: MainAxisAlignment.center,
              //                 children: [
              //                   Icon(Icons.add_a_photo, color: AppColors.grey),
              //                   Text('Pilih Gambar', style: TextStyle(color: AppColors.grey)),
              //                 ],
              //               )),
              //   ),
              // ),
              const SpaceHeight(40),
              BlocConsumer<EditMenuBloc, EditMenuState>(
                listener: (context, state) {
                  if (state is EditMenuSuccess) {
                    Navigator.pop(context, true);
                  }
                  if (state is EditMenuFailure) {
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
                    isLoading: state is EditMenuLoading,
                    onPressed: () {
                      final model = AddMenuRequestModel(
                        name: nameController.text,
                        price: int.tryParse(priceController.text) ?? 0,
                        description: descriptionController.text,
                        // image: _imageFile,
                      );
                      context
                          .read<EditMenuBloc>()
                          .add(UpdateMenuButtonPressed(menuId: widget.menu.id, data: model));
                    },
                    label: 'Simpan Perubahan',
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