import 'dart:io';

import 'package:flutter/material.dart';



enum ContentType {
  check,
  num,
}


abstract class Condition {
  String title;
  int id;
  bool isCompleted = false;
  ContentType contentType;

  void toggle(){}
  void increment(int i){}
}


class BoolCondition  extends Condition{
  String title;
  int id;
  bool isCompleted = false;
  ContentType contentType = ContentType.check;

  BoolCondition({@required this.id, this.title}){
    this.title ??= 'Condtion${this.id}';
  }

  @override
  void toggle() {
    this.isCompleted = isCompleted ? false : true;
  }
}

class NumCondition extends Condition {
  String title = '';
  int id;
  bool isCompleted = false;
  ContentType contentType = ContentType.num;
  int count = 0;
  int total;

  NumCondition({@required this.id, this.title, @required this.total}){
    this.title ??= 'Condtion${this.id}';
  }

  @override
  void increment(int i){
    count += i;
    this.isCompleted = (this.count == this.total) ? true : false;
  }


  void reset() {
    this.count = 0;
    this.isCompleted = false;
  }

}