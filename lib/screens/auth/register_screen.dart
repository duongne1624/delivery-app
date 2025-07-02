import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _isPasswordVisible = false;

  void _register(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
        authProvider.register(
          _phoneController.text,
          _passwordController.text,
          _emailController.text,
          _nameController.text,
        );

        if (authProvider.user != null) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        } else {
          setState(() {
            _errorMessage = 'Đăng ký thất bại. Vui lòng kiểm tra thông tin.';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Đã có lỗi xảy ra. Vui lòng thử lại.';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 40),
                // Logo or App Name
                Center(
                  child: Column(
                    children: [
                      Image.asset('assets/images/logo.png', width: 80, height: 80),
                      SizedBox(height: 16),
                      Text(
                        'Food Delivery',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                // Name Input
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Họ và tên',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập họ và tên';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                // Email Input
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Email không hợp lệ';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                // Phone Input
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Số điện thoại',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập số điện thoại';
                    }
                    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                      return 'Số điện thoại phải có 10 chữ số';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                // Password Input
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_isPasswordVisible,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu';
                    }
                    if (value.length < 6) {
                      return 'Mật khẩu phải có ít nhất 6 ký tự';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                // Error Message
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                SizedBox(height: 16),
                // Register Button
                ElevatedButton(
                  onPressed: _isLoading ? null : () => _register(context),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Đăng ký'),
                ),
                SizedBox(height: 16),
                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Đã có tài khoản?'),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.login);
                      },
                      child: Text('Đăng nhập'),
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

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}
