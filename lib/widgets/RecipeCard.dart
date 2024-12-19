import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:diplom/screens/SearchScreen.dart'; // Замените на путь к экрану поиска, если он у вас есть.
import 'package:diplom/services/LikeService.dart';  // Замените на путь к вашему сервису для работы с лайками


class RecipeCard extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String time;
  final String category; // Добавляем категорию
  final String itemId; // Уникальный идентификатор для рецепта
  final LikeService likeService;

  const RecipeCard({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.time,
    required this.category, // Инициализация категории
    required this.itemId,
    required this.likeService,
  }) : super(key: key);

  @override
  _RecipeCardState createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    _loadLikeStatus();
  }

  Future<void> _loadLikeStatus() async {
    final likedItems = await widget.likeService.getLikedItems();
    setState(() {
      isLiked = likedItems.contains(widget.itemId);
    });
  }

  Future<void> _toggleLike() async {
    setState(() {
      isLiked = !isLiked;
    });
    if (isLiked) {
      await widget.likeService.addLikedItem(widget.itemId);
    } else {
      await widget.likeService.removeLikedItem(widget.itemId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0), // Отступ вокруг карточки
      child: GestureDetector( // Используем GestureDetector для обработки нажатий
        onTap: () {
          // Здесь вы можете определить логику перехода на новый экран
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchScreen(), // Укажите ваш экран поиска
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // Смещение тени
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16), // Скругляем все углы
                    child: CachedNetworkImage(
                      imageUrl: widget.imageUrl,
                      fit: BoxFit.cover,
                      height: 120, // Высота изображения
                      width: double.infinity,
                      placeholder: (context, url) => Container(
                        height: 120,
                        width: double.infinity,
                        child: const Center(
                          child: CircularProgressIndicator(), // Индикатор загрузки
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E3E5C),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.time,
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Color(0xFF9FA5C0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.grey,
                  ),
                  onPressed: _toggleLike,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}