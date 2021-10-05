import 'package:flutter/material.dart';
import 'package:task_tree/routes/routes.dart';
import 'package:fluro/fluro.dart';

import 'package:task_tree/widgets/line.dart';
import 'package:task_tree/widgets/arrow.dart';
import 'package:task_tree/widgets/node.dart';


class LineScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
      ),
      body: Stack(
        children: [
          Positioned(
            left: 10,
            top: 10,
            width: 100,
            height: 100,
            child: Container(
              color: Colors.red,
            ),
          ),

          NodeWidget(left: 30, top: 100, height: 80, width: 150,),

          Positioned(
            left: 200,
            top: 200,
            width: 100,
            height: 100,
            child: Container(
              color: Colors.blue,
            ),
          ),

          Positioned(
            left: 150,
            top: 500,
            width: 100,
            height: 100,
            child: Container(
              color: Colors.green,
            ),
          ),

//          LineWidget(x1: 60, y1: 60, x2: 250, y2: 250, width: 1,),

          Arrow(x1: 60, y1: 60, x2: 200, y2: 550, width: 1, color: Colors.cyan, arrow_size: 6, ),

//          LineWidget(x1: 250, y1: 250, x2: 200, y2: 550),

          LineWidget(x1: 250, y1: 250, x2: 60, y2: 60),

          LineWidget(x1: 200, y1: 550, x2: 250, y2: 250,),

          Arrow(x1: 200, y1: 200, x2: 250, y2: 200, color: Colors.amber, width: 3,),
          Arrow(x1: 250, y1: 200, x2: 250, y2: 250, color: Colors.amber, width: 3,),
          Arrow(x1: 250, y1: 250, x2: 200, y2: 250, color: Colors.amber, width: 3,),
          Arrow(x1: 200, y1: 250, x2: 200, y2: 200, color: Colors.amber, width: 3,),


          Arrow(x1: 200, y1: 60, x2: 250, y2: 40, color: Colors.deepPurple, width: 2,),
          Arrow(x1: 250, y1: 40, x2: 300, y2: 60, color: Colors.deepPurple, width: 2,),
          Arrow(x1: 300, y1: 60, x2: 250, y2: 80, color: Colors.deepPurple, width: 2,),
          Arrow(x1: 250, y1: 80, x2: 200, y2: 60, color: Colors.deepPurple, width: 2,)


        ],
      ),
    );
    throw UnimplementedError();
  }
}