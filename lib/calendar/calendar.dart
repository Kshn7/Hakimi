import 'package:flutter/material.dart';
import 'package:homestay_form/api/api_holiday.dart';

class BookingCalendarPage extends StatefulWidget {
  const BookingCalendarPage({super.key});

  @override
  _BookingCalendarPageState createState() => _BookingCalendarPageState();
}

class _BookingCalendarPageState extends State<BookingCalendarPage> {
  int year = DateTime.now().year;
  int month = DateTime.now().month;
  int? selectedDay;
  List holidayDates = [];
  final Map<String, List<String>> bookings = {
    "2024-10-15": ["10:00 AM - John Doe", "2:00 PM - Jane Smith"],
    "2024-10-18": ["11:30 AM - Alice Brown"],
    "2024-10-20": ["1:00 PM - Bob Johnson", "3:00 PM - Clara Davis"],
  };

  @override
  void initState() {
    fetchHoliday(year.toString());
    super.initState();
  }

  // Future<void> fetchHolidays() async {
  //   final uri = Uri.https('holidayapi.com', '/v1/holidays', {
  //     'country': 'MY',
  //     'year': year.toString(),
  //     'month': month.toString(),
  //     'key': '0ba24f61-9795-4f75-b4c9-71afc2e556c0', // Your API key
  //     'public': 'true', // Optional filter for public holidays only
  //     'pretty': 'true' // Optional to prettify the response
  //   });
  //
  //   try {
  //     final response = await http.get(uri);
  //
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       setState(() {
  //         holidayDates = (data['holidays'] as List)
  //             .map((holiday) => holiday['date'] as String)
  //             .toList();
  //       });
  //     } else {
  //       throw Exception('Failed to fetch holidays: ${response.body}');
  //     }
  //   } catch (error) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text("Error fetching holidays: $error"),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }

  void incrementMonth() {
    setState(() {
      if (month == 12) {
        month = 1;
        year += 1;
        fetchHoliday(year.toString());
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
        fetchHoliday(year.toString());
      } else {
        month -= 1;
      }
      selectedDay = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    int daysInMonth = DateTime(year, month + 1, 0).day;
    int firstDayIndex = DateTime(year, month, 1).weekday % 7;
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            Row(
              children: [
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
                shrinkWrap: true,
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
            // Your holidays table
            HolidaysTable(holidayDates: holidayDates, selectedMonth: month),
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

  Future<void> fetchHoliday(String year) async {
    var holiday = await APIHoliday().fetchHoliday(year);
    holidayDates = holiday;
    setState(() {});
    //   {
    //     "name": "New Year's Day",
    //   "date": { "month": 1, "day": 1 },
    //   "formattedDate": "1 Jan",
    //   "weekday": { "numeric": 5, "name": "Friday" },
    //   "is_public": false,
    //   "is_observed": false,
    //   "is_religious": false,
    //   "type": "national holiday"
    // }
    setState(() {});
  }
}

class HolidaysTable extends StatelessWidget {
  final List holidayDates;
  final int selectedMonth;

  const HolidaysTable(
      {super.key, required this.holidayDates, required this.selectedMonth});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: holidayDates.length,
        itemBuilder: (context, index) {
          final holidayDate = holidayDates[index];
          final month = holidayDate['date']['month'];
          if (month != selectedMonth) return const SizedBox.shrink();
          return ListTile(
            title: Text(holidayDate['name']),
            subtitle: Text("${holidayDate['date']['day']}/$month"),
            trailing: const Icon(Icons.calendar_today),
          );
        },
      ),
    );
  }
}
