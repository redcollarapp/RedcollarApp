import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'product_details.dart';
import 'favourties.dart';

class ClothesSectionPage extends StatefulWidget {
  final String category;
  final String documentId;
  final String collectionName;

  const ClothesSectionPage({
    super.key,
    required this.category,
    required this.documentId,
    required this.collectionName,
  });

  @override
  State<ClothesSectionPage> createState() => _ClothesSectionPageState();
}

class _ClothesSectionPageState extends State<ClothesSectionPage> {
  List<Map<String, dynamic>> favorites = [];

  // Toggle favorite status
  void _toggleFavorite(Map<String, dynamic> item) {
    final isFavorite = favorites.any((fav) => fav['name'] == item['name']);
    setState(() {
      if (isFavorite) {
        favorites.removeWhere((fav) => fav['name'] == item['name']);
        Fluttertoast.showToast(
          msg: "${item['name']} removed from favorites!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      } else {
        favorites.add(item);
        Fluttertoast.showToast(
          msg: "${item['name']} added to favorites!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} Section'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesPage(favorites: favorites),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection(widget.collectionName)
            .doc(widget.documentId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          }
          if (!snapshot.hasData || snapshot.data?.data() == null) {
            return const Center(child: Text('No data found'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final items = data['items'] as List<dynamic>;

          if (items.isEmpty) {
            return const Center(child: Text('No items available'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index] as Map<String, dynamic>;
              return _buildClothingCard(item);
            },
          );
        },
      ),
    );
  }

  Widget _buildClothingCard(Map<String, dynamic> item) {
    final isFavorite = favorites.any((fav) => fav['name'] == item['name']);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: _getImageWidget(item['image']),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                Text(
                  item['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Product Price
                Text(
                  '₹${item['price']}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 8),
                // Buttons and Icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailPage(product: item),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'View Details',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                      ),
                      onPressed: () => _toggleFavorite(item),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // This method checks whether the image is a network URL or an asset
  Widget _getImageWidget(String imageUrl) {
    print("Loading image from: $imageUrl"); // Debug: print the image URL
    try {
      if (imageUrl.startsWith('http') || imageUrl.startsWith('https')) {
        return Image.network(
          imageUrl,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print("Error loading network image: $error");
            return const Icon(Icons.image_not_supported, size: 80);
          },
        );
      } else {
        return Image.asset(
          imageUrl,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print("Error loading asset image: $error");
            return const Icon(Icons.image_not_supported, size: 80);
          },
        );
      }
    } catch (e) {
      print("Error in image loading: $e");
      return const Icon(Icons.image_not_supported, size: 80);
    }
  }
}
