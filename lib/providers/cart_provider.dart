import 'package:flutter/material.dart';
import '../model/food_item.dart';

class CartProvider with ChangeNotifier {
  final List<FoodItem> _cartItems = [];

  List<FoodItem> get cartItems => _cartItems;
  double get totalPrice =>
      _cartItems.fold(0.0, (sum, item) => sum + item.price);

  void addItem(FoodItem item) {
    _cartItems.add(item);
    notifyListeners();
  }

  void removeItem(FoodItem item) {
    _cartItems.remove(item);
    notifyListeners();
  }

  bool get isEmpty => _cartItems.isEmpty;
}
