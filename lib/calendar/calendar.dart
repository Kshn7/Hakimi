import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BookingCalendarPage extends StatefulWidget {
  const BookingCalendarPage({super.key});

  @override
  _BookingCalendarPageState createState() => _BookingCalendarPageState();
}

class _BookingCalendarPageState extends State<BookingCalendarPage> {
  int year = 2024;
  int month = 10; // Start with October

  // Get the first day of the month and weekday name
  String getFirstDayOfMonth(int year, int month) {
    DateTime firstDay = DateTime(year, month, 1);
    List<String> weekdays = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];
    return weekdays[firstDay.weekday - 1];
  }

  void incrementMonth() {
    setState(() {
      if (month == 12) {
        month = 1;
        year += 1;
      } else {
        month += 1;
      }
    });
  }

  void decrementMonth() {
    setState(() {
      if (month == 1) {
        month = 12;
        year -= 1;
      } else {
        month -= 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String firstDay = getFirstDayOfMonth(year, month);

    // Get the number of days in the month
    int daysInMonth = DateTime(year, month + 1, 0).day;

    // Calculate the starting position for the first day of the month
    int firstDayIndex = getFirstDayOfMonth(year, month) == 'Sunday'
        ? 0
        : (DateTime(year, month, 1).weekday - 1);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [IconButton(onPressed: _logout, icon: Icon(Icons.logout))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title & Calendar
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Homestay Astana Ria D\'Raja',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '$year',
                          style: TextStyle(
                              fontSize: 28,
                              color: Colors.purple[900],
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          monthNames[month - 1].toUpperCase(),
                          style: TextStyle(
                              fontSize: 28,
                              color: Colors.purple[900],
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Days of the Week Row with Purple Background
                    Container(
                      color: Colors.purple,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                              child: Center(
                                  child: Text('SUN',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)))),
                          Expanded(
                              child: Center(
                                  child: Text('MON',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)))),
                          Expanded(
                              child: Center(
                                  child: Text('TUE',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)))),
                          Expanded(
                              child: Center(
                                  child: Text('WED',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)))),
                          Expanded(
                              child: Center(
                                  child: Text('THU',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)))),
                          Expanded(
                              child: Center(
                                  child: Text('FRI',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)))),
                          Expanded(
                              child: Center(
                                  child: Text('SAT',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Calendar Grid with Borders and White Background
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: daysInMonth + firstDayIndex,
                      // Total cells (empty + days)
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        childAspectRatio: 1.2,
                      ),
                      itemBuilder: (context, index) {
                        final day = (index >= firstDayIndex)
                            ? index - firstDayIndex + 1
                            : null;
                        final isWeekend = index % 7 == 0 ||
                            index % 7 == 6; // Sunday or Saturday

                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Center(
                            child: day != null
                                ? Text(
                                    '$day',
                                    style: TextStyle(
                                      color:
                                          isWeekend ? Colors.red : Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : const SizedBox
                                    .shrink(), // Empty box for placeholders
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Navigation and Search with Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: decrementMonth,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {},
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search, size: 18),
                          SizedBox(width: 8),
                          Text('CARIAN', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: incrementMonth,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Legend
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text('BOOKED', style: TextStyle(fontSize: 14)),
                      Text('8 DAYS',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Column(
                    children: [
                      Text('AVAILABLE', style: TextStyle(fontSize: 14)),
                      Text('23 DAYS',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _logout() {
    FirebaseAuth.instance.signOut();
  }
}

// Define month names for easy reference
const List<String> monthNames = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December"
];
