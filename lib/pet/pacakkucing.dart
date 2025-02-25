import 'package:flutter/material.dart';

class PacakKucingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pacak Kucing')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://example.com/cat_sitting_image.png', // Ganti dengan URL gambar kucing
              height: 200,
            ),
            SizedBox(height: 16),
            Text(
              'Pacak Kucing yang Lucu!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.orange),
            ),
            SizedBox(height: 8),
            Text(
              'Temukan kucing-kucing menggemaskan di sini!',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}