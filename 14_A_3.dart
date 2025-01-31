import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Birthday Card',
      home: BirthdayCard(name: "Alice", age: 25),
    );
  }
}

class BirthdayCard extends StatelessWidget {
  final String name;
  final int age;

  BirthdayCard({required this.name, required this.age});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Happy Birthday!')),
      body: Center(
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("🎉 Happy Birthday $name! 🎂",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text("You are now $age years old!",
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: 20),
                Image.network(
                    'https://www.pngall.com/wp-content/uploads/5/Birthday-Balloons-PNG-Image.png',
                    height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
