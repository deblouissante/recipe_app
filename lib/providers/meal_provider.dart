import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/api_service.dart';

class MealProvider with ChangeNotifier {
  List<Meal> _meals = [];
  bool _isLoading = false;
  String _errorMessage = "";

  List<Meal> get meals => _meals;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchMealsByLetter(String letter) async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      _meals = await ApiService().fetchMealsByLetter(letter);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
