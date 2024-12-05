import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homestay_form/calendar/calendar.dart';

import '../profile/profile.dart';
import '../receipt/receipt.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<String> _tabTitles = [
    'Booking Calendar',
    'Receipt Generator',
    'Senarai Pelanggan',
    'Senarai Resit',
    'Homestay Profile'
  ];

  static final List<Widget> _widgetOptions = <Widget>[
    const BookingCalendarPage(),
    const ReceiptGenerator(),
    const Center(child: Text('Senarai Pelanggan Page')),
    const Center(child: Text('Senarai Resit Page')),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tabTitles[_selectedIndex]),
        backgroundColor: Colors.blue,
        actions: [IconButton(onPressed: _logout, icon: Icon(Icons.logout))],
      ),
      body: SingleChildScrollView(
        child: _widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Booking Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Receipt Generator',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Senarai Pelanggan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Senarai Resit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Homestay Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

void _logout() {
  FirebaseAuth.instance.signOut();
}
