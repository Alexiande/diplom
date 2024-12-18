import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addUserData(String userId, String name, String avatarUrl) async {
  await FirebaseFirestore.instance.collection('users').doc(userId).set({
    'name': name,
    'avatarUrl': avatarUrl,
    'followersCount': 0,
    'followingCount': 0,
    'recipesCount': 0,
  });
}
