import 'package:flutter/material.dart';

class KlinikHewanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Klinik Hewan')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://example.com/clinic_image.png', // Ganti dengan URL gambar klinik
              height: 200,
            ),
            SizedBox(height: 16),
            Text(
              'Klinik Hewan Terbaik!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            SizedBox(height: 8),
            Text(
              'Kami siap merawat hewan peliharaanmu!',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}