import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_navigator.dart';
import '../../theme/theme.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool isLoading = false;
  bool rememberMe = false;
  bool showPassword = false;

  void _login() async {
    setState(() => isLoading = true);

    final auth = context.read<AuthProvider>();
    final success = await auth.login(phoneCtrl.text.trim(), passCtrl.text.trim());

    if (success && rememberMe) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('remember_me', true);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('remember_me', false);
    }

    setState(() => isLoading = false);

    if (success) {
      final user = context.read<AuthProvider>().user;
      if (user != null && user.role == 'shipper') {
        Navigator.of(context).pushReplacementNamed('/shipper');
      } else {
        AppNavigator.toHome(context);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng nhập thất bại')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadRememberMe();
  }

  void _loadRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getBool('remember_me') ?? false;
    setState(() => rememberMe = saved);
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
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? theme.colorScheme.surface.withOpacity(0.98) : Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black54 : Colors.black12,
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
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
                      padding: const EdgeInsets.all(16),
                      child: Icon(Icons.fastfood, size: 64, color: isDark ? Colors.white : Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Foodie App',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: isDark ? theme.colorScheme.primary : AppTheme.primaryColor,
                        fontSize: 28,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      'Đặt món nhanh chóng & dễ dàng',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: isDark ? theme.colorScheme.onSurface : Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 32),
                    AppTextField(
                      controller: phoneCtrl,
                      hintText: 'Số điện thoại',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: passCtrl,
                      hintText: 'Mật khẩu',
                      icon: Icons.lock,
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: rememberMe,
                          onChanged: (val) => setState(() => rememberMe = val ?? false),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          activeColor: isDark ? theme.colorScheme.primary : AppTheme.primaryColor,
                        ),
                        Text('Ghi nhớ', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700, color: isDark ? theme.colorScheme.onSurface : null)),
                        const Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: Text('Quên mật khẩu?', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: isLoading
                          ? Center(child: CircularProgressIndicator(color: isDark ? theme.colorScheme.primary : null))
                          : AppButton(
                              label: 'Đăng nhập',
                              onPressed: _login,
                              isLoading: isLoading,
                              icon: Icons.login,
                            ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Chưa có tài khoản?", style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700, color: isDark ? theme.colorScheme.onSurface : null)),
                        TextButton(
                          onPressed: () => AppNavigator.toRegister(context),
                          child: Text("Đăng ký ngay", style: theme.textTheme.bodyMedium?.copyWith(color: isDark ? theme.colorScheme.primary : AppTheme.primaryColor, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
