import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'favorites_provider.dart';
import 'cart_Screen.dart';
import 'product_provider.dart';

class ProductDetailPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailPage({
    Key? key,
    required this.product,
    required List cart,
    required List favorites,
  }) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String selectedColor = 'Brown';
  String selectedSize = 'M';

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final product = widget.product;

    // Safely access product details
    final productName = product['name'] ?? 'Unknown Product';
    final productDocId = product['docId'] ?? '';
    final productImage = product['image'] ?? '';
    final productPrice = product['price'] ?? 0.0;

    // Check if the product is already in favorites
    final isFavorite = favoritesProvider.isFavorite(productDocId);

    return Scaffold(
      body: Stack(
        children: [
          // Product Image
          Positioned.fill(
            child: Hero(
              tag: productName,
              child: _getImageWidget(productImage),
            ),
          ),

          // Details Section
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: _buildDetailsContent(productName, productPrice),
            ),
          ),

          // Back Button
          Positioned(
            top: 35,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Floating Action Buttons
          Positioned(
            bottom: 150,
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Add to Favorites Button
                GestureDetector(
                  onTap: () {
                    if (isFavorite) {
                      favoritesProvider.removeFavorite(productDocId);
                      _showSnackBar(
                          context, '$productName removed from favorites!');
                    } else {
                      favoritesProvider.addFavorite(product);
                      _showSnackBar(
                          context, '$productName added to favorites!');
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.brown,
                      size: 28,
                    ),
                  ),
                ),

                // Add to Cart Button
                GestureDetector(
                  onTap: () {
                    final productProvider =
                        Provider.of<ProductProvider>(context, listen: false);
                    productProvider.addToCart(widget.product);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          // Add product to the cart before navigating
                          final productProvider = Provider.of<ProductProvider>(
                              context,
                              listen: false);
                          productProvider
                              .addToCart(product); // Add product to cart

                          // Then navigate to the CartScreen
                          return const CartScreen(
                            cart: [],
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.brown,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsContent(String name, double price) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Name and Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '₹${price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Other Product Details (Rating, Delivery, etc.)
          _buildOtherProductDetails(),

          const SizedBox(height: 16),

          // Color Selection
          _buildColorSelection(),

          const SizedBox(height: 16),

          // Size Selection
          _buildSizeSelection(),

          const SizedBox(height: 16),

          // Description
          const Text(
            'Description',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            widget.product['description'] ?? 'No description available.',
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildOtherProductDetails() {
    return Row(
      children: [
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 16),
            const SizedBox(width: 4),
            Text(
              widget.product['rating']?.toString() ?? '4.6',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(width: 4),
            Text(
              '(52+ Reviews)',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
        const Spacer(),
        const Icon(Icons.local_shipping_outlined,
            size: 16, color: Colors.brown),
        const SizedBox(width: 4),
        const Text(
          'FREE DELIVERY',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildColorSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Color',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: ['Brown', 'Dark Brown', 'Beige', 'Light Brown']
              .map((color) => _buildColorOption(color))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildSizeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Size',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: ['XS', 'S', 'M', 'L', 'XL']
              .map((size) => _buildSizeOption(size))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildColorOption(String color) {
    final isSelected = selectedColor == color;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _getColorFromString(color),
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(color: Colors.black, width: 2)
              : Border.all(color: Colors.transparent),
        ),
      ),
    );
  }

  Widget _buildSizeOption(String size) {
    final isSelected = selectedSize == size;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSize = size;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.brown : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.brown : Colors.grey,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          size,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Color _getColorFromString(String color) {
    switch (color.toLowerCase()) {
      case 'brown':
        return Colors.brown;
      case 'dark brown':
        return const Color(0xFF4E342E);
      case 'beige':
        return const Color(0xFFF5F5DC);
      case 'light brown':
        return const Color(0xFFA1887F);
      default:
        return Colors.grey;
    }
  }

  Widget _getImageWidget(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Image.asset(
        'assets/images/default_image.png',
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (!imageUrl.startsWith('http') && !imageUrl.startsWith('https')) {
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/images/default_image.png',
            fit: BoxFit.cover,
          );
        },
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => Image.asset(
        'assets/images/default_image.png',
        fit: BoxFit.cover,
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
