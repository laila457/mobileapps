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
    _timer = Timer.periodic(Duration(seconds: 5), (timer) => _loadUserData());
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
        ],
      ),
    );
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
          style: TextStyle(fontSize: 16),
        ),
        Divider(color: Colors.grey[300]),
        SizedBox(height: 8),
      ],
    );
  }
}
