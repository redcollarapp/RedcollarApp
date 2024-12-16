import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductListingPage extends StatefulWidget {
  @override
  _ProductListingPageState createState() => _ProductListingPageState();
}

class _ProductListingPageState extends State<ProductListingPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Firebase collection references for multiple collections
  final List<String> collections = ['clothes', 'hoodies', 'jeans', 'shoes'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Listing'),
        actions: [
          // Search Bar in AppBar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 200,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products available.'));
          }

          final products = snapshot.data!;

          // Filter the products based on the search query
          final filteredProducts = products.where((product) {
            final name = product['name'].toString().toLowerCase();
            return name
                .contains(_searchQuery); // Match search query with product name
          }).toList();

          // Show a default of 10 products if no search query
          final displayedProducts = _searchQuery.isEmpty
              ? filteredProducts.take(10).toList()
              : filteredProducts;

          return ListView.builder(
            itemCount: displayedProducts.length,
            itemBuilder: (context, index) {
              final product = displayedProducts[index];
              final name = product['name'];
              final image = product['image'] ??
                  'assets/default-image.png'; // Default image
              final price = product['price'] ?? '0.00'; // Price field
              final brand = product['brand'] ?? 'Unknown'; // Brand field

              return Card(
                margin: const EdgeInsets.all(8),
                elevation: 4,
                child: ListTile(
                  leading: Image.network(
                    image,
                    fit: BoxFit.cover,
                    height: 50,
                    width: 50,
                  ),
                  title: Text(
                    name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Price: \$${price}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        'Brand: ${brand}',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Navigate to product details page
                    },
                    child: Text('View Details'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Fetch products from all collections
  Future<List<Map<String, dynamic>>> _fetchProducts() async {
    List<Map<String, dynamic>> allProducts = [];

    // Query each collection and fetch products
    for (String collection in collections) {
      final snapshot =
          await FirebaseFirestore.instance.collection(collection).get();

      // Merge products from each collection
      for (var doc in snapshot.docs) {
        allProducts.add({
          'name': doc['name'],
          'image': doc['image'],
          'price': doc['price'],
          'brand': doc['brand'],
        });
      }
    }

    return allProducts;
  }
}
