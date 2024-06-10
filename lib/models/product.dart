class Product {
  final String name;
  final double calories;
  final double fat;
  final double protein;
  final double carbs;
  final double cholesterol;
  final double sodium;

  Product({
    required this.name,
    required this.calories,
    required this.fat,
    required this.protein,
    required this.carbs,
    required this.cholesterol,
    required this.sodium,
  });

  // Преобразование продукта в Map для сохранения в SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'calories': calories,
      'fat': fat,
      'protein': protein,
      'carbs': carbs,
      'cholesterol': cholesterol,
      'sodium': sodium,
    };
  }

  // Создание продукта из Map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'],
      calories: map['calories'],
      fat: map['fat'],
      protein: map['protein'],
      carbs: map['carbs'],
      cholesterol: map['cholesterol'],
      sodium: map['sodium'],
    );
  }
}
