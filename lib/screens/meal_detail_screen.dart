import 'package:flutter/material.dart';
import '../models/meal.dart';
import 'package:google_fonts/google_fonts.dart';

class MealDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final meal = ModalRoute.of(context)?.settings.arguments as Meal?;

    if (meal == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Error')),
        body: Center(
          child: Text(
            'Meal data not found',
            style:
                GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 255, 177, 177),
                  const Color.fromARGB(255, 255, 223, 223)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Text(
            meal.name,
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 90, 0, 0), // Warna teks
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Membuat gambar di tengah
            Center(
              child: Image.network(
                meal.thumbnail,
                width: 400, // Atur lebar gambar
                // height: 350, // Atur tinggi gambar
                fit:
                    BoxFit.cover, // Untuk mengatur bagaimana gambar disesuaikan
              ),
            ),

            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.list_alt,
                    color: const Color.fromARGB(255, 122, 0, 0)),
                SizedBox(width: 8),
                Text(
                  "Instructions",
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 122, 0, 0),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 5,
                    spreadRadius: 2,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                meal.instructions,
                style: GoogleFonts.outfit(fontSize: 16, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
