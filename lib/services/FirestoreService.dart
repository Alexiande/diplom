import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Получение пользователя по email
  Future<DocumentSnapshot?> getUserByEmail(String email) async {
    final userQuery = await _db.collection('users').where('userEmail', isEqualTo: email).get();
    return userQuery.docs.isNotEmpty ? userQuery.docs.first : null;
  }

  // Обновление профиля пользователя
  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    await _db.collection('users').doc(userId).update(data);
  }

  // Создание нового профиля
  Future<void> createUserProfile(Map<String, dynamic> data) async {
    await _db.collection('users').add(data);
  }
}
