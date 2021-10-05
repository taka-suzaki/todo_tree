import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_tree/models/conditions.dart';
import 'package:task_tree/models/task_tree.dart';
import 'package:task_tree/routes/routes.dart';




class NodeWidget extends StatelessWidget {
  double left;
  double top;
  double width;
  double height;

  double input_x;
  double input_y;
  double output_x;
  double output_y;
  Node model;

  NodeWidget({@required this.model, @required this.left, @required this.top, @required this.height, @required this.width}){
    this.input_x = left+width/2;
    this.input_y = top;
    this.output_x = left+width/2;
    this.output_y = top+height;
  }


  @override
  Widget build(BuildContext context) {
    var _TreeModel = Provider.of<TreeModel>(context);
    return Positioned(
      left: this.left,
      top: this.top,
      width: this.width,
      height: this.height,
      child: Consumer<TreeModel>(
        builder: (BuildContext context, TreeModel value, Widget child) {
          return Card(
                child: Stack(
                  children: [
                    Positioned(
                        left: 10,
                        top: 3,
                        child: Text('Node${this.model.id}'),
                    ),

                    Positioned(
                        right: 0,
                        top: -5,
                        child: Container(
                          width: 30,
                          height: 20,
//                      color: Colors.red,
                          child:  IconButton(
                            icon: Icon(Icons.menu, ),
                            iconSize: 15, alignment: Alignment.topRight,
                            onPressed: (){
                              print('menu Pressed!!!');
                              Node node = Node(id: value.count);
                              return menuDialog(context, value);
                            },
                          ),
                        )
                    ),


                    Positioned(
                        right: 0,
                        bottom: 0,
                        child: model.isCompleted ?
                          Icon(Icons.check_box, color: Colors.green,) : Icon(Icons.check_box_outline_blank),
                    ),

                    (value.getSelectedMode() != SelectedMode.None ) ? GestureDetector(
                      child: Container(
                        color: model.canTapped ? Color.fromARGB(50, 255, 255, 255) : Color.fromARGB(200, 255, 255, 255),
                      ),
                      onTap: () {
                        print("children: ${model.children}, \nparents: ${model.parents}");
                        int tmpId = value.getTmpId();
                        print('Tapped! $tmpId');
                        if (tmpId < 0 || model.canTapped == false) {
                          return;
                        }
                        switch (value.getSelectedMode()) {
                          case SelectedMode.None:
                            return;
                          case SelectedMode.childConnect:
                            value.connectToChild(tmpId, this.model.id);
                            break;
                          case SelectedMode.parentConnect:
                            value.connectToParent(tmpId, this.model.id);
                            break;
                        }
                        value.setSelectedMode(SelectedMode.None);
                        value.setTmpId(-1);
                      },
                    ) : Container(),
                  ],
                ),

          );
        }
      ),
    );
    throw UnimplementedError();
  }


  menuDialog (BuildContext context, TreeModel value){
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text("Menu"),
          children: <Widget>[
            // コンテンツ領域
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                String path = '/project/0/tree/${this.model.id}/condition';
                print(path);
                getRoutes().navigateTo(context, path);
              },
              child: Text("詳細を開く"),
            ),
            SimpleDialogOption(
              onPressed: () {
                Node node = Node(id: value.count+1,);
                value.addChild(this.model.id, node);
                Navigator.pop(context);
              },
              child: Text("子を追加"),
            ),
            SimpleDialogOption(
              onPressed: () {
                Node node = Node(id: value.count+1);
                value.addParent(this.model.id, node);
                Navigator.pop(context);
              },
              child: Text("親を追加"),
            ),

            SimpleDialogOption(
              onPressed: () {
                value.setTmpId(this.model.id);
                value.setSelectedMode(SelectedMode.childConnect);
                value.setNodesTappedConnect(model.id);
                Navigator.pop(context);
              },
              child: Text("子ノードとして接続"),
            ),

            SimpleDialogOption(
              onPressed: () {
                value.setTmpId(this.model.id);
                value.setSelectedMode(SelectedMode.parentConnect);
                value.setNodesTappedConnect(model.id);
                Navigator.pop(context);
              },
              child: Text("親ノードとして接続"),
            )


          ],
        );
      },
    );
  }

}

