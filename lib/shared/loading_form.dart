import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

Widget loadingFrom() {
  return  SizedBox(
    width: double.infinity,
    height: double.infinity,
    child: Center(
      child: LoadingAnimationWidget.halfTriangleDot(
        color: const Color.fromARGB(255, 0, 0, 0),
        size: 30,
      ),
    ),
  );
}
