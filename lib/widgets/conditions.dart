import 'package:flutter/material.dart';

import 'package:task_tree/models/conditions.dart';
import 'package:task_tree/models/task_tree.dart';

Widget boolConditionWidget(TreeModel value, int id, BoolCondition condition) {
  return Card(
    child: CheckboxListTile(
      title: Text(condition.title),
      value: condition.isCompleted,
      onChanged: (bool b){
        value.toggleCondition(id, condition.id);
      },
    ),
  );
}

Widget numConditionWidget(TreeModel value, int id, NumCondition condition){
  return Card(
    child: Stack(
      children: [
        ListTile(
          title: Text(condition.title),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
//                color: Colors.redAccent,
                icon: Icon(Icons.remove, color: Colors.redAccent,),
                onPressed: (){
                  value.incrementCondition(id, condition.id, isDecrement: true);
                }
            ),

            Text("${condition.count}/${condition.total}"),

            IconButton(
                color: Colors.blueAccent,
                icon: Icon(Icons.add, color: Colors.blue,),
                onPressed: (){
                  value.incrementCondition(id, condition.id,);
                }
            ),

          ],
        ),
      ],
    ),

  );
}