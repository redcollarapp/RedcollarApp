import 'package:flutter/material.dart';
import 'cart_screen.dart'; // Import the Cart Screen

final List<Map<String, dynamic>> products = [
  {
    'name': 'Cltrs. Hoodie',
    'price': 250.0,
    'rating': 5,
    'image': 'assets/images/hoodie.jpg',
    'description': 'A cozy and stylish hoodie.',
    'image_variants': {
      "L": 'assets/images/hoodie_l.jpg',
      "XL": 'assets/images/hoodie_xl.jpg',
      "XXL": 'assets/images/hoodie_xxl.jpg',
    },
  },
  {
    'name': 'Cltrs. Shirt',
    'price': 150.0,
    'rating': 4,
    'image': 'assets/images/shirt.jpg',
    'description': 'A sleek and modern shirt.',
    'image_variants': {
      "L": 'assets/images/shirt_l.jpg',
      "XL": 'assets/images/shirt_xl.jpg',
      "XXL": 'assets/images/shirt_xxl.jpg',
    },
  },
];

class ProductDetailPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String selectedSize = "L";
  String selectedColor = "Teal";

  final List<String> sizes = ["L", "XL", "XXL"];
  final List<String> colors = ["Teal", "Choco", "Blume"];

  void addToCart(Map<String, dynamic> product) {
    final existingProductIndex =
        cartItems.indexWhere((item) => item['name'] == product['name']);

    if (existingProductIndex != -1) {
      cartItems[existingProductIndex]['quantity'] += 1;
    } else {
      cartItems.add({
        ...product,
        'quantity': 1,
        'size': selectedSize,
        'color': selectedColor,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final imageVariant = product['image_variants'] != null &&
            product['image_variants'].containsKey(selectedSize)
        ? product['image_variants'][selectedSize]
        : product['image']; // Fallback to default image if variant is missing

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "DETAILS",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  imageVariant,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported, size: 100),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "CULTURES",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product['name'],
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${product['price']}",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text("${product['rating']} Star"),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: sizes.map((size) {
                    final isSelected = size == selectedSize;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedSize = size;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.orange : Colors.grey[200],
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? Colors.orange : Colors.grey,
                          ),
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
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: colors.map((color) {
                    final isSelected = color == selectedColor;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedColor = color;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color:
                              isSelected ? Colors.orange : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? Colors.orange : Colors.grey,
                          ),
                        ),
                        child: Text(
                          color.toUpperCase(),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "\$${product['price']}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      addToCart(product);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Add to Cart',
                      style: TextStyle(fontSize: 18, color: Colors.white),
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
}
