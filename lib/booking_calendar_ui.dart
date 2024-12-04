import 'package:flutter/material.dart';
import 'booking_calendar_backend.dart'; // Import your backend class

class BookingCalendarPage extends StatefulWidget {
  const BookingCalendarPage({super.key});

  @override
  _BookingCalendarPageState createState() => _BookingCalendarPageState();
}

class _BookingCalendarPageState extends State<BookingCalendarPage> {
  final BookingCalendarBackend backend = BookingCalendarBackend();
  List<DateTime> bookedDates = []; // List to store booked dates
  int year = 2024;
  int month = 10; // Start with October

  @override
  void initState() {
    super.initState();
    fetchBookedDates(); // Fetch booked dates when the app loads
  }

  Future<void> fetchBookedDates() async {
    final dates = await backend.fetchBookedDates();
    setState(() {
      bookedDates = dates; // Update the state with fetched dates
    });
  }

  Future<void> toggleBooking(DateTime date) async {
    final isBooked = bookedDates.contains(date);
    if (isBooked) {
      await backend.deleteBooking(date); // Delete booking if already booked
    } else {
      await backend.addBooking(date); // Add booking if not booked
    }
    await fetchBookedDates(); // Refresh the calendar
  }

  String getFirstDayOfMonth(int year, int month) {
    DateTime firstDay = DateTime(year, month, 1);
    List<String> weekdays = [
      "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"
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
    fetchBookedDates(); // Fetch updated bookings for the new month
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
    fetchBookedDates(); // Fetch updated bookings for the new month
  }

  @override
  Widget build(BuildContext context) {
    String firstDay = getFirstDayOfMonth(year, month);

    int daysInMonth = DateTime(year, month + 1, 0).day;
    int firstDayIndex = DateTime(year, month, 1).weekday % 7;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
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
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '$year',
                          style: TextStyle(fontSize: 28, color: Colors.purple[900], fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          monthNames[month - 1].toUpperCase(),
                          style: TextStyle(fontSize: 28, color: Colors.purple[900], fontWeight: FontWeight.bold),
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
                          Expanded(child: Center(child: Text('SUN', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)))),
                          Expanded(child: Center(child: Text('MON', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)))),
                          Expanded(child: Center(child: Text('TUE', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)))),
                          Expanded(child: Center(child: Text('WED', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)))),
                          Expanded(child: Center(child: Text('THU', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)))),
                          Expanded(child: Center(child: Text('FRI', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)))),
                          Expanded(child: Center(child: Text('SAT', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Calendar Grid with Borders and White Background
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: daysInMonth + firstDayIndex,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        childAspectRatio: 1.2,
                      ),
                      itemBuilder: (context, index) {
                        final day = (index >= firstDayIndex) ? index - firstDayIndex + 1 : null;
                        final currentDate = day != null ? DateTime(year, month, day) : null;
                        final isBooked = currentDate != null && bookedDates.contains(currentDate);

                        return GestureDetector(
                          onTap: () {
                            if (currentDate != null) {
                              toggleBooking(currentDate);
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isBooked ? Colors.red : Colors.white,
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Center(
                              child: day != null
                                  ? Text(
                                '$day',
                                style: TextStyle(
                                  color: isBooked ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                                  : const SizedBox.shrink(),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Navigation and Search
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
                      Text('8 DAYS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Column(
                    children: [
                      Text('AVAILABLE', style: TextStyle(fontSize: 14)),
                      Text('23 DAYS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
}

// Define month names for easy reference
const List<String> monthNames = [
  "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"
];
