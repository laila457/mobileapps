import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:wellpage/pet/detailbook.dart';
import 'package:wellpage/pet/navigator.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
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
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String? selectedPackage;
  String? animalType;

  // Controllers for TextFields
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  bool isLoading = false; // Loading indicator

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

  void _onDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
      log('Selected date: ${date.toString()}');
    });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.purple,
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            colorScheme: ColorScheme.light(primary: Colors.purple)
                .copyWith(secondary: Colors.purple),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        log('Selected time: ${picked.hour}:${picked.minute}');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor:  const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pilih Bulan',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[800]),
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
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[800]),
            ),
            CalendarTimeline(
              initialDate: selectedDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(Duration(days: 30)),
              onDateSelected: _onDateSelected,
              monthColor: Colors.black,
              dayColor: Colors.black,
              activeDayColor: Colors.white,
              activeBackgroundDayColor: Colors.purple[700],
              dotsColor: Colors.white.withOpacity(0.4),
              locale: 'en_ISO',
            ),
            SizedBox(height: 20),
            Text(
              'Tanggal Terpilih: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 20),
            Text('Pilih Waktu',
                style: TextStyle(fontSize: 18, color: Colors.black)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${selectedTime.hour}:${selectedTime.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                ElevatedButton(
                  onPressed: () => _selectTime(context),
                  child: Text('Pilih Waktu'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Data Pelanggan',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[800]),
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nama Pemilik',
                prefixIcon: Icon(Icons.person, color: Colors.purple[700]),
              ),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'No. HP',
                prefixIcon: Icon(Icons.phone, color: Colors.purple[700]),
              ),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Alamat',
                prefixIcon: Icon(Icons.map, color: Colors.purple[700]),
              ),
              onChanged: (value) {
                setState(() {
                  // No need to set name again; consider removing this
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
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[800]),
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
              onPressed: () async {   runApp(MyApp());
                if (isLoading) return; // Prevent multiple clicks
                setState(() {
                  isLoading = true; // Set loading to true
                });

                // Validate input fields
                if (nameController.text.isNotEmpty &&
                    phoneController.text.isNotEmpty &&
                    selectedMonth != null &&
                    selectedDate != null &&
                    animalType != null &&
                    selectedPackage != null) {
                  try {
                    // Save booking to Firestore
                    await FirebaseFirestore.instance
                        .collection('bookings')
                        .add({
                      'name': nameController.text,
                      'phone': phoneController.text,
                      'month': selectedMonth,
                      'date': selectedDate.toIso8601String(),
                      'time': '${selectedTime.hour}:${selectedTime.minute}',
                      'animalType': animalType,
                      'package': selectedPackage,
                    });

                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Booking created successfully!'),
                    ));

                    // Navigate to BookingHistory
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BookingHistory()),
                    );
                  } catch (error) {
                    // Show error message if booking creation failed
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Error: ${error.toString()}'),
                    ));
                  }
                } else {
                  // Show error message if fields are not filled
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Please fill all fields!'),
                  ));
                }

                setState(() {
                  isLoading = false; // Set loading to false after processing
                });
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.purple[700],
              ),
              child: isLoading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                  : Text('Selesaikan Pemesanan'),
            ),
          ],
        ),
      ),
    );
  }
}
