import 'dart:async';
import 'package:wellpage/helpers/dbhelphistory.dart';
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
          // Add Grooming History Card
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
                  Row(
                    children: [
                      Icon(Icons.history, color: Color(0xFF8B6BB7)),
                      SizedBox(width: 8),
                      Text(
                        'Riwayat Grooming',
                        style: TextStyle(
                          color: Color(0xFF8B6BB7),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: _fetchGroomingHistory(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B6BB7)),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text('Belum ada riwayat grooming'),
                        );
                      }
                      
                      // Update the ListView.builder section:
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final booking = snapshot.data![index];
                          return Card(
                            margin: EdgeInsets.only(bottom: 8),
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Paket: ${booking['paket_grooming']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF8B6BB7),
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        DBHelpHistory.formatPrice(booking['total_harga']),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF8B6BB7),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text('Jenis Hewan: ${booking['jenis_hewan']}'),
                                  Text('Tanggal: ${DBHelpHistory.formatDate(booking['tanggal_grooming'])}'),
                                  Text('Waktu: ${DBHelpHistory.formatTime(booking['waktu_booking'])}'),
                                  Text('Pengantaran: ${booking['pengantaran']}'),
                                  if (booking['pengantaran'] == 'Antar Jemput') ...[
                                    Text('Kecamatan: ${booking['kecamatan']}'),
                                    Text('Desa: ${booking['desa']}'),
                                    Text('Alamat: ${booking['detail_alamat']}'),
                                  ],
                                  SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Pembayaran: ${booking['metode_pembayaran']}'),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Color(int.parse(DBHelpHistory.getStatusColor(booking['status_pembayaran']).replaceAll('#', '0xFF'))).withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          booking['status_pembayaran'],
                                          style: TextStyle(
                                            color: Color(int.parse(DBHelpHistory.getStatusColor(booking['status_pembayaran']).replaceAll('#', '0xFF'))),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchGroomingHistory() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost/mobileapps/get_grooming_history.php'),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['success'] && result['data'] != null) {
          final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(result['data']);
          if (data.isEmpty) {
            return [];
          }
          return data;
        }
      }
      return [];
    } catch (e) {
      print('Error fetching grooming history: $e');
      return [];
    }
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
