import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      appBar: AppBar(title: const Text('Tài khoản')),
      body: ListView(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CircleAvatar(radius: 30, child: Icon(Icons.person, size: 30)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user?.name ?? 'Người dùng',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('SĐT: ${user?.phone ?? ''}'),
                      if (user?.email != null && user!.email!.isNotEmpty)
                        Text('Email: ${user.email}', style: const TextStyle(color: Colors.black54)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Các mục cài đặt
          const _MenuTile(title: 'Cập nhật hồ sơ', icon: Icons.edit),
          const _MenuTile(title: 'Lịch sử đơn hàng', icon: Icons.receipt_long),
          const _MenuTile(title: 'Địa chỉ giao hàng', icon: Icons.location_on),
          const _MenuTile(title: 'Đổi mật khẩu', icon: Icons.lock),
          const _MenuTile(title: 'Liên hệ hỗ trợ', icon: Icons.support_agent),
          const _MenuTile(title: 'Điều khoản & Chính sách', icon: Icons.privacy_tip),

          const SizedBox(height: 20),
          // Đăng xuất
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              onPressed: () async {
                await context.read<AuthProvider>().logout();
                
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                }
              },
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text('Đăng xuất', style: TextStyle(color: Colors.red)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final String title;
  final IconData icon;

  const _MenuTile({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // TODO: điều hướng đến màn hình tương ứng
      },
    );
  }
}
