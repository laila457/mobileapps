// Update imports
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../pet/dasboard.dart';
import '../services/notification_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';

class PaymentPenitipanScreen extends StatefulWidget {
  final double amount;
  final String bookingId;

  const PaymentPenitipanScreen({
    Key? key,
    required this.amount,
    required this.bookingId,
  }) : super(key: key);

  @override
  State<PaymentPenitipanScreen> createState() => _PaymentPenitipanScreenState();
}

class _PaymentPenitipanScreenState extends State<PaymentPenitipanScreen> {
  String? selectedPaymentMethod;
  XFile? buktiTransaksi;  // Change File to XFile
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;
  Uint8List? imageBytes;  // Add this to store image bytes

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 1024,
      maxHeight: 1024,
    );
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        buktiTransaksi = image;
        imageBytes = bytes;
      });
    }
  }

  Widget _buildImagePreview() {
    if (imageBytes == null) return const SizedBox();
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Image.memory(
        imageBytes!,
        fit: BoxFit.cover,
      ),
    );
  }

  Future<void> _submitPayment() async {
    if (selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih metode pembayaran')),
      );
      return;
    }

    if (selectedPaymentMethod != 'Cash' && buktiTransaksi == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Upload bukti pembayaran')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final uri = Uri.parse('http://localhost/mobileapps-1/update_payment_penitipan.php');
      var request = http.MultipartRequest('POST', uri);

      request.fields.addAll({
        'booking_id': widget.bookingId,
        'metode_pembayaran': selectedPaymentMethod!,
      });

      if (buktiTransaksi != null) {
        final bytes = await buktiTransaksi!.readAsBytes();
        final multipartFile = http.MultipartFile.fromBytes(
          'bukti_transaksi',
          bytes,
          filename: '${DateTime.now().millisecondsSinceEpoch}.jpg',
        );
        request.files.add(multipartFile);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        
        if (result['status'] == 'success' && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pembayaran berhasil')),
          );

          if (mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Dash()),
              (route) => false,
            );
          }
        } else {
          throw Exception(result['message'] ?? 'Failed to update payment');
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
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Pembayaran',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rp ${widget.amount.toStringAsFixed(0)}',
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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              value: selectedPaymentMethod,
              hint: const Text('Pilih metode pembayaran'),
              items: ['Transfer Bank', 'QRIS', 'Cash'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedPaymentMethod = value;
                  if (value == 'Cash') {
                    buktiTransaksi = null;
                  }
                });
              },
            ),
            if (selectedPaymentMethod != null && selectedPaymentMethod != 'Cash')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  const Text(
                    'Bukti Pembayaran',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Column(
                      children: [
                        _buildImagePreview(),
                        ElevatedButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.upload_file),
                          label: Text(
                            buktiTransaksi == null
                                ? 'Upload Bukti Pembayaran'
                                : 'Ganti Bukti Pembayaran',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _submitPayment,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Konfirmasi Pembayaran',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}