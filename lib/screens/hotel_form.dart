/*import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';

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
  final notesController = TextEditingController();
  
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
        selectedDelivery != null &&
        checkInDate != null &&
        checkOutDate != null) {
      try {
        // Calculate total price based on package and number of days
        int numberOfDays = checkOutDate!.difference(checkInDate!).inDays;
        double basePrice = selectedPackage == 'Basic' ? 50000 :
                          selectedPackage == 'Premium' ? 75000 : 100000;
        double totalPrice = basePrice * numberOfDays;

        final data = {
          'check_in': DateFormat('yyyy-MM-dd').format(checkInDate!),
          'check_out': DateFormat('yyyy-MM-dd').format(checkOutDate!),
          'nama_pemilik': ownerNameController.text,
          'no_hp': phoneController.text,
          'nama_hewan': petNameController.text,
          'jenis_hewan': selectedPetType,
          'paket_penitipan': selectedPackage,
          'pengantaran': selectedDelivery,
          'kecamatan': selectedDelivery == 'Antar Jemput' ? selectedKecamatan : null,
          'desa': selectedDelivery == 'Antar Jemput' ? selectedKelurahan : null,
          'detail_alamat': selectedDelivery == 'Antar Jemput' ? addressController.text : null,
          'catatan': notesController.text,
          'total_harga': totalPrice.toString(),
          'metode_pembayaran': 'pending',
        };

        final success = await DatabaseHelper.createHotelReservation(data);
        
        if (mounted) {
          if (success) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentScreen(
                  bookingId: success.toString(),
                  amount: totalPrice,
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to create booking. Please try again.'),
                backgroundColor: Colors.red,
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
        const SnackBar(content: Text('Please complete all required fields')),
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
                'Customer Data',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: ownerNameController,
                decoration: const InputDecoration(
                  labelText: 'Owner Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: petNameController,
                decoration: const InputDecoration(
                  labelText: 'Pet Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              
              const SizedBox(height: 20),
              const Text(
                'Pet Type',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  ChoiceChip(
                    label: const Text('Dog'),
                    selected: selectedPetType == 'Anjing',
                    onSelected: (bool selected) {
                      setState(() => selectedPetType = selected ? 'Anjing' : null);
                    },
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    label: const Text('Cat'),
                    selected: selectedPetType == 'Kucing',
                    onSelected: (bool selected) {
                      setState(() => selectedPetType = selected ? 'Kucing' : null);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),
              const Text(
                'Select Package',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: Column(
                        children: const [
                          Text('Basic'),
                          Text('Rp 50.000/day', style: TextStyle(color: Colors.blue)),
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
                          Text('Premium'),
                          Text('Rp 75.000/day', style: TextStyle(color: Colors.blue)),
                        ],
                      ),
                      selected: selectedPackage == 'Premium',
                      onSelected: (bool selected) {
                        setState(() => selectedPackage = selected ? 'Premium' : null);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ChoiceChip(
                      label: Column(
                        children: const [
                          Text('VIP'),
                          Text('Rp 100.000/day', style: TextStyle(color: Colors.blue)),
                        ],
                      ),
                      selected: selectedPackage == 'VIP',
                      onSelected: (bool selected) {
                        setState(() => selectedPackage = selected ? 'VIP' : null);
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              const Text(
                'Check-in and Check-out Dates',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
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
                    initialDate: checkInDate ?? DateTime.now().add(const Duration(days: 1)),
                    firstDate: checkInDate ?? DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 90)),
                  );
                  if (date != null) {
                    setState(() => checkOutDate = date);
                  }
                },
              ),

              const SizedBox(height: 20),
              const Text(
                'Delivery Service',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Self Drop-off'),
                      selected: selectedDelivery == 'Datang Sendiri',
                      onSelected: (bool selected) {
                        setState(() => selectedDelivery = selected ? 'Datang Sendiri' : null);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Pick-up Service (Free)'),
                      selected: selectedDelivery == 'Antar Jemput',
                      onSelected: (bool selected) {
                        setState(() => selectedDelivery = selected ? 'Antar Jemput' : null);
                      },
                    ),
                  ),
                ],
              ),

              if (selectedDelivery == 'Antar Jemput') ...[
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'District',
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
                    labelText: 'Sub-district',
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
                    labelText: 'Address Details',
                    hintText: 'Enter address details (street name, house number, RT/RW)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
              ],

              const SizedBox(height: 20),
              TextFormField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'Special Notes',
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
                child: const Text('Submit Booking'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/