import 'package:flutter/material.dart';
import 'package:holiday_event_api/holiday_event_api.dart';

class BookingCalendarPage extends StatefulWidget {
  const BookingCalendarPage({super.key});

  @override
  _BookingCalendarPageState createState() => _BookingCalendarPageState();
}

class _BookingCalendarPageState extends State<BookingCalendarPage> {
  int year = DateTime.now().year;
  int month = DateTime.now().month;
  int? selectedDay;
  List<String> holidayDates = [];

  final Map<String, List<String>> bookings = {
    "2024-10-15": ["10:00 AM - John Doe", "2:00 PM - Jane Smith"],
    "2024-10-18": ["11:30 AM - Alice Brown"],
    "2024-10-20": ["1:00 PM - Bob Johnson", "3:00 PM - Clara Davis"],
  };

  @override
  void initState() {
    super.initState();
    fetchHolidays();
  }

  Future<void> fetchHolidays() async {
    final apiClient = HolidayEventApi('j0kvnWOfTiDK2vP1ADyl0THt1W25FV7I');

    try {
      final events = await apiClient.getEvents(adult: false);

      // Attempting to extract dates from the event name
      setState(() {
        holidayDates = events.events
            .map((event) {
              // Assuming event.name might contain a date in the format '2024-12-25' or similar
              final eventName = event.name;
              final dateMatch =
                  RegExp(r'\d{4}-\d{2}-\d{2}').firstMatch(eventName);
              if (dateMatch != null) {
                return dateMatch.group(0) ?? '';
              } else {
                return ''; // Return empty if no valid date is found
              }
            })
            .where((date) => date.isNotEmpty) // Remove any empty strings
            .toList();
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error fetching holidays: $error"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
    fetchHolidays();
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
    fetchHolidays();
  }

  @override
  Widget build(BuildContext context) {
    int daysInMonth = DateTime(year, month + 1, 0).day;
    int firstDayIndex = DateTime(year, month, 1).weekday % 7;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: decrementMonth,
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: incrementMonth,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              '${monthNames[month - 1]} $year',
              style: TextStyle(
                fontSize: 24,
                color: Colors.purple[900],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                shrinkWrap: true, // Solves the infinite size issue
                physics: const ClampingScrollPhysics(),
                itemCount: daysInMonth + firstDayIndex,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  final day = (index >= firstDayIndex)
                      ? index - firstDayIndex + 1
                      : null;

                  final dateKey = day != null
                      ? "$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}"
                      : null;

                  final isHoliday =
                      dateKey != null && holidayDates.contains(dateKey);

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
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: day == selectedDay
                            ? Colors.green[100]
                            : isHoliday
                                ? Colors.red[100]
                                : Colors.white,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
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
            ),
          ],
        ),
      ),
    );
  }

  void showBookings(BuildContext context, int day) {
    final dateKey =
        "$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";
    final dayBookings = bookings[dateKey] ?? [];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Bookings for $dateKey'),
        content: dayBookings.isNotEmpty
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: dayBookings.map((booking) => Text(booking)).toList(),
              )
            : const Text('No bookings for this day.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
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
