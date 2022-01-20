import 'package:flutter/material.dart';

import 'package:introduction_screen/introduction_screen.dart';

import './home_screen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IntroductionScreen(
          pages: [
            PageViewModel(
              title: "Pill Reminder",
              body:
              "By using this application, you can set a reminder for taking pill",
              image: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset(
                    "assets/images/pill.png",
                    height: 300.0,
                  ),
                ),
              ),
            ),
            PageViewModel(
              title: "Vaccine Reminder",
              body:
              "Also, you can set a reminder for taking vaccine as well if you need.",
              image: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset("assets/images/vaccine.png", height: 300.0),
                ),
              ),

            ),
            PageViewModel(
              title: "Health Care",
              body:
              "A complete health care support for you",
              image: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset("assets/images/health_care.png", height: 300.0),
                ),
              ),
            ),
          ],
          showNextButton: true,
          next: IconButton(
            icon: Icon(Icons.arrow_forward, color: Theme.of(context).primaryColor,),
          ),
          showSkipButton: true,
          skip: const Text("Skip", style: TextStyle(fontWeight: FontWeight.w600)),
          onSkip: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
          showDoneButton: true,
          done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
          onDone: () {
            // When done button is press
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
        ),
      ),
    );
  }
}
