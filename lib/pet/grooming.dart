import 'package:flutter/material.dart';

class GroomingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Grooming')),
      body: Column(
        children: [
          Expanded(
            child: Image.network(
              'https://media.istockphoto.com/id/1399034825/id/foto/seekor-kucing-putih-lucu-dengan-mantel-kuning-terlihat-keluar-dari-cangkang-putih-bebek-karet.jpg?s=612x612&w=0&k=20&c=Wj3dnHLtyIlpQI9L_OJT0owYp9Espof1yaDtN4ty2PA=', // Ganti dengan URL gambar grooming
              fit: BoxFit.cover, // Agar gambar menutupi seluruh area yang tersedia
              width: double.infinity, // Lebar gambar menyesuaikan lebar layar
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
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
        ],
      ),
    );
  }
}