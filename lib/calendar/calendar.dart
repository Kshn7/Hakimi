import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'holiday/holiday.dart';

class BookingCalendarPage extends StatefulWidget {
  const BookingCalendarPage({super.key});

  @override
  _BookingCalendarPageState createState() => _BookingCalendarPageState();
}

class _BookingCalendarPageState extends State<BookingCalendarPage> {
  int year = DateTime.now().year;
  int month = DateTime.now().month;
  int? selectedDay;
  List<CalendarificHoliday> holidayDates = [];
  final Map<String, List<String>> bookings = {
    "2024-10-15": ["10:00 AM - John Doe", "2:00 PM - Jane Smith"],
    "2024-10-18": ["11:30 AM - Alice Brown"],
    "2024-10-20": ["1:00 PM - Bob Johnson", "3:00 PM - Clara Davis"],
  };

  @override
  void initState() {
    fetchHoliday(year, month);
    super.initState();
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
      setState(() {});
      fetchHoliday(year, month);
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
            Expanded(
                flex: size.width > 600 ? 3 : 2,
                child: buildCalendar(daysInMonth, firstDayIndex)),
            Flexible(
                flex: 1,
                child: HolidaysTable(
                    holidayDates: holidayDates, selectedMonth: month)),
          ],
        ),
      ),
    );
  }

  Column buildCalendar(int daysInMonth, int firstDayIndex) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        /// Month + Year Title
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: decrementMonth,
            ),
            Text(
              '${monthNames[month - 1]} $year',
              style: TextStyle(
                fontSize: screenWidth < 600 ? 20 : 28,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: incrementMonth,
            ),
          ],
        ),

        const SizedBox(height: 8),

        /// Weekdays Header
        Container(
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT']
                .map((d) => Expanded(
                      child: Center(
                        child: Text(
                          d,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),

        const SizedBox(height: 10),

        /// Day Grid
        Expanded(
          child: GridView.builder(
            physics: const ClampingScrollPhysics(),
            itemCount: daysInMonth + firstDayIndex,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.1,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemBuilder: (context, index) {
              final day =
                  (index >= firstDayIndex) ? index - firstDayIndex + 1 : null;
              final dateKey = day != null
                  ? "$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}"
                  : null;

              final isHoliday = dateKey != null &&
                  holidayDates.any((h) => h.dateIso == dateKey);

              final isToday = day == DateTime.now().day &&
                  month == DateTime.now().month &&
                  year == DateTime.now().year;

              final isSelected = day == selectedDay;

              final hasBooking = bookings.containsKey(dateKey);

              Color bgColor = Colors.white;
              if (isSelected) {
                bgColor = Colors.green[200]!;
              } else if (isToday) {
                bgColor = Colors.blue[100]!;
              } else if (isHoliday) {
                bgColor = Colors.red[100]!;
              } else if (hasBooking) {
                bgColor = Colors.orange[100]!;
              }

              return GestureDetector(
                onTap: day != null
                    ? () {
                        setState(() {
                          selectedDay = day;
                        });
                        showBookings(context, day);
                      }
                    : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  decoration: BoxDecoration(
                    color: bgColor,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      day != null ? '$day' : '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 10),

        /// Booking Summary
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _legendBox('Booked', Colors.orange[200]!),
              _legendBox('Holiday', Colors.red[200]!),
              _legendBox('Today', Colors.blue[100]!),
              _legendBox('Selected', Colors.green[200]!),
            ],
          ),
        ),

        const SizedBox(height: 10),

        /// Search Button
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: _showDateSearchDialog,
              icon: const Icon(Icons.calendar_month_outlined,
                  color: Colors.white),
              label: const Text(
                'Carian Tarikh',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                elevation: 4,
                shadowColor: Colors.deepPurpleAccent,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void showBookings(BuildContext context, int day) {
    final dateKey =
        "$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";
    final dayBookings = bookings[dateKey] ?? [];

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 12,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 300, maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Tempahan: $dateKey',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 12),
                if (dayBookings.isNotEmpty)
                  ...dayBookings
                      .map(
                        (booking) => Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple[50],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.schedule,
                                  color: Colors.deepPurple),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  booking,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList()
                else
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Tiada tempahan pada hari ini.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    label: const Text('Tutup'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.deepPurple,
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
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

  Future<void> fetchHoliday(
    int year,
    int month,
  ) async {
    final calendarific = CalendarificService();
    final holidays = await calendarific.getHolidays(year, month); // April 2025

    for (var h in holidays) {
      debugPrint('${h.dateIso}: ${h.name}');
    }
    holidayDates = holidays;
    setState(() {});
  }

  Widget _legendBox(String label, Color color) {
    return Column(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  void _showDateSearchDialog() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(year, month),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      helpText: 'Pilih Tarikh',
      cancelText: 'Batal',
      confirmText: 'Pilih',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.deepPurple,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        year = picked.year;
        month = picked.month;
        selectedDay = picked.day;
      });

      fetchHoliday(year, month);
      showBookings(context, picked.day);
    }
  }
}

class HolidaysTable extends StatelessWidget {
  final List<CalendarificHoliday> holidayDates;
  final int selectedMonth;

  const HolidaysTable({
    super.key,
    required this.holidayDates,
    required this.selectedMonth,
  });

  @override
  Widget build(BuildContext context) {
    if (holidayDates.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Tiada cuti untuk bulan ini.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Card(
        margin: const EdgeInsets.all(12),
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Senarai Cuti Bulan Ini',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 10),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: holidayDates.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final holiday = holidayDates[index];
                  final name = holiday.name;
                  final date = holiday.dateIso;

                  return ListTile(
                    leading: Container(
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(Icons.flag, color: Colors.redAccent),
                    ),
                    title: Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      date,
                      style: const TextStyle(color: Colors.black54),
                    ),
                    trailing: const Icon(Icons.calendar_today_outlined,
                        color: Colors.deepPurple),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void debugPrint(String s) {
  if (kDebugMode) print(s);
}
