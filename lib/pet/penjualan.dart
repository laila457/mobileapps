import 'package:flutter/material.dart';

class PenjualanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Penjualan')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://example.com/sale_image.png', // Ganti dengan URL gambar penjualan
              height: 200,
            ),
            SizedBox(height: 16),
            Text(
              'Penjualan Terbaik!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            SizedBox(height: 8),
            Text(
              'Dapatkan produk hewan peliharaan dengan harga terbaik!',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}