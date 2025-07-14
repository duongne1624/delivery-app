import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/theme_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Tài khoản')),
      body: ListView(
        children: [
          // Thông tin người dùng
          Container(
            color: colorScheme.surface,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: colorScheme.primary.withOpacity(0.1),
                  child: Icon(Icons.person, size: 30, color: colorScheme.onSurface),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? 'Người dùng',
                        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text('SĐT: ${user?.phone ?? ''}', style: theme.textTheme.bodyMedium),
                      if (user?.email != null && user!.email!.isNotEmpty)
                        Text('Email: ${user.email}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.6),
                            )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Danh sách menu
          const _MenuTile(title: 'Cập nhật hồ sơ', icon: Icons.edit),
          const _MenuTile(title: 'Lịch sử đơn hàng', icon: Icons.receipt_long),
          const _MenuTile(title: 'Địa chỉ giao hàng', icon: Icons.location_on),
          const _MenuTile(title: 'Đổi mật khẩu', icon: Icons.lock),
          const _MenuTile(title: 'Liên hệ hỗ trợ', icon: Icons.support_agent),
          const _MenuTile(title: 'Điều khoản & Chính sách', icon: Icons.privacy_tip),

          // Toggle theme (nằm trong danh sách)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.color_lens, color: colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Giao diện', style: theme.textTheme.bodyMedium),
                ),
                Icon(
                  isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Switch(
                  value: !isDarkMode,
                  onChanged: (value) {
                    context.read<ThemeProvider>().toggleTheme(!value);
                  },
                  activeColor: colorScheme.primary,
                ),
              ],
            ),
          ),


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
              icon: Icon(Icons.logout, color: Colors.red.shade400),
              label: Text('Đăng xuất', style: TextStyle(color: Colors.red.shade400)),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.red.shade400),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      leading: Icon(icon, color: colorScheme.primary),
      title: Text(title, style: theme.textTheme.bodyMedium),
      trailing: Icon(Icons.chevron_right, color: colorScheme.onSurface.withOpacity(0.6)),
      onTap: () {
        // TODO: điều hướng đến màn hình tương ứng
      },
    );
  }
}
