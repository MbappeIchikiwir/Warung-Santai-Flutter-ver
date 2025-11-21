import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoritesScreen extends StatelessWidget {
  // Sample data for wishlist items (in real app, use Provider or state)
  final List<Map<String, dynamic>> wishlistItems = List.generate(
      4,
      (index) => {
            'title': 'Batagor Cihuy',
            'subtitle': 'Warung sebelah Kiri',
            'price': 'Rp.10.000',
            'rating': 5.0, // Adjust for variations
            'image': 'assets/Batagor.jpg', // Or use network URL
          });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6D6D6D), // Dark gray background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Wishlist',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16),
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                IconButton(
                    icon: Icon(Icons.notifications), onPressed: () {}), // Bell
                IconButton(
                    icon: Icon(Icons.shopping_bag), onPressed: () {}), // Bag
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ListView.builder(
              itemCount: wishlistItems.length,
              itemBuilder: (context, index) {
                final item = wishlistItems[index];
                return WishlistCard(item: item); // Reusable card widget
              },
            );
          },
        ),
      ),
      // Bottom nav with blur (from MainScreen, already there)
    );
  }
}

// Reusable WishlistCard widget
class WishlistCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const WishlistCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24)), // Large radius
      elevation: 4, // Soft shadow
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                item['image'],
                width: 110, // Fixed but responsive via LayoutBuilder if needed
                height: 110,
                fit: BoxFit.cover,
              ),
              // For online: CachedNetworkImage(imageUrl: 'https://example.com/image.jpg', ...)
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'],
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    item['subtitle'],
                    style: TextStyle(color: Colors.grey),
                  ),
                  Row(
                    children: List.generate(
                        5,
                        (i) => Icon(
                              i < item['rating']
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.black,
                              size: 16,
                            )),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.shopping_bag, size: 16),
                                SizedBox(width: 4),
                                Text('Shop'),
                              ],
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.favorite_border), // Toggle in real app
                        ],
                      ),
                      Text(item['price']),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.more_vert),
          ],
        ),
      ),
    );
  }
}
