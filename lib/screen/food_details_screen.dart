import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../model/food_item.dart';
import '../providers/cart_provider.dart';

class FoodDetailsScreen extends StatefulWidget {
  final FoodItem foodItem;

  const FoodDetailsScreen({Key? key, required this.foodItem}) : super(key: key);

  @override
  _FoodDetailsScreenState createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Gambar Full Screen di bagian atas
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.45,
            child: Image.asset(
              widget.foodItem.imageUrl,
              fit: BoxFit.cover,
            ),
          ),

          // 2. Tombol Back & Favorite (Floating di atas gambar)
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: Icon(Icons.favorite_border, color: Colors.red),
                    onPressed: () {
                      // Todo: Implement logic favorite
                    },
                  ),
                ),
              ],
            ),
          ),

          // 3. Container Detail (Melengkung ke atas)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.4 - 30,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Garis kecil buat indikator swipe (hiasan)
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Nama Makanan & Harga
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.foodItem.name,
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Text(
                        'Rp ${widget.foodItem.price}',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // Rating & Waktu (Opsional visual)
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      SizedBox(width: 4),
                      Text("4.8",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: 16),
                      Icon(Icons.timer, color: Colors.grey, size: 20),
                      SizedBox(width: 4),
                      Text("20 min", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Deskripsi
                  Text(
                    "Deskripsi",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Makanan lezat ini dibuat dengan bahan-bahan pilihan yang segar dan bumbu rahasia warung kami. Cocok untuk menemani santai Anda!",
                    style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                  Spacer(),

                  // --- BAGIAN TOMBOL ADD TO CART (VISUAL UPGRADE) ---
                  Container(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        // Logic Add Item
                        Provider.of<CartProvider>(context, listen: false)
                            .addItem(widget.foodItem);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Berhasil masuk keranjang! 🍲"),
                            backgroundColor: Colors.green[700],
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700], // HIJAU SEGAR
                        foregroundColor: Colors.white, // TEKS PUTIH
                        elevation: 5,
                        shadowColor: Colors.green.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16), // Rounded
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_bag_outlined,
                              color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            "Tambah ke Keranjang",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // ------------------------------------------------
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
