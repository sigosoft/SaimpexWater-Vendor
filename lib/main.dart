import 'package:flutter/material.dart';
import 'package:saimpexwater_vendorapp/core/constants/app_colors.dart';
import 'package:saimpexwater_vendorapp/views/login/login_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SaimpexVendorApp());
}

class SaimpexVendorApp extends StatelessWidget {
  const SaimpexVendorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saimpex Vendor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.backgroundTop,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryOrange,
          surface: AppColors.card,
        ),
      ),
      home: const LoginView(),
    );
  }
}
