import 'package:flutter/material.dart';

class AuthBanner extends StatelessWidget {
  const AuthBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400.0,
      height: 400.0,
      child: Image.asset('assets/image/LogoGD.png', fit: BoxFit.contain,),
    );
  }
}