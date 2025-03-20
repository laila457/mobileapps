import 'package:flutter/material.dart';
import 'package:wellpage/pet/dasboard.dart';
import 'package:wellpage/pet/grooming2.dart';
import 'package:wellpage/pet/penitipan.dart';
import 'package:wellpage/pet/formbook2.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Layanan1(name: null,),
    );
  }
}

class Layanan1 extends StatelessWidget {
  const Layanan1({super.key, required name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Layanan Happy Paws'),
        backgroundColor: Colors.purple[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              'Syarat & Ketentuan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple[800]),
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
                  MaterialPageRoute(builder: (context) => BookingForm()),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 185, 119, 226)),
              child: const Text('Pesan Sekarang'),
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
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: Colors.purple[800]),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}