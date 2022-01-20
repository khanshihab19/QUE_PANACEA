import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:que_panacea/services/auth.dart';

import '../widgets/grid_item.dart';

class HomeScreen extends StatelessWidget {
  final List<GridItem> gridItems = [
    GridItem(title: 'Pill Reminder', icon: FontAwesomeIcons.pills),
    GridItem(title: 'Vaccine Reminder', icon: FontAwesomeIcons.viruses),
    GridItem(
        title: 'Dr. Appointment Reminder',
        icon: FontAwesomeIcons.connectdevelop),
    GridItem(title: 'All Reminders', icon: FontAwesomeIcons.list),
    GridItem(title: 'Blood Pressure Tracker', icon: FontAwesomeIcons.heartbeat),
    GridItem(title: 'Weight Tracker', icon: Icons.line_weight),
    GridItem(title: 'BMI Calculator', icon: Icons.devices_other),
    GridItem(title: 'Exit App', icon: Icons.exit_to_app_sharp),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              height: 100,
              width: 150,
              alignment: Alignment.center,
              child: Image.asset('assets/images/health_care.png'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Que Panacea',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              ),
            ),
            Text(
              'A Digital Health Care Solution',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor),
            ),
            SizedBox(height: 8,),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(8.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 10),
                itemBuilder: (context, index) => GridItem(
                    title: gridItems[index].title, icon: gridItems[index].icon),
                itemCount: gridItems.length,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: IconButton(icon: Icon(Icons.logout, color: Colors.white,),),
        onPressed: () async {
          final AuthBase auth = Provider.of<AuthBase>(context, listen: false);
          await auth.signOut();
        },
      ),
    );
  }
}
