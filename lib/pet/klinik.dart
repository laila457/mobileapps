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
              'https://media.istockphoto.com/id/1171733307/id/foto/dokter-hewan-dengan-anjing-dan-kucing-anak-anjing-dan-anak-kucing-di-dokter.jpg?s=612x612&w=0&k=20&c=Nr5k3BsjXldM0Lw7u8DFhYbm2hN6VrE0ENG0liZkb5k=', // Ganti dengan URL gambar klinik
               fit: BoxFit.cover, // Agar gambar menutupi seluruh area yang tersedia
              width: double.infinity,
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