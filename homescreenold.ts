// body: SafeArea(
          //   child: SingleChildScrollView(
          //     child: Padding(
          //       padding: EdgeInsets.all(16.0),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           // Greeting
          //           Text(
          //             'Selamat Datang di Warung Santai!',
          //             style: GoogleFonts.poppins(
          //                 fontSize: 24,
          //                 fontWeight: FontWeight.bold,
          //                 color: Colors.black),
          //           ),
          //           SizedBox(height: 20),
          //           // Search Bar
          //           TextField(
          //             decoration: InputDecoration(
          //               hintText: 'Cari makanan favoritmu...',
          //               prefixIcon:
          //                   Icon(Icons.search, color: Colors.green[700]),
          //               filled: true,
          //               fillColor: Colors.white,
          //               border: OutlineInputBorder(
          //                   borderRadius: BorderRadius.circular(25)),
          //             ),
          //           ),
          //           SizedBox(height: 20),
          //           // Categories
          //           Text(
          //             'Kategori Makanan',
          //             style: GoogleFonts.poppins(
          //                 fontSize: 18, color: Colors.black),
          //           ),
          //           SizedBox(
          //             height: 130, // Diperluas sedikit untuk akomodasi teks
          //             child: ListView.builder(
          //               scrollDirection: Axis.horizontal,
          //               itemCount: categories.length,
          //               itemBuilder: (context, index) {
          //                 return Padding(
          //                   padding: EdgeInsets.all(8.0),
          //                   child: Column(
          //                     mainAxisSize: MainAxisSize
          //                         .min, // Menggunakan ukuran minimum
          //                     children: [
          //                       ClipRRect(
          //                         borderRadius: BorderRadius.circular(10),
          //                         child: Image.asset(
          //                           categories[index]['image']!,
          //                           width: 40,
          //                           height: 40,
          //                           fit: BoxFit.cover,
          //                         ),
          //                       ),
          //                       SizedBox(height: 5),
          //                       Flexible(
          //                         // Membuat teks fleksibel
          //                         child: Text(
          //                           categories[index]['name']!,
          //                           style: TextStyle(color: Colors.white),
          //                           overflow: TextOverflow
          //                               .ellipsis, // Potong teks panjang
          //                           maxLines: 1,
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 );
          //               },
          //             ),
          //           ),
          //           SizedBox(height: 20),
          //           // Popular Items
          //           Text(
          //             'Makanan Populer',
          //             style: GoogleFonts.poppins(
          //                 fontSize: 18, color: Colors.black),
          //           ),
          //           ListView.builder(
          //             shrinkWrap: true,
          //             physics: NeverScrollableScrollPhysics(),
          //             itemCount: popularItems.length,
          //             itemBuilder: (context, index) {
          //               return Card(
          //                 color: Colors.brown[100],
          //                 margin: EdgeInsets.symmetric(vertical: 10),
          //                 child: ListTile(
          //                   leading: Image.asset(popularItems[index]['image']!,
          //                       width: 60, height: 60, fit: BoxFit.cover),
          //                   title: Text(popularItems[index]['name']!,
          //                       style: TextStyle(fontWeight: FontWeight.bold)),
          //                   subtitle: Text(
          //                       'Rp. ${popularItems[index]['price']}',
          //                       style: TextStyle(color: Colors.green[700])),
          //                   onTap: () {
          //                     Navigator.push(
          //                       context,
          //                       MaterialPageRoute(
          //                         builder: (context) => FoodDetailsScreen(
          //                           foodItem: FoodItem(
          //                             id: index.toString(),
          //                             name: popularItems[index]['name']!,
          //                             description:
          //                                 'Delicious ${popularItems[index]['name']}!',
          //                             price: popularItems[index]['price']
          //                                 .toDouble(),
          //                             imageUrl: popularItems[index]['image']!,
          //                           ),
          //                         ),
          //                       ),
          //                     );
          //                   },
          //                 ),
          //               );
          //             },
          //           ),
          //           // Recommended Items
          //           Text(
          //             'Rekomendasi untukmu',
          //             style: GoogleFonts.poppins(
          //                 fontSize: 18, color: Colors.black),
          //           ),
          //           ListView.builder(
          //             shrinkWrap: true,
          //             physics: NeverScrollableScrollPhysics(),
          //             itemCount: popularItems.length,
          //             itemBuilder: (context, index) {
          //               return Card(
          //                 color: Colors.brown[100],
          //                 margin: EdgeInsets.symmetric(vertical: 10),
          //                 child: ListTile(
          //                   leading: Image.asset(popularItems[index]['image']!,
          //                       width: 60, height: 60, fit: BoxFit.cover),
          //                   title: Text(popularItems[index]['name']!,
          //                       style: TextStyle(fontWeight: FontWeight.bold)),
          //                   subtitle: Text(
          //                       'Rp. ${popularItems[index]['price']}',
          //                       style: TextStyle(color: Colors.green[700])),
          //                   onTap: () {
          //                     Navigator.push(
          //                       context,
          //                       MaterialPageRoute(
          //                         builder: (context) => FoodDetailsScreen(
          //                           foodItem: FoodItem(
          //                             id: index.toString(),
          //                             name: popularItems[index]['name']!,
          //                             description:
          //                                 'Delicious ${popularItems[index]['name']}!',
          //                             price: popularItems[index]['price']
          //                                 .toDouble(),
          //                             imageUrl: popularItems[index]['image']!,
          //                           ),
          //                         ),
          //                       ),
          //                     );
          //                   },
          //                 ),
          //               );
          //             },
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),


          // body: SafeArea(
          //   child: ListView(
          //     padding: EdgeInsets.all(16),
          //     children: [
          //       // Greeting
          //       Text(
          //         'Selamat Datang di Warung Santai!',
          //         style: GoogleFonts.poppins(
          //             fontSize: 24,
          //             fontWeight: FontWeight.bold,
          //             color: Colors.black),
          //       ),
          //       SizedBox(height: 20),
          //       // Search Bar
          //       TextField(
          //         decoration: InputDecoration(
          //           hintText: 'Cari makanan favoritmu...',
          //           prefixIcon: Icon(Icons.search, color: Colors.green[700]),
          //           filled: true,
          //           fillColor: Colors.white,
          //           border: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(25)),
          //         ),
          //       ),
          //       SizedBox(height: 20),
          //       // Categories
          //       Text(
          //         'Kategori Makanan',
          //         style: GoogleFonts.poppins(fontSize: 18, color: Colors.black),
          //       ),

          //       SizedBox(height: 20),
          //       // Popular Items
          //       // Text(
          //       //   'Makanan Populer',
          //       //   style: GoogleFonts.poppins(
          //       //       fontSize: 18, color: Colors.black),
          //       // ),
          //       // ListView.builder(
          //       //   shrinkWrap: true,
          //       //   physics: NeverScrollableScrollPhysics(),
          //       //   itemCount: popularItems.length,
          //       //   itemBuilder: (context, index) {
          //       //     return Card(
          //       //       color: Colors.brown[100],
          //       //       margin: EdgeInsets.symmetric(vertical: 10),
          //       //       child: ListTile(
          //       //         leading: Image.asset(popularItems[index]['image']!,
          //       //             width: 60, height: 60, fit: BoxFit.cover),
          //       //         title: Text(popularItems[index]['name']!,
          //       //             style: TextStyle(fontWeight: FontWeight.bold)),
          //       //         subtitle: Text(
          //       //             'Rp. ${popularItems[index]['price']}',
          //       //             style: TextStyle(color: Colors.green[700])),
          //       //         onTap: () {
          //       //           Navigator.push(
          //       //             context,
          //       //             MaterialPageRoute(
          //       //               builder: (context) => FoodDetailsScreen(
          //       //                 foodItem: FoodItem(
          //       //                   id: index.toString(),
          //       //                   name: popularItems[index]['name']!,
          //       //                   description:
          //       //                       'Delicious ${popularItems[index]['name']}!',
          //       //                   price: popularItems[index]['price']
          //       //                       .toDouble(),
          //       //                   imageUrl: popularItems[index]['image']!,
          //       //                 ),
          //       //               ),
          //       //             ),
          //       //           );
          //       //         },
          //       //       ),
          //       //     );
          //       //   },
          //       // ),
          //       // // Recommended Items
          //       // Text(
          //       //   'Rekomendasi untukmu',
          //       //   style: GoogleFonts.poppins(
          //       //       fontSize: 18, color: Colors.black),
          //       // ),
          //       // ListView.builder(
          //       //   shrinkWrap: true,
          //       //   physics: NeverScrollableScrollPhysics(),
          //       //   itemCount: popularItems.length,
          //       //   itemBuilder: (context, index) {
          //       //     return Card(
          //       //       color: Colors.brown[100],
          //       //       margin: EdgeInsets.symmetric(vertical: 10),
          //       //       child: ListTile(
          //       //         leading: Image.asset(popularItems[index]['image']!,
          //       //             width: 60, height: 60, fit: BoxFit.cover),
          //       //         title: Text(popularItems[index]['name']!,
          //       //             style: TextStyle(fontWeight: FontWeight.bold)),
          //       //         subtitle: Text(
          //       //             'Rp. ${popularItems[index]['price']}',
          //       //             style: TextStyle(color: Colors.green[700])),
          //       //         onTap: () {
          //       //           Navigator.push(
          //       //             context,
          //       //             MaterialPageRoute(
          //       //               builder: (context) => FoodDetailsScreen(
          //       //                 foodItem: FoodItem(
          //       //                   id: index.toString(),
          //       //                   name: popularItems[index]['name']!,
          //       //                   description:
          //       //                       'Delicious ${popularItems[index]['name']}!',
          //       //                   price: popularItems[index]['price']
          //       //                       .toDouble(),
          //       //                   imageUrl: popularItems[index]['image']!,
          //       //                 ),
          //       //               ),
          //       //             ),
          //       //           );
          //       //         },
          //       //       ),
          //       //     );
          //       //   },
          //       // ),
          //       _buildPostList(),
          //     ],
          //   ),
          // ),