import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/home_provider.dart';
import 'providers/restaurant_provider.dart';
import 'providers/notification_provider.dart';
import 'theme/theme_provider.dart';
import 'routes/routes.dart';
import 'services/dio_service.dart';
import 'theme/app_background.dart';
import 'theme/theme.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('vi_VN', null);

  if (!kIsWeb && Platform.isAndroid) {
    WebViewPlatform.instance = AndroidWebViewPlatform();
  }

  await DioService.init();

  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => RestaurantProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Giao Đồ Ăn',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.onGenerateRoute,

      builder: (context, child) => AppBackground(child: child ?? const SizedBox()),
    );
  }
}
