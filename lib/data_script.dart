import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateClothesDataScreen extends StatelessWidget {
  Future<void> _updateClothesData(BuildContext context) async {
    final docRef = FirebaseFirestore.instance
        .collection('clothes')
        .doc('biRhapgdIk6LdYEcoA6A');

    // 10 dummy data for clothes
    final clothesData = [
      {
        "brand": "CasualFit",
        "color": "Red",
        "material": "Cotton",
        "name": "Casual T-shirt",
        "price": 29.99,
        "rating": 4.5,
        "stock": 20,
        "image": "assets/compressedimages/clothes/c1.jpeg",
        "sizes": {"S": true, "M": true, "L": true, "XL": true},
      },
      {
        "brand": "Stylora",
        "color": "Blue",
        "material": "Polyester",
        "name": "Chic Denim Jacket",
        "price": 59.99,
        "rating": 4.7,
        "stock": 15,
        "image": "assets/compressedimages/clothes/c2.jpeg",
        "sizes": {"S": true, "M": true, "L": true, "XL": true},
      },
      {
        "brand": "VogueWear",
        "color": "Black",
        "material": "Wool",
        "name": "Elegant Black Blazer",
        "price": 89.99,
        "rating": 4.8,
        "stock": 10,
        "image": "assets/compressedimages/clothes/c3.jpeg",
        "sizes": {"S": true, "M": true, "L": true, "XL": true},
      },
      {
        "brand": "UrbanTrend",
        "color": "Grey",
        "material": "Blend",
        "name": "Oversized Sweatshirt",
        "price": 49.99,
        "rating": 4.6,
        "stock": 18,
        "image": "assets/compressedimages/clothes/c4.jpeg",
        "sizes": {"S": true, "M": true, "L": true, "XL": true},
      },
      {
        "brand": "ClassicWear",
        "color": "Green",
        "material": "Linen",
        "name": "Casual Green Shirt",
        "price": 39.99,
        "rating": 4.4,
        "stock": 12,
        "image": "assets/compressedimages/clothes/c5.jpeg",
        "sizes": {"S": true, "M": true, "L": true, "XL": true},
      },
      {
        "brand": "TrendGear",
        "color": "Pink",
        "material": "Cotton",
        "name": "Trendy Pink Dress",
        "price": 79.99,
        "rating": 4.9,
        "stock": 8,
        "image": "assets/compressedimages/clothes/c6.jpeg",
        "sizes": {"S": true, "M": true, "L": true, "XL": true},
      },
      {
        "brand": "EliteStyle",
        "color": "White",
        "material": "Silk",
        "name": "Formal White Shirt",
        "price": 99.99,
        "rating": 4.8,
        "stock": 5,
        "image": "assets/compressedimages/clothes/c7.jpeg",
        "sizes": {"S": true, "M": true, "L": true, "XL": true},
      },
      {
        "brand": "CasualWear",
        "color": "Yellow",
        "material": "Cotton",
        "name": "Bright Yellow T-shirt",
        "price": 34.99,
        "rating": 4.3,
        "stock": 20,
        "image": "assets/compressedimages/clothes/c8.jpeg",
        "sizes": {"S": true, "M": true, "L": true, "XL": true},
      },
      {
        "brand": "SmartFit",
        "color": "Navy Blue",
        "material": "Blended Wool",
        "name": "Classic Navy Suit",
        "price": 199.99,
        "rating": 4.9,
        "stock": 4,
        "image": "assets/compressedimages/clothes/c9.jpeg",
        "sizes": {"S": true, "M": true, "L": true, "XL": true},
      },
      {
        "brand": "GlamWear",
        "color": "Purple",
        "material": "Viscose",
        "name": "Evening Purple Gown",
        "price": 129.99,
        "rating": 4.6,
        "stock": 10,
        "image": "assets/compressedimages/clothes/c10.jpeg",
        "sizes": {"S": true, "M": true, "L": true, "XL": true},
      },
    ];

    try {
      for (final cloth in clothesData) {
        await docRef.set({
          'items': FieldValue.arrayUnion([cloth])
        }, SetOptions(merge: true));
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Clothes data updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Clothes Data'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _updateClothesData(context),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            backgroundColor: Colors.blue,
          ),
          child: const Text(
            'Update Clothes',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
