import 'package:flutter/material.dart';
import 'package:mat_app/authentication.dart';
import 'package:mat_app/main.dart';
import 'package:mat_app/login_screen.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        print('Auth state changed: ${snapshot.connectionState}');
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for the authentication state
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          print('User is logged in');
          return MatrimonyApp();
        } else {
          print('User is not logged in');
          return const LoginScreen();
        }
      },
    );
  }
}
