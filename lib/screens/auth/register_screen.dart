import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_navigator.dart';
import '../../theme/theme.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool isLoading = false;

  void _register() async {
    setState(() => isLoading = true);

    final auth = context.read<AuthProvider>();
    final success = await auth.register(
      name: nameCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
      email: emailCtrl.text.trim().isEmpty ? null : emailCtrl.text.trim(),
      password: passCtrl.text,
    );

    setState(() => isLoading = false);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? "Đăng ký thành công" : "Đăng ký thất bại"),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );

    if (success) AppNavigator.toLogin(context);
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      'Tạo tài khoản',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: isDark ? theme.colorScheme.primary : AppTheme.primaryColor,
                        fontSize: 28,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      'Đăng ký để trải nghiệm dịch vụ tốt nhất',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: isDark ? theme.colorScheme.onSurface : Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 32),
                    AppTextField(
                      controller: nameCtrl,
                      hintText: 'Họ tên',
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: phoneCtrl,
                      hintText: 'Số điện thoại',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: emailCtrl,
                      hintText: 'Email (không bắt buộc)',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: passCtrl,
                      hintText: 'Mật khẩu',
                      icon: Icons.lock,
                      obscureText: true,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: isLoading
                          ? Center(child: CircularProgressIndicator(color: isDark ? theme.colorScheme.primary : null))
                          : AppButton(
                              label: 'Đăng ký',
                              onPressed: _register,
                              isLoading: isLoading,
                              icon: Icons.person_add,
                            ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Đã có tài khoản?", style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700, color: isDark ? theme.colorScheme.onSurface : null)),
                        TextButton(
                          onPressed: () => AppNavigator.toLogin(context),
                          child: Text("Đăng nhập", style: theme.textTheme.bodyMedium?.copyWith(color: isDark ? theme.colorScheme.primary : AppTheme.primaryColor, fontWeight: FontWeight.bold)),
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
