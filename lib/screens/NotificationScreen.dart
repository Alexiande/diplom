import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.grey[200],
        elevation: 0,
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                // Section: New
                const SectionTitle(title: "New"),
                NotificationCard(
                  profileImage: "https://example.com/user1.jpg",
                  title: "Dean Winchester",
                  subtitle: "now following you",
                  time: "1h",
                  buttonText: "Follow",
                  buttonColor: Colors.blue,
                  textColor: Colors.white,
                ),
                // Section: Today
                const SectionTitle(title: "Today"),
                NotificationCardWithImage(
                  profileImage: "https://example.com/user2.jpg",
                  title: "John Steve",
                  title2: "Sam Winchester",
                  subtitle: "liked your recipe",
                  time: "20 min",
                  recipeImage: "https://example.com/recipe1.jpg",
                ),
                NotificationCard(
                  profileImage: "https://example.com/user1.jpg",
                  title: "Dean Winchester",
                  subtitle: "now following you",
                  time: "1h",
                  buttonText: "Followed",
                  buttonColor: Colors.grey[300]!,
                  textColor: Colors.black,
                ),
                // Section: Yesterday
                const SectionTitle(title: "Yesterday"),
                NotificationCardWithImage(
                  profileImage: "https://example.com/user2.jpg",
                  title: "John Steve",
                  title2: "Sam Winchester",
                  subtitle: "liked your recipe",
                  time: "20 min",
                  recipeImage: "https://example.com/recipe1.jpg",
                ),
                NotificationCard(
                  profileImage: "https://example.com/user1.jpg",
                  title: "Dean Winchester",
                  subtitle: "now following you",
                  time: "1h",
                  buttonText: "Follow",
                  buttonColor: Colors.blue,
                  textColor: Colors.white,
                ),
                NotificationCard(
                  profileImage: "https://example.com/user1.jpg",
                  title: "Dean Winchester",
                  subtitle: "now following you",
                  time: "1h",
                  buttonText: "Followed",
                  buttonColor: Colors.grey[300]!,
                  textColor: Colors.black,
                ),
              ],
            ),
          ),
          // Bottom Navigation Bar
          BottomNavigationBar(
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            currentIndex: 3,
            items: const [
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
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String profileImage;
  final String title;
  final String subtitle;
  final String time;
  final String buttonText;
  final Color buttonColor;
  final Color textColor;

  const NotificationCard({
    Key? key,
    required this.profileImage,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.buttonText,
    required this.buttonColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(profileImage),
      ),
      title: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 14, color: Colors.black),
          children: [
            TextSpan(
              text: title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const TextSpan(text: ' '),
            TextSpan(text: subtitle),
          ],
        ),
      ),
      subtitle: Text("$time • ", style: const TextStyle(color: Colors.grey)),
      trailing: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: buttonColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () {},
        child: Text(
          buttonText,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class NotificationCardWithImage extends StatelessWidget {
  final String profileImage;
  final String title;
  final String title2;
  final String subtitle;
  final String time;
  final String recipeImage;

  const NotificationCardWithImage({
    Key? key,
    required this.profileImage,
    required this.title,
    required this.title2,
    required this.subtitle,
    required this.time,
    required this.recipeImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(profileImage),
      ),
      title: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 14, color: Colors.black),
          children: [
            TextSpan(
              text: title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const TextSpan(text: " and "),
            TextSpan(
              text: title2,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      subtitle: Text("$subtitle • $time",
          style: const TextStyle(color: Colors.grey)),
      trailing: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          recipeImage,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
