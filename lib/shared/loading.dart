import 'package:flutter/material.dart';

Widget loading(){
  return  const SizedBox(
    width: double.infinity,
    height: double.infinity,
      child: Center(
        child: CircularProgressIndicator(), // Widget circular progress indicator
      ),
    );
}