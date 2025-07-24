
import 'package:delivery_online_app/routes/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/shipper_service.dart';
import '../../models/user_model.dart';
import '../../theme/theme_provider.dart';

class ShipperProfileScreen extends StatefulWidget {
  const ShipperProfileScreen({super.key});

  @override
  State<ShipperProfileScreen> createState() => _ShipperProfileScreenState();
}

class _ShipperProfileScreenState extends State<ShipperProfileScreen> {
  late Future<UserModel> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = ShipperService.getProfile();
  }

  void _logout(BuildContext context) async {
    await context.read<AuthProvider>().logout();
    if (mounted) {
      AppNavigator.toLogin(context);
    }
  }

  void _changePassword(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Chức năng đang phát triển!')));
  }

  void _toggleTheme(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = context.read<ThemeProvider>();
    final isDark = theme.brightness == Brightness.dark;
    themeProvider.toggleTheme(!isDark);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(isDark ? 'Đã chuyển sang Light mode' : 'Đã chuyển sang Dark mode')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final isDark = themeProvider.themeMode == ThemeMode.dark;
        return FutureBuilder<UserModel>(
          future: _profileFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.hasError) {
              return const Center(child: Text('Không thể tải thông tin shipper.'));
            }
            final user = snapshot.data!;
            return Container(
              decoration: BoxDecoration(
                gradient: isDark
                    ? const LinearGradient(colors: [Color(0xFF232526), Color(0xFF414345)], begin: Alignment.topLeft, end: Alignment.bottomRight)
                    : const LinearGradient(colors: [Color(0xFFFFE0B2), Color(0xFFFDE8D0)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              ),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 420),
                  margin: const EdgeInsets.symmetric(vertical: 32, horizontal: 12),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black.withOpacity(0.85) : Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? Colors.black54 : Colors.black12,
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          CircleAvatar(
                            radius: 48,
                            backgroundImage: user.image != null && user.image!.isNotEmpty
                                ? NetworkImage(user.image!)
                                : null,
                            child: user.image == null || user.image!.isEmpty
                                ? const Icon(Icons.person, size: 54)
                                : null,
                          ),
                          IconButton(
                            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode, color: isDark ? Colors.yellow : Colors.black54),
                            tooltip: isDark ? 'Chuyển sang Light mode' : 'Chuyển sang Dark mode',
                            onPressed: () => _toggleTheme(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Text(user.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
                      const SizedBox(height: 8),
                      Text(user.phone, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: isDark ? Colors.white70 : Colors.black87)),
                      if (user.email != null && user.email!.isNotEmpty)
                        Text(user.email!, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: isDark ? Colors.white70 : Colors.black87)),
                      const SizedBox(height: 24),
                      Card(
                        color: isDark ? Colors.grey[900] : Colors.white,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: const Icon(Icons.monetization_on, color: Colors.green),
                          title: const Text('Thống kê thu nhập'),
                          subtitle: const Text('Tổng thu nhập tháng này: ...đ'),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Chức năng đang phát triển!')));
                          },
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.lock_reset),
                              label: const Text('Đổi mật khẩu'),
                              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(44)),
                              onPressed: () => _changePassword(context),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.logout),
                              label: const Text('Đăng xuất'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                minimumSize: const Size.fromHeight(44),
                              ),
                              onPressed: () => _logout(context),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
