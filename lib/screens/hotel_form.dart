import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/db_helper.dart';

class HotelForm extends StatefulWidget {
  const HotelForm({super.key});

  @override
  State<HotelForm> createState() => _HotelFormState();
}

class _HotelFormState extends State<HotelForm> {
  final _formKey = GlobalKey<FormState>();
  final ownerNameController = TextEditingController();
  final phoneController = TextEditingController();
  final petNameController = TextEditingController();
  final addressController = TextEditingController();
  final specialReqController = TextEditingController();
  
  String? selectedPetType;
  String? selectedPackage;
  String? selectedDelivery;
  String? selectedKecamatan;
  String? selectedKelurahan;
  DateTime? checkInDate;
  DateTime? checkOutDate;

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
          'check_in_date': DateFormat('yyyy-MM-dd').format(checkInDate!),
          'check_out_date': DateFormat('yyyy-MM-dd').format(checkOutDate!),
          'phone_number': phoneController.text,
          'package': selectedPackage,
          'delivery_type': selectedDelivery,
          'kecamatan': selectedDelivery == 'Antar Jemput' ? selectedKecamatan : null,
          'kelurahan': selectedDelivery == 'Antar Jemput' ? selectedKelurahan : null,
          'address': selectedDelivery == 'Antar Jemput' ? addressController.text : null,
          'special_requirements': specialReqController.text,
        };

        final success = await DatabaseHelper.createHotelReservation(data);
        
        if (mounted) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Hotel booking successful!')),
            );
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to create hotel booking')),
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
        title: const Text('Pet Hotel Reservation'),
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
                          Text('Regular'),
                          Text('Rp 35.000/hari', style: TextStyle(color: Colors.blue)),
                        ],
                      ),
                      selected: selectedPackage == 'Regular',
                      onSelected: (bool selected) {
                        setState(() => selectedPackage = selected ? 'Regular' : null);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ChoiceChip(
                      label: Column(
                        children: const [
                          Text('Premium'),
                          Text('Rp 50.000/hari', style: TextStyle(color: Colors.blue)),
                        ],
                      ),
                      selected: selectedPackage == 'Premium',
                      onSelected: (bool selected) {
                        setState(() => selectedPackage = selected ? 'Premium' : null);
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

              const SizedBox(height: 20),
              // Keep existing check-in and check-out date pickers
              ListTile(
                title: Text(checkInDate == null 
                  ? 'Select Check-in Date' 
                  : DateFormat('yyyy-MM-dd').format(checkInDate!)),
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
                  ? 'Select Check-out Date' 
                  : DateFormat('yyyy-MM-dd').format(checkOutDate!)),
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

              const SizedBox(height: 20),
              TextFormField(
                controller: specialReqController,
                decoration: const InputDecoration(
                  labelText: 'Special Requirements',
                  hintText: 'Any special needs for your pet?',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('Book Pet Hotel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}