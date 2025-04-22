import 'package:flutter/material.dart';
import 'package:wellpage/controllers/login_screen.dart';
import 'package:wellpage/pet/formbooking.dart';
import 'package:wellpage/pet/layanantrue.dart';
import 'package:wellpage/pet/profile.dart';
import 'package:wellpage/screen/welcome.dart';
import 'grooming2.dart'; // Import the GroomingPage
import 'penitipan2.dart'; // Import the PenitipanPage

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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Welcome To Happy Paws',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold, // Make text bold
                color: const Color.fromARGB(255, 4, 4, 4),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Add the image asset below the welcome text
          Center(
            child: Image.asset(
              '../assets/images/dash.png',
              width: 200,// a smaller width
              height: 200,//et a smaller height
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              hintText: 'Telusuri...',
              prefixIcon: Icon(Icons.search, color: Colors.purple[300]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.purple[300]!),
              ),
            ),
          ),
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
                title: 'Layanan',
                icon: Icons.house,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Layanan1()),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Booking Anda',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.purple[800]),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: [
                BookingCard(
                  title: 'Grooming - Paket Basic',
                  date: 'Selasa, 2 Feb 2025',
                  time: '14.00 - 15.00',
                  price: 'Rp 60.000 - QRIS',
                  pets: 'Milo - Kucing Persia Max - Golden',
                ),
                BookingCard(
                  title: 'Grooming - Paket Basic',
                  date: 'Selasa, 2 Feb 2025',
                  time: '14.00 - 15.00',
                  price: 'Rp 60.000 - QRIS',
                  pets: 'Milo - Kucing Persia Max - Golden',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FormBooking()),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 251, 182, 232)),
            child: const Text('Pesan Sekarang'),
          ),
        ],
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const ServiceCard(
      {super.key,
      required this.title,
      required this.icon,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: 180,
        decoration: BoxDecoration(
          color: Colors.purple[300],
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final String title;
  final String date;
  final String time;
  final String price;
  final String pets;

  const BookingCard(
      {super.key,
      required this.title,
      required this.date,
      required this.time,
      required this.price,
      required this.pets});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(date),
            Text(time),
            const SizedBox(height: 10),
            Text(price, style: TextStyle(color: Colors.purple[800])),
            const SizedBox(height: 5),
            Text(pets, style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}
