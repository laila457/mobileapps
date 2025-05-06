import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';
import 'package:wellpage/pet/dasboard.dart'; // Add this import at the top

class GroomingForm extends StatefulWidget {
  const GroomingForm({super.key});

  @override
  State<GroomingForm> createState() => _GroomingFormState();
}

class _GroomingFormState extends State<GroomingForm> {
  // Remove duplicate phoneController and fix variable declarations
  final _formKey = GlobalKey<FormState>();
  final ownerNameController = TextEditingController();
  final phoneController = TextEditingController();
  final petNameController = TextEditingController();
  final addressController = TextEditingController();
  final notesController = TextEditingController();
  
  String? selectedPetType;
  String? selectedPackage;
  String? selectedDelivery;
  String? selectedKecamatan;
  String? selectedKelurahan;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && 
        selectedPetType != null && 
        selectedPackage != null && 
        selectedDelivery != null) {
      try {
        final data = {
          'owner_name': ownerNameController.text,
          'pet_name': petNameController.text,
          'pet_type': selectedPetType,
          'service_date': DateFormat('yyyy-MM-dd').format(selectedDate!),
          'service_time': '${selectedTime!.hour}:${selectedTime!.minute}:00',
          'phone_number': phoneController.text,
          'package': selectedPackage,
          'delivery_type': selectedDelivery,
          'kecamatan': selectedDelivery == 'Antar Jemput' ? selectedKecamatan : null,
          'kelurahan': selectedDelivery == 'Antar Jemput' ? selectedKelurahan : null,
          'address': selectedDelivery == 'Antar Jemput' ? addressController.text : null,
          'notes': notesController.text,
        };

        final success = await DatabaseHelper.createGroomingReservation(data);
        
        if (mounted) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Booking berhasil! Silahkan cek status pesanan Anda di dashboard.',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
              ),
            );
            
            // Navigate to Dashboard
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const Dash(),
              ),
              (route) => false,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Gagal membuat booking. Silakan coba lagi.',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grooming Reservation'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Data Pelanggan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: ownerNameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Pemilik',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: petNameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Hewan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'No. HP',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              
              const SizedBox(height: 20),
              const Text(
                'Jenis Hewan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  ChoiceChip(
                    label: const Text('Anjing'),
                    selected: selectedPetType == 'Anjing',
                    onSelected: (bool selected) {
                      setState(() => selectedPetType = selected ? 'Anjing' : null);
                    },
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    label: const Text('Kucing'),
                    selected: selectedPetType == 'Kucing',
                    onSelected: (bool selected) {
                      setState(() => selectedPetType = selected ? 'Kucing' : null);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),
              const Text(
                'Pilih Paket',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: Column(
                        children: const [
                          Text('Basic'),
                          Text('Rp 59.000', style: TextStyle(color: Colors.blue)),
                        ],
                      ),
                      selected: selectedPackage == 'Basic',
                      onSelected: (bool selected) {
                        setState(() => selectedPackage = selected ? 'Basic' : null);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ChoiceChip(
                      label: Column(
                        children: const [
                          Text('Kutu & Jamur'),
                          Text('Rp 70.000', style: TextStyle(color: Colors.blue)),
                        ],
                      ),
                      selected: selectedPackage == 'Kutu & Jamur',
                      onSelected: (bool selected) {
                        setState(() => selectedPackage = selected ? 'Kutu & Jamur' : null);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ChoiceChip(
                      label: Column(
                        children: const [
                          Text('Full Service'),
                          Text('Rp 86.000', style: TextStyle(color: Colors.blue)),
                        ],
                      ),
                      selected: selectedPackage == 'Full Service',
                      onSelected: (bool selected) {
                        setState(() => selectedPackage = selected ? 'Full Service' : null);
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              const Text(
                'Lokasi dan Pengantaran',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Datang Sendiri'),
                      selected: selectedDelivery == 'Datang Sendiri',
                      onSelected: (bool selected) {
                        setState(() => selectedDelivery = selected ? 'Datang Sendiri' : null);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Layanan Antar Jemput (Gratis)'),
                      selected: selectedDelivery == 'Antar Jemput',
                      onSelected: (bool selected) {
                        setState(() => selectedDelivery = selected ? 'Antar Jemput' : null);
                      },
                    ),
                  ),
                ],
              ),
              if (selectedDelivery == 'Antar Jemput')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Layanan antar jemput gratis tersedia untuk area: Sukaharja, Pinayungan, dan Puseurjaya',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Kecamatan',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedKecamatan,
                      items: const [
                        DropdownMenuItem(value: 'Telukjambe Timur', child: Text('Telukjambe Timur')),
                      ],
                      onChanged: (String? value) {
                        setState(() => selectedKecamatan = value);
                      },
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Desa/Kelurahan',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedKelurahan,
                      items: const [
                        DropdownMenuItem(value: 'Sukaharja', child: Text('Sukaharja')),
                        DropdownMenuItem(value: 'Pinayungan', child: Text('Pinayungan')),
                        DropdownMenuItem(value: 'Puseurjaya', child: Text('Puseurjaya')),
                      ],
                      onChanged: (String? value) {
                        setState(() => selectedKelurahan = value);
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: addressController,
                      decoration: const InputDecoration(
                        labelText: 'Detail Alamat',
                        hintText: 'Masukkan detail alamat (nama jalan, nomor rumah, RT/RW)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                  ],
                ),

              ListTile(
                title: Text(selectedDate == null 
                  ? 'Select Date' 
                  : DateFormat('yyyy-MM-dd').format(selectedDate!)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 30)),
                  );
                  if (date != null) {
                    setState(() => selectedDate = date);
                  }
                },
              ),
              ListTile(
                title: Text(selectedTime == null 
                  ? 'Select Time' 
                  : selectedTime!.format(context)),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    setState(() => selectedTime = time);
                  }
                },
              ),
              TextFormField(
                controller: notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('Submit Booking'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}