import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class extralayout extends StatelessWidget {
  const extralayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hard Layout !!'),
      ),
      body: Column(
        children: [
          Expanded(child: Row(
            children: [
              Expanded(child: Container(
                color: Colors.yellowAccent,
              )),
              Expanded(child: Column(
                 children: [
                   Expanded(child: Row(
                     children: [
                       Expanded(child: Container(
                         color: Colors.cyanAccent,
                       )),
                       Expanded(child: Container(
                         color: Colors.blueAccent,
                       )),
                     ],
                   )),
                   Expanded(child: Row(
                     children: [
                       Expanded(child: Container(
                         color: Colors.purpleAccent,
                       )),
                       Expanded(child: Container(
                         color: Colors.redAccent  ,
                       )),
                     ],
                   ))
                 ],
              )),

            ],
          )),
          Expanded(child: Row(
            children: [
              Expanded(child: Container(
                color: Colors.white24,
              )),
            ],
          )),
          Expanded(child: Row(
            children: [
              Expanded(child: Container(
                color: Colors.deepOrange,
              )),
            ],
          )),
        ],
      ),
    );
  }
}
