import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:que_panacea/services/auth.dart';

class AllRemindersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context, listen: false);
    String userId = auth.currentUser.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text('All reminders'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Reminders')
              .doc(userId)
              .collection('userReminders')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              child: Text(
                                'Type: ${snapshot.data.docs[index]['type']}',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 8,),
                            Text(
                              'ID: ${snapshot.data.docs[index]['reminderId']}',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 8,),
                            Text(
                              'Title: ${snapshot.data.docs[index]['title']}',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 8,),
                            Text(
                              'Description: ${snapshot.data.docs[index]['description']}',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 8,),
                            if(snapshot.data.docs[index]['type']!= 'Dr. Appointment Reminder')Text(
                              'Dose: ${snapshot.data.docs[index]['dose']}',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 8,),
                            Text(
                              'Repeat: ${snapshot.data.docs[index]['repeat']}',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 8,),
                            Text(
                              'Date & Time: ${snapshot.data.docs[index]['dateTime']}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    });
              } else {
                return Text('There is no data');
              }
            }
          },
        ),
      ),
    );
  }
}
