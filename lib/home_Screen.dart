import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'clothes_Screen.dart';
import 'profile_Page.dart';
import 'search.dart';
import 'favorites_Page.dart';

import 'cart_Screen.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({Key? key, required this.username, required bool isAdmin})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      _HomeContent(username: widget.username), // Home Content
      const SearchScreen(), // Search Screen
      FavoritesPage(), // Favorites Page
      const CartScreen(cart: []), // Cart Screen
      ProfileScreen(), // Profile Screen
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.brown,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final String username;

  const _HomeContent({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          Text(
            'Hi $username,',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Get popular fashion from everywhere',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),

          // Search Bar with Voice Button
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: Colors.grey[200],
                child: IconButton(
                  icon: const Icon(Icons.mic, color: Colors.black),
                  onPressed: () {
                    // Add voice search logic
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Carousel Section
          _buildCarousel(),

          const SizedBox(height: 16),

          // New Arrival Section
          _buildNewArrivals(),

          const SizedBox(height: 16),

          // Categories Section
          const Text(
            'Categories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // Product Grid Section
          _buildProductGrid(context),
        ],
      ),
    );
  }

  Widget _buildCarousel() {
    final List<Map<String, String>> carouselItems = [
      {
        'image': 'assets/compressedimages/cclothes/t6.jpeg',
        'title': 'Upto 40% Off\nJackets Collections',
      },
      {
        'image': 'assets/overcost/o1-min.jpeg',
        'title': 'Winter Wear',
      },
      {
        'image': 'assets/hoodie-shop.jpeg',
        'title': 'Exclusive Hoodies',
      },
    ];

    return CarouselSlider.builder(
      itemCount: carouselItems.length,
      itemBuilder: (context, index, realIndex) {
        final item = carouselItems[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  item['image']!,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Text(
                    item['title']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.85,
        aspectRatio: 16 / 9,
      ),
    );
  }

  Widget _buildNewArrivals() {
    final newArrivals = [
      {
        'name': 'Wilcox',
        'type': 'Dresses',
        'price': '\$85.88',
        'image': 'assets/overcost/o1-min.jpeg',
      },
      {
        'name': 'Karen Willis',
        'type': 'Dresses',
        'price': '\$142',
        'image': 'assets/overcost/o1-min.jpeg',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'New Arrival',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 250,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: newArrivals.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final item = newArrivals[index];
              return SizedBox(
                width: 180,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16)),
                          child: Image.asset(
                            item['image']!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Details
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name']!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  item['type']!,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(
                                    height:
                                        4), // Spacing between type and price
                                Text(
                                  '\$${item['price']}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            // Shopping Bag Icon
                            IconButton(
                              onPressed: () {
                                // Add to cart logic
                              },
                              icon: const Icon(
                                Icons.shopping_bag_outlined,
                                color: Colors.brown,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductGrid(BuildContext context) {
    final sampleProducts = [
      {
        'name': 'T-Shirts',
        'docId': 'biRhapgdIk6LdYEcoA6A',
        'collection': 'clothes',
        'image': 'assets/compressedimages/cclothes/t6.jpeg',
      },
      {
        'name': 'Hoodies',
        'docId': '0XT0FaUS8sdxQj7VYnIJ',
        'collection': 'hoodies',
        'image': 'assets/compressedimages/choodies/h1.jpeg',
      },
      {
        'name': 'Jeans',
        'docId': '7iUIOTG60q64EmQqAmdV',
        'collection': 'jeans',
        'image': 'assets/compressedimages/cjeans/j1.jpeg',
      },
      {
        'name': 'Shoes',
        'docId': 'Op3RND16TFucJc9YNy7S',
        'collection': 'shoes',
        'image': 'assets/compressedimages/cshoes/s1.jpeg',
      },
      {
        'name': 'Accessories',
        'docId': 't4m2VdyNicHLvHcEb4KV',
        'collection': 'accessories',
        'image': 'assets/accesores/a1-min.jpeg',
      },
      {
        'name': 'Overcoat',
        'docId': '3rvTIeYM6ACCE8HEOrlt',
        'collection': 'overcoat',
        'image': 'assets/overcost/02-min.jpeg',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 3 / 4,
      ),
      itemCount: sampleProducts.length,
      itemBuilder: (context, index) {
        final product = sampleProducts[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClothesSectionPage(
                  category: product['name']!,
                  documentId: product['docId']!,
                  collectionName: product['collection']!,
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(product['image']!),
                fit: BoxFit.cover,
              ),
            ),
            alignment: Alignment.center,
            child: Container(
              color: Colors.black.withOpacity(0.4),
              child: Text(
                product['name']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
