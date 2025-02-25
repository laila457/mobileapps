import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Karir',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CareerPage(),
    );
  }
}

class CareerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Karir'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bergabunglah dengan Kami',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Kami mencari individu yang berbakat dan berdedikasi untuk bergabung dengan tim kami. Di sini, Anda akan menemukan lingkungan kerja yang mendukung dan penuh peluang.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),
              Text(
                'Posisi Tersedia',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              JobCard(title: 'Software Engineer', description: 'Bertanggung jawab untuk pengembangan aplikasi.'),
              JobCard(title: 'UI/UX Designer', description: 'Mendesain antarmuka pengguna yang menarik.'),
              JobCard(title: 'Product Manager', description: 'Mengelola pengembangan produk dari awal hingga akhir.'),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Aksi untuk melamar pekerjaan
                },
                child: Text('Lamar Sekarang'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class JobCard extends StatelessWidget {
  final String title;
  final String description;

  JobCard({required this.title, required this.description});

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
              description,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}