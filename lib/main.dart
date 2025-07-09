import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/restaurant_provider.dart';
import 'providers/home_provider.dart';
import 'screens/auth/splash_screen.dart';
import 'services/dio_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DioService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RestaurantProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App giao đồ ăn',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const SplashScreen(),
    );
  }
}
