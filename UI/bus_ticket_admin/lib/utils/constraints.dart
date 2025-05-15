import 'package:flutter/material.dart';

const kPrimaryColor = Color.fromRGBO(33, 150, 243, 1);
const kPrimaryLightColor = Color.fromARGB(255, 245, 237, 255);

const double defaultPadding = 16.0;

final kBoxDecorationStyle = BoxDecoration(
  color: Color.fromARGB(255, 255, 255, 255),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);
