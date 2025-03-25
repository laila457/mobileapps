import 'package:flutter/material.dart';
import '../controllers/auth_booking.dart';

class BookingPage extends StatelessWidget {
  final AuthBookingController authBookingController = AuthBookingController();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  // Tambahkan controller untuk bulan, tanggal, waktu, jenis hewan, dan paket

  void createBooking() async {
    String name = nameController.text;
    String phone = phoneController.text;
    // Ambil nilai dari controller lain
    String month = "April"; // Ganti dengan input yang sesuai
    String date = "2025-04-01"; // Ganti dengan input yang sesuai
    String time = "10:00"; // Ganti dengan input yang sesuai
    String animalType = "Kucing"; // Ganti dengan input yang sesuai
    String package = "Basic - 59k"; // Ganti dengan input yang sesuai

    final result = await authBookingController.createBooking(
      name,
      phone,
      month,
      date,
      time,
      animalType,
      package,
    );

    // Tampilkan hasil
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Booking')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nama Pemilik'),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'No. HP'),
              keyboardType: TextInputType.phone,
            ),
            // Tambahkan TextField lainnya sesuai kebutuhan
            ElevatedButton(
              onPressed: createBooking,
              child: Text('Selesaikan Pemesanan'),
            ),
          ],
        ),
      ),
    );
  }
}