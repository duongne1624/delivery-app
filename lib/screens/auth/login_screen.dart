import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../home/home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool isLoading = false;

  void _login() async {
    setState(() => isLoading = true);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final success = await auth.login(phoneCtrl.text, passCtrl.text);
    setState(() => isLoading = false);

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng nhập thất bại')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng nhập')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Số điện thoại')),
            TextField(controller: passCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Mật khẩu')),
            const SizedBox(height: 16),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(onPressed: _login, child: const Text('Đăng nhập')),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RegisterScreen()),
              ),
              child: const Text("Chưa có tài khoản? Đăng ký ngay"),
            )
          ],
        ),
      ),
    );
  }
}
