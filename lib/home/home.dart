import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homestay_form/pelanggan/senarai_pelanggan.dart';

import '../calendar/calendar.dart';
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
    const SenaraiPelanggan(),
    const Center(child: Text('Senarai Resit Page')),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //changed
  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override //also changed
  Widget build(BuildContext context) {
    bool isWebLayout = MediaQuery.of(context).size.aspectRatio > 1;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC), // Soft light grey-blue
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: CircleAvatar(
            backgroundColor: Colors.blue.shade100,
            child: const Icon(Icons.home, color: Colors.blue),
          ),
        ),
        title: Text(
          _tabTitles[_selectedIndex],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            tooltip: 'Log Keluar',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: isWebLayout ? 800 : double.infinity,
          padding: EdgeInsets.all(isWebLayout ? 20 : 10),
          child: _widgetOptions[_selectedIndex],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'Kalender',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: 'Resit',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Pelanggan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'Senarai Resit',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_work),
              label: 'Profil',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
