import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AdminProductManagementScreen extends StatefulWidget {
  const AdminProductManagementScreen({super.key});

  @override
  _AdminProductManagementScreenState createState() =>
      _AdminProductManagementScreenState();
}

class _AdminProductManagementScreenState
    extends State<AdminProductManagementScreen> {
  final _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  File? _selectedImage;
  String? _editingProductId;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    if (_nameController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    String? imageUrl;
    if (_selectedImage != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('product_images/${DateTime.now().millisecondsSinceEpoch}');
      await storageRef.putFile(_selectedImage!);
      imageUrl = await storageRef.getDownloadURL();
    }

    final productData = {
      'name': _nameController.text,
      'description': _descriptionController.text,
      'price': double.parse(_priceController.text),
      'imageUrl': imageUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (_editingProductId != null) {
      // Update product
      await _firestore
          .collection('products')
          .doc(_editingProductId)
          .update(productData);
    } else {
      // Add new product
      productData['createdAt'] = FieldValue.serverTimestamp();
      await _firestore.collection('products').add(productData);
    }

    _resetForm();
  }

  void _resetForm() {
    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _selectedImage = null;
    _editingProductId = null;
    Navigator.pop(context);
  }

  void _showProductSheet([DocumentSnapshot? product]) {
    if (product != null) {
      _editingProductId = product.id;
      _nameController.text = product['name'];
      _descriptionController.text = product['description'];
      _priceController.text = product['price'].toString();
      _selectedImage = null; // Placeholder for edit image functionality
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              if (_selectedImage != null)
                Image.file(
                  _selectedImage!,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ElevatedButton(
                onPressed: () async {
                  final picker = ImagePicker();
                  final pickedFile =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _selectedImage = File(pickedFile.path);
                    });
                  }
                },
                child: const Text('Pick Image'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveProduct,
                child: Text(_editingProductId == null
                    ? 'Add Product'
                    : 'Update Product'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Manage Products'),
        backgroundColor: Colors.grey[900],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProductSheet(),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('products')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data!.docs;

          if (products.isEmpty) {
            return const Center(
              child: Text(
                'No products available. Add new products to display here.',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index].data() as Map<String, dynamic>;
              final productId = products[index].id;

              return Card(
                color: Colors.grey[800],
                child: ListTile(
                  leading: product['imageUrl'] != null
                      ? Image.network(product['imageUrl'],
                          width: 50, fit: BoxFit.cover)
                      : const Icon(Icons.image, color: Colors.white70),
                  title: Text(
                    product['name'],
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    '\$${product['price']}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showProductSheet(products[index]),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _firestore
                            .collection('products')
                            .doc(productId)
                            .delete(),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
