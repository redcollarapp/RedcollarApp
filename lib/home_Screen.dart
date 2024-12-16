import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_Page.dart';
import 'clothes_Screen.dart';
import 'admin_panel_screen.dart';
import 'cart_screen.dart';
import 'favourties.dart';
import 'search.dart';
import 'accounts.dart';

class HomeScreen extends StatefulWidget {
  final bool isAdmin;

  const HomeScreen({super.key, required this.isAdmin});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Screens for BottomNavigationBar
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    // Dynamically include the Admin Panel if the user is an admin
    _screens = [
      const HomeContentScreen(),
      ProductListingPage(),
      const FavoritesPage(favorites: []),
      if (widget.isAdmin) const AdminPanelScreen(),
      const AccountPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update current page
          });
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          if (widget.isAdmin)
            const BottomNavigationBarItem(
              icon: Icon(Icons.admin_panel_settings),
              label: 'Admin',
            ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}

class HomeContentScreen extends StatelessWidget {
  const HomeContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userName = FirebaseAuth.instance.currentUser?.email ?? 'Guest';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.person, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileControllerScreen(),
              ),
            );
          },
        ),
        title: const Text(
          'CULTURES',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Message
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Welcome, $userName!',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            // Category Tabs
            _buildCategoryTabs(),
            const SizedBox(height: 16),
            // Product Grid
            _buildProductGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    final categories = ['POPULAR', 'NEW', 'CATALOG', 'VIRTUAL STYLING'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: categories
            .map(
              (category) => Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Chip(
                  label: Text(
                    category,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  backgroundColor: Colors.orange.withOpacity(0.2),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildProductGrid(BuildContext context) {
    final sampleProducts = [
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

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      padding: const EdgeInsets.all(16),
      itemCount: sampleProducts.length,
      itemBuilder: (context, index) {
        final product = sampleProducts[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClothesSectionPage(
                  category: product['name'].toString(),
                  documentId: product['docId'].toString(),
                  collectionName: product['collection'].toString(),
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    product['image'].toString(),
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  product['name'].toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Explore Now',
                  style: TextStyle(color: Colors.orange),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
