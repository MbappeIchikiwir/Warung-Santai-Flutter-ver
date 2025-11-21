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
                    itemCount: foodItems.length,
                    itemBuilder: (context, index) {
                      final item = foodItems[index];
                      return Card(
                        color: Colors.brown[100],
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        child: ListTile(
                          leading: Image.asset(item.imageUrl,
                              width: 60, height: 60, fit: BoxFit.cover),
                          title: Text(item.name,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Rp. ${item.price}',
                              style: TextStyle(color: Colors.green[700])),
                          trailing: ElevatedButton(
                            onPressed: () {
                              Provider.of<CartProvider>(context, listen: false)
                                  .addItem(item);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      '${item.name} ditambahkan ke keranjang!')));
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[700]),
                            child: Text('Tambah Pesanan'),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      FoodDetailsScreen(foodItem: item)),
                            );
                          },
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
