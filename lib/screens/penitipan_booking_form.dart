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
  
  // Add these lists
  final List<String> kecamatan = ['Telukjambe Timur'];
  final List<String> desa = ['Sukaharja', 'Pinayungan', 'Puseurjaya'];
  
  String? selectedJenisHewan;
  String? selectedPaket;
  String? selectedPengantaran;
  String? selectedKecamatan;
  String? selectedDesa;
  DateTime? checkInDate;
  DateTime? checkOutDate;

  final Map<String, double> paketHarga = {
    'basic': 35000.0,
    'premium': 50000.0,
    'exclusive': 75000.0,
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
        // Convert pengantaran to match enum values
        String dbPengantaran = selectedPengantaran == 'Antar Jemput' ? 'antar' : 'jemput';
        
        // Convert paket_penitipan to match enum values
        String dbPaket = selectedPaket!.toLowerCase();

        final response = await http.post(
          Uri.parse('http://localhost/mobileapps/create_penitipan.php'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'user_id': null, // Should be set from login session
            'check_in': DateFormat('yyyy-MM-dd').format(checkInDate!),
            'check_out': DateFormat('yyyy-MM-dd').format(checkOutDate!),
            'nama_pemilik': namaPemilikController.text,
            'no_hp': noHpController.text,
            'nama_hewan': namaHewanController.text,
            'jenis_hewan': selectedJenisHewan,
            'paket_penitipan': dbPaket,
            'pengantaran': dbPengantaran,
            'kecamatan': selectedPengantaran == 'Antar Jemput' ? selectedKecamatan : null,
            'desa': selectedPengantaran == 'Antar Jemput' ? selectedDesa : null,
            'detail_alamat': selectedPengantaran == 'Antar Jemput' ? alamatController.text : null,
            'catatan': catatanController.text,
            'total_harga': totalHarga,
            'metode_pembayaran': 'pending',
            'status': 'pending'
          }),
        );

        final result = jsonDecode(response.body);
        
        if (result['status'] == 'success' && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '✨ Reservasi Berhasil!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Total: Rp ${calculateTotalPrice().toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              backgroundColor: Color(0xFF4CAF50),
              duration: const Duration(seconds: 4),
              behavior: SnackBarBehavior.floating,
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.all(16),
            ),
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
                  decoration: InputDecoration(
                    labelText: 'Nama Pemilik',
                    prefixIcon: Icon(Icons.person_outline, color: darkPurple),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: mediumPurple),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: darkPurple, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: noHpController,
                  decoration: InputDecoration(
                    labelText: 'Nomor HP',
                    hintText: 'Contoh: 08123456789',
                    prefixIcon: Icon(Icons.phone_android, color: darkPurple),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: darkPurple),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: mediumPurple),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: darkPurple, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Wajib diisi';
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Harus number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: namaHewanController,
                  decoration: InputDecoration(
                    labelText: 'Nama Hewan',
                    prefixIcon: Icon(Icons.pets, color: darkPurple),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: mediumPurple),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: darkPurple, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                ),

                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Jenis Hewan',
                    prefixIcon: Icon(Icons.pets_outlined, color: darkPurple),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: mediumPurple),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: darkPurple, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
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
                  decoration: InputDecoration(
                    labelText: 'Paket Penitipan',
                    prefixIcon: Icon(Icons.pets_outlined, color: darkPurple),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: mediumPurple),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: darkPurple, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  value: selectedPaket,
                  items: [
                    DropdownMenuItem(
                      value: 'basic',
                      child: Row(
                        children: [
                          Icon(Icons.star_border, color: darkPurple),
                          SizedBox(width: 10),
                          Text('Basic - Rp ${paketHarga['basic']?.toStringAsFixed(0)}/hari (Kandang standar, makan 2x)'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'premium',
                      child: Row(
                        children: [
                          Icon(Icons.star, color: darkPurple),
                          SizedBox(width: 10),
                          Text('Premium - Rp ${paketHarga['premium']?.toStringAsFixed(0)}/hari (Kandang besar, makan 3x)'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'exclusive',
                      child: Row(
                        children: [
                          Icon(Icons.stars, color: darkPurple),
                          SizedBox(width: 10),
                          Text('Exclusive - Rp ${paketHarga['exclusive']?.toStringAsFixed(0)}/hari (VIP room, makan 4x, grooming)'),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() => selectedPaket = value);
                  },
                  validator: (value) => value == null ? 'Wajib dipilih' : null,
                ),
                const SizedBox(height: 16),

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
                        Row(
                          children: [
                            Icon(Icons.calendar_month, color: darkPurple),
                            SizedBox(width: 8),
                            Text(
                              'Jadwal Penitipan',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: darkPurple,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        InkWell(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 90)),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: darkPurple,
                                      onPrimary: Colors.white,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (date != null) {
                              setState(() => checkInDate = date);
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: mediumPurple),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today, color: darkPurple),
                                SizedBox(width: 12),
                                Text(
                                  checkInDate == null 
                                    ? 'Pilih Tanggal Check-in'
                                    : 'Check-in: ${DateFormat('dd/MM/yyyy').format(checkInDate!)}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Spacer(),
                                Icon(Icons.arrow_forward_ios, size: 16),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        InkWell(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: checkInDate ?? DateTime.now(),
                              firstDate: checkInDate ?? DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 90)),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: darkPurple,
                                      onPrimary: Colors.white,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (date != null) {
                              setState(() => checkOutDate = date);
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: mediumPurple),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today, color: darkPurple),
                                SizedBox(width: 12),
                                Text(
                                  checkOutDate == null 
                                    ? 'Pilih Tanggal Check-out'
                                    : 'Check-out: ${DateFormat('dd/MM/yyyy').format(checkOutDate!)}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Spacer(),
                                Icon(Icons.arrow_forward_ios, size: 16),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
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
                        Row(
                          children: [
                            Icon(Icons.local_shipping, color: darkPurple),
                            SizedBox(width: 8),
                            Text(
                              'Metode Pengantaran (Free pengantaran daerah Telukjambe Timur)',
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
                            labelText: 'Pilih Metode',
                            prefixIcon: Icon(Icons.delivery_dining, color: darkPurple),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: mediumPurple),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: darkPurple, width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          value: selectedPengantaran,
                          items: [
                            DropdownMenuItem(
                              value: 'Datang Sendiri',
                              child: Row(
                                children: [
                                  Icon(Icons.directions_walk, color: darkPurple),
                                  SizedBox(width: 10),
                                  Text('Datang Sendiri'),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'Antar Jemput',
                              child: Row(
                                children: [
                                  Icon(Icons.local_shipping, color: darkPurple),
                                  SizedBox(width: 10),
                                  Text('Antar Jemput'),
                                ],
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() => selectedPengantaran = value);
                          },
                          validator: (value) => value == null ? 'Wajib dipilih' : null,
                        ),
                        
                        // Add conditional address form fields
                        if (selectedPengantaran == 'Antar Jemput') ...[
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Kecamatan',
                              prefixIcon: Icon(Icons.location_city, color: darkPurple),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(color: mediumPurple),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(color: darkPurple, width: 2),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            value: selectedKecamatan,
                            items: kecamatan.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() => selectedKecamatan = newValue);
                            },
                            validator: (value) => selectedPengantaran == 'Antar Jemput' && value == null 
                              ? 'Wajib dipilih untuk antar jemput' : null,
                          ),

                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Desa',
                              prefixIcon: Icon(Icons.location_on, color: darkPurple),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(color: mediumPurple),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(color: darkPurple, width: 2),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            value: selectedDesa,
                            items: desa.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() => selectedDesa = newValue);
                            },
                            validator: (value) => selectedPengantaran == 'Antar Jemput' && value == null 
                              ? 'Wajib dipilih untuk antar jemput' : null,
                          ),

                          const SizedBox(height: 16),
                          TextFormField(
                            controller: alamatController,
                            decoration: InputDecoration(
                              labelText: 'Detail Alamat',
                              hintText: 'Masukkan detail alamat lengkap',
                              prefixIcon: Icon(Icons.home, color: darkPurple),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(color: mediumPurple),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(color: darkPurple, width: 2),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            maxLines: 3,
                            validator: (value) => selectedPengantaran == 'Antar Jemput' && value!.isEmpty 
                              ? 'Wajib diisi untuk antar jemput' : null,
                          ),
                        ],
                        ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                const SizedBox(height: 16),
                TextFormField(
                  controller: catatanController,
                  decoration: InputDecoration(
                    labelText: 'Catatan Khusus',
                    hintText: 'Tambahkan catatan khusus untuk hewan Anda',
                    prefixIcon: Icon(Icons.note_add, color: darkPurple),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: mediumPurple),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: darkPurple, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
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
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 5,
                      shadowColor: darkPurple.withOpacity(0.5),
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