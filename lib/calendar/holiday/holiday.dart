import 'dart:convert';

import 'package:homestay_form/calendar/calendar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CalendarificHoliday {
  final String name;
  final String dateIso;
  final String description;

  CalendarificHoliday({
    required this.name,
    required this.dateIso,
    required this.description,
  });

  factory CalendarificHoliday.fromJson(Map<String, dynamic> json) {
    final dateMap = json['date'] as Map<String, dynamic>? ?? {};
    final isoDate = dateMap['iso'];

    return CalendarificHoliday(
      name: json['name'] ?? 'Unnamed',
      dateIso: isoDate, // ← this is already a String
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dateIso': dateIso,
      'description': description,
    };
  }
}

class CalendarificService {
  final String apiKey =
      'wxsRsbfqrxrhSaXGlbIaLFmqMmjeOoas'; // replace with your key
  final String baseUrl = 'https://calendarific.com/api/v2/holidays';

  Future<List<CalendarificHoliday>> getHolidays(int year, int month) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'holidays_${year}_$month';
    // prefs.remove(cacheKey);
    // Check if already cached
    if (prefs.containsKey(cacheKey)) {
      final cachedData = prefs.getString(cacheKey);

      if (cachedData != null) {
        final List<dynamic> jsonList = jsonDecode(cachedData);

        // ✅ Now parse using your simplified model
        return jsonList
            .map((e) => CalendarificHoliday(
                  name: e['name'],
                  dateIso: e[
                      'dateIso'], // <- this matches your own `toJson()` format
                  description: e['description'],
                ))
            .toList();
      }
    } else {
      print("No date");
    }

    // If not cached, fetch from API
    final url = Uri.parse(
        '$baseUrl?api_key=$apiKey&country=MY&year=$year&month=$month');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> holidaysJson = json['response']['holidays'];
      debugPrint(jsonEncode(json['response']['holidays']));

      final holidays =
          holidaysJson.map((e) => CalendarificHoliday.fromJson(e)).toList();

      // Save to local storage
      final jsonToSave = holidays.map((e) => e.toJson()).toList();
      prefs.setString(cacheKey, jsonEncode(jsonToSave));

      return holidays;
    } else {
      throw Exception('Failed to fetch holidays: ${response.statusCode}');
    }
  }
}
