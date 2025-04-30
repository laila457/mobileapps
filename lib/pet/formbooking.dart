import 'dart:convert';
import 'dart:developer';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:wellpage/pet/stylebook.dart';
import 'package:http/http.dart' as http;
import 'package:wellpage/models/booking_model.dart';
import 'package:wellpage/controllers/booking_controller.dart';

class FormBooking extends StatefulWidget {
  @override
  _FormBookingState createState() => _FormBookingState();
}

class _FormBookingState extends State<FormBooking> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String selectedPetType = 'Kucing';
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController petCountController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    await BookingController.initDatabase();
  }

  Future<void> _saveBooking() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    try {
      // Create a booking model
      BookingModel booking = BookingModel(
        ownerName: nameController.text,
        phoneNumber: phoneController.text,
        petCount: int.tryParse(petCountController.text) ?? 0,
        petType: selectedPetType,
        notes: notesController.text,
        bookingDate: selectedDate.toString().split(' ')[0],
        bookingTime: '${selectedTime.hour}:${selectedTime.minute.toString().padLeft(2, '0')}',
      );

      final success = await BookingController.saveBooking(booking);
      
      if (!mounted) return;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking berhasil disimpan!')),
        );
        _resetForm();
      } else {
        throw Exception('Gagal menyimpan booking');
      }
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
    notesController.clear();
    setState(() {
      selectedDate = DateTime.now();
      selectedTime = TimeOfDay.now();
      selectedPetType = 'Kucing';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Grooming'),
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
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 16),
                        CalendarTimeline(
                          initialDate: selectedDate,
                          firstDate: DateTime(DateTime.now().year, 1, 1),
                          lastDate: DateTime(DateTime.now().year, 12, 31),
                          onDateSelected: (date) =>
                              setState(() => selectedDate = date),
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
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
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
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: nameController,
                          decoration:
                              _inputDecoration('Nama Pemilik', Icons.person),
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Nama tidak boleh kosong'
                              : null,
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          controller: phoneController,
                          decoration: _inputDecoration('No. HP', Icons.phone),
                          keyboardType: TextInputType.phone,
                          validator: (value) => value?.isEmpty ?? true
                              ? 'No. HP tidak boleh kosong'
                              : null,
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          controller: petCountController,
                          decoration:
                              _inputDecoration('Jumlah Hewan', Icons.pets),
                          keyboardType: TextInputType.number,
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Jumlah hewan tidak boleh kosong'
                              : null,
                        ),
                        SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: selectedPetType,
                          decoration:
                              _inputDecoration('Jenis Hewan', Icons.category),
                          items: [
                            DropdownMenuItem(
                                value: 'Kucing', child: Text('Kucing')),
                            DropdownMenuItem(
                                value: 'Anjing', child: Text('Anjing')),
                            DropdownMenuItem(
                                value: 'Burung', child: Text('Burung')),
                            DropdownMenuItem(
                                value: 'Reptil', child: Text('Reptil')),
                            DropdownMenuItem(
                                value: 'Kelinci', child: Text('Kelinci')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              selectedPetType = value!;
                            });
                          },
                          validator: (value) => value == null
                              ? 'Jenis hewan tidak boleh kosong'
                              : null,
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          controller: notesController,
                          decoration:
                              _inputDecoration('Catatan Tambahan', Icons.note),
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
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
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
    notesController.dispose();
    super.dispose();
  }
}