class Recipe {
  final int id;
  final String title;
  final String image;
  final List<String> usedIngredients;
  final List<String> missedIngredients;

  Recipe({
    required this.id,
    required this.title,
    required this.image,
    required this.usedIngredients,
    required this.missedIngredients,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      usedIngredients: List<String>.from(json['usedIngredients'].map((item) => item['name'])),
      missedIngredients: List<String>.from(json['missedIngredients'].map((item) => item['name'])),
    );
  }
}
