import 'package:flutter/material.dart';
import 'auth_form.dart';
import 'auth_banner.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: const [AuthBanner(), AuthForm()],
      ),
    );
  }
}
