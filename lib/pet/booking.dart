import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Booking Form',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: BookingPage(),
    );
  }
}

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String? selectedMonth;
  DateTime? selectedDate;
  String? selectedPackage;
  String? name;
  String? phone;
  String? animalType;

  List<String> months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  List<String> packages = [
    'Basic - 59k',
    'Kutu - Jamur - 70k',
    'Full - 86k',
  ];

  List<String> animalTypes = [
    'Anjing',
    'Kucing',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🐾 Booking Form'),
        backgroundColor: Colors.purple[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pilih Bulan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple[800]),
            ),
            DropdownButton<String>(
              hint: Text('Select Month'),
              value: selectedMonth,
              onChanged: (String? newValue) {
                setState(() {
                  selectedMonth = newValue;
                });
              },
              items: months.map<DropdownMenuItem<String>>((String month) {
                return DropdownMenuItem<String>(
                  value: month,
                  child: Text(month),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            Text(
              'Pilih Tanggal',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple[800]),
            ),
            CalendarDatePicker(
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(Duration(days: 30)),
              onDateChanged: (DateTime date) {
                setState(() {
                  selectedDate = date;
                });
              },
            ),
            SizedBox(height: 16),
            Text(
              'Data Pelanggan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple[800]),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Nama Pemilik',
                prefixIcon: Icon(Icons.person, color: Colors.purple[700]),
              ),
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'No. HP',
                prefixIcon: Icon(Icons.phone, color: Colors.purple[700]),
              ),
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                setState(() {
                  phone = value;
                });
              },
            ),
            DropdownButton<String>(
              hint: Text('Jenis Hewan'),
              value: animalType,
              onChanged: (String? newValue) {
                setState(() {
                  animalType = newValue;
                });
              },
              items: animalTypes.map<DropdownMenuItem<String>>((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            Text(
              'Pilih Paket',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple[800]),
            ),
            DropdownButton<String>(
              hint: Text('Select Package'),
              value: selectedPackage,
              onChanged: (String? newValue) {
                setState(() {
                  selectedPackage = newValue;
                });
              },
              items: packages.map<DropdownMenuItem<String>>((String package) {
                return DropdownMenuItem<String>(
                  value: package,
                  child: Text(package),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle the booking submission
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Pesanan Diterima'),
                      content: Text('Terima kasih, $name! Booking Anda sudah diterima.'),
                      actions: [
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.purple[700],
              ),
              child: Text('Selesaikan Pemesanan'),
            ),
          ],
        ),
      ),
    );
  }
}