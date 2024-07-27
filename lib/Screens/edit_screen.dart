import 'package:flutter/material.dart';

import '../Model/eventsListData.dart';


class EditScreen extends StatefulWidget {
  final Datum event;

  EditScreen({required this.event});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late Status _status;
  late DateTime _startAt;
  late int _duration;
  late List<String> _images;

  @override
  void initState() {
    super.initState();
    _title = widget.event.title;
    _description = widget.event.description;
    _status = widget.event.status;
    _startAt = widget.event.startAt;
    _duration = widget.event.duration;
    _images = widget.event.images;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Event')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Title'),
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) {
                  _description = value!;
                },
              ),
              DropdownButtonFormField<Status>(
                value: _status,
                decoration: InputDecoration(labelText: 'Status'),
                onChanged: (Status? newValue) {
                  setState(() {
                    _status = newValue!;
                  });
                },
                items: Status.values.map((Status status) {
                  return DropdownMenuItem<Status>(
                    value: status,
                    child: Text(status.toString().split('.').last),
                  );
                }).toList(),
              ),
              TextFormField(
                initialValue: _startAt.toIso8601String(),
                decoration: InputDecoration(labelText: 'Start At'),
                onSaved: (value) {
                  _startAt = DateTime.parse(value!);
                },
              ),
              TextFormField(
                initialValue: _duration.toString(),
                decoration: InputDecoration(labelText: 'Duration'),
                onSaved: (value) {
                  _duration = int.parse(value!);
                },
              ),
              TextFormField(
                initialValue: _images.join(', '),
                decoration: InputDecoration(labelText: 'Images'),
                onSaved: (value) {
                  _images = value!.split(',').map((e) => e.trim()).toList();
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Datum editedEvent = Datum(
                      createdAt: widget.event.createdAt,
                      title: _title,
                      description: _description,
                      status: _status,
                      startAt: _startAt,
                      duration: _duration,
                      id: widget.event.id,
                      images: _images,
                    );
                    Navigator.pop(context, editedEvent);
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
