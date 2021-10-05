import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_tree/widgets/line.dart';



class Arrow extends StatelessWidget {
  double x1, y1;
  double x2, y2;
  double width;
  Color color;
//
  double arrow_size;
//
  double angle;
  double length;
  double x, y;

  Widget widget;

  Arrow({@required double x1, @required double y1, @required double x2, @required double y2, double width=1, color=Colors.black, double arrow_size=6.0}){

    this.width = width;

    this.x1= x1+this.width/3;
    this.y1 = y1-this.width/3;
    this.x2 = x2+this.width/3;
    this.y2 = y2-this.width/3;

    this.x = this.x1;
    this.y = this.y1;
    if (x1 > x2) {
      this.x = this.x2;
      this.y = this.y2;
    }

    this.color = color;
    this.arrow_size = arrow_size;

    this.angle =  (this.x2 == this.x1) ?  (this.y1 < this.y2) ? pi/2 : -pi /2 : atan((y2-y1)/(x2-x1));
    this.length = sqrt(pow((x2-x1), 2)+pow((y2-y1), 2));
//    this.length = 100;
    this.widget = line();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget,
        CircleWidget(x1-arrow_size/2, y1-arrow_size/3, arrow_size),
        CircleWidget(x2-arrow_size/2, y2-arrow_size/3, arrow_size),
      ],
    );
    throw UnimplementedError();
  }

  Widget line(){
    return Positioned(
      left: this.x,
      top: this.y,
      width: this.length,
      height: this.width,
      child: Transform(
        child: Container(
          color: this.color,
        ),

        alignment: FractionalOffset.centerLeft,
        transform: new Matrix4.identity()
          ..rotateZ(angle),
      ),
    );
  }

  Widget CircleWidget(double x, double y, double size){
    return Positioned(
        left: x,
        top: y,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: this.color,
          ),
        )
    );

  }

}