import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Stack(
      children: [
        Image.asset('assets/keranjang.png',
            fit: BoxFit.cover, height: double.infinity),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Keranjang',
                    style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                Expanded(
                  child: cartProvider.isEmpty
                      ? Center(
                          child: Text('Keranjang kosong',
                              style: TextStyle(color: Colors.white)))
                      : ListView.builder(
                          itemCount: cartProvider.cartItems.length,
                          itemBuilder: (context, index) {
                            final item = cartProvider.cartItems[index];
                            return Card(
                              color: Colors.brown[100],
                              margin: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 16),
                              child: ListTile(
                                leading: Image.asset(item.imageUrl,
                                    width: 60, height: 60, fit: BoxFit.cover),
                                title: Text(item.name,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text('Rp. ${item.price}',
                                    style: TextStyle(color: Colors.green[700])),
                                trailing: IconButton(
                                  icon: Icon(Icons.remove_circle,
                                      color: Colors.red),
                                  onPressed: () =>
                                      cartProvider.removeItem(item),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                          Text('Rp. ${cartProvider.totalPrice}',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.green[700])),
                        ],
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: cartProvider.isEmpty
                            ? null
                            : () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Checkout berhasil!')));
                              },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[700]),
                        child: Text('Checkout'),
                      ),
                    ],
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
