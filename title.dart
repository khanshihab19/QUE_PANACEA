import 'package:flutter/material.dart';

Widget title(String title) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      '$title',
      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
    ),
  );
}
