import 'dart:convert';
import 'dart:developer';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:wellpage/pet/stylebook.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path_package;

class FormBooking extends StatefulWidget {
  @override
  _FormBookingState createState() => _FormBookingState();
}

class _FormBookingState extends State<FormBooking> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController petCountController = TextEditingController();
  final TextEditingController petTypeController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  bool isLoading = false;

  Future<void> _saveBooking() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final database = await openDatabase(
        path_package.join(await getDatabasesPath(), 'flutter_auth.db'),
      );

      await database.insert(
        'bookings',
        {
          'owner_name': nameController.text,
          'phone_number': phoneController.text,
          'pet_count': int.tryParse(petCountController.text) ?? 0,
          'pet_type': petTypeController.text,
          'notes': notesController.text,
          'booking_date': "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}",
          'booking_time': "${selectedTime.hour}:${selectedTime.minute}",
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking berhasil disimpan!')),
      );
      _resetForm();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _resetForm() {
    nameController.clear();
    phoneController.clear();
    petCountController.clear();
    petTypeController.clear();
    notesController.clear();
    setState(() {
      selectedDate = DateTime.now();
      selectedTime = TimeOfDay.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Layanan'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: Styless.appBarColor.withOpacity(0.8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pilih Tanggal & Waktu',
                            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                        SizedBox(height: 16),
                        CalendarTimeline(
                          initialDate: selectedDate,
                          firstDate: DateTime(DateTime.now().year, 1, 1), // Start from January of current year
                          lastDate: DateTime(DateTime.now().year, 12, 31), // End at December of current year
                          onDateSelected: (date) => setState(() => selectedDate = date),
                          monthColor: Colors.white,
                          dayColor: Colors.white,
                          activeDayColor: Colors.white,
                          activeBackgroundDayColor: Styless.highlightColor,
                          dotsColor: Colors.white,
                          locale: 'id',
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Waktu: ${selectedTime.hour}:${selectedTime.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            ElevatedButton.icon(
                              onPressed: () => _selectTime(context),
                              icon: Icon(Icons.access_time),
                              label: Text('Pilih Waktu'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Card(
                  color: Styless.appBarColor.withOpacity(0.8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Data Pemilik & Hewan',
                            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: nameController,
                          decoration: _inputDecoration('Nama Pemilik', Icons.person),
                          validator: (value) =>
                              value?.isEmpty ?? true ? 'Nama tidak boleh kosong' : null,
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          controller: phoneController,
                          decoration: _inputDecoration('No. HP', Icons.phone),
                          keyboardType: TextInputType.phone,
                          validator: (value) =>
                              value?.isEmpty ?? true ? 'No. HP tidak boleh kosong' : null,
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          controller: petCountController,
                          decoration: _inputDecoration('Jumlah Hewan', Icons.pets),
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              value?.isEmpty ?? true ? 'Jumlah hewan tidak boleh kosong' : null,
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          controller: petTypeController,
                          decoration: _inputDecoration('Jenis Hewan', Icons.category),
                          validator: (value) =>
                              value?.isEmpty ?? true ? 'Jenis hewan tidak boleh kosong' : null,
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          controller: notesController,
                          decoration: _inputDecoration('Catatan Tambahan', Icons.note),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _saveBooking,
                    child: isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('Selesaikan Pemesanan',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.white70),
      filled: true,
      fillColor: Colors.black12,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Styless.highlightColor,
              onPrimary: Colors.white,
              surface: Styless.appBarColor,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedTime) {
      setState(() => selectedTime = picked);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    petCountController.dispose();
    petTypeController.dispose();
    notesController.dispose();
    super.dispose();
  }
}