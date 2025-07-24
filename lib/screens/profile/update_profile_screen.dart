import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final user = context.watch<AuthProvider>().user;
    return Scaffold(
      appBar: AppBar(title: const Text('Cập nhật hồ sơ')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Họ và tên',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Vui lòng nhập họ tên' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return null;
                  final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]');
                  if (!emailRegex.hasMatch(value)) return 'Email không hợp lệ';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      await context.read<AuthProvider>().updateProfile(
                        name: _nameController.text.trim(),
                        email: _emailController.text.trim(),
                      );
                      if (context.mounted) Navigator.pop(context);
                    }
                  },
                  child: const Text('Lưu thay đổi', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
