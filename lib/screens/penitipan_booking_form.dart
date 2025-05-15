import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/notification_service.dart';
import 'payment_penitipan_screen.dart';

class PenitipanBookingForm extends StatefulWidget {
  const PenitipanBookingForm({super.key});

  @override
  State<PenitipanBookingForm> createState() => _PenitipanBookingFormState();
}

class _PenitipanBookingFormState extends State<PenitipanBookingForm> {
  final _formKey = GlobalKey<FormState>();
  final namaPemilikController = TextEditingController();
  final noHpController = TextEditingController();
  final namaHewanController = TextEditingController();
  final alamatController = TextEditingController();
  final catatanController = TextEditingController();
  
  String? selectedJenisHewan;
  String? selectedPaket;
  String? selectedPengantaran;
  String? selectedKecamatan;
  String? selectedDesa;
  DateTime? checkInDate;
  DateTime? checkOutDate;

  final Map<String, double> paketHarga = {
    'Regular': 35000.0,
    'Premium': 50000.0,
  };

  double calculateTotalPrice() {
    if (checkInDate == null || checkOutDate == null || selectedPaket == null) {
      return 0.0;
    }
    final days = checkOutDate!.difference(checkInDate!).inDays;
    return days * paketHarga[selectedPaket]!;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && 
        selectedJenisHewan != null && 
        selectedPaket != null && 
        selectedPengantaran != null &&
        checkInDate != null &&
        checkOutDate != null) {
      
      final totalHarga = calculateTotalPrice();
      
      try {
        final response = await http.post(
          Uri.parse('http://localhost/mobileapps-1/create_penitipan.php'),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: {
            'check_in': DateFormat('yyyy-MM-dd').format(checkInDate!),
            'check_out': DateFormat('yyyy-MM-dd').format(checkOutDate!),
            'nama_pemilik': namaPemilikController.text,
            'no_hp': noHpController.text,
            'nama_hewan': namaHewanController.text,
            'jenis_hewan': selectedJenisHewan,
            'paket_penitipan': selectedPaket,
            'pengantaran': selectedPengantaran,
            'kecamatan': selectedPengantaran == 'Antar Jemput' ? selectedKecamatan : '',
            'desa': selectedPengantaran == 'Antar Jemput' ? selectedDesa : '',
            'detail_alamat': selectedPengantaran == 'Antar Jemput' ? alamatController.text : '',
            'catatan': catatanController.text,
            'total_harga': totalHarga.toString(),
            'metode_pembayaran': 'pending', // Empty string instead of 'pending'
          },
        );

        final result = jsonDecode(response.body);
        
        if (result['status'] == 'success' && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Reservasi berhasil dibuat')),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentPenitipanScreen(
                amount: totalHarga,
                bookingId: result['booking_id'].toString(),
              ),
            ),
          );
        } else {
          throw Exception(result['message']);
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
        title: const Text('Form Penitipan Hewan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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

              TextFormField(
                controller: namaHewanController,
                decoration: const InputDecoration(
                  labelText: 'Nama Hewan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Jenis Hewan',
                  border: OutlineInputBorder(),
                ),
                value: selectedJenisHewan,
                items: ['Anjing', 'Kucing'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => selectedJenisHewan = value);
                },
                validator: (value) => value == null ? 'Wajib dipilih' : null,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Paket Penitipan',
                  border: OutlineInputBorder(),
                ),
                value: selectedPaket,
                items: [
                  DropdownMenuItem(
                    value: 'Regular',
                    child: Text('Regular - Rp ${paketHarga['Regular']?.toStringAsFixed(0)}/hari'),
                  ),
                  DropdownMenuItem(
                    value: 'Premium',
                    child: Text('Premium - Rp ${paketHarga['Premium']?.toStringAsFixed(0)}/hari'),
                  ),
                ],
                onChanged: (value) {
                  setState(() => selectedPaket = value);
                },
                validator: (value) => value == null ? 'Wajib dipilih' : null,
              ),
              const SizedBox(height: 16),

              ListTile(
                title: Text(checkInDate == null 
                  ? 'Pilih Tanggal Check-in' 
                  : 'Check-in: ${DateFormat('dd/MM/yyyy').format(checkInDate!)}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 90)),
                  );
                  if (date != null) {
                    setState(() => checkInDate = date);
                  }
                },
              ),

              ListTile(
                title: Text(checkOutDate == null 
                  ? 'Pilih Tanggal Check-out' 
                  : 'Check-out: ${DateFormat('dd/MM/yyyy').format(checkOutDate!)}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: checkInDate ?? DateTime.now(),
                    firstDate: checkInDate ?? DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 90)),
                  );
                  if (date != null) {
                    setState(() => checkOutDate = date);
                  }
                },
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Pengantaran',
                  border: OutlineInputBorder(),
                ),
                value: selectedPengantaran,
                items: ['Datang Sendiri', 'Antar Jemput'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => selectedPengantaran = value);
                },
                validator: (value) => value == null ? 'Wajib dipilih' : null,
              ),

              if (selectedPengantaran == 'Antar Jemput') ...[
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Kecamatan',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedKecamatan,
                  items: ['Telukjambe Timur'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => selectedKecamatan = value);
                  },
                  validator: (value) => value == null ? 'Wajib dipilih' : null,
                ),

                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Desa',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedDesa,
                  items: ['Sukaharja', 'Pinayungan', 'Puseurjaya'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => selectedDesa = value);
                  },
                  validator: (value) => value == null ? 'Wajib dipilih' : null,
                ),

                const SizedBox(height: 16),
                TextFormField(
                  controller: alamatController,
                  decoration: const InputDecoration(
                    labelText: 'Detail Alamat',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                ),
              ],

              const SizedBox(height: 16),
              TextFormField(
                controller: catatanController,
                decoration: const InputDecoration(
                  labelText: 'Catatan Khusus',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),

              const SizedBox(height: 24),
              if (checkInDate != null && checkOutDate != null && selectedPaket != null)
                Text(
                  'Total Harga: Rp ${calculateTotalPrice().toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Buat Reservasi'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}