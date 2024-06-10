import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  final String apiUrl = 'https://api.edamam.com/api/food-database/v2/parser';
  final String appId = '4195f8f0';
  final String apiKey = '31380ee0762d18bbdd90ecc3b9160a0d';

  Future<List<Product>> fetchProducts(String query) async {
    final response = await http.get(Uri.parse('$apiUrl?ingr=$query&app_id=$appId&app_key=$apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final hints = data['hints'] as List;
      return hints.map((hint) {
        final food = hint['food'];
        return Product(
          name: food['label'],
          calories: _roundDouble(food['nutrients']['ENERC_KCAL']?.toDouble() ?? 0.0),
          fat: _roundDouble(food['nutrients']['FAT']?.toDouble() ?? 0.0),
          protein: _roundDouble(food['nutrients']['PROCNT']?.toDouble() ?? 0.0),
          carbs: _roundDouble(food['nutrients']['CHOCDF']?.toDouble() ?? 0.0),
          cholesterol: _roundDouble(food['nutrients']['CHOLE']?.toDouble() ?? 0.0),
          sodium: _roundDouble(food['nutrients']['NA']?.toDouble() ?? 0.0),
        );
      }).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  double _roundDouble(double value) {
    return double.parse(value.toStringAsFixed(1));
  }
}
