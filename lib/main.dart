import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projek_akhir/core/constants/colors.dart';
import 'package:projek_akhir/data/repository/admin_menu_repository.dart';
import 'package:projek_akhir/data/repository/auth_repository.dart';
import 'package:projek_akhir/presentation/admin/menu/bloc/menu_bloc.dart';
import 'package:projek_akhir/presentation/auth/bloc/login/bloc/login_bloc.dart';
import 'package:projek_akhir/presentation/screen/login_screen.dart';
import 'package:projek_akhir/service/service_http_client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Gunakan MultiBlocProvider untuk menyediakan semua BLoC
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(
            AuthRepository(ServiceHttpClient()),
          ),
        ),
        BlocProvider(
          create: (context) => MenusBloc(
            AdminMenuRepository(ServiceHttpClient()),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MangMindo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryRed),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: AppColors.lightGrey,
          )
        ),
        home: const LoginPage(),
      ),
    );
  }
}