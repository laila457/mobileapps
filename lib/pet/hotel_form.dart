import 'package:flutter/material.dart';
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
  final petNameController = TextEditingController();
  final petTypeController = TextEditingController();
  final phoneController = TextEditingController();
  final specialReqController = TextEditingController();
  DateTime? checkInDate;
  DateTime? checkOutDate;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final data = {
          'owner_name': ownerNameController.text,
          'pet_name': petNameController.text,
          'pet_type': petTypeController.text,
          'check_in_date': DateFormat('yyyy-MM-dd').format(checkInDate!),
          'check_out_date': DateFormat('yyyy-MM-dd').format(checkOutDate!),
          'phone_number': phoneController.text,
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
            children: [
              TextFormField(
                controller: ownerNameController,
                decoration: const InputDecoration(labelText: 'Owner Name'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: petNameController,
                decoration: const InputDecoration(labelText: 'Pet Name'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: petTypeController,
                decoration: const InputDecoration(labelText: 'Pet Type'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
                keyboardType: TextInputType.phone,
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
                    initialDate: checkInDate ?? DateTime.now(),
                    firstDate: checkInDate ?? DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 90)),
                  );
                  if (date != null) {
                    setState(() => checkOutDate = date);
                  }
                },
              ),
              TextFormField(
                controller: specialReqController,
                decoration: const InputDecoration(
                  labelText: 'Special Requirements',
                  hintText: 'Any special needs for your pet?'
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Book Pet Hotel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}