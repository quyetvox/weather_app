import 'package:flutter/material.dart';

Widget textEmptyData(String value) {
  return Center(
      child: Text(
    '$value not match data!',
    style: const TextStyle(color: Colors.white),
  ));
}

Widget textNotFoundData(String value) {
  return Center(
      child: Text(
    'Cannot found data $value!',
    style: const TextStyle(color: Colors.white),
  ));
}