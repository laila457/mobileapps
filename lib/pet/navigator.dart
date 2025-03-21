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
      selectedItemColor: Colors.black, // Light purple color for selected items
      unselectedItemColor: Colors.grey, // Black for unselected items
      backgroundColor: Styless.backgroundColor,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Pesan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Upload',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.logout),
          label: 'Logout',
        ),
      ],
    );
  }
}