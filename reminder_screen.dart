import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:que_panacea/model/reminder.dart';
import 'package:que_panacea/services/auth.dart';
import 'package:que_panacea/services/local_notify_manager.dart';
import 'package:que_panacea/ui/widgets/dropdown_form.dart';
import 'package:date_time_picker/date_time_picker.dart';

import '../widgets/title.dart';
import '../widgets/input_box.dart';

class ReminderScreen extends StatefulWidget {
  @override
  _ReminderScreenState createState() => _ReminderScreenState();

  ReminderScreen({this.pageTitle});

  String pageTitle;
}

class _ReminderScreenState extends State<ReminderScreen> {
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    localNotifyManager.setOnNotificationReceive(onNotificationReceive);
    localNotifyManager.setOnNotificationClick(onNotificationClick);
  }

  onNotificationReceive(ReceiveNotification notification) {
    print('Notification Received: ${notification.id}');
  }

  onNotificationClick(String payload) {
    print('Payload: $payload');

    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => SecondScreen(
    //           payload: payload,
    //         )));
  }

  List<String> _list = ['Daily', 'Weekly', 'Monthly'];

  List<String> _doseList = ['0.5mg', '1mg', '10mg'];
  DateTime selectedDateTime = DateTime.now();

  String selectedValue = 'Daily';
  String selectedDose = '0.5mg';

  void onRepeatChanged(String value) {
    selectedValue = value;
    print(value);
  }

  void onDoseChanged(String value) {
    selectedDose = value;
    print(value);
  }

  Future<void> _selectTime(BuildContext context) async {
    DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        minTime: DateTime.now(),
        maxTime: DateTime(2025, 6, 7), onChanged: (date) {
      print('change $date');
    }, onConfirm: (date) {
      print('confirm $date');
      setState(() {
        selectedDateTime = date;
      });
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  void _saveReminder() async {
    String type = widget.pageTitle;

    int id = Random().nextInt(1000000);
    Reminder reminder = Reminder(
        reminderId: id,
        title: titleController.text,
        description: descriptionController.text,
        dose: selectedDose,
        dateTime: selectedDateTime,
        repeat: selectedValue,
        type: type);

    await localNotifyManager.scheduleNotification(reminder);

    final AuthBase auth = Provider.of<AuthBase>(context, listen: false);
    String userId = auth.currentUser.uid;

    FirebaseFirestore.instance
        .collection('Reminders')
        .doc(userId)
        .collection('userReminders')
        .doc(reminder.reminderId.toString())
        .set({
      'reminderId': reminder.reminderId,
      'title': reminder.title,
      'description': reminder.description,
      'dose': reminder.dose,
      'type': reminder.type,
      'repeat': reminder.repeat,
      'dateTime': reminder.dateTime.toIso8601String(),
    });
  }

  @override
  Widget build(BuildContext context) {

    String tempTitle = widget.pageTitle == 'Pill Reminder'
        ? 'Pill'
        : widget.pageTitle == 'Vaccine Reminder'
        ? 'Vaccine'
        : 'Doctor';
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pageTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              title('Add New Reminder'),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: title('$tempTitle Name'),
                  ),
                  Expanded(
                    child: inputBox(
                        title: '$tempTitle Name', controller: titleController),
                  ),

                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: title('Description'),
                  ),

                  Expanded(
                    child: inputBox(
                        title: 'Description', controller: descriptionController),
                  ),
                ],
              ),
              if(tempTitle != 'Doctor')
                Row(
                children: [
                  Expanded(
                    child: title('Dosage'),
                  ),
                  Expanded(
                    child: dropdownForm('Dosage', _doseList, onDoseChanged),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: title('Remind Me'),
                  ),
                  Expanded(
                    child: dropdownForm('Reminder', _list, onRepeatChanged),
                  )
                ],
              ),
              TextButton(
                onPressed: () {
                  _selectTime(context);
                },
                child: Text('Pick Time'),
              ),
              ElevatedButton(
                  onPressed: _saveReminder, child: Text('Save Reminder')),
            ],
          ),
        ),
      ),
    );
  }
}
