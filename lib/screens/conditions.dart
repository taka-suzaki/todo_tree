import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_tree/models/task_tree.dart';
import 'package:task_tree/models/conditions.dart';
import 'package:task_tree/widgets/conditions.dart';


class ConditionsScreen extends StatefulWidget {
  int nodeId;

  ConditionsScreen(this.nodeId);
  _ConditionScreenState createState() => _ConditionScreenState(this.nodeId);
}

class _ConditionScreenState extends State<ConditionsScreen> {
  int nodeId;


  TextEditingController titleEditController = TextEditingController(text: '');
  ContentType contentType = ContentType.check;
  TextEditingController numEditController = TextEditingController(text: '');

  _ConditionScreenState(this.nodeId);


  @override
  Widget build(BuildContext context) {
    print('condition');
    var _TreeModel = Provider.of<TreeModel>(context);
    return Consumer<TreeModel>(
        builder: (BuildContext context, TreeModel value, Widget child) {
          Node model = value.all_nodes[value.findById(this.nodeId)];
          return Scaffold(
            appBar: AppBar(
              title: Text('Node${model.id}'),
            ),

            body: Container(
              child:  SingleChildScrollView(
                child: Column(
                  children: conditionWidgets(value, model),
                ),
              ),
            ),

            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                conditionsOptionDialog(context, value, model);
              }
            ),
          );
        }
    );
  }

  List<Widget> conditionWidgets(TreeModel value, Node model) {
    Widget widget;
    List<Widget> widgets = [];
    for (int i = 0; i < model.conditions.length; i++) {
      switch(model.conditions[i].contentType) {
        case ContentType.check:
          widgets.add(boolConditionWidget(value, model.id, model.conditions[i]));
          break;
        case ContentType.num:
          widgets.add(numConditionWidget(value, model.id, model.conditions[i]));
          break;
      }
    }
    return widgets;
  }




  conditionsOptionDialog(BuildContext context, TreeModel value, Node model) {

    int total = 0;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Menu"),
            scrollable: true,
            content: SingleChildScrollView(
              child: Column(
                children: [
//                タイトル
                  Card(
                    child: ListTile(
                      title: Column(
                          children: <Widget>[
                            Text('Title'),
                            TextField(
                              controller: titleEditController,
                              onSubmitted: (_) {
                                print(titleEditController.text);
                              },
                            ),
                          ]
                      ),
                    ),
                  ),

//                  Condtionの選択
                  Card(
                    child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return ListTile(
                          title: Column(
                              children: <Widget>[
                                Text('Options'),
                                Column(
                                  children: <Widget>[
                                    RadioListTile<ContentType>(
                                      title: const Text('check box'),
                                      value: ContentType.check,
                                      groupValue: contentType,
                                      onChanged: (ContentType value) {
                                        setState(() {
                                          contentType = value;
                                        });
                                      },
                                    ),
                                    RadioListTile<ContentType>(
                                      title: const Text('num'),
                                      value: ContentType.num,
                                      groupValue: contentType,
                                      onChanged: (ContentType value) {
                                        setState(() {
                                          contentType = value;
                                        });

                                      },
                                    ),

                                    (contentType == ContentType.num) ?
                                    Card(
                                      child: ListTile(
                                        title: Column(
                                            children: <Widget>[
                                              Text('Total'),
                                              TextField(
                                                controller: numEditController,
                                                keyboardType: TextInputType.number,
                                                onChanged: (_) {
                                                  total = int.parse(numEditController.text);
                                                },
                                              ),
                                            ]
                                        ),
                                      ),
                                    ) : Container(),
                                  ],
                                ),
                              ]
                          ),
                        );
                      },
                    ),
                  ),





                ],
              ),

            ),

            actions: [
              FlatButton(child: Text("Cancel"), onPressed: () => Navigator.pop(context),),
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  int id = model.conditions.length + 1;
                  Condition condition;
                  switch (contentType) {
                    case ContentType.check:
                      condition = BoolCondition(id: id, title: titleEditController.text);
                      break;
                    case ContentType.num:
                      condition =  NumCondition(id: id, total: total, title: titleEditController.text);
                      break;
                    default:
                      return;
                  }

                  if (condition != null) {
                    value.addCondition(model.id, condition);
                  }
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
    );



  }
}





