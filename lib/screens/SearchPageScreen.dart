import 'package:flutter/material.dart';

void main() {
  runApp(const SearchPageScreen());
}

class SearchPageScreen extends StatelessWidget {
  const SearchPageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SearchPage(),
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int _selectedCategoryIndex = 0;
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const Text(
      'Home',
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    ),
    const Text(
      'Upload',
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    ),
    ElevatedButton(
      onPressed: () {},
      child: const Text('Scan'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[1000],
        shape: CircleBorder(),
        padding: EdgeInsets.all(24),
      ),
    ),
    const Icon(
      Icons.notifications,
      size: 30,
    ),
    const Text(
      'Profile',
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 106,
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
                      color: Color (0xFF2E3E5C),
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
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Category',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E3E5C),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildCategoryButton('All', 0),
                const SizedBox(width: 16),
                _buildCategoryButton('Food', 1),
                const SizedBox(width: 16),
                _buildCategoryButton('Drink', 2),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: IndexedStack(
              index: _selectedCategoryIndex,
              children: [
                Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: Text(
                      'All elements will be displayed here',
                      style: TextStyle(
                        color: Color(0xFF2E3E5C),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: Text(
                      'Food elements will be displayed here',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: Text(
                      'Drink elements will be displayed here',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud_upload),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[1000],
        unselectedItemColor: Color(0xFF9FA5C0),
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.blue[1000],
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFF9FA5C0),
        ),
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildCategoryButton(String title, int index) {
    final isSelected = _selectedCategoryIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[1000] : Colors.grey[200],
          borderRadius: BorderRadius.circular(32),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Color(0xFF9FA5C0),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}













