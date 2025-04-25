import 'package:flutter/material.dart';
import 'package:wellpage/pet/stylebook.dart';

class Navigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const Navigation({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey.shade700, // Changed to dark gray
      backgroundColor: Styless.backgroundColor,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 12,
      ),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book_rounded),
          label: 'Layanan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_library_rounded),
          label: 'Booking',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.logout_rounded),
          label: 'Logout',
        ),
      ],
    );
    
  }
}