import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wellpage/controllers/booking_penitipan_controller.dart'; // Tambahkan ini

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final petCountController = TextEditingController();
  final notesController = TextEditingController();

  String? selectedPetType = 'Kucing';
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  bool isLoading = false;

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.deepPurple,
            colorScheme: const ColorScheme.light(primary: Colors.deepPurple),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.deepPurple),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => selectedTime = picked);
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final success = await BookPenitipanController.saveBooking(
      ownerName: nameController.text,
      phoneNumber: phoneController.text,
      petCount: int.parse(petCountController.text),
      petType: selectedPetType ?? '',
      notes: notesController.text,
      bookingDate: selectedDate,
      bookingTime: selectedTime.format(context),
    );

    setState(() => isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking berhasil!')),
      );
      _formKey.currentState!.reset();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan booking. Coba lagi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F2FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFB39DDB),
        title: const Text('Booking Penitipan Hewan'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildSectionTitle('Data Pemilik'),
              _buildTextField(nameController, 'Nama Pemilik', Icons.person),
              _buildTextField(phoneController, 'Nomor HP', Icons.phone, TextInputType.phone),

              const SizedBox(height: 24),
              _buildSectionTitle('Data Hewan'),
              _buildTextField(petCountController, 'Jumlah Hewan', Icons.pets, TextInputType.number),
              _buildDropdown(),
              _buildTextField(notesController, 'Catatan Tambahan', Icons.note, null),

              const SizedBox(height: 24),
              _buildSectionTitle('Tanggal & Waktu'),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text('Tanggal: ${DateFormat.yMMMd().format(selectedDate)}'),
                      leading: const Icon(Icons.calendar_today),
                      onTap: _selectDate,
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text('Waktu: ${selectedTime.format(context)}'),
                      leading: const Icon(Icons.access_time),
                      onTap: _selectTime,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9575CD),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Simpan Booking',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      [TextInputType? keyboardType, int maxLines = 1]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: (value) => value == null || value.isEmpty ? '$label tidak boleh kosong' : null,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: selectedPetType,
        items: ['Kucing', 'Anjing', 'Burung', 'Reptil', 'Kelinci']
            .map((type) => DropdownMenuItem(value: type, child: Text(type)))
            .toList(),
        decoration: InputDecoration(
          labelText: 'Jenis Hewan',
          prefixIcon: const Icon(Icons.category),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) => setState(() => selectedPetType = value),
        validator: (value) => value == null ? 'Pilih jenis hewan' : null,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF6A1B9A),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    petCountController.dispose();
    notesController.dispose();
    super.dispose();
  }
}
