import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_navigator.dart';
import '../../theme/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final success = await auth.loadUser();

    if (!mounted) return;

    if (success) {
      AppNavigator.toHome(context);
    } else {
      AppNavigator.toLogin(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? LinearGradient(
                  colors: [theme.colorScheme.background, theme.colorScheme.surface],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : const LinearGradient(
                  colors: [Color(0xFFFFB074), Color(0xFFFDE8D0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: isDark ? theme.colorScheme.surface.withOpacity(0.98) : Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black54 : Colors.black12,
                  blurRadius: 18,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: isDark
                        ? LinearGradient(
                            colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : const LinearGradient(
                            colors: [AppTheme.primaryColor, Colors.orangeAccent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Icon(Icons.fastfood, size: 72, color: Colors.white),
                ),
                const SizedBox(height: 20),
                Text(
                  "Foodie App",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: isDark ? theme.colorScheme.primary : AppTheme.primaryColor,
                    fontSize: 30,
                    letterSpacing: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Đặt món nhanh & tiện lợi",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: isDark ? theme.colorScheme.onSurface : Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 32),
                CircularProgressIndicator(
                  color: isDark ? theme.colorScheme.primary : Colors.deepOrange,
                  strokeWidth: 3.2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
