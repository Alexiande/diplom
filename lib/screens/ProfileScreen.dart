import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diplom/screens/EditProfileScreen.dart';
import 'package:diplom/services/LikeService.dart'; // Подключаем сервис для лайков
import 'package:diplom/widgets/RecipeCard.dart'; // Подключаем виджет RecipeCard

class ProfileScreen extends StatefulWidget {
  final String userId;

  ProfileScreen({required this.userId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String avatarUrl = 'asset/images/default_avatar.png'; // по умолчанию
  String name = 'Unknown'; // по умолчанию
  String bio = 'Who\'re great?'; // по умолчанию

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    print('Loading profile for userId: ${widget.userId}');
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();
      if (userDoc.exists) {
        print('User data found');
        setState(() {
          avatarUrl = userDoc['avatarUrl'] ?? 'asset/images/default_avatar.png';
          name = userDoc['name'] ?? 'Unknown';
          bio = userDoc['bio'] ?? 'Who\'re great?';
        });
      } else {
        print('User not found');
      }
    } catch (e) {
      print('Error loading user profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Color(0xFF3E5481)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(userId: widget.userId),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(widget.userId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Center(child: Text('Error loading profile data'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            print('No data found for user: ${widget.userId}');
            return _buildDefaultProfile();
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;
          print('Loaded data: $userData');

          avatarUrl = userData['avatarUrl'] ?? 'assets/images/default_avatar.png';
          name = userData['name'] ?? 'Unknown';
          bio = userData['bio'] ?? 'Who\'re great?';

          // Получаем количество рецептов, лайков и подписчиков
          int recipesCount = userData['recipesCount'] ?? 0;
          int followingCount = userData['followingCount'] ?? 0;
          int followersCount = userData['followersCount'] ?? 0;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: avatarUrl.startsWith('http')
                          ? NetworkImage(avatarUrl)
                          : AssetImage(avatarUrl) as ImageProvider,
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF3E5481)),
                        ),
                        Text(
                          bio,
                          style: TextStyle(fontSize: 16, color: Color(0xFF9FA5C0)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatColumn('Recipes', recipesCount),
                    _buildStatColumn('Following', followingCount),
                    _buildStatColumn('Followers', followersCount),
                  ],
                ),
              ),
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      TabBar(
                        tabs: [
                          Tab(text: 'Recipes'),
                          Tab(text: 'Liked'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _buildRecipesList(),
                            _buildLikedList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatColumn(String title, int count) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF9FA5C0))),
        Text(count.toString(), style: TextStyle(fontSize: 16, color: Color(0xFF3E5481))),
      ],
    );
  }

  // Загрузка рецептов пользователя из подколлекции 'recipes'
  Widget _buildRecipesList() {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(widget.userId).collection('recipes').get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
          return Center(child: Text('Error loading recipes'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No recipes found.'));
        }

        var recipes = snapshot.data!.docs;
        return ListView.builder(
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            var recipe = recipes[index].data() as Map<String, dynamic>;
            return RecipeCard(
              title: recipe['title'],
              imageUrl: recipe['imageUrl'],
              time: recipe['time'],
              category: recipe['category'],
              itemId: recipes[index].id,
              likeService: LikeService(),
            );
          },
        );
      },
    );
  }

  // Загрузка лайкнутых рецептов из подколлекции 'likedRecipes'
  Widget _buildLikedList() {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(widget.userId).collection('likedRecipes').get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
          return Center(child: Text('Error loading liked recipes'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No liked recipes.'));
        }

        var likedRecipes = snapshot.data!.docs;
        return ListView.builder(
          itemCount: likedRecipes.length,
          itemBuilder: (context, index) {
            var recipe = likedRecipes[index].data() as Map<String, dynamic>;
            return RecipeCard(
              title: recipe['title'],
              imageUrl: recipe['imageUrl'],
              time: recipe['time'],
              category: recipe['category'],
              itemId: likedRecipes[index].id,
              likeService: LikeService(),
            );
          },
        );
      },
    );
  }

  Widget _buildDefaultProfile() {
    return Center(
      child: Text('User data not found. Please try again later.'),
    );
  }
}
