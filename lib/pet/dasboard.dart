import 'package:flutter/material.dart';
import 'package:wellpage/controllers/login_screen.dart';
import 'package:wellpage/pet/formbooking.dart';
import 'package:wellpage/pet/layanantrue.dart';
import 'package:wellpage/pet/profile.dart';
import 'package:wellpage/screen/welcome.dart';
import 'package:wellpage/pet/formbooking.dart'; // Import the GroomingPage
import 'package:wellpage/pet/bookpenitipan.dart'; // Import the BookingScreen

void main() {
  runApp(MaterialApp(
    title: 'Happy Paws',
    theme: ThemeData(
      primarySwatch: Colors.deepPurple,
      scaffoldBackgroundColor: Colors.white,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 16),
        bodyMedium: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 14),
      ),
    ),
    home: Dash(),
  ));
}

class Dash extends StatefulWidget {
  const Dash({super.key});

  @override
  _DashState createState() => _DashState();
}

class _DashState extends State<Dash> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(
          index); // Use jumpToPage instead of animateToPage for instant switch
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.purple[300],
      ),
      body: PageView(
        controller: _pageController,
        physics:
            const NeverScrollableScrollPhysics(), // Disable swipe to change pages
        children: [
          _buildHomePage(context), // Home Page
          Layanan1(), // Replace with your actual ChatPage widget
          FormBooking(), // Replace with your actual NewPostPage widget
          HomeScreens(),//ual Signin widget
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
            label: 'Layanan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_library),
            label: 'Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.purple[800], //warna icon saat dipilih
        unselectedItemColor: Colors.purple[200],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget _buildHomePage(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  'Layanan Kami',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Pilih layanan terbaik untuk hewan kesayangan Anda',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: ServiceCard(
                    title: 'Grooming',
                    subtitle: 'Mulai dari Rp 60.000',
                    imagePath: 'assets/images/catlist.png',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FormBooking()),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ServiceCard(
                    title: 'Penitipan',
                    subtitle: 'Mulai dari Rp 50.000/hari',
                    imagePath: 'assets/images/penitipan.png',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BookingScreen()),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ServiceCard(
              title: 'Antar Jemput',
              subtitle: 'Tersedia untuk area tertentu',
              imagePath: 'assets/images/delivery.png',
              isWide: true,
              onTap: () {
                // Handle antar jemput
              },
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Syarat dan Ketentuan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                RequirementItem(
                  text: 'Hewan harus dalam kondisi sehat dan tidak agresif',
                ),
                RequirementItem(
                  text: 'Tidak menerima hewan dengan penyakit menular',
                ),
                RequirementItem(
                  text: 'Jika hewan sulit dikendalikan, biaya tambahan dapat dikenakan',
                ),
                RequirementItem(
                  text: 'Pembatalan kurang dari 24 jam sebelum jadwal tidak bisa refund',
                ),
                RequirementItem(
                  text: 'Untuk layanan penitipan, hewan wajib sudah divaksin',
                ),
                RequirementItem(
                  text: 'Layanan antar jemput hanya tersedia di area tertentu',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FormBooking()),
                    ),
                    icon: const Icon(Icons.pets),
                    label: const Text('Pesan Grooming'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 239, 149, 255),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BookingScreen()),
                    ),
                    icon: const Icon(Icons.home),
                    label: const Text('Pesan Penitipan'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 239, 149, 255),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final VoidCallback onTap;
  final bool isWide;

  const ServiceCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.onTap,
    this.isWide = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                imagePath,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: onTap,
                    child: const Text('Book Now'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[400],
                      minimumSize: const Size(double.infinity, 36),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RequirementItem extends StatelessWidget {
  final String text;

  const RequirementItem({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.purple[400], size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
