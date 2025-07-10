import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_navigator.dart';
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

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.fastfood, size: 64),
                const SizedBox(height: 12),
                Text(
                  'Tạo tài khoản',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(fontSize: 22),
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
                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : AppButton(
                          label: 'Đăng ký',
                          onPressed: _register,
                          isLoading: isLoading,
                          icon: Icons.person_add,
                        )
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Đã có tài khoản?"),
                    TextButton(
                      onPressed: () => AppNavigator.toLogin(context),
                      child: const Text("Đăng nhập"),
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
