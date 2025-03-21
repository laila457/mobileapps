import 'dart:developer';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:wellpage/pet/stylebook.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pilih Layanan',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Styless.backgroundColor, // Apply background color
        appBarTheme: AppBarTheme(
          backgroundColor: Styless.appBarColor, // Apply app bar color
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Styless.buttonColor, // Apply button color
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Styless.highlightColor, // Apply cursor color
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Styless.highlightColor),
          ),
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.white), // Apply text color
          bodyLarge: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
        ),
      ),
      home: FormBook(),
    );
  }
}

class FormBook extends StatefulWidget {
  @override
  _FormBookState createState() => _FormBookState();
}

class _FormBookState extends State<FormBook> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  void _onDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
      log(date.toString());
    });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Styless.highlightColor, // Apply highlight color to time picker
              onPrimary: Colors.white,
              surface: Styless.appBarColor,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Styless.backgroundColor,
          ),
          child: child!,
        );
      },
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pilih Tanggal', style: TextStyle(fontSize: 18, color: Colors.white)),
            Center(
              child: CalendarTimeline(
                initialDate: selectedDate,
                firstDate: DateTime(2019, 1, 15),
                lastDate: DateTime.now(),
                onDateSelected: _onDateSelected,
                monthColor: Colors.white, // Set month color to white
                dayColor: Colors.white, // Set day color to white
                activeDayColor: Colors.white,
                activeBackgroundDayColor: Colors.transparent,
                dotsColor: Colors.white.withOpacity(0.4),
                selectableDayPredicate: (date) => date.day != 23,
                locale: 'en_ISO',
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Tanggal Terpilih: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(height: 20),
            Text('Pilih Waktu', style: TextStyle(fontSize: 18, color: Colors.white)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${selectedTime.hour}:${selectedTime.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                ElevatedButton(
                  onPressed: () => _selectTime(context),
                  child: Text('Pilih Waktu'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Data pelanggan yang harus diisi!', style: TextStyle(fontSize: 18, color: Colors.white)),
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