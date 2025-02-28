import 'package:flutter/material.dart';
import 'package:wellpage/pet/adopted.dart';
import 'package:wellpage/pet/klinik.dart';
import 'package:wellpage/pet/grooming.dart';
import 'package:wellpage/pet/penitipan.dart';
import 'package:wellpage/pet/pacakkucing.dart';
import 'package:wellpage/pet/penjualan.dart';

class Beranda extends StatelessWidget {
  const Beranda({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Amazon Pet'),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {}),
        ],
      ),
      
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 0, 213, 125),
              ),
            ),
            ListTile(
              title: Text('Klinik Hewan'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => KlinikHewanPage()),
                );
              },
            ),
            ListTile(
              title: Text('Grooming'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => GroomingPage()),
                );
              },
            ),
            ListTile(
              title: Text('Penitipan'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => PenitipanPage()),
                );
              },
            ),
            ListTile(
              title: Text('Pacak Kucing'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => PacakKucingPage()),
                );
              },
            ),
                        ListTile(
              title: Text('Adopsi Hewan'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Adopted()),
                );
              },
            ),
            ListTile(
              title: Text('Penjualan'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => PenjualanPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/pet-shop%2C-poster-design-template-95aae2fd84664bc617c690a903fd4d11_screen.jpg?ts=1680656993',
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat Datang di Amazon Pet',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Kami menyediakan berbagai produk terbaik untuk hewan peliharaan Anda.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Produk Unggulan',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  ProductCard(title: 'Makanan Kucing', price: 'Rp 100.000'),
                  ProductCard(title: 'Mainan Anjing', price: 'Rp 50.000'),
                  ProductCard(title: 'Kandang Kucing', price: 'Rp 300.000'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String title;
  final String price;

  ProductCard({required this.title, required this.price});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              price,
              style: TextStyle(fontSize: 16, color: Colors.green),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // Aksi untuk menambah ke keranjang
              },
              child: Text('Tambah ke Keranjang'),
            ),
          ],
        ),
      ),
    );
  }
}