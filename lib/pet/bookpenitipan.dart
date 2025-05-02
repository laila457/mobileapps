import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wellpage/controllers/booking_penitipan_controller.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String selectedPackage = 'Basic';
  bool isDeliveryService = false;
  String? selectedLocation;
  String? selectedVillage;
  final addressDetailController = TextEditingController();
  
  // Calendar variables
  String selectedMonth = DateFormat('MMMM').format(DateTime.now());
  int selectedDay = DateTime.now().day;
  List<int> daysInMonth = [];

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final petCountController = TextEditingController();
  final notesController = TextEditingController();

  String? selectedPetType = 'Kucing';
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _updateDaysInMonth(DateTime.now());
  }
  
  void _updateDaysInMonth(DateTime date) {
    final lastDay = DateTime(date.year, date.month + 1, 0).day;
    daysInMonth = List.generate(lastDay, (index) => index + 1);
  }

  Widget _buildMonthDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonFormField<String>(
        value: selectedMonth,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Pilih bulan',
        ),
        items: List.generate(12, (index) {
          final month = DateTime(DateTime.now().year, index + 1);
          return DropdownMenuItem(
            value: DateFormat('MMMM').format(month),
            child: Text(DateFormat('MMMM').format(month)),
          );
        }),
        onChanged: (value) {
          if (value != null) {
            setState(() {
              selectedMonth = value;
              final monthNumber = DateFormat('MMMM').parse(value).month;
              _updateDaysInMonth(DateTime(DateTime.now().year, monthNumber));
            });
          }
        },
      ),
    );
  }
  
  Widget _buildCalendarGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: daysInMonth.length,
      itemBuilder: (context, index) {
        final day = daysInMonth[index];
        final isSelected = day == selectedDay;
        return InkWell(
          onTap: () {
            setState(() {
              selectedDay = day;
              final monthNumber = DateFormat('MMMM').parse(selectedMonth).month;
              selectedDate = DateTime(
                DateTime.now().year,
                monthNumber,
                day,
              );
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue[100] : Colors.white,
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day.toString(),
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.blue[900] : Colors.black,
                    ),
                  ),
                  Text(
                    DateFormat('E').format(DateTime(
                      DateTime.now().year,
                      DateFormat('MMMM').parse(selectedMonth).month,
                      day,
                    )),
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

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

    // Validate delivery fields if delivery service is selected
    if (isDeliveryService) {
      if (selectedLocation == null || selectedVillage == null || addressDetailController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mohon lengkapi data alamat pengantaran')),
        );
        return;
      }
    }

    setState(() => isLoading = true);

    try {
      final success = await BookPenitipanController.saveBooking(
        ownerName: nameController.text,
        phoneNumber: phoneController.text,
        petCount: int.parse(petCountController.text),
        petType: selectedPetType ?? '',
        notes: notesController.text,
        bookingDate: selectedDate,
        bookingTime: selectedTime.format(context),
        package: selectedPackage,
        isDeliveryService: isDeliveryService,
        location: selectedLocation,
        village: selectedVillage,
        addressDetail: addressDetailController.text,
      );

      setState(() => isLoading = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking berhasil disimpan!'),
            backgroundColor: Colors.green,
          ),
        );
        // Reset form
        setState(() {
          _formKey.currentState!.reset();
          selectedLocation = null;
          selectedVillage = null;
          addressDetailController.clear();
          isDeliveryService = false;
          selectedPetType = '';
          selectedPackage = '';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menyimpan booking. Silakan coba lagi.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.purple[100],
        title: const Text('Reservasi Grooming'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pilih Jadwal Section
                Row(
                  children: [
                    Icon(Icons.calendar_month, size: 20),
                    const SizedBox(width: 8),
                    Text('Pilih Jadwal', style: TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 8),
                // Calendar section
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    children: [
                      _buildMonthDropdown(),
                      SizedBox(height: 16),
                      _buildCalendarGrid(),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                Text('Waktu Booking', style: TextStyle(color: Colors.grey[600])),
                _buildTimePicker(),

                // Data Pelanggan Section
                const SizedBox(height: 24),
                Row(
                  children: [
                    Icon(Icons.person_outline, size: 20),
                    const SizedBox(width: 8),
                    Text('Data Pelanggan', style: TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: nameController,
                  hint: 'Nama Pemilik',
                  label: '',
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: phoneController,
                  hint: 'No. HP',
                  label: '',
                  keyboardType: TextInputType.phone,
                ),

                // Jenis Hewan Section
                const SizedBox(height: 24),
                Row(
                  children: [
                    Icon(Icons.pets, size: 20),
                    const SizedBox(width: 8),
                    Text('Jenis Hewan', style: TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: 'Anjing',
                      groupValue: selectedPetType,
                      onChanged: (value) => setState(() => selectedPetType = value as String),
                    ),
                    Text('Anjing'),
                    const SizedBox(width: 24),
                    Radio(
                      value: 'Kucing',
                      groupValue: selectedPetType,
                      onChanged: (value) => setState(() => selectedPetType = value as String),
                    ),
                    Text('Kucing'),
                  ],
                ),

                // Pilih Paket Section
                const SizedBox(height: 24),
                Row(
                  children: [
                    Icon(Icons.shopping_bag_outlined, size: 20),
                    const SizedBox(width: 8),
                    Text('Pilih Paket', style: TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildPackageButton('Basic', 'Rp 50.000'),
                    const SizedBox(width: 8),
                    _buildPackageButton('Kutu & Jamur', 'Rp 70.000'),
                    const SizedBox(width: 8),
                    _buildPackageButton('Full Service', 'Rp 85.000'),
                  ],
                ),

                // Lokasi Section
                const SizedBox(height: 24),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 20),
                    const SizedBox(width: 8),
                    Text('Lokasi dan Pengantaran', style: TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: !isDeliveryService,
                      onChanged: (value) => setState(() => isDeliveryService = !(value ?? true)),
                    ),
                    Text('Datang Sendiri'),
                    const SizedBox(width: 16),
                    Checkbox(
                      value: isDeliveryService,
                      onChanged: (value) => setState(() => isDeliveryService = value ?? false),
                    ),
                    Text('Layanan Antar Jemput (Gratis)'),
                  ],
                ),
                Text(
                  'Layanan antar jemput gratis tersedia untuk area: Sukaharjo, Plosoyudan, dan Puseurjaya',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),

                // Add delivery address fields when delivery is selected
                if (isDeliveryService) ...[
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Kecamatan',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    value: selectedLocation,
                    items: ['Telukjambe Timur'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedLocation = value;
                      });
                    },
                    validator: (value) => value == null ? 'Pilih kecamatan' : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Desa/Kelurahan',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    value: selectedVillage,
                    items: ['Sukaharjo', 'Plosoyudan', 'Puseurjaya'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedVillage = value;
                      });
                    },
                    validator: (value) => value == null ? 'Pilih desa/kelurahan' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: addressDetailController,
                    decoration: InputDecoration(
                      labelText: 'Detail Alamat',
                      hintText: 'Masukkan detail alamat (nama jalan, nomor rumah, RT/RW)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    maxLines: 3,
                    validator: (value) => value!.isEmpty ? 'Masukkan detail alamat' : null,
                  ),
                ],

                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[400],
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text('Selesaikan Pemesanan'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPackageButton(String title, String price) {
    bool isSelected = selectedPackage == title;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => selectedPackage = title),
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? Colors.purple : Colors.grey[300]!,
            ),
            borderRadius: BorderRadius.circular(8),
            color: isSelected ? Colors.purple[50] : Colors.white,
          ),
          child: Column(
            children: [
              Text(title, style: TextStyle(fontSize: 12)),
              Text(price, style: TextStyle(fontSize: 12, color: Colors.purple)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimePicker() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: InkWell(
        onTap: _selectTime,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedTime.format(context),
              style: TextStyle(fontSize: 16),
            ),
            Icon(Icons.access_time, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required String label,
    TextInputType? keyboardType,
    int? maxLines,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines ?? 1,
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$hint tidak boleh kosong';
        }
        return null;
      },
    );
  }
}