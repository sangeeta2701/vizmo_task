import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vizmo_task/Screens/edit_screen.dart';
import 'package:vizmo_task/Utils/colors.dart';
import 'package:vizmo_task/Utils/constants.dart';

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
      appBar: AppBar(
        backgroundColor: themeColor,
        title: Text('My Events',style: appBarStyle,),
      centerTitle: true,),
      body: Column(
        children: [
          TableCalendar(
            calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: lightThemeColor,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                    color: themeColor,
                    shape: BoxShape.circle,
                    )),
            headerStyle: HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
            ),
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
                tempList = tempList
                    .where((event) =>
                        selectedDtaeFormat ==
                        DateFormat("dd-MM-yyyy").format(event.startAt))
                    .toList();
                print("Templist: ${tempList.length}");
              });

              // _loadEvents(_selectedDate);
            },
          ),
          tempList.isEmpty
              ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Center(
                    child: Text("No events for the day",style: blackContentStyle,),
                  ),
              )
              : Expanded(
                  child: ListView.builder(
                    itemCount: tempList.length,
                    itemBuilder: (context, index) {
                      final event = tempList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 20),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: lightThemeColor,
                              boxShadow: [
                                BoxShadow(
                                  color: gColor.withOpacity(0.5),
                                  spreadRadius: 3,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                )
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          event.title,
                                          style: blackHeadingStyle,
                                        ),
                                        Text(
                                          event.description,
                                          style: blackContentStyle,
                                        )
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        _editEvent(context, event);
                                      },
                                      icon: Icon(Icons.edit))
                                ]),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
