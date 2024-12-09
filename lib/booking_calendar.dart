import 'package:flutter/material.dart';
import 'package:holiday_event_api/holiday_event_api.dart';
import 'package:table_calendar/table_calendar.dart';

class BookingCalendarPage extends StatefulWidget {
  const BookingCalendarPage({Key? key}) : super(key: key);

  @override
  State<BookingCalendarPage> createState() => _BookingCalendarPageState();
}

class _BookingCalendarPageState extends State<BookingCalendarPage> {
  final _client = HolidayEventApi(
      'j0kvnWOfTiDK2vP1ADyl0THt1W25FV7I'); // Replace with your API key
  Map<DateTime, List<String>> _events = {}; // Holds the holiday events
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEvents(); // Fetch events when the page is loaded
  }

  // Fetch holidays or events from the API
  Future<void> _fetchEvents() async {
    try {
      final response = await _client.getEvents();
      print('API Response: $response'); // Check if data is returned

      // Check if response contains events
      if (response.events.isEmpty) {
        print('No events found.');
      }

      final Map<DateTime, List<String>> events = {};
      for (var event in response.events) {
        DateTime date = DateTime.now(); // Adjust the date as needed
        events[date] = [event.name];
      }

      setState(() {
        _events = events;
        _isLoading = false;
      });
    } catch (e) {
      print('Error: $e'); // Show detailed error in console
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Holiday Calendar'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: TableCalendar(
                firstDay: DateTime(2024, 1, 1), // Start date
                lastDay: DateTime(2024, 12, 31), // End date
                focusedDay: DateTime.now(), // Today's date
                holidayPredicate: (day) {
                  return _events
                      .containsKey(day); // Mark the day if there's an event
                },
                calendarStyle: CalendarStyle(
                  holidayDecoration: BoxDecoration(
                    color: Colors.red, // Mark holidays with a red circle
                    shape: BoxShape.circle,
                  ),
                  holidayTextStyle: const TextStyle(color: Colors.white),
                ),
                eventLoader: (day) =>
                    _events[day] ?? [], // Show events on the day
              ),
            ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: BookingCalendarPage(), // Set the main page to BookingCalendarPage
  ));
}
