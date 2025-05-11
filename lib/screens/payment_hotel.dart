import 'package:flutter/material.dart';
import 'package:wellpage/pet/dasboard.dart';
import '../database/db_helper.dart';

class PaymentHotel extends StatefulWidget {
  final String bookingId;
  final double amount;

  const PaymentHotel({
    Key? key,
    required this.bookingId,
    required this.amount,
  }) : super(key: key);

  @override
  State<PaymentHotel> createState() => _PaymentHotelState();
}

class _PaymentHotelState extends State<PaymentHotel> {
  String? selectedPaymentMethod;

  final Map<String, List<String>> paymentMethods = {
    'E-Wallet': ['DANA', 'OVO', 'GoPay', 'ShopeePay'],
    'Bank Transfer': ['BCA', 'Mandiri', 'BNI', 'BRI'],
    'Virtual Account': ['BCA VA', 'Mandiri VA', 'BNI VA', 'BRI VA'],
  };

  Future<void> _processPayment() async {
    if (selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih metode pembayaran')),
      );
      return;
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 2));

      // Update payment status in database
      await DatabaseHelper.updatePaymentStatus(widget.bookingId, selectedPaymentMethod!);

      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pembayaran berhasil!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to Dashboard
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Dash()),
          (route) => false,
        );
      }
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pembayaran gagal: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran Hotel'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ringkasan Pembayaran',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Total: Rp ${widget.amount.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text('ID Booking: ${widget.bookingId}'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              'Pilih Metode Pembayaran',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            for (var method in paymentMethods.entries)
              ExpansionTile(
                title: Text(method.key),
                children: method.value.map((channel) {
                  return RadioListTile<String>(
                    title: Text(channel),
                    value: channel,
                    groupValue: selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() => selectedPaymentMethod = value);
                    },
                  );
                }).toList(),
              ),

            const SizedBox(height: 20),
            if (selectedPaymentMethod != null)
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Metode Pembayaran: $selectedPaymentMethod',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      const Text('Klik Bayar Sekarang untuk melanjutkan pembayaran'),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _processPayment,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                'Bayar Sekarang',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}