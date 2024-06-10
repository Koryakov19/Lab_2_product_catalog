import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  ProductDetailScreen({required this.product});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late bool _isFavorite;
  late List<Product> _favoriteProducts = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteProductsJson = prefs.getStringList('favoriteProducts') ?? [];
    setState(() {
      _favoriteProducts = favoriteProductsJson
          .map((json) => Product.fromMap(jsonDecode(json)))
          .toList();
      _isFavorite = _favoriteProducts.any((product) => product.name == widget.product.name);
    });
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteProductsJson = prefs.getStringList('favoriteProducts') ?? [];

    setState(() {
      if (_isFavorite) {
        favoriteProductsJson.removeWhere((json) => Product.fromMap(jsonDecode(json)).name == widget.product.name);
      } else {
        favoriteProductsJson.add(jsonEncode(widget.product.toMap()));
      }
      prefs.setStringList('favoriteProducts', favoriteProductsJson);
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/backg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: Container(
                  color: Colors.white.withOpacity(0.8),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blueAccent, width: 2),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                widget.product.name,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          _buildNutritionRow('Calories', '${widget.product.calories} kcal'),
                          _buildNutritionRow('Fat', '${widget.product.fat} g'),
                          _buildNutritionRow('Protein', '${widget.product.protein} g'),
                          _buildNutritionRow('Carbs', '${widget.product.carbs} g'),
                          _buildNutritionRow('Cholesterol', '${widget.product.cholesterol} mg'),
                          _buildNutritionRow('Sodium', '${widget.product.sodium} mg'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.white.withOpacity(0.8),
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: GestureDetector(
                    onTap: _toggleFavorite,
                    child: Icon(
                      _isFavorite ? Icons.star : Icons.star_border,
                      color: _isFavorite ? Colors.yellow : Colors.grey,
                      size: 70.0, // Увеличиваем размер звезды
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black.withOpacity(0.5),
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionRow(String label, String value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green, width: 2),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
