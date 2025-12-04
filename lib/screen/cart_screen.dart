// lib/screen/cart_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/cart_provider.dart';
import '../model/cart_item_model.dart';
// [FIX] Hapus import food_details_screen.dart karena tidak dipakai (mengatasi unused_import)
import 'home_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch data saat screen dibuka
    Future.microtask(
        () => Provider.of<CartProvider>(context, listen: false).fetchCart());
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final groupedItems = cart.groupedBySeller;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          'Keranjang (${cart.cartList.length})',
          style: GoogleFonts.poppins(
              color: Colors.black, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          if (cart.selectedItemCount > 0)
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    // [FIX] Pastikan parameter 'title' ada di sini (mengatasi missing_required_argument)
                    title: Text(
                      "Hapus ${cart.selectedItemCount} barang?",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                    content: const Text(
                        "Barang yang dipilih akan dihapus dari keranjang."),
                    actions: [
                      TextButton(
                          child: const Text("Batal"),
                          onPressed: () => Navigator.pop(ctx)),
                      TextButton(
                          child: const Text("Hapus",
                              style: TextStyle(color: Colors.red)),
                          onPressed: () {
                            cart.removeSelectedItems();
                            Navigator.pop(ctx);
                          }),
                    ],
                  ),
                );
              },
              child: Text("Hapus",
                  style: GoogleFonts.poppins(
                      color: Colors.red, fontWeight: FontWeight.bold)),
            )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => await cart.fetchCart(),
        color: Colors.green[700],
        child: cart.isLoading && cart.cartList.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : cart.cartList.isEmpty
                ? _buildEmptyState(context) // State kosong
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 20),
                          itemCount: groupedItems.length,
                          itemBuilder: (context, index) {
                            String sellerId =
                                groupedItems.keys.elementAt(index);
                            List<CartItem> items = groupedItems[sellerId]!;
                            return _SellerGroupCard(
                                items: items, sellerId: sellerId);
                          },
                        ),
                      ),
                      _buildBottomBar(context, cart),
                    ],
                  ),
      ),
    );
  }

  // --- WIDGET: EMPTY STATE ---
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined,
              size: 100, color: Colors.grey[300]),
          const SizedBox(height: 20),
          Text("Keranjangmu kosong nih",
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
          const SizedBox(height: 20),

          // Tombol Navigasi ke Home
          ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const HomeScreen(title: 'Home')),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              elevation: 2,
            ),
            child: Text(
              "Mulai Belanja",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  // --- WIDGET: BOTTOM BAR ---
  Widget _buildBottomBar(BuildContext context, CartProvider cart) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5))
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: cart.isAllSelected,
                      activeColor: Colors.green[700],
                      onChanged: (val) => cart.toggleSelectAll(val),
                    ),
                    Text("Semua", style: GoogleFonts.poppins(fontSize: 14)),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("Total Harga",
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: Colors.grey[600])),
                    Text(
                      "Rp ${cart.totalPrice.toStringAsFixed(0)}",
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[900]),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: cart.selectedItemCount == 0
                      ? null
                      : () async {
                          bool success = await cart.checkout();
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Checkout Berhasil!")));
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    disabledBackgroundColor: Colors.grey[300],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    "Checkout (${cart.selectedItemCount})",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// --- WIDGET: SELLER GROUP & ITEM ROW ---

class _SellerGroupCard extends StatelessWidget {
  final String sellerId;
  final List<CartItem> items;

  const _SellerGroupCard(
      {Key? key, required this.items, required this.sellerId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final isSellerSelected = items.every((item) => item.isSelected);
    final sellerName = items.first.sellerName;

    return Container(
      margin: const EdgeInsets.only(top: 10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Checkbox(
                  value: isSellerSelected,
                  activeColor: Colors.green[700],
                  onChanged: (val) =>
                      cart.toggleSelectSeller(sellerId, val ?? false),
                ),
                const Icon(Icons.storefront, size: 20),
                const SizedBox(width: 8),
                Text(
                  sellerName,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...items.map((item) => _CartItemRow(item: item)).toList(),
        ],
      ),
    );
  }
}

class _CartItemRow extends StatelessWidget {
  final CartItem item;

  const _CartItemRow({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        cart.removeSelectedItem(item.id);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: item.isSelected,
              activeColor: Colors.green[700],
              onChanged: (val) => cart.toggleSelectItem(item.id),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                item.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, _) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Rp ${item.price.toStringAsFixed(0)}",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            _QtyBtn(
                              icon: Icons.remove,
                              onTap: () =>
                                  cart.updateQuantity(item.id, -1, context),
                              isEnabled: item.quantity > 1,
                            ),
                            Container(
                              width: 32,
                              alignment: Alignment.center,
                              child: Text("${item.quantity}"),
                            ),
                            _QtyBtn(
                              icon: Icons.add,
                              onTap: () =>
                                  cart.updateQuantity(item.id, 1, context),
                              isEnabled: item.quantity < item.maxStock,
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isEnabled;

  const _QtyBtn(
      {Key? key,
      required this.icon,
      required this.onTap,
      required this.isEnabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isEnabled ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Icon(icon,
            size: 16, color: isEnabled ? Colors.grey[700] : Colors.grey[300]),
      ),
    );
  }
}
