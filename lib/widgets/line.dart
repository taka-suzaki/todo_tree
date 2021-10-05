import 'dart:math';

import 'package:flutter/material.dart';

class LineWidget extends StatelessWidget{
  double x1;
  double y1;
  double x2;
  double y2;
  double width = 1;
  Color color = Colors.black;
  double angle;
  double length;

  double x;
  double y;

  Widget widget;

  LineWidget({@required double x1, @required double y1, @required double x2, @required double y2, double width = 1, color=Colors.black,}){
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

    this.angle =  (this.x2 == this.x1) ?  (this.y1 < this.y2) ? pi/2 : -pi /2 : atan((y2-y1)/(x2-x1));
    this.length = sqrt(pow((x2-x1), 2)+pow((y2-y1), 2));
//    this.length = 100;
    this.widget = line();
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

  @override
  Widget build(BuildContext context) {
//    print(widget.toStringDeep());
    return widget;
  }

}