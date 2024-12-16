import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HoodieUploaderScreen extends StatelessWidget {
  final List<Map<String, dynamic>> hoodies = [
    {
      "name": "Classic Hoodie",
      "price": 45.99,
      "brand": "ComfortWear",
      "color": "Black",
      "material": "Cotton Blend",
      "rating": 4.8,
      "sizes": {"S": true, "M": true, "L": true, "XL": true},
      "stock": 20,
      "image": "https://via.placeholder.com/150?text=Classic+Hoodie"
    },
    {
      "name": "Zip-Up Hoodie",
      "price": 55.99,
      "brand": "UrbanStyle",
      "color": "Gray",
      "material": "Polyester",
      "rating": 4.7,
      "sizes": {"S": true, "M": false, "L": true, "XL": true},
      "stock": 15,
      "image": "https://via.placeholder.com/150?text=Zip-Up+Hoodie"
    },
    {
      "name": "Oversized Hoodie",
      "price": 60.99,
      "brand": "TrendyFit",
      "color": "White",
      "material": "Fleece",
      "rating": 4.9,
      "sizes": {"S": false, "M": true, "L": true, "XL": true},
      "stock": 10,
      "image": "https://via.placeholder.com/150?text=Oversized+Hoodie"
    },
    {
      "name": "Pullover Hoodie",
      "price": 40.99,
      "brand": "CasualFit",
      "color": "Navy Blue",
      "material": "Cotton",
      "rating": 4.5,
      "sizes": {"S": true, "M": true, "L": false, "XL": false},
      "stock": 18,
      "image": "https://via.placeholder.com/150?text=Pullover+Hoodie"
    },
    {
      "name": "Graphic Hoodie",
      "price": 50.99,
      "brand": "ArtWear",
      "color": "Black/Red",
      "material": "Polyester Blend",
      "rating": 4.6,
      "sizes": {"S": true, "M": true, "L": true, "XL": true},
      "stock": 12,
      "image": "https://via.placeholder.com/150?text=Graphic+Hoodie"
    },
    {
      "name": "Tech Hoodie",
      "price": 65.99,
      "brand": "SportStyle",
      "color": "Olive Green",
      "material": "Nylon",
      "rating": 4.8,
      "sizes": {"S": true, "M": true, "L": true, "XL": true},
      "stock": 30,
      "image": "https://via.placeholder.com/150?text=Tech+Hoodie"
    },
    {
      "name": "Fur-Lined Hoodie",
      "price": 75.99,
      "brand": "WinterWear",
      "color": "Brown",
      "material": "Cotton/Fur",
      "rating": 5.0,
      "sizes": {"S": true, "M": true, "L": true, "XL": true},
      "stock": 8,
      "image": "https://via.placeholder.com/150?text=Fur-Lined+Hoodie"
    },
    {
      "name": "Striped Hoodie",
      "price": 48.99,
      "brand": "ClassicStyle",
      "color": "Red/White",
      "material": "Cotton Blend",
      "rating": 4.4,
      "sizes": {"S": true, "M": true, "L": true, "XL": true},
      "stock": 20,
      "image": "https://via.placeholder.com/150?text=Striped+Hoodie"
    },
    {
      "name": "Lightweight Hoodie",
      "price": 38.99,
      "brand": "ActiveWear",
      "color": "Sky Blue",
      "material": "Polyester",
      "rating": 4.3,
      "sizes": {"S": true, "M": true, "L": false, "XL": true},
      "stock": 25,
      "image": "https://via.placeholder.com/150?text=Lightweight+Hoodie"
    },
    {
      "name": "Camo Hoodie",
      "price": 58.99,
      "brand": "AdventureFit",
      "color": "Camo Green",
      "material": "Cotton Blend",
      "rating": 4.7,
      "sizes": {"S": false, "M": true, "L": true, "XL": true},
      "stock": 14,
      "image": "https://via.placeholder.com/150?text=Camo+Hoodie"
    },
  ];

  Future<void> _updateHoodieData(BuildContext context) async {
    try {
      final DocumentReference documentRef = FirebaseFirestore.instance
          .collection('hoodies')
          .doc('0XT0FaUS8sdxQj7VYnIJ');

      // Update the items field with new hoodies data
      await documentRef.update({"items": hoodies});

      Fluttertoast.showToast(
        msg: "Hoodies updated successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to update Hoodies: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Hoodies Data'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _updateHoodieData(context),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            backgroundColor: Colors.blue,
          ),
          child: const Text(
            'Update Hoodies',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
