import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lottie/lottie.dart';
import 'product_details.dart';
import 'favorites_provider.dart';

class ClothesSectionPage extends StatefulWidget {
  final String category;
  final String documentId;
  final String collectionName;

  const ClothesSectionPage({
    Key? key,
    required this.category,
    required this.documentId,
    required this.collectionName,
  }) : super(key: key);

  @override
  State<ClothesSectionPage> createState() => _ClothesSectionPageState();
}

class _ClothesSectionPageState extends State<ClothesSectionPage> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category,
          style: const TextStyle(color: Colors.brown),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.brown),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          // Product Grid
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection(widget.collectionName)
                  .doc(widget.documentId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildShimmerEffect();
                }
                if (snapshot.hasError) {
                  return _buildErrorState();
                }
                if (!snapshot.hasData || snapshot.data?.data() == null) {
                  return _buildEmptyState();
                }

                final data = snapshot.data!.data() as Map<String, dynamic>;
                final items = (data['items'] ?? []) as List<dynamic>;

                final List<Map<String, dynamic>> mappedItems = items
                    .map((item) => Map<String, dynamic>.from(item))
                    .toList();

                final filteredItems = mappedItems
                    .where((item) =>
                        item['name']?.toLowerCase().contains(searchQuery) ??
                        false)
                    .toList();

                if (filteredItems.isEmpty) {
                  return _buildEmptyState();
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    return _buildClothingCard(context, item, favoritesProvider);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            color: Colors.white,
            height: 200,
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/jsons/empty.json', height: 200),
          const SizedBox(height: 16),
          const Text('No items found.', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/jsons/error.json', height: 200),
          const SizedBox(height: 16),
          const Text('Error loading data.', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildClothingCard(
    BuildContext context,
    Map<String, dynamic> item,
    FavoritesProvider favoritesProvider,
  ) {
    final isFavorite = favoritesProvider.isFavorite(item['docId'] ?? '');

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailPage(
              product: item,
              cart: [], favorites: [], // Pass other parameters if necessary
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        child: Column(
          children: [
            Expanded(
              child: _getImageWidget(item['image'] ?? ''),
            ),
            ListTile(
              title: Text(
                item['name'] ?? 'Unnamed',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('₹${item['price'] ?? '0.00'}'),
              trailing: IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: () {
                  if (isFavorite) {
                    favoritesProvider.removeFavorite(item['docId'] ?? '');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('${item['name']} removed from favorites!'),
                      ),
                    );
                  } else {
                    favoritesProvider.addFavorite(item);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${item['name']} added to favorites!'),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _getImageWidget(String? imageUrl) {
  if (imageUrl == null || imageUrl.isEmpty) {
    return Image.asset(
      'assets/images/default_image.png',
      fit: BoxFit.cover,
    );
  }

  // Check if the image is a local asset (starts with "assets/")
  if (imageUrl.startsWith('assets/')) {
    return Image.asset(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'assets/images/default_image.png',
          fit: BoxFit.cover,
        );
      },
    );
  }

  // If the image is a network URL
  return CachedNetworkImage(
    imageUrl: imageUrl,
    fit: BoxFit.cover,
    placeholder: (context, url) => const Center(
      child: CircularProgressIndicator(),
    ),
    errorWidget: (context, url, error) => Image.asset(
      'assets/images/default_image.png',
      fit: BoxFit.cover,
    ),
  );
}
