import 'package:firebase_auth/firebase_auth.dart';
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
    return StreamBuilder<User?>(
      stream: Auth().authStateChanges, // Firebase Auth state listener
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          print("🔄 Waiting for authentication state...");
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          print("❌ Error: ${snapshot.error}");
          return Center(child: Text("Something went wrong. Please try again."));
        }

        if (snapshot.hasData) {
          print("✅ User is logged in: ${snapshot.data?.email}");
          return HomePage(onSignOut: () => Auth().signOut());
        } else {
          print("🔑 User is not logged in");
          return const LoginScreen();
        }
      },
    );
  }
}
