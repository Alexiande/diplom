import 'package:flutter/material.dart';
import 'package:diplom/api_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  ApiService apiService = ApiService();
  late Future<List<dynamic>> items;

  int _selectedIndex = 0; // To store the current index
  String selectedCategory = 'All'; // Selected category

  @override
  void initState() {
    super.initState();
    items = apiService.fetchItems(); // Load data on initialization
  }

  // Method to handle navigation item taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Method to filter items by category
  Future<List<dynamic>> _filterItems() async {
    final allItems = await items;
    if (selectedCategory == 'All') {
      return allItems;
    } else {
      return allItems.where((item) => item['category'] == selectedCategory).toList();
    }
  }

  Color _getButtonColor(String category) {
    return selectedCategory == category ? const Color(0xFF4169E1) : const Color(0xFFF4F5F7);
  }

  Color _getButtonTextColor(String category) {
    return selectedCategory == category ? Colors.white : const Color(0xFF9FA5C0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(32.0),
          ),
          child: const Row(
            children: [
              Icon(Icons.search, color: Colors.grey),
              SizedBox(width: 8),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      color: Color(0xFF2E3E5C),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        automaticallyImplyLeading: false, // Remove back arrow
      ),
      body: Column(
        children: [
          // Add top padding for search bar
          const SizedBox(height: 16), // Padding above the search bar

          // Categories header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              'Categories',
              style: TextStyle(
                fontSize: 22.0,
                color: Color(0xFF2E3E5C),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getButtonColor('All'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    selectedCategory = 'All';
                  });
                },
                child: Text(
                  'All',
                  style: TextStyle(color: _getButtonTextColor('All')),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getButtonColor('Food'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    selectedCategory = 'Food';
                  });
                },
                child: Text(
                  'Food',
                  style: TextStyle(color: _getButtonTextColor('Food')),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getButtonColor('Drinks'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    selectedCategory = 'Drinks';
                  });
                },
                child: Text(
                  'Drinks',
                  style: TextStyle(color: _getButtonTextColor('Drinks')),
                ),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _filterItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Failed to load items'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No items found'));
                } else {
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Two columns
                      crossAxisSpacing: 8.0, // Space between columns
                      mainAxisSpacing: 8.0, // Space between rows
                      childAspectRatio: 0.7, // Aspect ratio for cards
                    ),
                    padding: const EdgeInsets.all(16.0),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final item = snapshot.data![index];
                      return RecipeCard(
                        title: item['title'],
                        imageUrl: item['image'],
                        time: '>60 min', // You can add time in JSON
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex, // Current selected item
        selectedItemColor: Colors.blue, // Color for selected item
        unselectedItemColor: Colors.grey, // Color for unselected items
        onTap: _onItemTapped, // Handler for changing index
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String time;

  const RecipeCard({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0), // Padding around card
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // Shadow offset
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                height: 120, // Decrease image height
                width: double.infinity,
                placeholder: (context, url) => Container(
                  height: 120,
                  width: double.infinity,
                  child: const Center(
                    child: CircularProgressIndicator(), // Loading indicator
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 120,
                  width: double.infinity,
                  child: const Center(
                    child: Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0), // Decrease padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16, // Decrease font size
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E3E5C),
                    ),
                  ),
                  const SizedBox(height: 4), // Decrease spacing between texts
                  Text(
                    'Food • $time',
                    style: const TextStyle(
                      fontSize: 12, // Decrease font size
                      color: Color(0xFF9FA5C0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

