import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vizmo_task/Model/eventsListData.dart';

class ApiService {
  final String baseUrl =
      'https://mock.apidog.com/m1/561191-524377-default/Event';

  Future<List<Datum>> fetchEvents(DateTime date) async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      print(response.body);
      print(response.statusCode);
      EventsListData eventsListData = eventsListDataFromJson(response.body);
      return eventsListData.data;
    } else {
      throw Exception('Failed to load events');
    }
  }

  Future<void> updateEvent(Datum event) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${event.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(event.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update event');
    }
  }
}
