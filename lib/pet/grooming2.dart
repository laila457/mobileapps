import 'package:flutter/material.dart';
import 'dasboard.dart';

class GroomingsPage extends StatelessWidget {
  const GroomingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grooming'),
        backgroundColor: Colors.purple[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'List Paket & Harga',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.purple[800]),
            ),
            const SizedBox(height: 20),
            DataTable(
              columns: const [
                DataColumn(label: Text('Paket', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Harga', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Detail', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: const [
                DataRow(cells: [
                  DataCell(Text('Basic')),
                  DataCell(Text('Rp 59.000')),
                  DataCell(Text('Perawatan Basik')),
                ]),
                DataRow(cells: [
                  DataCell(Text('Kutu - Jamur')),
                  DataCell(Text('Rp 70.000')),
                  DataCell(Text('Perawatan Kutu & Jamur')),
                ]),
                DataRow(cells: [
                  DataCell(Text('Full Treatment')),
                  DataCell(Text('Rp 100.000')),
                  DataCell(Text('Perawatan Lengkap')),
                ]),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              '“Layanan Grooming kucing di Shiroo Petshop memastikan kucingmu tetap bersih dan wangi! Dengan tenaga profesional dan produk terbaik, kami menjamin pengalaman grooming terbaik untuk hewan kesayangan.”',
              style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Dash()),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 185, 119, 226)),
              child: Text('Pesan Sekarang'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Layanan'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Booking'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Akun'),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.purple[300],
        onTap: (index) {
          // Handle navigation
        },
      ),
    );
  }
}