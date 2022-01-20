import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:que_panacea/services/auth.dart';
import '../widgets/input_box.dart';

class BloodPressureTrackerScreen extends StatefulWidget {
  @override
  _BloodPressureTrackerScreenState createState() => _BloodPressureTrackerScreenState();
}

class _BloodPressureTrackerScreenState extends State<BloodPressureTrackerScreen> {
  bool dateTimePicked = false;

  DateTime dateTime;

  var highPressureController = TextEditingController();
  var lowPressureController = TextEditingController();

  Future<void> _pickDateTime(BuildContext context) async {
    DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        minTime: DateTime.now(),
        maxTime: DateTime(2025, 6, 7), onChanged: (date) {
          print('change $date');
        }, onConfirm: (date) {
          print('confirm $date');
          setState(() {
            dateTime = date;
            dateTimePicked = true;
          });
        }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  void _addBloodPressure(BuildContext context) {
    AlertDialog alertDialog = AlertDialog(
      title: Text('Add Weight'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          inputBox(
            title: 'High Pressure',
            controller: highPressureController,
          ),
          inputBox(
            title: 'Low Pressure',
            controller: lowPressureController,
          ),
          TextButton(
              onPressed: () => _pickDateTime(context),
              child: Text(dateTimePicked ? DateFormat('yyyy-MM-dd').format(dateTime) : 'Pick Date & Time'))
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel')),
        TextButton(
            onPressed: () {
              final AuthBase auth =
              Provider.of<AuthBase>(context, listen: false);
              String userId = auth.currentUser.uid;

              FirebaseFirestore.instance
                  .collection('BloodPressureTracker')
                  .doc(userId)
                  .collection('userBloodPressures')
                  .doc(dateTime.toIso8601String())
                  .set({
                'highPressure': highPressureController.text,
                'lowPressure': highPressureController.text,
                'dateTime': dateTime.toIso8601String(),
              });
              setState(() {
                dateTimePicked = false;
                highPressureController.text = '';
                lowPressureController.text = '';
              });
              Navigator.of(context).pop();
              //else if(Platform.isIOS) MinimizeApp.minimizeApp();
            },
            child: Text('Add'))
      ],
    );

    showDialog(context: context, builder: (context) => alertDialog);
  }

  @override
  Widget build(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context, listen: false);
    String userId = auth.currentUser.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Pressure Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('BloodPressureTracker')
                .doc(userId)
                .collection('userBloodPressures')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        String date = snapshot.data.docs[index]['dateTime'];
                        DateTime dateTime = DateTime.parse(date);

                        date = DateFormat('yyyy-MM-dd').format(dateTime);
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Date: $date',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),

                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'High Pressure: ${snapshot.data.docs[index]['highPressure']}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Low Pressure: ${snapshot.data.docs[index]['lowPressure']}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      });
                } else {
                  return Text('There is no data');
                }
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.add),
          onPressed: () => _addBloodPressure(context)),
    );
  }
}
