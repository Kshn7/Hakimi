import 'dart:convert';

import 'package:http/http.dart' as http;

class APIHoliday {
  String apikey = '6af50567-ae8f-439b-8202-8dc846239089';
  String baseURL = 'https://freeholidayapi.com';
  String iso2 = 'MY';

  // fetchCounty<List>() async {
  //   final response = await http.get(Uri.parse('$baseURL/api/v1/countries'));
  //
  //   if (response.statusCode == 200) {
  //     // If the server returns a successful response
  //     var data = json.decode(response.body);
  //     getISO2(data);
  //     return data;
  //   } else {
  //     // If the server returns an error
  //     throw Exception('Failed to load data');
  //   }
  // }

  // void getISO2(List data) {
  //   var filterData = data.where((e) => e['country'] == 'Malaysia').first;
  //   iso2 = filterData['iso2'];
  //   print(iso2);
  // }

  fetchHoliday(String year) async {
    final response = await http.get(Uri.parse(
        '$baseURL/api/v1/holidays?country=$iso2&year=$year&apiKey=$apikey'));

    if (response.statusCode == 200) {
      // If the server returns a successful response
      List data = json.decode(response.body);
      return data;
    } else {
      // If the server returns an error
      throw Exception('Failed to load data');
    }
  }
}
