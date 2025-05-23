import 'dart:async';
import 'package:flutter/material.dart';
import '../screen/welcome.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreens extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Akun Saya'),
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF8B6BB7),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Logout'),
                    content: Text('Apakah Anda yakin ingin keluar?'),
                    actions: [
                      TextButton(
                        child: Text('Batal'),
                        onPressed: () => Navigator.pop(context),
                      ),
                      TextButton(
                        child: Text('Ya'),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => WelcomeScreen()),
                            (route) => false,
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xFFFAF5FF),
          child: ProfileSection(),
        ),
      ),
    );
  }
}

class ProfileSection extends StatefulWidget {
  @override
  _ProfileSectionState createState() => _ProfileSectionState();
}

// Update the state variables
class _ProfileSectionState extends State<ProfileSection> {
  String username = '';
  String email = '';
  String phone = '';
  String address = '';
  String profilePicture = '';
  String role = '';
  String createdAt = '';
  bool isLoading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    // Set up periodic data refresh
    _timer = Timer.periodic(Duration(seconds: 300), (timer) => _loadUserData());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost/mobileapps/get_user_profile.php'),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Connection timeout');
        },
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['success'] && result['data'] != null) {
          setState(() {
            username = result['data']['username'] ?? '';
            email = result['data']['email'] ?? '';
            phone = result['data']['phone'] ?? '';
            address = result['data']['address'] ?? '';
            profilePicture = result['data']['profile_picture'] ?? '';
            role = result['data']['role'] ?? '';
            createdAt = result['data']['created_at'] ?? '';
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Profil',
                    style: TextStyle(
                      color: Color(0xFF8B6BB7),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  isLoading
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B6BB7)),
                        )
                      : Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Color(0xFFE0D4F6),
                              backgroundImage: profilePicture.isNotEmpty
                                  ? NetworkImage('http://localhost/mobileapps/$profilePicture')
                                  : null,
                              child: profilePicture.isEmpty
                                  ? Text(
                                      username.isNotEmpty ? username[0].toUpperCase() : '?',
                                      style: TextStyle(
                                        fontSize: 40,
                                        color: Color(0xFF8B6BB7),
                                      ),
                                    )
                                  : null,
                            ),
                            SizedBox(height: 8),
                            Text(
                              '@$username',
                              style: TextStyle(
                                color: Color(0xFF8B6BB7),
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              role.toUpperCase(),
                              style: TextStyle(
                                color: Color(0xFF8B6BB7),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          // Information Card
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Informasi Akun',
                    style: TextStyle(
                      color: Color(0xFF8B6BB7),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildInfoRow('Username', '@$username'),
                  _buildInfoRow('Email', email),
                  _buildInfoRow('Nomor HP', phone),
                  _buildInfoRow('Alamat', address),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          // Remove the standalone Grooming History Card and keep only the Booking History Card with tabs
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFBA68C8), Color(0xFF7B1FA2)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Text(
                        'Riwayat Booking',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      TabBar(
                        tabs: [
                          Tab(text: 'Grooming'),
                          Tab(text: 'Penitipan'),
                        ],
                        labelColor: Color(0xFF8B6BB7),
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Color(0xFF8B6BB7),
                      ),
                      SizedBox(
                        height: 400,
                        child: TabBarView(
                          children: [
                            _buildGroomingHistoryTab(),
                            _buildPenitipanHistoryTab(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchGroomingHistory() async {
    if (email.isEmpty) return [];
    
    try {
      final response = await http.get(
        Uri.parse('http://localhost/mobileapps/get_grooming_history.php?email=$email'),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Connection timeout');
        },
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        print('Grooming history response: $result'); // Debug print
        if (result['success'] && result['data'] != null) {
          return List<Map<String, dynamic>>.from(result['data']);
        }
      }
      return [];
    } catch (e) {
      print('Error fetching grooming history: $e');
      return [];
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'process':
        return Colors.blue;
      case 'success':
        return Colors.green;
      case 'cancel':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value.isEmpty ? '-' : value,
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF8B6BB7),
          ),
        ),
        Divider(color: Colors.grey[300]),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _buildGroomingHistoryTab() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchBookingHistory('grooming'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Tidak ada riwayat grooming'));
        }
        return _buildBookingList(snapshot.data!);
      },
    );
  }

  Widget _buildPenitipanHistoryTab() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchBookingHistory('penitipan'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Tidak ada riwayat penitipan'));
        }
        return _buildPenitipanList(snapshot.data!);
      },
    );
  }

  Widget _buildPenitipanList(List<Map<String, dynamic>> bookings) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return _buildPenitipanCard(booking);
      },
    );
  }

  Widget _buildPenitipanCard(Map<String, dynamic> booking) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          _buildPenitipanHeader(booking),
          _buildPenitipanDetails(booking),
        ],
      ),
    );
  }

  Widget _buildPenitipanHeader(Map<String, dynamic> booking) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFF3E5F5),
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildStatusBadge(booking['status'] ?? 'pending'),
              SizedBox(width: 8),
              _buildPaymentBadge(booking['metode_pembayaran'] ?? 'pending'),
            ],
          ),
          Text(
            'Rp ${booking['total_harga']}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF8B6BB7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPenitipanDetails(Map<String, dynamic> booking) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(Icons.calendar_today, 'Check In: ${booking['check_in']}'),
          SizedBox(height: 8),
          _buildDetailRow(Icons.calendar_today, 'Check Out: ${booking['check_out']}'),
          SizedBox(height: 8),
          _buildDetailRow(Icons.pets, '${booking['jenis_hewan']} - ${booking['nama_hewan']}'),
          SizedBox(height: 8),
          _buildDetailRow(Icons.category, 'Paket: ${booking['paket_penitipan']?.toUpperCase()}'),
          if (booking['pengantaran'] == 'antar') ...[
            SizedBox(height: 8),
            _buildDetailRow(
              Icons.location_on,
              '${booking['detail_alamat']}, ${booking['desa']}, ${booking['kecamatan']}'
            ),
          ],
          if (booking['catatan'] != null && booking['catatan'].isNotEmpty) ...[
            SizedBox(height: 8),
            _buildDetailRow(Icons.note, 'Catatan: ${booking['catatan']}'),
          ],
          if (booking['bukti_transaksi'] != null && booking['bukti_transaksi'].isNotEmpty) ...[
            SizedBox(height: 8),
            Text(
              'Bukti Pembayaran: Sudah diupload',
              style: TextStyle(color: Colors.green),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBookingList(List<Map<String, dynamic>> bookings) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return _buildBookingCard(booking);
      },
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          _buildBookingHeader(booking),
          _buildBookingDetails(booking),
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchBookingHistory(String type) async {
    if (email.isEmpty) return [];
    
    try {
      final response = await http.get(
        Uri.parse('http://localhost/mobileapps/get_booking_history.php?type=$type&email=$email'),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Connection timeout');
        },
      );
  
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        print('Booking history response: $result'); // Debug print
        if (result['success'] && result['data'] != null) {
          return List<Map<String, dynamic>>.from(result['data']);
        }
      }
      return [];
    } catch (e) {
      print('Error fetching booking history: $e');
      return [];
    }
  }

  // Move these methods inside the class, before the build method
  Widget _buildBookingHeader(Map<String, dynamic> booking) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFF3E5F5),
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildStatusBadge(booking['status'] ?? 'pending'),
              SizedBox(width: 8),
              _buildPaymentBadge(booking['metode_pembayaran'] ?? 'pending'),
            ],
          ),
          Text(
            'Rp ${booking['total_harga']}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF8B6BB7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingDetails(Map<String, dynamic> booking) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(Icons.calendar_today, '${booking['tanggal_grooming']} ${booking['waktu_booking']}'),
          SizedBox(height: 8),
          _buildDetailRow(Icons.pets, '${booking['jenis_hewan']} - ${booking['paket_grooming']}'),
          if (booking['pengantaran'] == 'antar') ...[
            SizedBox(height: 8),
            _buildDetailRow(
              Icons.location_on,
              '${booking['detail_alamat']}, ${booking['desa']}, ${booking['kecamatan']}'
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: _getStatusColor(status),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPaymentBadge(String method) {
    Color color;
    switch(method.toLowerCase()) {
      case 'qris': color = Colors.green; break;
      case 'cash': color = Colors.orange; break;
      case 'banktransfer': color = Colors.blue; break;
      default: color = Colors.grey;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        method.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
