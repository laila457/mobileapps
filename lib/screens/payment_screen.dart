import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';  // Add this import
import 'dart:io';
import 'dart:convert';
import 'package:wellpage/pet/dasboard.dart';
import 'package:wellpage/database/database_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;

class PaymentScreen extends StatefulWidget {
  final String bookingId;
  final double amount;

  const PaymentScreen({
    super.key,
    required this.bookingId,
    required this.amount,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedMethod = '';
  XFile? imageFile;  // Change to XFile
  bool isLoading = false;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      
      if (pickedFile != null) {
        setState(() {
          imageFile = pickedFile;  // Store XFile directly
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  // Update the import at the top

  Future<void> _submitPayment() async {
    if (selectedMethod.isEmpty || imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih metode pembayaran dan upload bukti')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // Show immediate success notification
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
                        '✨ Pembayaran Berhasil!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Total Pembayaran: Rp ${widget.amount.toStringAsFixed(0)}',
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
          duration: const Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );

      // Continue with the API request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://localhost/mobileapps/create_payment.php'),
      );

      request.fields['booking_id'] = widget.bookingId;
      request.fields['payment_method'] = selectedMethod;
      request.fields['status_pembayaran'] = 'pending';  // Add status
      
      // Handle file upload
      final bytes = await imageFile!.readAsBytes();
      final filename = DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
      
      request.files.add(
        http.MultipartFile.fromBytes(
          'bukti_transaksi',
          bytes,
          filename: filename,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result['success']) {
          if (mounted) {
            await Future.delayed(const Duration(seconds: 1)); // Short delay for notification visibility
            await Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const Dash(),
                settings: const RouteSettings(name: '/dashboard'),
              ),
              (route) => false,
            );
          }
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Pembayaran',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rp ${widget.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Metode Pembayaran',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                'DANA',
                'OVO',
                'GoPay',
                'Bank Transfer',
              ].map((method) => ChoiceChip(
                label: Text(method),
                selected: selectedMethod == method,
                onSelected: (selected) {
                  setState(() => selectedMethod = selected ? method : '');
                },
              )).toList(),
            ),
            const SizedBox(height: 24),
            const Text(
              'Upload Bukti Pembayaran',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (imageFile != null)
              FutureBuilder<Uint8List>(
                future: imageFile!.readAsBytes(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Image.memory(
                          snapshot.data!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() => imageFile = null);
                          },
                        ),
                      ],
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              )
            else
              InkWell(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color.fromARGB(255, 0, 255, 85)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload_file, size: 48),
                        Text('Tap untuk upload bukti'),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _submitPayment,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Konfirmasi Pembayaran'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
