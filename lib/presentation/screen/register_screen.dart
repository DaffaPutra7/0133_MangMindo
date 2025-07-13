import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projek_akhir/core/core.dart';
import 'package:projek_akhir/data/model/request/auth/register_request_model.dart';
import 'package:projek_akhir/data/repository/auth_repository.dart';
import 'package:projek_akhir/presentation/auth/register/bloc/register_bloc.dart';
import 'package:projek_akhir/presentation/screen/user/map/map_screen.dart';
import 'package:projek_akhir/service/service_http_client.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LatLng? _pickedLocation;
  String? _pickedAddress;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(AuthRepository(ServiceHttpClient())),
      child: Scaffold(
        appBar: AppBar(title: const Text('Registrasi')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: BlocConsumer<RegisterBloc, RegisterState>(
            listener: (context, state) {
              if (state is RegisterFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.primaryRed,
                  ),
                );
              }
              if (state is RegisterSuccess) {
                nameController.clear();
                emailController.clear();
                passwordController.clear();
                setState(() {
                  _pickedAddress = null;
                  _pickedLocation = null;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Registrasi berhasil!'),
                    backgroundColor: AppColors.primaryGreen,
                  ),
                );
                Navigator.pop(context);
              }
            },
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Buat Akun Baru',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryRed,
                    ),
                  ),
                  const SpaceHeight(40.0),
                  CustomTextField(
                    controller: nameController,
                    label: 'Nama Lengkap',
                  ),
                  const SpaceHeight(20.0),
                  CustomTextField(controller: emailController, label: 'Email'),
                  const SpaceHeight(20.0),
                  CustomTextField(
                    controller: passwordController,
                    label: 'Password',
                    obscureText: true,
                  ),
                  const SpaceHeight(20.0),

                  InkWell(
                    onTap: () async {
                      final result = await Navigator.push<PickedLocation>(
                        context,
                        MaterialPageRoute(builder: (context) => const MapScreen()),
                      );

                      if (result != null) {
                        setState(() {
                          _pickedLocation = result.latLng;
                          _pickedAddress = result.address;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on_outlined, color: AppColors.primaryRed),
                          const SpaceWidth(10),
                          Expanded(
                            child: Text(
                              _pickedAddress ?? 'Pilih Lokasi',
                              style: TextStyle(color: _pickedAddress == null ? Colors.grey.shade600 : Colors.black),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                  
                  const SpaceHeight(40.0),
                  Button.filled(
                    isLoading: state is RegisterLoading,
                    onPressed: () {
                      final data = RegisterRequestModel(
                        name: nameController.text,
                        email: emailController.text,
                        password: passwordController.text,
                        latitude: _pickedLocation?.latitude,
                        longitude: _pickedLocation?.longitude,
                      );
                      context.read<RegisterBloc>().add(
                        RegisterButtonPressed(data: data),
                      );
                    },
                    label: 'Registrasi',
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
