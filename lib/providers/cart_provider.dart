import 'dart:async';
import 'package:flutter/material.dart';
import '../model/cart_item_model.dart';
import '../model/food_item.dart'; // [PENTING] Import model FoodItem lama lo

class CartProvider with ChangeNotifier {
  // Simpan data dalam Map agar akses by ID cepat (O(1))
  final Map<String, CartItem> _items = {};

  // Timer untuk Debounce
  Timer? _debounceTimer;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Map<String, CartItem> get items => _items;

  // --- GETTERS ---

  List<CartItem> get cartList => _items.values.toList();

  double get totalPrice {
    return _items.values
        .where((item) => item.isSelected)
        .fold(0.0, (sum, item) => sum + item.subtotal);
  }

  int get selectedItemCount {
    return _items.values.where((item) => item.isSelected).length;
  }

  bool get isAllSelected =>
      _items.isNotEmpty && _items.values.every((item) => item.isSelected);

  bool get isEmpty => _items.isEmpty; // Tambahan biar kode lama lo gak error

  Map<String, List<CartItem>> get groupedBySeller {
    final Map<String, List<CartItem>> grouped = {};
    for (var item in _items.values) {
      if (!grouped.containsKey(item.sellerId)) {
        grouped[item.sellerId] = [];
      }
      grouped[item.sellerId]!.add(item);
    }
    return grouped;
  }

  // --- ACTIONS ---

  // [FIX UTAMA] Ini method yang dicari sama MenuScreen & FoodDetailsScreen
  void addItem(FoodItem food) {
    if (_items.containsKey(food.id)) {
      // Kalau barang udah ada, update quantity aja
      _items[food.id]!.quantity += 1;
    } else {
      // Kalau belum ada, bikin CartItem baru dari FoodItem
      _items[food.id] = CartItem(
        id: food.id,
        productId: food.id,
        name: food.name,
        price: food.price,
        imageUrl: food.imageUrl,
        // Karena FoodItem lama gak punya seller, kita kasih default dulu
        sellerId: 'warung_pusat',
        sellerName: 'Warung Santai Pusat',
        quantity: 1,
        isSelected: true, // Auto-centang pas masuk keranjang
      );
    }
    notifyListeners();
  }

  // --- LOGIC BARU (YANG KEMARIN GW KASIH) ---

  Future<void> fetchCart() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(Duration(seconds: 1)); // Simulasi
    _isLoading = false;
    notifyListeners();
  }

  void toggleSelectAll(bool? value) {
    if (value == null) return;
    for (var item in _items.values) {
      item.isSelected = value;
    }
    notifyListeners();
  }

  void toggleSelectSeller(String sellerId, bool value) {
    final sellerItems = _items.values.where((i) => i.sellerId == sellerId);
    for (var item in sellerItems) {
      item.isSelected = value;
    }
    notifyListeners();
  }

  void toggleSelectItem(String itemId) {
    if (_items.containsKey(itemId)) {
      _items[itemId]!.isSelected = !_items[itemId]!.isSelected;
      notifyListeners();
    }
  }

  void updateQuantity(String itemId, int change, BuildContext context) {
    if (!_items.containsKey(itemId)) return;

    final item = _items[itemId]!;
    final newQty = item.quantity + change;

    if (newQty < 1) return;
    if (newQty > item.maxStock) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Stok maksimal tercapai")));
      return;
    }

    item.quantity = newQty;
    notifyListeners();

    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      print("API Call: Update Item $itemId to qty $newQty");
    });
  }

  void removeSelectedItem(String itemId) {
    // Diubah jadi sync sementara biar cepet
    _items.remove(itemId);
    notifyListeners();
  }

  // Untuk kompatibilitas kode lama lo yang panggil `removeItem(item)`
  void removeItem(CartItem item) {
    _items.remove(item.id);
    notifyListeners();
  }

  Future<void> removeSelectedItems() async {
    _items.removeWhere((key, item) => item.isSelected);
    notifyListeners();
  }

  Future<bool> checkout() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(Duration(seconds: 2));
    _isLoading = false;
    notifyListeners();
    return true;
  }
}
