import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/post_provider.dart';
import 'screen/login_screen.dart';
import 'screen/register_screen.dart';
import 'screen/startup_screen.dart';
import 'screen/main_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => PostProvider()),
      ],
      child: MaterialApp(
        title: 'Warung Santai',
        theme: ThemeData(
          primarySwatch: Colors.brown,
          textTheme: GoogleFonts.poppinsTextTheme(),
          scaffoldBackgroundColor: Color(0xFFF5E6C8), // Soft beige background
        ),
        home: StartupScreen(),
        routes: {
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/app': (context) => MainScreen(),
          '/startup': (context) => StartupScreen(),
        },
      ),
    );
  }
}
