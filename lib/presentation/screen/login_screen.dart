import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projek_akhir/data/model/request/auth/login_request_model.dart';
import 'package:projek_akhir/presentation/auth/bloc/login/bloc/login_bloc.dart';
import '../../core/core.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isShowPassword = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SpaceHeight(80.0),
              Image.asset(
                "assets/images/logo.png", 
                height: 150, // Atur ukuran tinggi logo
              ),
              const Text(
                'Selamat Datang di MangMindo',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryRed,
                ),
              ),
              const SpaceHeight(40.0),
              CustomTextField(controller: emailController, label: 'Email'),
              const SpaceHeight(20.0),
              CustomTextField(
                controller: passwordController,
                label: 'Password',
                obscureText: !isShowPassword,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isShowPassword = !isShowPassword;
                    });
                  },
                  icon: Icon(
                    isShowPassword ? Icons.visibility : Icons.visibility_off,
                    color: AppColors.grey,
                  ),
                ),
              ),
              const SpaceHeight(40.0),
              BlocConsumer<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state is LoginFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: AppColors.primaryRed,
                      ),
                    );
                  } else if (state is LoginSuccess) {
                    final role = state.authResponse.role;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Login berhasil sebagai $role!'),
                        backgroundColor: AppColors.primaryGreen,
                      ),
                    );
                    if (role == 'admin') {
                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminDashboardPage()));
                    } else {
                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const CustomerDashboardPage()));
                    }
                  }
                },
                builder: (context, state) {
                  return Button.filled(
                    isLoading: state is LoginLoading,
                    onPressed: () {
                      final data = LoginRequestModel(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                      context.read<LoginBloc>().add(
                        LoginButtonPressed(data: data),
                      );
                    },
                    label: 'Login',
                  );
                },
              ),
              const SpaceHeight(20.0),
            ],
          ),
        ),
      ),
    );
  }
}
