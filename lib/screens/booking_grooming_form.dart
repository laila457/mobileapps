import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:wellpage/screens/payment_screen.dart';
import 'dart:convert';
import '../services/notification_service.dart';

class BookingGroomingForm extends StatefulWidget {
  const BookingGroomingForm({super.key});

  @override
  State<BookingGroomingForm> createState() => _BookingGroomingFormState();
}

class _BookingGroomingFormState extends State<BookingGroomingForm> {
  final _formKey = GlobalKey<FormState>();
  final namaPemilikController = TextEditingController();
  final noHpController = TextEditingController();
  final alamatController = TextEditingController();
  
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String jenisHewan = '';
  String paketGrooming = '';
  String pengantaran = '';
  String kecamatan = '';
  String desa = '';

  final List<String> kecamatanList = ['Karawang Barat', 'Karawang Timur', 'Telukjambe'];
  final List<String> desaList = ['Adiarsa', 'Karawang', 'Telukjambe'];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  double _calculatePrice() {
    switch (paketGrooming) {
      case 'Basic':
        return 59000.00;
      case 'Kutu & Jamur':
        return 70000.00;
      case 'Full Grooming':
        return 86000.00;
      default:
        return 0.00;
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() &&
        jenisHewan.isNotEmpty &&
        paketGrooming.isNotEmpty &&
        pengantaran.isNotEmpty) {
      try {
        final response = await http.post(
          Uri.parse('http://localhost/mobileapps-1/create.php'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'tanggal_grooming': DateFormat('yyyy-MM-dd').format(selectedDate),
            'waktu_booking': '${selectedTime.hour}:${selectedTime.minute}:00',
            'nama_pemilik': namaPemilikController.text,
            'no_hp': noHpController.text,
            'jenis_hewan': jenisHewan,
            'paket_grooming': paketGrooming,
            'pengantaran': pengantaran,
            'kecamatan': pengantaran == 'Antar Jemput' ? kecamatan : '',
            'desa': pengantaran == 'Antar Jemput' ? desa : '',
            'detail_alamat': pengantaran == 'Antar Jemput' ? alamatController.text : '',
            'total_harga': _calculatePrice(),
            'metode_pembayaran': 'pending',
            'status_pembayaran': 'pending'
          }),
        );

        if (response.statusCode == 200) {
          final result = jsonDecode(response.body);
          if (result['success']) {
            NotificationService.showNotification(
              title: 'Booking Berhasil',
              body: 'Booking grooming telah berhasil dibuat',
            );
            
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentScreen(
                    bookingId: result['booking_id'].toString(),
                    amount: _calculatePrice(),
                  ),
                ),
              );
            }
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Grooming'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: namaPemilikController,
                decoration: const InputDecoration(
                  labelText: 'Nama Pemilik',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: noHpController,
                decoration: const InputDecoration(
                  labelText: 'Nomor HP',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              ListTile(
                title: Text('Tanggal: ${DateFormat('dd/MM/yyyy').format(selectedDate)}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              
              ListTile(
                title: Text('Waktu: ${selectedTime.format(context)}'),
                trailing: const Icon(Icons.access_time),
                onTap: () => _selectTime(context),
              ),

              const Text('Jenis Hewan'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['Anjing', 'Kucing'].map((type) => 
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                    child: ChoiceChip(
                      label: Text(type),
                      selected: jenisHewan == type,
                      onSelected: (selected) {
                        setState(() => jenisHewan = selected ? type : '');
                      },
                    ),
                  ),
                ).toList(),
              ),

              const SizedBox(height: 16),
              const Text('Paket Grooming'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('Basic\nRp 59.000'),
                    selected: paketGrooming == 'Basic',
                    onSelected: (selected) {
                      setState(() => paketGrooming = selected ? 'Basic' : '');
                    },
                  ),
                  ChoiceChip(
                    label: const Text('Kutu & Jamur\nRp 70.000'),
                    selected: paketGrooming == 'Kutu & Jamur',
                    onSelected: (selected) {
                      setState(() => paketGrooming = selected ? 'Kutu & Jamur' : '');
                    },
                  ),
                  ChoiceChip(
                    label: const Text('Full Grooming\nRp 86.000'),
                    selected: paketGrooming == 'Full Grooming',
                    onSelected: (selected) {
                      setState(() => paketGrooming = selected ? 'Full Grooming' : '');
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),
              const Text('Pengantaran'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['Datang ke Toko', 'Antar Jemput'].map((type) => 
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                    child: ChoiceChip(
                      label: Text(type),
                      selected: pengantaran == type,
                      onSelected: (selected) {
                        setState(() => pengantaran = selected ? type : '');
                      },
                    ),
                  ),
                ).toList(),
              ),

              if (pengantaran == 'Antar Jemput') ...[
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Kecamatan',
                    border: OutlineInputBorder(),
                  ),
                  value: kecamatan.isEmpty ? null : kecamatan,
                  items: kecamatanList.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() => kecamatan = newValue ?? '');
                  },
                ),

                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Desa',
                    border: OutlineInputBorder(),
                  ),
                  value: desa.isEmpty ? null : desa,
                  items: desaList.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() => desa = newValue ?? '');
                  },
                ),

                const SizedBox(height: 16),
                TextFormField(
                  controller: alamatController,
                  decoration: const InputDecoration(
                    labelText: 'Detail Alamat',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) => pengantaran == 'Antar Jemput' && value!.isEmpty 
                    ? 'Wajib diisi untuk antar jemput' : null,
                ),
              ],

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Booking Sekarang'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}