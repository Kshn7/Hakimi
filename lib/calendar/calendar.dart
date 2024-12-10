import 'package:flutter/material.dart';
import 'package:homestay_form/holiday_service.dart';
// Import the HolidayService

class BookingCalendarPage extends StatefulWidget {
  const BookingCalendarPage({super.key});

  @override
  _BookingCalendarPageState createState() => _BookingCalendarPageState();
}

class _BookingCalendarPageState extends State<BookingCalendarPage> {
  int year = 2024;
  int month = 10;
  List<DateTime> holidays = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHolidaysForYear(year); // Fetch holidays for the initial year
  }

  Future<void> fetchHolidaysForYear(int year) async {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    try {
      List<DateTime> fetchedHolidays = await HolidayService.fetchHolidays(year);
      setState(() {
        holidays = fetchedHolidays;
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching holidays: $error');
      setState(() {
        isLoading = false;
      });
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
      fetchHolidaysForYear(year); // Update holidays when navigating
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
      fetchHolidaysForYear(year); // Update holidays when navigating
    });
  }

  bool isHoliday(DateTime date) {
    return holidays.any((holiday) =>
        holiday.year == date.year &&
        holiday.month == date.month &&
        holiday.day == date.day);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    int daysInMonth = DateTime(year, month + 1, 0).day;
    int firstDayIndex =
        DateTime(year, month, 1).weekday - 1; // Get weekday (0 = Sunday)

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title and Navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: decrementMonth,
                ),
                Text(
                  '${monthNames[month - 1]} $year',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: incrementMonth,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Calendar Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount:
                  daysInMonth + firstDayIndex, // Days + empty placeholders
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1.2,
              ),
              itemBuilder: (context, index) {
                final day = (index >= firstDayIndex)
                    ? index - firstDayIndex + 1
                    : null; // Calculate day
                final isWeekend = index % 7 == 0 || index % 7 == 6;

                return Container(
                  decoration: BoxDecoration(
                    color: isHoliday(DateTime(year, month, day ?? 1))
                        ? Colors.green
                        : Colors.white,
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Center(
                    child: day != null
                        ? Text(
                            '$day',
                            style: TextStyle(
                              color: isWeekend ? Colors.red : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Month Names
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
