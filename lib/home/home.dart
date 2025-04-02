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

<<<<<<< HEAD
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isWebLayout =
        MediaQuery.of(context).size.aspectRatio > 1; //weblayout change
=======
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
>>>>>>> 9f37067 (changed button padding and fix thumbscroll)

    return Scaffold(
      appBar: AppBar(
        title: Text(_tabTitles[_selectedIndex]),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () {
              _logout(context); //context passed here
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: isWebLayout ? 400 : double.infinity,
          padding: EdgeInsets.all(isWebLayout ? 20 : 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _widgetOptions[_selectedIndex]),
              const SizedBox(height: 20), //added const

              SizedBox(
                width: isWebLayout ? 400 : double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: isWebLayout ? 16 : 12),
                    textStyle: TextStyle(fontSize: isWebLayout ? 18 : 14),
                  ),
                  child: Text("Submit"),
                ),
              ),
            ],
          ),
        ),
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
<<<<<<< HEAD

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login'); //bring user to login
    }
  }
=======
>>>>>>> 9f37067 (changed button padding and fix thumbscroll)
}
