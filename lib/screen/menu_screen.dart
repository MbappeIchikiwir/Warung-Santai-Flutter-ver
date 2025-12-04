import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../model/food_item.dart';
import '../providers/cart_provider.dart';
import 'food_details_screen.dart';

class MenuScreen extends StatelessWidget {
  final List<FoodItem> foodItems = [
    FoodItem(
        id: '1',
        name: 'Nasi Goreng ',
        description: 'Nasi goreng spesial',
        price: 15000.0,
        imageUrl: 'assets/nasgor.jpg'),
    FoodItem(
        id: '2',
        name: 'Batagor',
        description: 'Batagor enak',
        price: 10000.0,
        imageUrl: 'assets/batagor.jpg'),
    // Add more items per category
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset('assets/warung.png',
            fit: BoxFit.cover, height: double.infinity),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Daftar Menu',
                    style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.only(
                        bottom: 80), // Biar gak ketutup bottom bar
                    itemCount: foodItems.length,
                    itemBuilder: (context, index) {
                      final item = foodItems[index];
                      return Card(
                        // Gw ganti jadi putih bersih biar makanan lebih pop-up,
                        // tapi kalau lo mau tetep coklat, ganti jadi Colors.brown[50] (lebih soft)
                        color: Colors.white,
                        elevation: 3, // Kasih bayangan biar ngambang dikit
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                item.imageUrl,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              item.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            subtitle: Text(
                              'Rp. ${item.price}',
                              style: TextStyle(
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.w600),
                            ),
                            // --- INI VISUAL UPGRADE TOMBOLNYA ---
                            trailing: ElevatedButton(
                              onPressed: () {
                                Provider.of<CartProvider>(context,
                                        listen: false)
                                    .addItem(item);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  backgroundColor: Colors.green[
                                      700], // SnackBar juga ijo biar senada
                                  content:
                                      Text('${item.name} masuk keranjang! 🛒'),
                                  duration: Duration(seconds: 1),
                                ));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.green[600], // Hijau segar
                                foregroundColor:
                                    Colors.white, // Teks PUTIH (Wajib!)
                                elevation: 2,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(20), // Lebih tumpul
                                ),
                              ),
                              child: Text(
                                'Tambah +', // Teks gw singkat biar gak sempit, tapi bebas mau ubah
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                            // ------------------------------------
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        FoodDetailsScreen(foodItem: item)),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
