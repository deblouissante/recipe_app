import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart'; // Import API service
import '../models/meal.dart'; // Model Meal untuk data resep
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedLetter = 'a';
  late ApiService apiService;
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    apiService = ApiService(); // Menginisialisasi ApiService
    _fetchMeals();
  }

  // Fungsi untuk mengambil data resep dari API
  void _fetchMeals() {
    apiService.fetchMealsByLetter(selectedLetter).then((meals) {
      // Simpan data ke dalam state atau provider
      setState(() {
        // Tangani data meals di sini
      });
    }).catchError((error) {
      // Tangani error jika API gagal
      print("Error fetching meals: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(241, 227, 211, 100),
        toolbarHeight: 250,
        title: isSearching
            ? TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Search Recipe',
                  border: InputBorder.none,
                  suffixIcon: Icon(Icons.search),
                ),
                autofocus: true,
                onChanged: (value) => setState(() {}),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Cookify',
                      style: GoogleFonts.lora(
                        color: const Color.fromARGB(255, 105, 3, 3),
                        fontSize: 45,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'your recipes bank!',
                      style: GoogleFonts.lora(
                        color: Color.fromARGB(255, 105, 3, 3),
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () => setState(() {
                            isSearching = !isSearching;
                          }),
                          icon: Icon(
                            isSearching ? Icons.close : Icons.search,
                            color: const Color.fromARGB(255, 105, 3, 3),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
      body: Column(
        children: [
          // Dropdown untuk memilih huruf
          DropdownButton<String>(
            value: selectedLetter,
            items: List.generate(26, (index) {
              final letter = String.fromCharCode(97 + index); // a-z
              return DropdownMenuItem(
                value: letter,
                child: Text(letter.toUpperCase()),
              );
            }),
            onChanged: (value) {
              setState(() {
                selectedLetter = value!;
              });
              _fetchMeals(); // Memanggil data lagi setelah memilih huruf baru
            },
          ),
          Expanded(
            child: FutureBuilder<List<Meal>>(
              future: apiService
                  .fetchMealsByLetter(selectedLetter), // Memanggil API
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No meals found."));
                } else {
                  final meals = snapshot.data!;
                  final searchedMeals = searchController.text.isEmpty
                      ? meals
                      : meals
                          .where((meal) => meal.name
                              .toLowerCase()
                              .contains(searchController.text.toLowerCase()))
                          .toList();

                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 350,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 2,
                    ),
                    padding: const EdgeInsets.all(15),
                    itemCount: searchedMeals.length,
                    itemBuilder: (context, index) {
                      final meal = searchedMeals[index];
                      bool isHovered = false;

                      return StatefulBuilder(
                        builder: (context, setState) {
                          return MouseRegion(
                            onEnter: (_) => setState(() => isHovered = true),
                            onExit: (_) => setState(() => isHovered = false),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/detail',
                                    arguments: meal);
                              },
                              child: Card(
                                elevation: isHovered ? 6 : 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: isHovered
                                    ? Colors.pink.shade50
                                    : Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      // Tidak ada bagian favorite
                                      Text(
                                        meal.name,
                                        style: GoogleFonts.outfit(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
