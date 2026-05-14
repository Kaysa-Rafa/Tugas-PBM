import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/login_page.dart';
import 'pages/product_list_page.dart';
import 'pages/add_product_page.dart';
import 'pages/submit_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Perbaikan: inisialisasi binding
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.orbitronTextTheme(
      ThemeData.dark().textTheme,
    );

    return MaterialApp(
      title: 'Tugas PBM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFF00E5FF),
        scaffoldBackgroundColor: Color(0xFF0A0E21),
        cardColor: Color(0xFF1D1F33),
        textTheme: textTheme,
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF1D1F33),
          titleTextStyle: GoogleFonts.orbitron(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00E5FF),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF00E5FF),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/products': (context) => ProductListPage(),
        '/add-product': (context) => AddProductPage(),
        '/submit': (context) => SubmitPage(),
      },
      // Perbaikan: rute fallback jika halaman tidak ditemukan
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(child: Text('Halaman tidak ditemukan')),
        ),
      ),
    );
  }
}