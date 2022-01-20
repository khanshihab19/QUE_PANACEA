import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:que_panacea/ui/screens/all_reminders_screen.dart';
import 'package:que_panacea/ui/screens/blood_pressure_tracker_screen.dart';
import 'package:que_panacea/ui/screens/bmi_calculator_screen.dart';
import 'package:que_panacea/ui/screens/reminder_screen.dart';
import 'package:que_panacea/ui/screens/wight_tracker_screen.dart';

class GridItem extends StatelessWidget {
  final String title;
  final IconData icon;

  GridItem({@required this.title, @required this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (title == 'Pill Reminder' ||
            title == 'Vaccine Reminder' ||
            title == 'Dr. Appointment Reminder') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReminderScreen(pageTitle: title,),
            ),
          );
        }else if (title == 'All Reminders') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AllRemindersScreen(),
            ),
          );
        }else if (title == 'Blood Pressure Tracker') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BloodPressureTrackerScreen(),
            ),
          );
        }else if (title == 'Weight Tracker') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WeightTrackerScreen(),
            ),
          );
        }else if (title == 'BMI Calculator') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BMICalculatorScreen(),
            ),
          );
        }else if (title == 'Exit App') {

          AlertDialog alertDialog = AlertDialog(
            title: Text('Are you sure you want to exit?'),
            actions: [
              TextButton(onPressed: (){
                Navigator.of(context).pop();
              }, child: Text('Cancel')),
              TextButton(onPressed: (){
               if(Platform.isAndroid) SystemChannels.platform.invokeMethod('SystemNavigator.pop');
               //else if(Platform.isIOS) MinimizeApp.minimizeApp();
              }, child: Text('Confirm'))
            ],
          );

          showDialog(context: context, builder: (context) => alertDialog);
        }
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FaIcon(
              icon,
              size: 30,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FittedBox(
                  child: Text(
                title,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).accentColor),
              )),
            )
          ],
        ),
      ),
    );
  }
}
