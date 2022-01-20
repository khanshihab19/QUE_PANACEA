import 'package:flutter/material.dart';

import '../widgets/title.dart';
import '../widgets/input_box.dart';

class BMICalculatorScreen extends StatefulWidget {
  @override
  _BMICalculatorScreenState createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  RangeValues _currentRangeValues = RangeValues(0, 0);
  Color _activeColor = Colors.grey;

  var _heightFeetController = TextEditingController();

  var _heightInchController = TextEditingController();

  var _weightController = TextEditingController();

  bool _showLoading = false;

  String output = "";

  void _calculateBMI() async {
    setState(() {
      _showLoading = true;
    });
    double heightFeet = double.parse(_heightFeetController.text);
    //Converting feet to meter.
    heightFeet *= 0.3048;

    double heightInch = double.parse(_heightInchController.text);
    //converting inch to meter
    heightInch *= 0.0254;

    double height = heightFeet + heightInch;

    double weight = double.parse(_weightController.text);

    setState(() {
      double bmi = weight / (height * height);

      output = bmi.toStringAsFixed(1);
      if (bmi < 18.5) {
        output += ' (underweight)';
        _currentRangeValues = RangeValues(0, 18.5);
        _activeColor = Colors.blue;
      } else if (bmi >= 18.5 && bmi <= 24.9) {
        output += ' (healthy)';
        _currentRangeValues = RangeValues(18.5, 24.9);
        _activeColor = Colors.green;
      } else if (bmi >= 25 && bmi <= 29.9) {
        output += ' (overweight)';
        _currentRangeValues = RangeValues(25, 29.9);
        _activeColor = Colors.yellow;
      } else if (bmi >= 30 && bmi <= 39.9) {
        output += ' (obese)';
        _currentRangeValues = RangeValues(30, 39.9);
        _activeColor = Colors.red;
      }
      _showLoading = false;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                title('Your height'),
                Expanded(child: inputBox(title: 'Feet', controller: _heightFeetController, keyboardType: TextInputType.number)),
                Expanded(child: inputBox(title: 'Inch', controller: _heightInchController, keyboardType: TextInputType.number)),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                title('Your weight'),
                Expanded(child: inputBox(title: 'KG', controller: _weightController, keyboardType: TextInputType.number)),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: _calculateBMI,
              child: Text('Calculate'),
            ),
            SizedBox(
              height: 20,
            ),
            !_showLoading
                ? title('Your BMI is: $output')
                : CircularProgressIndicator(),
            SizedBox(
              height: 20,
            ),

          ],
        ),
      ),
    );
  }
}
