import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';

class GroomingForm extends StatefulWidget {
  const GroomingForm({super.key});

  @override
  State<GroomingForm> createState() => _GroomingFormState();
}

class _GroomingFormState extends State<GroomingForm> {
  final _formKey = GlobalKey<FormState>();
  final ownerNameController = TextEditingController();
  final petNameController = TextEditingController();
  final petTypeController = TextEditingController();
  final phoneController = TextEditingController();
  final notesController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final data = {
          'owner_name': ownerNameController.text,
          'pet_name': petNameController.text,
          'pet_type': petTypeController.text,
          'service_date': DateFormat('yyyy-MM-dd').format(selectedDate!),
          'service_time': '${selectedTime!.hour}:${selectedTime!.minute}:00',
          'phone_number': phoneController.text,
          'notes': notesController.text,
        };

        final success = await DatabaseHelper.createGroomingReservation(data);
        
        if (mounted) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Booking successful!')),
            );
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to create booking')),
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
        title: const Text('Grooming Reservation'),
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
                child: const Text('Submit Booking'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}