import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'login_screen.dart';

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

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final success = await auth.register(
      name: nameCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
      email: emailCtrl.text.trim().isEmpty ? null : emailCtrl.text.trim(),
      password: passCtrl.text,
    );

    setState(() => isLoading = false);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đăng ký thành công")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đăng ký thất bại")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng ký')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Họ tên')),
            TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Số điện thoại')),
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email (không bắt buộc)')),
            TextField(controller: passCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Mật khẩu')),
            const SizedBox(height: 16),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(onPressed: _register, child: const Text('Đăng ký')),
            TextButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              ),
              child: const Text("Đã có tài khoản? Đăng nhập"),
            )
          ],
        ),
      ),
    );
  }
}
