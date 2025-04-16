import 'package:flutter/material.dart';
import '../screen/welcome.dart';  // Add this import
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path_package;

class HomeScreens extends StatelessWidget {
  const HomeScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileSection(),
            GallerySection(),
            LogoutButton(),
          ],
        ),
      ),
    );
  }
}

class ProfileSection extends StatefulWidget {
  const ProfileSection({super.key});

  @override
  _ProfileSectionState createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _loadUserData() async {
    try {
      final database = await openDatabase(
        path_package.join(await getDatabasesPath(), 'flutter_auth.db'),
      );
      
      final List<Map<String, dynamic>> users = await database.query('users', limit: 1);
      if (users.isNotEmpty) {
        setState(() {
          nameController.text = users[0]['name'] ?? '';
          phoneController.text = users[0]['phone'] ?? '';
          emailController.text = users[0]['email'] ?? '';
        });
      }
      await database.close();
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> _initDatabase() async {
    try {
      final database = await openDatabase(
        path_package.join(await getDatabasesPath(), 'flutter_auth.db'),
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS users (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT,
              phone TEXT,
              email TEXT
            )
          ''');
        },
      );
      await database.close();
      await _loadUserData();
    } catch (e) {
      print('Error initializing database: $e');
    }
  }

  Future<void> _saveUserData() async {
    try {
      final database = await openDatabase(
        path_package.join(await getDatabasesPath(), 'flutter_auth.db'),
      );
      
      // Try to update first
      int updated = await database.update(
        'users',
        {
          'name': nameController.text,
          'phone': phoneController.text,
          'email': emailController.text,
        },
        where: 'id = ?',
        whereArgs: [1],
      );
  
      // If no rows were updated, insert new data
      if (updated == 0) {
        await database.insert(
          'users',
          {
            'name': nameController.text,
            'phone': phoneController.text,
            'email': emailController.text,
          },
        );
      }
      
      await database.close();
      setState(() => isEditing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(question),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Show answer in a dialog
          if (answer.isNotEmpty) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(question),
                content: Text(answer),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Tutup'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildInfoField(String label, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          TextFormField(
            controller: controller,
            enabled: isEditing,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            'Rosa',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Informasi Akun',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(isEditing ? Icons.save : Icons.edit),
                onPressed: () {
                  if (isEditing) {
                    _saveUserData();
                  } else {
                    setState(() => isEditing = true);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoField('Nama', nameController),
          _buildInfoField('No Handphone', phoneController),
          _buildInfoField('Email', emailController),
          const SizedBox(height: 24),
          const Text(
            'Pertanyaan yang sering ditanyakan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildFAQItem('Apakah bisa grooming tanpa booking?', 
              'Sebaiknya booking terlebih dahulu agar tidak antre..'),
          _buildFAQItem('Apakah ada layanan antar jemput?', 
              'Ya, kami menyediakan layanan antar jemput dengan biaya tambahan 20k untuk area Karawang.'),
          _buildFAQItem('Apakah saja fasilitas layanan yang ada?', 
              'Kami menyediakan beberapa layanan:\n\n'
              '1. Basic Grooming (59k)\n'
              '   - Mandi\n'
              '   - Blow dry\n'
              '   - Sisir\n\n'
              '2. Grooming Anti Kutu & Jamur (70k)\n'
              '   - Mandi khusus\n'
              '   - Treatment anti kutu\n'
              '   - Treatment anti jamur\n\n'
              '3. Full Grooming (86k)\n'
              '   - Semua layanan basic\n'
              '   - Potong kuku\n'
              '   - Pembersihan telinga\n'
              '   - Styling'),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }
}

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                '120',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text('Followers'),
            ],
          ),
          Column(
            children: [
              Text(
                '80',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text('Following'),
            ],
          ),
          Column(
            children: [
              Text(
                '50',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text('Posts'),
            ],
          ),
        ],
      ),
    );
  }
}

class GallerySection extends StatelessWidget {
  final List<String> images = [
    'assets/images/cat2.jpg',
    'assets/images/dog_cocoa.png',
    'assets/images/dog_marly.png',
    'assets/images/dog_walt.png',
    'assets/images/cat_brook.png',
    'assets/images/cat_marly.png',
  ];

  GallerySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gallery',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: images.length,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  images[index],
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          (route) => false,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logged out successfully')),
        );
      },
      child: const Text('Logout'),
    );
  }
}
