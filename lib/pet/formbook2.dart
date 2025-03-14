import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pilih Layanan',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: Bookingform(),
    );
  }
}

class Bookingform extends StatefulWidget {
  @override
  _BookingformState createState() => _BookingformState();
}

class _BookingformState extends State<Bookingform> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(), // Mengizinkan pemilihan tanggal mulai dari hari ini
      lastDate: DateTime.now().add(Duration(days: 730)), // Mengizinkan pemilihan hingga 2 tahun ke depan
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(), // Tema terang untuk pemilih tanggal
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Layanan'),
        backgroundColor: Colors.grey[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pilih Tanggal', style: TextStyle(fontSize: 18)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                  style: TextStyle(fontSize: 16),
                ),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text('Pilih Tanggal'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Pilih Waktu', style: TextStyle(fontSize: 18)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${selectedTime.hour}:${selectedTime.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(fontSize: 16),
                ),
                ElevatedButton(
                  onPressed: () => _selectTime(context),
                  child: Text('Pilih Waktu'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Data pelanggan yang harus diisi!'),
            TextField(
              decoration: InputDecoration(labelText: 'Nama Pemilik'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'No. Hp'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Total Hewan'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Jenis Hewan'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Catatan'),
            ),
            // Add other input fields as needed...
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle button press
              },
              child: Text('Selesaikan Pemesanan'),
            ),
          ],
        ),
      ),
    );
  }
}