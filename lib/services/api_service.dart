import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meal.dart';

class ApiService {
  static const String _baseUrl = "https://www.themealdb.com/api/json/v1/1";

  Future<List<Meal>> fetchMealsByLetter(String letter) async {
    final response =
        await http.get(Uri.parse("$_baseUrl/search.php?f=$letter"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['meals'] != null) {
        return (data['meals'] as List)
            .map((mealJson) => Meal.fromJson(mealJson))
            .toList();
      } else {
        return [];
      }
    } else {
      throw Exception("Failed to fetch meals");
    }
  }
}
