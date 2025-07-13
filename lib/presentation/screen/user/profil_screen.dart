import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:projek_akhir/core/core.dart';
import 'package:projek_akhir/data/model/response/auth/auth_response_model.dart';
import 'package:projek_akhir/presentation/auth/login/bloc/login_bloc.dart';
import 'package:projek_akhir/presentation/screen/user/camera/camera_screen.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  File? _imageFile;
  User? _user;

  @override
  void initState() {
    super.initState();
    final authState = context.read<LoginBloc>().state;
    if (authState is LoginSuccess) {
      _user = authState.authResponse.user;
    }
  }

  // Fungsi untuk meminta izin dan membuka kamera
  Future<void> _openCamera() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      final File? result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CameraScreen()),
      );
      if (result != null) {
        setState(() {
          _imageFile = result;
        });
        // TODO: Tambahkan logika untuk upload foto ke local storage/server
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Izin kamera ditolak.')));
    }
  }

  // Fungsi untuk memilih dari galeri
  Future<void> _pickFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
      // TODO: Tambahkan logika untuk upload foto ke local storage/server
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SpaceHeight(20),
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300],
                  backgroundImage:
                      _imageFile != null ? FileImage(_imageFile!) : null,
                  child: _imageFile == null
                      ? const Icon(Icons.person, size: 60, color: Colors.grey)
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: AppColors.primaryRed,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt,
                          color: Colors.white, size: 20),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext bc) {
                            return SafeArea(
                              child: Wrap(
                                children: <Widget>[
                                  ListTile(
                                      leading: const Icon(Icons.photo_camera),
                                      title: const Text('Ambil Foto'),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        _openCamera();
                                      }),
                                  ListTile(
                                    leading: const Icon(Icons.photo_library),
                                    title: const Text('Pilih dari Galeri'),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      _pickFromGallery();
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          const SpaceHeight(24),
          Card(
            child: ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Nama'),
              subtitle: Text(_user?.name ?? '-'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email'),
              subtitle: Text(_user?.email ?? '-'),
            ),
          ),
          const SpaceHeight(40),

          // ✅ PERBAIKAN DI SINI
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Apakah Anda yakin ingin logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          context.read<LoginBloc>().add(LogoutButtonPressed());
                        },
                        child: const Text('Logout',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryRed,
                side: const BorderSide(color: AppColors.primaryRed),
              ),
              child: const Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }
}