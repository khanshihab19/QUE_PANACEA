import 'package:flutter/material.dart';

Widget inputBox({String title, TextEditingController controller, TextInputType keyboardType}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: '$title',
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
        ),
      ),
      keyboardType: keyboardType,
    ),
  );
}