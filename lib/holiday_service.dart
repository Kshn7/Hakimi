import 'dart:convert';

import 'package:http/http.dart' as http;

class HolidayService {
  static const String _baseUrl = "https://calendarific.com/api/v2/holidays";
  static const String _apiKey =
      "j0kvnWOfTiDK2vP1ADyl0THt1W25FV7I"; // Replace with your API key
  static const String _country = "MY"; // Country code for Malaysia

  static Future<List<DateTime>> fetchHolidays(int year) async {
    final response = await http.get(
      Uri.parse("$_baseUrl?api_key=$_apiKey&country=$_country&year=$year"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final holidays = data['response']['holidays'] as List;

      return holidays.map<DateTime>((holiday) {
        return DateTime.parse(holiday['date']['iso']);
      }).toList();
    } else {
      throw Exception('Failed to load holidays');
    }
  }
}
