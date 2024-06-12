import 'package:flutter/material.dart';
import 'package:todo_app/views/login_view.dart';
import 'package:todo_app/views/signup_view.dart';

class AuthView extends StatefulWidget {
  AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  bool state = true;

  void to() {
    setState(() {
      state = !state;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (state) {
      return LogInView(to);
    } else {
      return SignUpView(to);
    }
  }
}
