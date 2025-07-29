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

  // GlobalKey for accessing Navigator context
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static bool _navigatorKeySet = false; // Flag to prevent duplicate setting

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_navigatorKeySet && context.mounted) {
        print('MyApp: Setting navigator key at ${DateTime.now()}');
        notificationProvider.setNavigatorKey(navigatorKey);
        _navigatorKeySet = true;
      }
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Giao Đồ Ăn',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      navigatorKey: navigatorKey, // Attach the navigator key
      builder: (context, child) {
        // Đảm bảo Overlay có sẵn trong context
        return Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (context) => AppBackground(child: child ?? const SizedBox()),
            ),
          ],
        );
      },
    );
  }
}
