import 'dart:io';
import 'package:delivery_online_app/routes/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../order/order_detail_screen.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final String paymentUrl;
  
  const PaymentWebViewScreen({
    super.key,
    required this.paymentUrl,
  });
  
  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  String? _errorMessage;
  
  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }
  
  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      // Set User Agent để tương thích với ZaloPay
      ..setUserAgent('Mozilla/5.0 (Linux; Android 10; SM-G973F) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36')
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (int progress) {
          debugPrint('WebView loading progress: $progress%');
        },
        onPageStarted: (String url) {
          debugPrint('Page started loading: $url');
          if (mounted) {
            setState(() {
              _isLoading = true;
              _errorMessage = null;
            });
          }
        },
        onPageFinished: (String url) {
          debugPrint('Page finished loading: $url');
          if (mounted) {
            setState(() => _isLoading = false);
          }
        },
        onWebResourceError: (WebResourceError error) {
          debugPrint('WebView error: ${error.description}');
          if (mounted) {
            setState(() {
              _isLoading = false;
              _errorMessage = 'Lỗi tải trang: ${error.description}';
            });
          }
        },
        onNavigationRequest: (NavigationRequest request) {
          debugPrint('Navigation request: ${request.url}');
          if (_isPaymentCallback(request.url)) {
            _handlePaymentResult();
            return NavigationDecision.prevent;
          }
          
          // ✅ Cho phép mở ZaloPay app nếu có
          if (request.url.startsWith('zalopay://')) {
            _openZaloPayApp(request.url);
            return NavigationDecision.prevent;
          }
          
          return NavigationDecision.navigate;
        },
      ))
      ..enableZoom(false); // Tắt zoom để UX tốt hơn
      
    // Load URL với error handling
    _loadPaymentUrl();
  }
  
  Future<void> _loadPaymentUrl() async {
    try {
      await _controller.loadRequest(Uri.parse(widget.paymentUrl));
    } catch (e) {
      debugPrint('Error loading payment URL: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Không thể tải trang thanh toán';
        });
      }
    }
  }
  
  // Kiểm tra các pattern callback khác nhau
  bool _isPaymentCallback(String url) {
    return url.contains('returncode=1');
  }

  
  // Mở ZaloPay app nếu có
  Future<void> _openZaloPayApp(String url) async {
    try {
      // Implement deep link handling here
      debugPrint('Opening ZaloPay app with URL: $url');
    } catch (e) {
      debugPrint('Error opening ZaloPay app: $e');
    }
  }
  
  Future<void> _handlePaymentResult() async {
    // ✅ Hiển thị loading khi xử lý
    if (mounted) {
      setState(() => _isLoading = true);
    }
    
    try {
      if (!mounted) return;
      
      AppNavigator.toOrders(context);
      
      // ✅ Hiển thị snackbar sau khi navigate
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text('Thanh toán thành công!'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ));
    } catch (e) {
      debugPrint('Payment verification error: $e');
      if (!mounted) return;
      
      setState(() => _isLoading = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text('Lỗi xác minh thanh toán: $e')),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'Thử lại',
            textColor: Colors.white,
            onPressed: _handlePaymentResult,
          ),
        ),
      );
    }
  }
  
  // ✅ Thêm method refresh
  Future<void> _refreshPage() async {
    setState(() => _isLoading = true);
    await _controller.reload();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? theme.colorScheme.surface : Colors.white,
        title: Row(
          children: [
            Text(
              'Thanh toán đơn hàng',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
        ),
        // ✅ Thêm action refresh
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshPage,
            tooltip: 'Tải lại',
          ),
        ],
      ),
      body: Stack(
        children: [
          // ✅ Xử lý error state
          if (_errorMessage != null)
            _buildErrorWidget()
          else
            WebViewWidget(controller: _controller),
          
          // ✅ Loading overlay với design đẹp hơn
          if (_isLoading) _buildLoadingOverlay(isDark, theme),
        ],
      ),
    );
  }
  
  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                setState(() => _errorMessage = null);
                _loadPaymentUrl();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLoadingOverlay(bool isDark, ThemeData theme) {
    return Container(
      color: isDark 
          ? Colors.black.withOpacity(0.7) 
          : Colors.white.withOpacity(0.7),
      child: Center(
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: isDark ? theme.colorScheme.primary : Colors.deepOrange,
                  strokeWidth: 3,
                ),
                const SizedBox(height: 16),
                Text(
                  'Đang tải trang thanh toán...',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
