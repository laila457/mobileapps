import 'package:flutter/material.dart';
import 'grooming2.dart'; // Import the GroomingPage
import 'penitipan.dart'; // Import the PenitipanPage

void main() {
  runApp(MaterialApp(
    title: 'Happy Paws',
    theme: ThemeData(
      primarySwatch: Colors.purple,
      scaffoldBackgroundColor: Colors.white,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 16),
        bodyMedium: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 14),
      ),
    ),
    home: Dash(),
  ));
}

class Dash extends StatelessWidget {
  const Dash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Happy Paws'),
        backgroundColor: Colors.purple[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'memberikan pengalaman yang menyenangkan dan bebas stres hewan kesayangan.',
              style: TextStyle(fontSize: 16, color: Colors.purple[800]),
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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple[800]),
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
                      MaterialPageRoute(builder: (context) => const PenitipanPage()),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Booking Anda',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple[800]),
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
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[300],
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text('Pesan Sekarang'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const ServiceCard({super.key, required this.title, required this.icon, required this.onTap});

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
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
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

  const BookingCard({super.key, required this.title, required this.date, required this.time, required this.price, required this.pets});

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