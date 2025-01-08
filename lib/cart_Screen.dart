import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'product_provider.dart';
import 'check_Screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key, required List cart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final cart = productProvider.cart;

    // Calculate totals
    double subtotal = cart.fold(
      0,
      (sum, item) =>
          sum +
          ((item['price'] as num?)?.toDouble() ?? 0) *
              ((item['quantity'] as num?)?.toInt() ?? 1),
    );
    double discount = subtotal * 0.1; // 10% discount
    double total = subtotal - discount;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.brown),
        title: const Text(
          'My Cart',
          style: TextStyle(
            color: Colors.brown,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: cart.isEmpty
          ? _buildEmptyCart()
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final item = cart[index];
                      return _buildCartItem(context, item, productProvider);
                    },
                  ),
                ),
                const Divider(height: 1, thickness: 1),
                _buildCartSummary(
                  context,
                  subtotal,
                  discount,
                  total,
                  cart,
                ),
              ],
            ),
    );
  }

  // Build cart item widget
  Widget _buildCartItem(BuildContext context, Map<String, dynamic> item,
      ProductProvider provider) {
    final name = item['name'] ?? 'Unnamed Item';
    final price = (item['price'] as num?)?.toDouble() ?? 0.0;
    final quantity = (item['quantity'] as num?)?.toInt() ?? 1;
    final color = item['color'] ?? 'Not Specified';
    final size = item['size'] ?? 'Not Specified';
    final image = item['image'] ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _getImageWidget(image),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            'Color: $color',
                            style: const TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          child: Text(
                            'Size: $size',
                            style: const TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '₹$price x $quantity',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline,
                        color: Colors.brown),
                    onPressed: () {
                      if (quantity > 1) {
                        provider.updateCartQuantity(item, quantity - 1);
                        _showToast('Quantity updated');
                      } else {
                        provider.removeFromCart(item);
                        _showToast('Item removed from cart');
                      }
                    },
                  ),
                  Text(
                    '$quantity',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline,
                        color: Colors.brown),
                    onPressed: () {
                      provider.updateCartQuantity(item, quantity + 1);
                      _showToast('Quantity updated');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build cart summary widget
  Widget _buildCartSummary(BuildContext context, double subtotal,
      double discount, double total, List cart) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildPriceRow(
            'Subtotal',
            '₹${subtotal.toStringAsFixed(2)}',
          ),
          _buildPriceRow(
            'Discount',
            '-₹${discount.toStringAsFixed(2)}',
          ),
          const Divider(thickness: 1),
          _buildPriceRow(
            'Total',
            '₹${total.toStringAsFixed(2)}',
            isBold: true,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: cart.isEmpty
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutScreen(
                          cart: cart,
                          subtotal: subtotal,
                          discount: discount,
                          total: total,
                        ),
                      ),
                    );
                  },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: cart.isEmpty ? Colors.grey : Colors.brown,
            ),
            child: const Text(
              'Checkout',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build empty cart widget
  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.brown),
          const SizedBox(height: 16),
          const Text(
            'Your cart is empty!',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add some products to the cart.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // Build price row widget
  Widget _buildPriceRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  // Show toast for actions
  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.brown,
      textColor: Colors.white,
    );
  }

  // Build image widget with fallback
  Widget _getImageWidget(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Image.asset(
        'assets/images/default_image.png',
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      );
    }

    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/images/default_image.png',
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          );
        },
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: 80,
      height: 80,
      fit: BoxFit.cover,
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => Image.asset(
        'assets/images/default_image.png',
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      ),
    );
  }
}
