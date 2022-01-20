import 'package:flutter/material.dart';

Widget dropdownForm(String title, List<String> list, Function onChanged){
  String initValue = list[0];


  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: DropdownButtonFormField(
      items: list.map((String value) {
        return DropdownMenuItem(
          child: Text(value),
          value: value,
        );
      }).toList(),
      onTap: () {
      },
      value: initValue,
      onChanged: onChanged,

    ),
  );
}