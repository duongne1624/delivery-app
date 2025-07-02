// lib/screens/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Giỏ hàng')),
      body: cartProvider.cartItems.isEmpty
          ? Center(child: Text('Giỏ hàng trống'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartProvider.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartProvider.cartItems[index];
                      return ListTile(
                        leading: Image.asset('assets/images/${item['image']}'),
                        title: Text(item['name']),
                        subtitle: Text('${item['price']} VND x ${item['quantity']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () => cartProvider.updateQuantity(item['id'], item['quantity'] - 1),
                            ),
                            Text('${item['quantity']}'),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () => cartProvider.updateQuantity(item['id'], item['quantity'] + 1),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => cartProvider.removeFromCart(item['id']),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tổng: ${cartProvider.totalPrice.toStringAsFixed(0)} VND'),
                      ElevatedButton(
                        onPressed: () {
                          // Checkout logic
                        },
                        child: Text('Thanh toán'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
