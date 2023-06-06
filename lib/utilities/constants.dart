import 'package:flutter/material.dart';

const apiKey = 'e8af3fc706fe6546af5dca2c4b954fe0';

const kTextFieldDecoration = InputDecoration(
  fillColor: Colors.white10,
  filled: true,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
    borderSide: BorderSide.none,
  ),
  hintText: 'Enter City Name',
  hintStyle: TextStyle(
    fontSize: 16,
  ),
  prefixIcon: Icon(Icons.search),
);
