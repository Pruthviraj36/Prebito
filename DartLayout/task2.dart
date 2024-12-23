import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class extralayout2 extends StatelessWidget {
  const extralayout2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("2nd Hard Layout !!"),
      ),
      body: Column(
        children: [
          Expanded(child: Row(
            children: [
              Expanded(flex: 3,child: Container(
                color: Colors.brown,
              )),
              Expanded(child: Container(
                color: Colors.cyan,
              ))
            ],
          )),
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
                         color: Colors.cyan[200],
                       )),
                       Expanded(child: Container(
                         color: Colors.blueGrey[200],
                       ))
                     ],
                   )),
                   Expanded(child: Row(
                     children: [
                       Expanded(child: Container(
                         color: Colors.purpleAccent[200],
                       )),
                       Expanded(child: Container(
                         color: Colors.red[200],
                       ))
                     ],
                   )),
                 ],

               )),
               Expanded(child: Container(
                 color: Colors.blue[500],
               ))
             ],
          )),
          Expanded(child: Row(
            children: [
              Expanded(child: Container(
                color: Colors.black,
              )),
              Expanded(child: Container(
                color: Colors.white,
              )),
              Expanded(child: Container(
                color: Colors.black,
              )),
              Expanded(child: Container(
                color: Colors.white,
              ))
            ],
          )),
         Expanded(child: Row(
           children: [
             Expanded(child: Column(
               children: [
                 Expanded(child: Row(
                   children: [
                     Expanded(child:Container(
                       color: Colors.blue,
                     )),
                     Expanded(child: Column(
                       children: [
                         Expanded(child: Row(
                           children: [
                             Expanded(child: Container(color: Colors.yellow,)),
                             Expanded(child: Container(color: Colors.purple,))
                           ],
                         )),
                         Expanded(child: Row(
                           children: [
                             Expanded(child: Container(color: Colors.green,)),
                             Expanded(child: Container(color: Colors.pink,))
                           ],
                         ))
                       ],
                     ))
                   ],
                 )),
                 Expanded(child: Row(children: [
                   Expanded(child: Container(
                     color: Colors.pink,
                   )),
                   Expanded(child: Container(
                     color: Colors.orange,
                   ))
                 ],))
               ],
             )),
             Expanded(child: Container(
               color:
               Colors.blue[100],
             )),
             Expanded(child: Column(
               children: [
                 Expanded(child: Row(
                   children: [
                     Expanded(child:Container(
                       color: Colors.blue,
                     )),
                     Expanded(child: Column(
                       children: [
                         Expanded(child: Row(
                           children: [
                             Expanded(child: Container(color: Colors.yellow,)),
                             Expanded(child: Container(color: Colors.purple,))
                           ],
                         )),
                         Expanded(child: Row(
                           children: [
                             Expanded(child: Container(color: Colors.green,)),
                             Expanded(child: Container(color: Colors.grey,))
                           ],
                         ))
                       ],
                     ))
                   ],
                 )),
                 Expanded(child: Row(children: [
                   Expanded(child: Container(
                     color: Colors.pink,
                   )),
                   Expanded(child: Container(
                     color: Colors.orange,
                   ))
                 ],))
               ],
             )),
           ],
         ))
        ],
      ),
    );
  }
}
