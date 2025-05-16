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
          Uri.parse('http://localhost/mobileapps/create_penitipan.php'),
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
    final lightPurple = Color(0xFFE0D4F6);
    final mediumPurple = Color(0xFFB19CD9);
    final darkPurple = Color(0xFF8B6BB7);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.pets, color: Colors.white),
            SizedBox(width: 8),
            Text('Pet Hotel Booking'),
          ],
        ),
        backgroundColor: darkPurple,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [lightPurple, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
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
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_on, color: darkPurple),
                              SizedBox(width: 8),
                              Text(
                                'Detail Lokasi',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: darkPurple,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Kecamatan',
                              prefixIcon: Icon(Icons.map, color: darkPurple),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
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
                          SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Desa',
                              prefixIcon: Icon(Icons.location_city, color: darkPurple),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
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
                          SizedBox(height: 16),
                          TextFormField(
                            controller: alamatController,
                            decoration: InputDecoration(
                              labelText: 'Detail Alamat',
                              prefixIcon: Icon(Icons.home, color: darkPurple),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            maxLines: 3,
                            validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                          ),
                        ],
                      ),
                    ),
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
                
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: darkPurple,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: darkPurple.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Harga',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'Rp ${calculateTotalPrice().toStringAsFixed(0)}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  height: 55,
                  margin: EdgeInsets.only(bottom: 20),
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.pets),
                        SizedBox(width: 8),
                        Text(
                          'Buat Reservasi',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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