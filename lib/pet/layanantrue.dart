import 'package:flutter/material.dart';
import 'package:wellpage/pet/booking.dart';
import 'package:wellpage/pet/dasboard.dart';
import 'package:wellpage/pet/grooming2.dart';
import 'package:wellpage/pet/penitipan.dart';
import 'package:wellpage/pet/formbook2.dart';
import 'package:wellpage/pet/profile.dart';
import 'package:wellpage/pet/stylebook.dart';
import 'package:wellpage/screen/welcome.dart';
import 'package:wellpage/widgets/welcome_button.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pilih Layanan',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor:
            Styless.backgroundColor, // Apply background color
        appBarTheme: AppBarTheme(
          backgroundColor: Styless.appBarColor, // Apply app bar color
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Styless.buttonColor, // Apply button color
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Styless.highlightColor, // Apply cursor color
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Styless.highlightColor),
          ),
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.white), // Apply text color
          bodyLarge: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
        ),
      ),
      home: Layanan1(),
    );
  }
}

class Layanantrue extends StatefulWidget {
  @override
  _LayanantrueState createState() => _LayanantrueState();
}

class _LayanantrueState extends State<Layanantrue> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 158, 232),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Layanan1(), // First Page
          BookingPage(), // Replace with your actual ChatPage widget
          PenitipanPage(), // Replace with your actual NewPostPage widget
          HomeScreens()//eplace with your actual Signin widget
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_library),
            label: 'Penitipan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.purple[300],
      ),
    );
  }
}

// Layanan1 class as defined previously
class Layanan1 extends StatelessWidget {
  final String? name;

  const Layanan1({super.key, this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Layanan Happy Paws'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Layanan',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[800]),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ServiceCard(
                  title: 'Grooming',
                  icon: Icons.pets,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GroomingsPage()),
                    );
                  },
                ),
                ServiceCard(
                  title: 'Penitipan',
                  icon: Icons.house,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PenitipanPage()),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Syarat & Ketentuan',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[800]),
            ),
            const SizedBox(height: 10),
            const Text(
              '🔊 Hewan harus dalam kondisi sehat dan tidak agresif.\n'
              '🔊 Tidak menerima hewan dengan penyakit menular.\n'
              '🔊 Jika hewan tidak diambil, pemanggilan akan dilakukan.\n'
              '🔊 Pembatalan kurang dari 24 jam sebelum jadwal tidak dapat dilakukan.\n'
              '🔊 Untuk layanan penitipan, hewan harus dijadwalkan 1 minggu sebelumnya.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookingPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 251, 182, 232)),
              child: const Text('Pesan Sekarang'),
            ),
          ],
        ),
      ),
    );
  }
}
