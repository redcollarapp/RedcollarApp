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
  String? _selectedCollection;
  String? _selectedDocId;

  final List<Map<String, dynamic>> collections = [
    {
      'name': 'T-Shirt',
      'docId': 'biRhapgdIk6LdYEcoA6A',
      'collection': 'clothes', // Firestore collection name
      'image': 'assets/t-shop.jpeg',
    },
    {
      'name': 'Hoodie',
      'docId': '0XT0FaUS8sdxQj7VYnIJ',
      'collection': 'hoodies', // Firestore collection name
      'image': 'assets/hoodie-shop.jpeg',
    },
    {
      'name': 'Jeans',
      'docId': '7iUIOTG60q64EmQqAmdV',
      'collection': 'jeans', // Firestore collection name
      'image': 'assets/jean-shop.jpeg',
    },
    {
      'name': 'Shoes',
      'docId': 'Op3RND16TFucJc9YNy7S',
      'collection': 'shoes', // Firestore collection name
      'image': 'assets/shoe-shop.jpeg',
    },
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _addProduct() async {
    if (_nameController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _selectedCollection == null) {
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

    // Save the product to the Firestore collection and document selected
    await _firestore
        .collection(_selectedCollection!) // Using the selected collection
        .doc(_selectedDocId!) // Using the selected document ID
        .collection(
            'products') // Adding the product under the selected document
        .add({
      'name': _nameController.text,
      'description': _descriptionController.text,
      'price': double.parse(_priceController.text),
      'imageUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    }).then((_) => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Product added successfully!')),
            ));

    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _selectedImage = null;
    _selectedCollection = null;
    _selectedDocId = null;

    Navigator.pop(context);
  }

  void _showAddProductSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
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
              DropdownButtonFormField<String>(
                value: _selectedCollection,
                items: collections
                    .map((collection) => DropdownMenuItem<String>(
                          value: collection['collection'],
                          child: Text(
                            collection['name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCollection = value;
                    // Set the document ID for the selected collection
                    _selectedDocId = collections.firstWhere((collection) =>
                        collection['collection'] ==
                        _selectedCollection)['docId'];
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Select Collection',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                dropdownColor: Colors.black,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _priceController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
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
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                ),
                child: const Text('Pick Image'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addProduct,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                ),
                child: const Text('Add Product'),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Admin Product Management'),
        backgroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProductSheet,
        child: const Icon(Icons.add),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: collections.length,
        itemBuilder: (context, index) {
          final collection = collections[index];
          return Card(
            color: Colors.grey[800],
            child: ListTile(
              leading: Image.asset(collection['image']),
              title: Text(
                collection['name'],
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                'Collection: ${collection['collection']}',
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _firestore
                      .collection(collection['collection'])
                      .doc(collection['docId'])
                      .delete()
                      .then((_) => ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    '${collection['name']} deleted successfully!')),
                          ));
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
