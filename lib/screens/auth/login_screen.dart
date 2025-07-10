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
      AppNavigator.toHome(context);
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

    InputDecoration _inputDecoration({required String hint, required IconData icon}) {
      return InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black54),
        prefixIcon: Icon(icon, color: Colors.black45),
        filled: true,
        fillColor: Colors.transparent,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.black26.withOpacity(0.2), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppTheme.primaryColor.withOpacity(0.6), width: 1.2),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.fastfood, size: 72, color: AppTheme.primaryColor),
                const SizedBox(height: 12),
                Text(
                  'Foodie App',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Đặt món nhanh chóng & dễ dàng',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black54),
                ),
                const SizedBox(height: 36),

                // SĐT
                AppTextField(
                  controller: phoneCtrl,
                  hintText: 'Số điện thoại',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: 12),
                // Mật khẩu
                AppTextField(
                  controller: passCtrl,
                  hintText: 'Mật khẩu',
                  icon: Icons.lock,
                  obscureText: true,
                ),

                const SizedBox(height: 12),

                // Nhớ mật khẩu + Quên
                Row(
                  children: [
                    Checkbox(
                      value: rememberMe,
                      onChanged: (val) => setState(() => rememberMe = val ?? false),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    const Text('Ghi nhớ'),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Quên mật khẩu?',
                          style: TextStyle(color: Colors.redAccent)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Nút đăng nhập
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : AppButton(
                          label: 'Đăng nhập',
                          onPressed: _login,
                          isLoading: isLoading,
                          icon: Icons.login,
                        )
                ),

                const SizedBox(height: 24),

                // Đăng ký
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Chưa có tài khoản?"),
                    TextButton(
                      onPressed: () => AppNavigator.toRegister(context),
                      child: const Text("Đăng ký ngay"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
