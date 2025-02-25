import 'package:flutter/material.dart';

class GroomingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Grooming')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://example.com/grooming_image.png', // Ganti dengan URL gambar grooming
              height: 200,
            ),
            SizedBox(height: 16),
            Text(
              'Waktunya Grooming!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            SizedBox(height: 8),
            Text(
              'Buat hewan peliharaanmu terlihat lebih menawan!',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}