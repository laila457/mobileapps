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

  final List<String> kecamatanList = ['Telukjambe Timur'];
  final List<String> desaList = ['Sukaharja', 'Pinayungan', 'Puseurjaya'];

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
        // Convert paket_grooming to match enum values
        String dbPaketGrooming = '';
        switch (paketGrooming) {
          case 'Basic':
            dbPaketGrooming = 'basic';
            break;
          case 'Kutu & Jamur':
            dbPaketGrooming = 'kutu';
            break;
          case 'Full Grooming':
            dbPaketGrooming = 'full';
            break;
        }

        // Convert pengantaran to match enum values
        String dbPengantaran = pengantaran == 'Antar Jemput' ? 'antar' : 'jemput';

        final response = await http.post(
          Uri.parse('http://localhost/mobileapps/create.php'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'user_id': null, // This should be set from login session
            'tanggal_grooming': DateFormat('yyyy-MM-dd').format(selectedDate),
            'waktu_booking': '${selectedTime.hour}:${selectedTime.minute}:00',
            'nama_pemilik': namaPemilikController.text,
            'no_hp': noHpController.text,
            'jenis_hewan': jenisHewan,
            'paket_grooming': dbPaketGrooming,
            'pengantaran': dbPengantaran,
            'kecamatan': pengantaran == 'Antar Jemput' ? kecamatan : null,
            'desa': pengantaran == 'Antar Jemput' ? desa : null,
            'detail_alamat': pengantaran == 'Antar Jemput' ? alamatController.text : null,
            'total_harga': _calculatePrice(),
            'metode_pembayaran': 'pending',
            'status': 'pending'
          }),
        );

        if (response.statusCode == 200) {
          final result = jsonDecode(response.body);
          if (result['success']) {
            // Enhanced notification
            NotificationService.showNotification(
              title: '✨ Booking Grooming Berhasil!',
              body: 'Hai, booking grooming untuk ${jenisHewan}mu sudah terjadwal.\n'
                   '📅 Tanggal: ${DateFormat('dd/MM/yyyy').format(selectedDate)}\n'
                   '⏰ Waktu: ${selectedTime.format(context)}\n'
                   '💅 Paket: $paketGrooming',
            );
            
            if (mounted) {
              // Show success snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.check_circle, color: Colors.white),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Booking Berhasil!',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Total Pembayaran: Rp ${_calculatePrice().toStringAsFixed(0)}',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 4),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: EdgeInsets.all(16),
                ),
              );

              // Continue with navigation...
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
      elevation: 0,
   backgroundColor: Colors.purple[300],    ),
    body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color.fromARGB(255, 243, 173, 255).withOpacity(0.1), // Light purple at the top
            Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Informasi Pemilik',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: namaPemilikController,
                          decoration: InputDecoration(
                            labelText: 'Nama Pemilik',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: const Icon(Icons.person),
                          ),
                          validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: noHpController,
                          decoration: InputDecoration(
                            labelText: 'Nomor HP',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: const Icon(Icons.phone),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Wajib diisi';
                            }
                            if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                              return 'Nomor HP hanya boleh berisi angka';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Jadwal Grooming',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        ListTile(
                          leading: const Icon(Icons.calendar_today),
                          title: Text('Tanggal: ${DateFormat('dd/MM/yyyy').format(selectedDate)}'),
                          onTap: () => _selectDate(context),
                        ),
                        ListTile(
                          leading: const Icon(Icons.access_time),
                          title: Text('Waktu: ${selectedTime.format(context)}'),
                          onTap: () => _selectTime(context),
                        ),
                      ],
                    ),
                  ),
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
                const Text('Pengantaran (Free pengantaran daerah Telukjambe Timur)'),
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
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Booking Sekarang',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}