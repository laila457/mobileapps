import 'package:flutter/material.dart';
import 'package:wellpage/pet/penitipan.dart';
import 'package:wellpage/pet/penjualan.dart';

void main() {
  runApp(MaterialApp(
    title: 'Happy Paws',
    theme: ThemeData(
      primarySwatch: Colors.purple,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 16),
        bodyMedium: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 14),
      ),
    ),
    home: Dashboard(),
  ));
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Happy Paws'),
        backgroundColor: Colors.purple[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Setiap hewan memiliki kebutuhan unik, itulah mengapa Happy Paws hadir untuk memberikan pengalaman perawatan yang menyenangkan bagi hewan kesayangan Anda.',
              style: TextStyle(fontSize: 16, color: Colors.purple[900]),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ServiceCard(
                  title: 'Grooming',
                  icon: Icons.pets,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Penjualan()),
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
            const SizedBox(height: 30),
            Text(
              'Yang dikatakan pelanggan kami',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple[800]),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 100, // Set a height for the RatingCard container
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(4, (index) => RatingCard()), // Generate 4 RatingCards
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Jam Operasional: 09.00 - 21.00',
              style: TextStyle(fontSize: 16, color: Colors.purple[600]),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[800],
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

class RatingCard extends StatelessWidget {
  const RatingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(right: 10.0), // Add space between cards
      decoration: BoxDecoration(
        color: Colors.purple[200],
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.purple[500]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.star, color: Colors.amber),
              Icon(Icons.star, color: Colors.amber),
              Icon(Icons.star, color: Colors.amber),
              Icon(Icons.star, color: Colors.amber),
              Icon(Icons.star_border, color: Colors.amber),
            ],
          ),
          const SizedBox(height: 8),
          Text('“Pelayanan yang sangat baik dan ramah!”', style: TextStyle(color: Colors.purple[700])),
        ],
      ),
    );
  }
}