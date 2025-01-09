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
        height: size.height * 0.9,
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
            Flexible(
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
                                : day == DateTime.now().day &&
                                        month == DateTime.now().month &&
                                        year == DateTime.now().year
                                    ? Colors.grey
                                    : holidayDates.any((e) =>
                                            e['date']['month'] == month &&
                                            e['date']['day'] == day)
                                        ? Colors.pink
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
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
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
