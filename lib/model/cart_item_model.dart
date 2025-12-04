// lib/model/cart_item_model.dart

class CartItem {
  final String id;
  final String productId;
  final String name;
  final double price;
  final String imageUrl;
  final String sellerId;
  final String sellerName;
  final int maxStock;

  // Mutable properties (bisa berubah di UI)
  int quantity;
  bool isSelected;
  bool isLoading; // Untuk loading state per item (misal saat update qty)

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.sellerId,
    required this.sellerName,
    this.maxStock = 99,
    this.quantity = 1,
    this.isSelected = false,
    this.isLoading = false,
  });

  // Helper untuk hitung subtotal per item
  double get subtotal => price * quantity;
}
