import 'package:flutter/material.dart';
import 'package:vizmo_task/API/api_service.dart';
import 'package:vizmo_task/Utils/colors.dart';
import 'package:vizmo_task/Utils/constants.dart';

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
      appBar: AppBar(
        backgroundColor: themeColor,
        title: Text('Edit Event',style: appBarStyle,),centerTitle: true,),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16,horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  style: blackContentStyle,
                  initialValue: _title,
                  decoration: InputDecoration(labelText: 'Title',
                  labelStyle: blackContentStyle),
                  
                  onSaved: (value) {
                    _title = value!;
                  },
                ),
                TextFormField(
                  style: blackContentStyle,
                  initialValue: _description,
                  decoration: InputDecoration(labelText: 'Description',
                  labelStyle: blackContentStyle),
                  onSaved: (value) {
                    _description = value!;
                  },
                ),
                DropdownButtonFormField<Status>(
                  value: _status,
                  decoration: InputDecoration(labelText: 'Status',labelStyle: blackContentStyle),
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
                  style: blackContentStyle,
                  initialValue: _startAt.toIso8601String(),
                  decoration: InputDecoration(labelText: 'Start At',labelStyle: blackContentStyle),
                  onSaved: (value) {
                    _startAt = DateTime.parse(value!);
                  },
                ),
                TextFormField(
                  style: blackContentStyle,
                  initialValue: _duration.toString(),
                  decoration: InputDecoration(labelText: 'Duration',labelStyle: blackContentStyle),
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
                SizedBox(height: 30,),
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        
                        // Datum editedEvent = Datum(
                        //   createdAt: widget.event.createdAt,
                        //   title: _title,
                        //   description: _description,
                        //   status: _status,
                        //   startAt: _startAt,
                        //   duration: _duration,
                        //   id: widget.event.id,
                        //   images: _images,
                        // );
                        Navigator.pop(context);
                      }
                    },
                    child: Center(child: Text('Save',style: buttonStyle,)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
