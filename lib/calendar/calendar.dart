import 'package:flutter/material.dart';

class BookingCalendarPage extends StatefulWidget {
  const BookingCalendarPage({super.key});

  @override
  _BookingCalendarPageState createState() => _BookingCalendarPageState();
}

class _BookingCalendarPageState extends State<BookingCalendarPage> {
  int year = DateTime.now().year;
  int month = DateTime.now().month; // Start with October
  int? selectedDay;

  final TextEditingController dateController = TextEditingController();
  final TextEditingController eventController = TextEditingController();

  // Mock data for bookings
  final Map<String, List<String>> bookings = {
    "2024-10-15": ["10:00 AM - John Doe", "2:00 PM - Jane Smith"],
    "2024-10-18": ["11:30 AM - Alice Brown"],
    "2024-10-20": ["1:00 PM - Bob Johnson", "3:00 PM - Clara Davis"],
  };

  void incrementMonth() {
    setState(() {
      if (month == 12) {
        month = 1;
        year += 1;
      } else {
        month += 1;
      }
      selectedDay = null;
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
      selectedDay = null;
    });
  }

  void jumpToDate(String input) {
    try {
      final DateTime date = DateTime.parse(input);
      setState(() {
        year = date.year;
        month = date.month;
        selectedDay = date.day;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid date format. Please use YYYY-MM-DD."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void showBookings(BuildContext context, int day) {
    final dateKey =
        "$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";
    final dayBookings = bookings[dateKey] ?? ["No bookings available"];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Bookings for $dateKey"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...dayBookings.map(
                (booking) =>
                    Text(booking, style: const TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  addBooking(context, dateKey);
                },
                child: const Text("Add Booking"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void addBooking(BuildContext context, String dateKey) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Booking for $dateKey"),
          content: TextField(
            controller: eventController,
            decoration:
                const InputDecoration(hintText: "Enter booking details"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  bookings.putIfAbsent(dateKey, () => []);
                  bookings[dateKey]!.add(eventController.text);
                  eventController.clear();
                });
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int daysInMonth = DateTime(year, month + 1, 0).day;
    int firstDayIndex = DateTime(year, month, 1).weekday % 7;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          // Search Bar

          const SizedBox(height: 16),
          // Calendar Header
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                // Days of the Week Row
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
                // Calendar Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: daysInMonth + firstDayIndex,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: 1.2,
                  ),
                  itemBuilder: (context, index) {
                    final day = (index >= firstDayIndex)
                        ? index - firstDayIndex + 1
                        : null;

                    return GestureDetector(
                      onTap: day != null
                          ? () {
                              setState(() {
                                selectedDay = day;
                              });
                              showBookings(context, day);
                            }
                          : null,
                      child: Container(
                        decoration: BoxDecoration(
                          color: day == selectedDay
                              ? Colors.green[100]
                              : Colors.white,
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Center(
                          child: day != null
                              ? Text(
                                  '$day',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
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
          const SizedBox(height: 40),
          // Navigation Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: decrementMonth,
              ),
              Expanded(
                child: TextField(
                  controller: dateController,
                  decoration: InputDecoration(
                    labelText: "Search Date (YYYY-MM-DD)",
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        jumpToDate(dateController.text);
                      },
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: incrementMonth,
              ),
            ],
          ),
        ],
      ),
    );
  }

  static const List<String> monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
}
