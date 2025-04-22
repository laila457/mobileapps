import 'package:flutter/material.dart';
import 'package:wellpage/pet/formbooking.dart';
import 'package:wellpage/pet/layanantrue.dart';
import 'package:wellpage/pet/penitipan2.dart';
import 'package:wellpage/screen/welcome.dart';
import 'package:wellpage/pet/profile.dart';

class GroomingsPage extends StatefulWidget {
  const GroomingsPage({super.key});

  @override
  State<GroomingsPage> createState() => _GroomingsPageState();
}

class _GroomingsPageState extends State<GroomingsPage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grooming'),
        backgroundColor: Colors.purple[300],
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'List Paket & Harga',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple[800]),
                ),
                const SizedBox(height: 20),
                DataTable(
                  columns: const [
                    DataColumn(
                        label: Text('Paket',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Harga',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Detail',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: const [
                    DataRow(cells: [
                      DataCell(Text('Basic')),
                      DataCell(Text('Rp 59.000')),
                      DataCell(Text('Perawatan Basic')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Kutu - Jamur')),
                      DataCell(Text('Rp 70.000')),
                      DataCell(Text('Perawatan Kutu & Jamur')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Full Treatment')),
                      DataCell(Text('Rp 100.000')),
                      DataCell(Text('Perawatan Lengkap')),
                    ]),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  '“Layanan Grooming kucing di Shiroo Petshop memastikan kucingmu tetap bersih dan wangi! Dengan tenaga profesional dan produk terbaik, kami menjamin pengalaman grooming terbaik untuk hewan kesayangan.”',
                  style: TextStyle(
                      color: Colors.grey[600], fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 20),
                // Row to display images side by side
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Space images evenly
                  children: [
                    _buildImageContainer('../assets/images/list.png'),
                    _buildImageContainer('../assets/images/clist.png'),
                    _buildImageContainer('../assets/images/catlist.png'),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FormBooking()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color.fromARGB(255, 251, 182, 232)),
                  child: const Text('Pesan Sekarang'),
                ),
              ],
            ),
          ),
          Layanan1(), // Replace with your actual ChatPage widget
          FormBooking(), // Replace with your actual NewPostPage widget
          const HomeScreens(), // Replace with your actual Signin widget
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Layanan'),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_library), label: 'Booking'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple[300],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildImageContainer(String imagePath) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), // Set the border radius
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10), // Match the radius
        child: Image.asset(
          imagePath,
          width: 120,//t the desired width
          height: 120,//Set the desired height
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}