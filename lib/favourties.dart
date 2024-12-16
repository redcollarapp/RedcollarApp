import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FavoritesPage extends StatefulWidget {
  final List<Map<String, dynamic>> favorites;

  const FavoritesPage({super.key, required this.favorites});

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: Colors.orange,
      ),
      body: widget.favorites.isEmpty
          ? const Center(
              child: Text(
                'No items in your favorites!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.favorites.length,
              itemBuilder: (context, index) {
                final favorite = widget.favorites[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        favorite['image'] ??
                            'assets/images/default_image.png', // Use local asset path
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      favorite['name'] ?? 'Unnamed Item',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '\$${favorite['price'] ?? '0.00'}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeFromFavorites(index),
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _removeFromFavorites(int index) {
    final removedItem = widget.favorites[index];

    setState(() {
      widget.favorites.removeAt(index);
    });

    Fluttertoast.showToast(
      msg: "${removedItem['name']} removed from favorites!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }
}
