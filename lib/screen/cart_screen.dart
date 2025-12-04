// lib/screen/cart_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/cart_provider.dart';
import '../model/cart_item_model.dart'; // Pastikan import model

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch data saat pertama kali buka screen
    Future.microtask(
        () => Provider.of<CartProvider>(context, listen: false).fetchCart());
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final groupedItems = cart.groupedBySeller;

    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F5F5), // Background abu muda ala E-commerce
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
          // Tombol Delete Multiple
          if (cart.selectedItemCount > 0)
            TextButton(
              onPressed: () {
                // Konfirmasi hapus
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text("Hapus ${cart.selectedItemCount} barang?"),
                    actions: [
                      TextButton(
                          child: Text("Batal"),
                          onPressed: () => Navigator.pop(ctx)),
                      TextButton(
                          child: Text("Hapus",
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
                ? _buildEmptyState(context)
                : Column(
                    children: [
                      // List Barang (Scrollable)
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
                      // Checkout Bar
                      _buildBottomBar(context, cart),
                    ],
                  ),
      ),
    );
  }

  // --- WIDGETS KECIL (Split Methods) ---

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
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => Navigator.pop(context), // Balik ke Home
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("Mulai Belanja"),
          )
        ],
      ),
    );
  }

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
            // Voucher Row (Optional UI improvement)
            InkWell(
              onTap: () {}, // Todo: Buka menu voucher
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  children: [
                    const Icon(Icons.confirmation_number_outlined,
                        color: Colors.orange, size: 20),
                    const SizedBox(width: 8),
                    Text("Makin hemat pakai promo",
                        style: GoogleFonts.poppins(fontSize: 12)),
                    const Spacer(),
                    const Icon(Icons.chevron_right,
                        size: 20, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                // Checkbox Select All
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
                // Total Price & Button
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    "Checkout (${cart.selectedItemCount})",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: cart.selectedItemCount == 0
                            ? Colors.grey
                            : Colors.white),
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

// --- SUB-WIDGETS (Extracted for Performance) ---

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
          // Seller Header
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
                const Spacer(),
                TextButton(
                  onPressed: () {}, // Navigasi ke toko
                  child: Text("Kunjungi Toko",
                      style: TextStyle(fontSize: 12, color: Colors.green[700])),
                )
              ],
            ),
          ),
          const Divider(height: 1),
          // List Items dalam Toko ini
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
            // Checkbox Item
            Checkbox(
              value: item.isSelected,
              activeColor: Colors.green[700],
              onChanged: (val) => cart.toggleSelectItem(item.id),
            ),
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                // Ganti NetworkImage jika pakai URL
                item.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, _) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: Icon(Icons.broken_image)),
              ),
            ),
            const SizedBox(width: 12),
            // Details
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
                  const SizedBox(height: 4),
                  Text(
                    "Stok: ${item.maxStock}", // Info stok
                    style: TextStyle(color: Colors.grey[500], fontSize: 11),
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
                      // Quantity Buttons
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
