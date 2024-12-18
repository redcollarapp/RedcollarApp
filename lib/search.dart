import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductListingPage extends StatefulWidget {
  @override
  _ProductListingPageState createState() => _ProductListingPageState();
}

class _ProductListingPageState extends State<ProductListingPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // List of items with docIds and collection to fetch from Firestore
  final List<Map<String, dynamic>> items = [
    {
      'name': 'T-Shirt',
      'docId': 'biRhapgdIk6LdYEcoA6A',
      'collection': 'clothes',
      'image': 'assets/t-shop.jpeg',
    },
    {
      'name': 'Hoodie',
      'docId': '0XT0FaUS8sdxQj7VYnIJ',
      'collection': 'hoodies',
      'image': 'assets/hoodie-shop.jpeg',
    },
    {
      'name': 'Jeans',
      'docId': '7iUIOTG60q64EmQqAmdV',
      'collection': 'jeans',
      'image': 'assets/jean-shop.jpeg',
    },
    {
      'name': 'Shoes',
      'docId': 'Op3RND16TFucJc9YNy7S',
      'collection': 'shoes',
      'image': 'assets/shoe-shop.jpeg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Listing'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 200,
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search products...',
                  suffixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchProducts(),
        builder: (context, snapshot) {
          // While loading, show a spinner
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // If there's an error, display it
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // If no data or empty list, show a message
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products available.'));
          }

          final products = snapshot.data!;

          // Filter the products based on the search query
          final filteredProducts = products.where((product) {
            final name = (product['name'] ?? '').toString().toLowerCase();
            final brand = (product['brand'] ?? '').toString().toLowerCase();
            final color = (product['color'] ?? '').toString().toLowerCase();
            final type = (product['type'] ?? '').toString().toLowerCase();

            // If _searchQuery is empty, show all products (will limit after)
            if (_searchQuery.isEmpty) {
              return true;
            }

            return name.contains(_searchQuery) ||
                brand.contains(_searchQuery) ||
                color.contains(_searchQuery) ||
                type.contains(_searchQuery);
          }).toList();

          // Show a default of 10 products if no search query
          final displayedProducts = _searchQuery.isEmpty
              ? filteredProducts.take(10).toList()
              : filteredProducts;

          return ListView.builder(
            itemCount: displayedProducts.length,
            itemBuilder: (context, index) {
              final product = displayedProducts[index];

              // Extract product details with safety checks
              final name = product['name'] ?? 'No Name';
              final brand = product['brand'] ?? 'Unknown';
              final color = product['color'] ?? 'Unknown';
              final material = product['material'] ?? 'N/A';
              final image = product['image'] ?? 'assets/t-shop.jpeg';
              final price = product['price'] ?? 0.0;
              final rating = product['rating'] ?? 0.0;
              final sizes = product['sizes'] != null
                  ? Map<String, dynamic>.from(product['sizes'])
                  : {};
              final stock = product['stock'] ?? 0;
              final type = product['type'] ?? 'N/A';

              return Card(
                margin: const EdgeInsets.all(8),
                elevation: 4,
                child: ListTile(
                  leading: Image.network(
                    image,
                    fit: BoxFit.cover,
                    height: 50,
                    width: 50,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/t-shop.jpeg',
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  title: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Brand: $brand',
                            style: const TextStyle(fontSize: 14)),
                        Text('Color: $color',
                            style: const TextStyle(fontSize: 14)),
                        Text('Type: $type',
                            style: const TextStyle(fontSize: 14)),
                        Text('Material: $material',
                            style: const TextStyle(fontSize: 14)),
                        Text('Rating: ${rating.toStringAsFixed(1)} ★',
                            style: const TextStyle(fontSize: 14)),
                        Text('Stock: $stock',
                            style: const TextStyle(fontSize: 14)),
                        Text(
                          'Price: \$${price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Show detailed info in a dialog
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(name),
                          content: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  image,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/t-shop.jpeg',
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                                const SizedBox(height: 8),
                                Text('Brand: $brand'),
                                Text('Color: $color'),
                                Text('Type: $type'),
                                Text('Material: $material'),
                                Text('Rating: ${rating.toStringAsFixed(1)} ★'),
                                Text('Stock: $stock'),
                                Text('Price: \$${price.toStringAsFixed(2)}'),
                                const SizedBox(height: 8),
                                Text('Sizes Available:'),
                                for (var sizeEntry in sizes.entries)
                                  if (sizeEntry.value == true)
                                    Text('Size ${sizeEntry.key}')
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text('View Details'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Fetch each product from Firestore by docId and collection
  Future<List<Map<String, dynamic>>> _fetchProducts() async {
    List<Map<String, dynamic>> allProducts = [];

    for (var item in items) {
      final collectionName = item['collection'];
      final docId = item['docId'];
      final docRef =
          FirebaseFirestore.instance.collection(collectionName).doc(docId);
      final docSnap = await docRef.get();

      if (docSnap.exists) {
        final data = docSnap.data() ?? {};
        // Merge Firestore data with fallback data from 'items' list
        // If Firestore doesn't have an image, fallback to the provided image
        final mergedData = {
          'name': data['name'] ?? item['name'],
          'brand': data['brand'] ?? 'Unknown',
          'color': data['color'] ?? 'Unknown',
          'material': data['material'] ?? 'N/A',
          'image': data['image'] ?? item['image'],
          'price': data['price'] ?? 0.0,
          'rating': data['rating'] ?? 0.0,
          'sizes': data['sizes'] ?? {},
          'stock': data['stock'] ?? 0,
          'type': data['type'] ?? 'N/A',
        };
        allProducts.add(mergedData);
      } else {
        // If the document doesn't exist, we can just use the fallback
        allProducts.add({
          'name': item['name'],
          'brand': 'Unknown',
          'color': 'Unknown',
          'material': 'N/A',
          'image': item['image'],
          'price': 0.0,
          'rating': 0.0,
          'sizes': {},
          'stock': 0,
          'type': 'N/A',
        });
      }
    }

    return allProducts;
  }
}
