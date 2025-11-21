import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../model/food_item.dart';
import '../providers/cart_provider.dart';

class FoodDetailsScreen extends StatelessWidget {
  final FoodItem foodItem;

  const FoodDetailsScreen({required this.foodItem, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset('assets/detail.png',
            fit: BoxFit.cover, height: double.infinity),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      foodItem.imageUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      foodItem.name,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Rp. ${foodItem.price.toStringAsFixed(0)}',
                      style: TextStyle(fontSize: 18, color: Colors.green[700]),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      foodItem.description,
                      style:
                          const TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Nutrisi: ${(foodItem.nutrition['calories'] as num).toDouble()} cal, '
                      '${(foodItem.nutrition['protein'] as num).toDouble()}g protein, '
                      '${(foodItem.nutrition['fat'] as num).toDouble()}g fat',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          i < foodItem.rating.toDouble()
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.yellow,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Provider.of<CartProvider>(context, listen: false)
                                .addItem(foodItem);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${foodItem.name} ditambahkan ke keranjang!',
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[700],
                          ),
                          child: const Text('Tambah ke Keranjang'),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon:
                                  const Icon(Icons.share, color: Colors.white),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.favorite_border,
                                  color: Colors.white),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
