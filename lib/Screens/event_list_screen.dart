import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vizmo_task/Screens/edit_screen.dart';

import '../API/api_service.dart';
import '../Model/eventsListData.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDate = DateTime.now();
  List<Datum> _events = [];
  List<Datum> tempList = [];
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadEvents(_selectedDate);
  }

  void _loadEvents(DateTime date) async {
    try {
      List<Datum> events = await _apiService.fetchEvents(date);
      setState(() {
        _events = events;
        print(_events.length);
      });
    } catch (e) {
      // Handle the exception
      print(e);
    }
  }

  void _editEvent(BuildContext context, Datum event) async {
    final editedEvent = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditScreen(event: event)),
    );

    if (editedEvent != null) {
      await _apiService.updateEvent(editedEvent);
      setState(() {
        int index = _events.indexWhere((e) => e.id == editedEvent.id);
        if (index != -1) {
          _events[index] = editedEvent;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Events')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _selectedDate,
            selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDate = selectedDay;
                print("Selected Date: $_selectedDate");
                tempList = _events;
                String selectedDtaeFormat =
                    DateFormat("dd-MM-yyyy").format(_selectedDate);
                print("Format: $selectedDtaeFormat");



               tempList =  tempList
                    .where((event) =>
                        selectedDtaeFormat ==
                        DateFormat("dd-MM-yyyy").format(event.startAt))
                    .toList();
                print("Templist: ${tempList.length}");
              });

              // _loadEvents(_selectedDate);
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tempList.length,
              itemBuilder: (context, index) {
                final event = tempList[index];
                return ListTile(
                  title: Text(event.title),
                  subtitle: Text(event.description),
                  onTap: () => _editEvent(context, event),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
